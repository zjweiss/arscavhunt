from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import simplejson as json
import time
import os
from django.conf import settings
from django.core.files.storage import FileSystemStorage


"""
Utils
"""
def fetchall(cursor): 
    "Returns all rows from a cursor as a dict" 
    desc = cursor.description 
    return [
            dict(zip([col[0] for col in desc], row)) 
            for row in cursor.fetchall() 
    ]


@csrf_exempt
def postmedia(request):
    if request.method != 'POST':
        return HttpResponse(status=400)

    # loading multipart/form-data
    filename = request.POST.get("filename")

    if request.FILES.get("image"):
        content = request.FILES['image']
        filename = filename+str(time.time())+".jpeg"
        fs = FileSystemStorage()
        filename = fs.save(filename, content)
        imageurl = fs.url(filename)

    return JsonResponse( {"filename" : filename})



"""
Users API
"""
def users(req):
    if req.method != "GET":
        return HttpResponse(status=404)

    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT
              u.id AS user_id,
              u.first_name,
              u.last_name,
              u.username,
              COALESCE(SUM(CASE WHEN uqls.status = 'complete' THEN qpl.points ELSE 0 END), 0) AS total_points
            FROM
              users u
            LEFT JOIN user_quest_locations_status uqls ON u.id = uqls.user_id
            LEFT JOIN quest_locations qpl ON uqls.quest_id = qpl.quest_id AND uqls.location_id = qpl.location_id
            GROUP BY
              u.id, u.first_name, u.last_name, u.username
            ORDER BY
              total_points DESC;
        """)
        rows = fetchall(cursor)
        return JsonResponse({"data": rows})


def get_user_quest_feed(req, user_id):
    if req.method not in {'GET'}:
        return HttpResponse(status=404)
    
    with connection.cursor() as cursor:
        cursor.execute("""
            WITH user_check AS (
                SELECT 1 FROM users WHERE id = %s
            ), active_quests AS (
              SELECT DISTINCT
                  q.id AS quest_id,
                  q.name AS quest_name,
                  q.thumbnail as quest_thumbnail,
                  q.description as quest_description,
                  q.rating as quest_rating,
                  q.estimated_time,
                  SUM(CASE WHEN uqls.status = 'active' THEN 1 ELSE 0 END) as incomplete,
                  SUM(CASE WHEN uqls.status = 'complete' THEN 1 ELSE 0 END) as complete
                FROM
                  quests q
                  INNER JOIN user_quest_locations_status uqls ON q.id = uqls.quest_id
                WHERE
                  uqls.user_id = %s
                GROUP BY q.id, q.name
            ), other_quests AS (
              SELECT DISTINCT
                  q.id AS quest_id,
                  q.name AS quest_name,
                  q.thumbnail as quest_thumbnail,
                  q.description as quest_description,
                  q.rating as quest_rating,
                  q.estimated_time,
                  0 as complete,
                  (SELECT COUNT(*) FROM quest_locations ql WHERE ql.quest_id = q.id) AS incomplete
                FROM
                  quests q
                WHERE
                  q.id NOT IN (SELECT quest_id FROM active_quests)
            )
            SELECT
              *,
              'active' AS quest_status
            FROM
              active_quests
            UNION ALL
            SELECT
              *,
              'inactive' AS quest_status
            FROM
              other_quests
            WHERE EXISTS (SELECT 1 FROM user_check);
        """, [user_id, user_id])
        rows = fetchall(cursor)
        
        if rows:
            return JsonResponse({"data": rows})

        return HttpResponse(status=404)


def get_active_quest_details(req, user_id, quest_id):
    if req.method != 'GET':
        return HttpResponse(status=404)
    
    if user_id and quest_id:
        with connection.cursor() as cursor:
            cursor.execute("""
            SELECT
                ql.quest_id,
                ql.location_id,
                l.name,
                latitude,
                longitude,
                description,
                thumbnail,
                ar_enabled,
                distance_threshold,
                status,
                points,
                STRING_AGG(tags.name, ',') as tags
            FROM quest_locations ql 
            JOIN locations l ON ql.location_id = l.id
            JOIN user_quest_locations_status uqls ON uqls.user_id = %s AND uqls.location_id = ql.location_id AND uqls.quest_id = ql.quest_id
            JOIN location_tag lt ON lt.location_id = ql.location_id
            JOIN tags ON lt.tag_id = tags.id
            WHERE ql.quest_id = %s
            GROUP BY ql.quest_id, ql.location_id, l.name, latitude, longitude, description, thumbnail, ar_enabled, distance_threshold, status, points;
            """, [user_id, quest_id])

            rows = fetchall(cursor)
            
            if rows:
                return JsonResponse({"data": rows})
            
            # No active quest information was found for this specific user
            return HttpResponse(status=404)
            
    return HttpResponse(status=400)


@csrf_exempt
def login(req):
    if req.method not in {'POST'}:
        return HttpResponse(status=404)

    body = json.loads(req.body)
    username = body.get("username", None)
    
    if username:
        with connection.cursor() as cursor:
            cursor.execute("""
                WITH user_info AS (
                    SELECT * FROM users WHERE username = %s
                ), cte2 AS (
                    -- all the quests and its subquest locations that have been completed by
                    -- a secific user.
                    SELECT SUM(ql.points) as points 
                    FROM user_info, user_quest_locations_status uqls 
                    JOIN quest_locations ql 
                        ON uqls.quest_id = ql.quest_id
                        AND uqls.location_id = ql.location_id
                    WHERE user_id = user_info.id AND status = 'complete'
                )
                SELECT 
                    user_info.id,
                    user_info.first_name,
                    user_info.last_name,
                    user_info.username,
                    COALESCE(points, 0) as points 
                FROM user_info, cte2;
            """, [username])
            row = cursor.fetchone()
            if row:
                return JsonResponse({"status": "validUser", "user": row})

            return JsonResponse({"status": "noUser", "user": None}, status=404)
    else:
        return HttpResponse(status=400)


@csrf_exempt
def submit_checkpoint(req, user_id: int, quest_id: int, location_id: int):
    if req.method not in {'POST'}:
        return HttpResponse(status=404)

    if user_id and quest_id and location_id:
        with connection.cursor() as cursor:
            cursor.execute("""
                UPDATE user_quest_locations_status AS uql
                    SET status = 'complete'
                WHERE
                    uql.user_id = %s
                    AND uql.quest_id = %s 
                    AND uql.location_id = %s
            """, [user_id, quest_id, location_id])
            # Do we need to do a validity check to make sure
            # the ids passed to the call are valid? (i.e. imagine location_id = 8?)
            return HttpResponse(status=200)
    else:
        return HttpResponse(status=400)


@csrf_exempt
def accept_quest(req, user_id: int, quest_id: int):
    if req.method not in {'POST'}:
        return HttpResponse(status=404)
    
    if user_id and quest_id:
        with connection.cursor() as cursor:
            cursor.execute("""
                WITH sub_qs AS (
                  SELECT quest_id, location_id FROM quest_locations WHERE quest_id = %s
                )
                INSERT INTO user_quest_locations_status (user_id, quest_id, location_id)
                SELECT %s as user_id, sub_qs.quest_id, sub_qs.location_id
                FROM sub_qs;
            """, [quest_id, user_id])
        return HttpResponse(status=200)
    else:
        return HttpResponse(status=400)
