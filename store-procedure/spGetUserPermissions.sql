SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,José Mauricio Galeano Castrillón>
-- Create date: <Create Date,,22/02/2025>
-- Description:	<Description,,Este procedimiento almacenado se utiliza para consultar los permisos de un usuario por tabla y registro>
-- =============================================
ALTER PROCEDURE spGetUserPermissions
	-- Add the parameters for the stored procedure here
	@IdUser int, 
	@TableName nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRANSACTION;

	BEGIN TRY
		
		DECLARE @id_usuario INT, @id_registro INT;

		IF EXISTS (SELECT * FROM PermisosRegistros PR INNER JOIN PermisosTablas PT ON PT.id_permiso_tabla = PR.id_permiso_tabla
				   INNER JOIN UsuarioRol UR ON UR.id_rol = PR.id_rol 
				   INNER JOIN Usuarios U ON U.id_usuario = UR.id_usuario
				   WHERE U.id_usuario = @IdUser AND PT.nombre_tabla = @TableName) 
		BEGIN
			
			INSERT INTO AuditoriaAccesos (id_usuario, accion, nombre_tabla, id_registro, fecha_hora)
			SELECT @IdUser, 'SELECT', @TableName AS nombre_tabla, PR.id_registro, GETDATE() AS fecha_hora
			FROM PermisosRegistros PR INNER JOIN PermisosTablas PT ON PT.id_permiso_tabla = PR.id_permiso_tabla
			INNER JOIN UsuarioRol UR ON UR.id_rol = PR.id_rol 
			INNER JOIN Usuarios U ON U.id_usuario = UR.id_usuario
			WHERE U.id_usuario = @IdUser AND PT.nombre_tabla = @TableName;

			SELECT PT.nombre_tabla, (SELECT nombre_rol FROM Roles R WHERE R.id_rol = PR.id_rol) AS nombre_rol, PR.id_registro as registro, puede_ver, puede_editar, puede_eliminar
			FROM PermisosRegistros PR INNER JOIN PermisosTablas PT ON PT.id_permiso_tabla = PR.id_permiso_tabla
			INNER JOIN UsuarioRol UR ON UR.id_rol = PR.id_rol 
			INNER JOIN Usuarios U ON U.id_usuario = UR.id_usuario
			WHERE U.id_usuario = @IdUser AND PT.nombre_tabla = @TableName;

		END;
		ELSE
		BEGIN

			INSERT INTO AuditoriaAccesos (id_usuario, accion, nombre_tabla, id_registro, fecha_hora)
			SELECT @IdUser, 'SELECT', @TableName AS nombre_tabla, NULL, GETDATE() AS fecha_hora
			FROM PermisosRegistros PR INNER JOIN PermisosTablas PT ON PT.id_permiso_tabla = PR.id_permiso_tabla
			INNER JOIN UsuarioRol UR ON UR.id_rol = PR.id_rol 
			INNER JOIN Usuarios U ON U.id_usuario = UR.id_usuario
			WHERE U.id_usuario = @IdUser AND PT.nombre_tabla = @TableName;

			SELECT PT.nombre_tabla, (SELECT nombre_rol FROM Roles R WHERE R.id_rol = PT.id_rol) AS nombre_rol, puede_select, puede_insert, puede_update, puede_delete
			FROM PermisosTablas PT INNER JOIN UsuarioRol UR ON UR.id_rol = PT.id_rol 
			INNER JOIN Usuarios U ON U.id_usuario = UR.id_usuario
			WHERE U.id_usuario = @IdUser AND PT.nombre_tabla = @TableName;

		END;

	END TRY

	BEGIN CATCH
		SELECT ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() AS ErrorState,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage;

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;

END
GO
