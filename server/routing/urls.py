"""
URL configuration for routing project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from app import views

urlpatterns = [
    # User API
    # GET
    path('users/', views.users, name='users'),
    # path('users/<int:user_id>/quests/', views.users, name='feed'),
    
    # POST 
    path('login/', views.login, name='login'),
    # path('users/<int:user_id>/quests/<int:quest_id>/accept/', views.users, name='accept quest'),
    # path('/users/<int:user_id>/quests/<int:quest_id>/locations/<int:location_id>/submit_checkpoint', views.users, name='submit checkpoint'),
    
    # Quest API
    # GET
    # path('quests/<int:quest_id>', views.users, name='quest'),
]
