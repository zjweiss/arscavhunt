from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

@csrf_exempt
def login(req):
    if req.method not in {'POST'}:
        return HttpResponse(status=404)

    body = json.loads(req.body)
    username = body.get("username", None)

    if username:
        with connection.cursor() as cursor:
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
                return JsonResponse(status=404, data={"status": "noUser"})
    else:
        return HttpResponse(status=404)


def get_leaderboard(req):
    if req.method not in {'GET'}:
        return HttpResponse(status=404)

    cursor = connection.cursor()
    cursor.execute("""
        SELECT first_name, last_name, points
        FROM users ORDER BY points DESC;
    """)
    rows = cursor.fetchall()

    res = {}
    res['users'] = rows
    return JsonResponse(res)
