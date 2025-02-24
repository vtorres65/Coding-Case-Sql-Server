from django.shortcuts import render
from django.db import connection
from .models import UserPermissionsByTable, UserPermissionsByRegister
from rest_framework.response import Response
from .serializer import *
from rest_framework.views import APIView
from django.http import Http404
from rest_framework import status

# Create your views here.

class UserPermissionsByTableViewSet(APIView):
 
  def get(self, request, format=None):

      cursor = connection.cursor()
      args = [request.data.Id_Usuario, request.data.Nombre_Tabla]
      cursor.callproc('spGetUserPermissions', args)
      results = cursor.fetchall()
      return Response(results)
  

class AuditoriaAccesoViewSet(APIView):

  def get(self, request, format=None):

      cursor = connection.cursor()
      cursor.callproc('v_AuditoriaAccesos')
      results = cursor.fetchall()
      return Response(results)

class NominaViewSet(APIView):
    
     def get(self, request, format=None):

      cursor = connection.cursor()
      cursor.callproc('v_Nomina')
      results = cursor.fetchall()
      return Response(results)