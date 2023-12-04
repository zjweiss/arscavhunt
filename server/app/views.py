from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import simplejson as json
import shortuuid
import time
import os
from django.conf import settings
from django.core.files.storage import FileSystemStorage

short = shortuuid.ShortUUID()

"""
Utils
"""
def fetchall(cursor): 
    """Returns all rows from a cursor as a dict."""
    desc = cursor.description 
    return [
            dict(zip([col[0] for col in desc], row)) 
            for row in cursor.fetchall() 
    ]


def generate_invite_code(n: int = 5):
    """Generates a cryptographically secure random string for invite codes"""
    return short.random(length = n)


@csrf_exempt
def postmedia(request):
    """Saves files in a /media directory for use by the client."""
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


def users(req):
    """ Retrieves all users."""
    if req.method != "GET":
        return HttpResponse(status=404)

    with connection.cursor() as cursor:
        cursor.execute("""
            WITH cte AS (
                SELECT
                  u.id AS user_id,
                  u.first_name,
                  u.last_name,
                  u.username,
                  u.avatar_url,
                  COALESCE(SUM(CASE WHEN tqls.status = 'complete' THEN qpl.points ELSE 0 END), 0) AS total_points
                FROM
                  users u
                LEFT JOIN team_users tu ON u.id = tu.user_id
                LEFT JOIN team_quest_locations_status tqls ON tqls.team_id = tu.team_id
                LEFT JOIN quest_locations qpl ON tqls.quest_id = qpl.quest_id AND tqls.location_id = qpl.location_id
                WHERE u.id <> 0
                GROUP BY
                  u.id, u.first_name, u.last_name, u.username
                ORDER BY
                  total_points DESC
            )
            SELECT 
              *,
              DENSE_RANK() OVER (ORDER BY total_points DESC) as ranking 
            FROM cte;
        """)
        rows = fetchall(cursor)
        return JsonResponse({"data": rows})


def get_user_quest_feed(req, user_id):
    if req.method not in {'GET'}:
        return HttpResponse(status=404)
    
    with connection.cursor() as cursor:
        cursor.execute("""
            WITH active_quests AS (
                SELECT DISTINCT
                    q.id AS quest_id,
                    q.name AS quest_name,
                    q.thumbnail as quest_thumbnail,
                    q.description as quest_description,
                    q.rating as quest_rating,
                    q.estimated_time,
                    SUM(CASE WHEN tqls.status = 'active' THEN 1 ELSE 0 END) as incomplete,
                    SUM(CASE WHEN tqls.status = 'complete' THEN 1 ELSE 0 END) as complete
                FROM
                  quests q
                  INNER JOIN team_quest_locations_status tqls ON q.id = tqls.quest_id
                  INNER JOIN team_users tu ON tu.team_id = tqls.team_id
                WHERE
                  tu.user_id = %s
                GROUP BY q.id, q.name
            ), other_quests AS (
              SELECT DISTINCT
                  q.id AS quest_id,
                  q.name AS quest_name,
                  q.thumbnail as quest_thumbnail,
                  q.description as quest_description,
                  q.rating as quest_rating,
                  q.estimated_time,
                  5 AS incomplete,
                  0 as complete
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
        """, [user_id])
        rows = fetchall(cursor)
        
        if rows:
            return JsonResponse({"data": rows})

        return HttpResponse(status=404)


def get_active_quest_details(req, user_id, quest_id):
    if req.method != 'GET':
        return HttpResponse(status=404)
    
    if quest_id:
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
                  ar_file,
                  distance_threshold,
                  status,
                  points,
                  STRING_AGG(tags.name, ',') as tags,
                  code as team_code
              FROM quest_locations ql 
                JOIN locations l ON ql.location_id = l.id
                LEFT JOIN location_tag lt ON lt.location_id = ql.location_id
                LEFT JOIN tags ON lt.tag_id = tags.id
                JOIN team_users tu ON tu.user_id = %s
                JOIN teams ON teams.id = tu.team_id
                JOIN team_quest_locations_status tqls ON tqls.team_id = tu.team_id AND tqls.location_id = ql.location_id AND tqls.quest_id = ql.quest_id
              WHERE ql.quest_id = %s 
              GROUP BY ql.quest_id, ql.location_id, l.name, latitude, longitude, description, thumbnail, ar_file, distance_threshold, status, points, code
              ORDER BY CAST(status AS CHAR);
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
                    SELECT
                        SUM(points) as points
                    FROM user_info, team_users
                    JOIN team_quest_locations_status tqls ON tqls.team_id = team_users.team_id
                    JOIN quest_locations ql
                        ON tqls.quest_id = ql.quest_id 
                        AND tqls.location_id = ql.location_id
                    WHERE team_users.user_id = user_info.id AND status = 'complete'
                )
                SELECT 
                    user_info.id,
                    user_info.first_name,
                    user_info.last_name,
                    user_info.username,
                    user_info.avatar_url,
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
def submit_checkpoint(req, team_code: str, quest_id: int, location_id: int):
    if req.method not in {'POST'}:
        return HttpResponse(status=404)

    if quest_id and location_id:
        with connection.cursor() as cursor:
            # Check if team exists using team_code.
            cursor.execute("""
                SELECT id FROM teams WHERE code = %s;
            """, [team_code])
    
            row = cursor.fetchone() 
            if row:
                team_id = row[0]
                # Update the teams quest status.
                cursor.execute("""
                    UPDATE team_quest_locations_status AS tql
                        SET status = 'complete'
                    WHERE
                        tql.team_id = %s
                        AND tql.quest_id = %s 
                        AND tql.location_id = %s
                """, [team_id, quest_id, location_id])
                return HttpResponse(status=200)
            else:
                return HttpResponse(status=404)
    else:
        return HttpResponse(status=400)


@csrf_exempt
def accept_quest(req, user_id: int, quest_id: int):
    if req.method not in {'POST'}:
        return HttpResponse(status=404)
    
    # If a user wants to accept a quest with a friend, they can provide a 5 character
    # code as part of the JSON payload.
    if req.body:
        body = json.loads(req.body)
        team_code = body.get("team_code", None)

        if team_code:
            with connection.cursor() as cursor:
                cursor.execute("""
                  SELECT id FROM teams WHERE code = %s;
                """, [team_code])

                row = cursor.fetchone()
                if row:
                    _id = row[0]
                    cursor.execute("""
                        INSERT INTO team_users (team_id, user_id)
                        VALUES (%s, %s);
                    """, [_id, user_id])
                
                    return JsonResponse(data={"team_code": team_code}, status=200)

                return HttpResponse(status=404)

        return HttpResponse(status=404)
    
    # When a user accepts a quest solo, they will be provided an invite code (or team identification string)
    # other users can provide this team identification string to join the original user in this quest.
    if user_id and quest_id:
        team_code = generate_invite_code()
        with connection.cursor() as cursor:
            # Register the team.
            cursor.execute("""
                INSERT INTO teams (code)
                VALUES (%s)
                RETURNING id;
            """, [team_code])
            
            # Add the initiating user to the team.
            row_id = cursor.fetchone()[0]
            cursor.execute("""
                INSERT INTO team_users (team_id, user_id)
                VALUES (%s, %s);
            """, [row_id, user_id])

            # Add all subquests to the team quest locations status table.
            cursor.execute("""
                WITH sub_qs AS (
                    SELECT quest_id, location_id
                    FROM quest_locations
                    WHERE quest_id = %s
                    ORDER BY RANDOM()
                    LIMIT 5
                )
                INSERT INTO team_quest_locations_status (team_id, quest_id, location_id)
                SELECT %s as team_id, sub_qs.quest_id, sub_qs.location_id
                FROM sub_qs;
            """, [quest_id, row_id])
            
            return JsonResponse(data={"team_code": team_code}, status=200)
    else:
        return HttpResponse(status=400)


def get_team_members(req, team_code: str):
    if req.method not in {'GET'}:
        return HttpResponse(status=404)

    if team_code:
        with connection.cursor() as cursor:
            # Check if the team being requested exists
            cursor.execute("""
                SELECT id FROM teams WHERE code = %s; 
            """, [team_code])

            row = cursor.fetchone()
            if row:
                team_id = row[0]

                # Return all the users in that team.
                cursor.execute("""
                    SELECT 
                        users.id,
                        first_name,
                        last_name,
                        username,
                        avatar_url
                    FROM users
                    JOIN team_users tu ON users.id = tu.user_id
                    WHERE tu.team_id = %s;
                """, [team_id])

                rows = fetchall(cursor)
                return JsonResponse(data={"data": rows})
            else:
                return HttpResponse(status=404)
    else:
        return HttpResponse(status=400)

