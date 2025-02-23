CREATE TRIGGER TRG_Auditoria_Empleados
ON Empleados
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_usuario INT;
    DECLARE @accion NVARCHAR(10);
    DECLARE @permiso INT;

    -- OBTENER EL USUARIO QUE ESTÁ REALIZANDO LA ACCIÓN
    SELECT @id_usuario = id_usuario 
	FROM Usuarios 
	WHERE activo = 1 AND nombre = SESSION_CONTEXT(N'usuario_actual');

    -- DETERMINAR LA ACCIÓN REALIZADA (INSERT, UPDATE, DELETE)
    SET @accion = CASE 
        WHEN EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted) THEN 'UPDATE'
        WHEN EXISTS (SELECT 1 FROM inserted) THEN 'INSERT'
        WHEN EXISTS (SELECT 1 FROM deleted) THEN 'DELETE'
    END;

    -- VERIFICAR SI EL USUARIO TIENE PERMISOS SOBRE ESTA TABLA Y ACCIÓN
    SELECT @permiso = CASE 
        WHEN @accion = 'INSERT' AND PT.puede_insert = 1 THEN 1
        WHEN @accion = 'UPDATE' AND PT.puede_update = 1 THEN 1
        WHEN @accion = 'DELETE' AND PT.puede_delete = 1 THEN 1
        ELSE 0
    END
    FROM PermisosTablas PT
    INNER JOIN UsuarioRol UR ON UR.id_rol = PT.id_rol
    INNER JOIN Usuarios U ON U.id_usuario = UR.id_usuario
    WHERE U.id_usuario = @id_usuario;

    -- SI NO TIENE PERMISOS, CANCELAR LA OPERACIÓN Y REALIZA ROLLBACK
    IF @permiso = 0
    BEGIN
        RAISERROR ('Acceso denegado: No tienes permisos para realizar esta acción en Empleados.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- REGISTRAR EN AUDITORÍA SI TIENE PERMISOS
    INSERT INTO AuditoriaAccesos (id_usuario, accion, nombre_tabla, fecha_hora)
    VALUES (@id_usuario, @accion, 'Empleados', GETDATE());
END;
