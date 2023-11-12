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
    # USER API
    path('users/', views.users, name='Get users'),
    path('login/', views.login, name='Login'),
    path('users/<int:user_id>/quests/', views.get_user_quest_feed, name='Get active and available quests'),
    path('users/<int:user_id>/quests/<int:quest_id>/', views.get_active_quest_details, name='Get active quest'),
    path('users/<int:user_id>/quests/<int:quest_id>/accept/', views.accept_quest, name='Accept quest'),
    path('users/<int:user_id>/quests/<int:quest_id>/locations/<int:location_id>/submit_checkpoint', views.submit_checkpoint, name='Submit checkpoint'),
    
    # MISC. API
    path('postmedia/', views.postmedia, name="Post an image"),
]
