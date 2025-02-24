from datetime import tzinfo
from time import timezone
from django.db import models
from django.utils import timezone
import datetime
# Create your models here.


class Usuarios(models.Model):
    Id_Usuario = models.AutoField(db_column='id_usuario', primary_key=True)  # Field id_usuario made lowercase.
    Nombre = models.CharField(db_column='nombre', max_length=100, db_collation='Modern_Spanish_CI_AS')  # Field nombre made lowercase.
    Email = models.CharField(db_column='email', max_length=100, db_collation='Modern_Spanish_CI_AS')  # Field emaiil made lowercase.
    Activo = models.CharField(db_column='activo')  # Field activo.
    
    class Meta:
        managed = False
        db_table = 'Usuarios'

class Tablas(models.Model):
    Id_Table = models.AutoField(db_column='id_table', primary_key=True)  # Field id_table made lowercase.
    Nombre_Tabla = models.CharField(db_column='nombre_tabla', max_length=50, db_collation='Modern_Spanish_CI_AS')  # Field nombre_tabla made lowercase.
    
    class Meta:
        managed = False
        db_table = 'Tablas'

class UserPermissionsByTable(models.Model):
    Nombre_Tabla = models.CharField(db_column='nombre_tabla', max_length=50, db_collation='Modern_Spanish_CI_AS')  # Field nombre_tabla made lowercase.
    Nombre_Rol = models.CharField(db_column='nombre_rol', max_length=50, db_collation='Modern_Spanish_CI_AS')  # Field nombre_rol made lowercase.
    Registro = models.CharField(db_column='registro')  # Field id_registro.
    Puede_Ver = models.CharField(db_column='puede_ver')  # Field puede_ver.
    Puede_Editar = models.CharField(db_column='puede_editar')  # Field puede_editar.
    Puede_Eliminar = models.CharField(db_column='puede_eliminar')  # Field puede_eliminar.
    
    class Meta:
        managed = False
        db_table = 'UserPermissionsByTable'

class UserPermissionsByRegister(models.Model):
    Nombre_Tabla = models.CharField(db_column='nombre_tabla', max_length=50, db_collation='Modern_Spanish_CI_AS')  # Field nombre_tabla made lowercase.
    Nombre_Rol = models.CharField(db_column='nombre_rol', max_length=50, db_collation='Modern_Spanish_CI_AS')  # Field nombre_rol made lowercase.
    Registro = models.CharField(db_column='registro')  # Field id_registro.
    Puede_Select = models.CharField(db_column='puede_select')  # Field puede_ver.
    Puede_Insert = models.CharField(db_column='puede_insert')  # Field puede_editar.
    Puede_Update = models.CharField(db_column='puede_update')  # Field puede_eliminar.
    Puede_Delete = models.CharField(db_column='puede_delete')  # Field puede_eliminar.
    
    class Meta:
        managed = False
        db_table = 'UserPermissionsByRegister'