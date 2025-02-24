from email.policy import default
from multiprocessing.sharedctypes import Value
from sre_parse import State
from .models import UserPermissionsByTable, UserPermissionsByRegister
from rest_framework import serializers
from django.http import Http404
import datetime

class UserPermissionsByTableSerializer(serializers.ModelSerializer):
  class Meta:
    model = UserPermissionsByTable
    fields = '__all__'

class UserPermissionsByRegisterSerializer(serializers.ModelSerializer):
  class Meta:
    model = UserPermissionsByRegister
    fields = '__all__'