from django.http import JsonResponse, HttpResponse
from django.db import connection
from django.views.decorators.csrf import csrf_exempt
import json

def getchatts(request):
    if request.method != 'GET':
        return HttpResponse(status=404)

    response = { "msg": "yo" }
    return JsonResponse(response)
