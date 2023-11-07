from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import simplejson as json

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
        return JsonResponse({"users": rows})

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
            return HttpResponse(status=200)
    else:
        return HttpResponse(status=400)

@csrf_exempt
def accept_quest(req, user_id: int, quest_id: int):
    if req.method not in {'POST'}:
        return HttpResponse(status=404)
    
    # TODO: fix this query to work with user id instead of username
    if user_id and quest_id:
        with connection.cursor() as cursor:
            cursor.execute("""
                WITH sub_qs AS (
                  SELECT quest_id, location_id FROM quest_locations WHERE quest_id = %s
                )
                INSERT INTO user_quest_locations_status (user_id, quest_id, location_id)
                SELECT %s, sub_qs.quest_id, sub_qs.location_id
                FROM cte, sub_qs;
            """, [quest_id, user_id])
        return HttpResponse(status=200)
    else:
        return HttpResponse(status=400)

def get_user_quest_feed(req, user_id):
    if req.method not in {'GET'}:
        return HttpResponse(status=404)
    
    with connection.cursor() as cursor:
        cursor.execute("""
        WITH cte AS (
          -- Selects all the quests that will be active for a specific user
          SELECT * FROM user_quest_locations_status uql
          WHERE user_id = %s 
        ), cte2 AS (
          SELECT 
            quest_id,
            SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) AS active_subquests,
            SUM(CASE WHEN status = 'complete' THEN 1 ELSE 0 END) AS complete_subquests
          FROM cte 
          GROUP BY quest_id
        ), cte3 AS (
          SELECT 
            quest_id,
            COUNT(location_id) as total_subquests
          FROM quest_locations
          GROUP BY quest_id
        )
        SELECT DISTINCT 
          id, 
          name, 
          CASE 
            WHEN cte.user_id IS NOT NULL THEN 'active' 
            ELSE 'not active' 
          END AS quest_status,
          thumbnail, 
          description, 
          rating, 
          estimated_time,
          COALESCE(cte2.active_subquests, 0) AS incomplete_subquests,
          COALESCE(cte2.complete_subquests, 0) AS complete_subquests,
          COALESCE(cte3.total_subquests, 0) AS total_subquests
        FROM quests q 
        LEFT JOIN cte ON q.id = cte.quest_id
        LEFT JOIN cte2 ON q.id = cte2.quest_id
        LEFT JOIN cte3 ON q.id = cte3.quest_id;
        """, [user_id])
        rows = fetchall(cursor)
        
        return JsonResponse({"feed": rows})

