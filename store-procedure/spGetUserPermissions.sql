-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,José Mauricio Galeano Castrillón>
-- Create date: <Create Date,,22/02/2025>
-- Description:	<Description,,Este procedimiento almacenado se utiliza para consultar los permisos de un usuario por tabla>
-- =============================================
CREATE PROCEDURE spGetUserPermissions
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

		-- Validar si la tabla existe en la base de datos
		IF NOT EXISTS (
            SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_NAME = @TableName AND TABLE_TYPE = 'BASE TABLE'
        )
        BEGIN
            RAISERROR ('Error: La tabla especificada no existe en la base de datos.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

		-- Obtener los permisos del usuario sobre la tabla
		DECLARE @permiso INT;

        SELECT @permiso = 1
        FROM PermisosTablas PT
        INNER JOIN UsuarioRol UR ON UR.id_rol = PT.id_rol
        INNER JOIN Usuarios U ON U.id_usuario = UR.id_usuario
        WHERE U.id_usuario = @IdUser AND PT.nombre_tabla = @TableName;

		-- Verificar si el usuario tiene permisos
        IF @permiso IS NULL
        BEGIN
            RAISERROR ('Acceso denegado: No tienes permisos sobre esta tabla.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

		-- Registrar en auditoría si el usuario tiene permisos
        INSERT INTO AuditoriaAccesos (id_usuario, accion, nombre_tabla, fecha_hora)
        VALUES (@IdUser, 'SELECT', @TableName, GETDATE());

		-- Devolver los permisos del usuario sobre la tabla
        SELECT 
            PT.nombre_tabla, R.nombre_rol, PT.puede_select, PT.puede_insert, PT.puede_update, PT.puede_delete
        FROM PermisosTablas PT
        INNER JOIN UsuarioRol UR ON UR.id_rol = PT.id_rol
        INNER JOIN Usuarios U ON U.id_usuario = UR.id_usuario
        INNER JOIN Roles R ON R.id_rol = PT.id_rol
        WHERE U.id_usuario = @IdUser AND PT.nombre_tabla = @TableName;

		-- Si todo sale bien, hacer commit
        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        -- Capturar errores y mostrar mensaje
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;

        -- Si hay un error, hacer rollback
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH;
END;
GO
