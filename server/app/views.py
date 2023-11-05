from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json


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
