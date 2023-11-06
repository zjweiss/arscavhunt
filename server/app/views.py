from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

"""
Locations API endpoint
"""

@csrf_exempt
def submit_checkpoint(req):
    if req.method not in {'POST'}:
        return HttpResponse(status=404)

    body = json.loads(req.body)
    username = body.get('username', None)
    quest_id = body.get('quest_id', None)
    location_id = body.get('location_id', None)
    
    if username and quest_id and location_id:
        with connection.cursor() as cursor:
            cursor.execute("""
                UPDATE user_quest_locations_status AS uql
                    SET status = 'complete'
                WHERE
                    uql.user_id = (SELECT id FROM users WHERE username=%s)
                    AND uql.quest_id = %s 
                    AND uql.location_id = %s
                RETURNING *;
            """, [username, quest_id, location_id])
            return HttpResponse(status=200)
    else:
        return HttpResponse(status=400)

"""
Quests API Endpoint
"""
@csrf_exempt
def accept_quest(req):
    if req.method not in {'POST'}:
        return HttpResponse(status=404)
    
    body = json.loads(req.body)
    username = body.get('username', None)
    quest_id = body.get('quest_id', None)
    
    if username and quest_id:
        # TODO: grab all the subquests for a quest
        # TODO: insert all the subquests into the user_quest_locations table
        return JsonResponse()
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
          WHERE user_id = 1
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
        rows = cursor.fetchall()
        
        return JsonResponse({"feed": rows})

"""
Users API Endpoint
"""

@csrf_exempt
def login(req):
    if req.method not in {'POST'}:
        return HttpResponse(status=404)

    body = json.loads(req.body)
    username = body.get("username", None)
    
    if username:
        with connection.cursor() as cursor:
            # TODO: compute points
            cursor.execute("""
                SELECT * FROM users WHERE username = %s;
            """, [username])
            row = cursor.fetchone()
            if row:
                res = {
                    "status": "validUser",
                    "user": row
                }
                return JsonResponse(res)
            else:
                return JsonResponse(
                    status=404, 
                    data={
                        "status": "noUser", 
                        "user": []
                    }
                )
    else:
        return HttpResponse(status=400)
