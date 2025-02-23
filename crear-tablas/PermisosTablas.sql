-- Tabla de Permisos por Tabla
CREATE TABLE PermisosTablas (
    id_permiso_tabla INT IDENTITY(1,1) PRIMARY KEY,
    id_rol INT NOT NULL,
    nombre_tabla NVARCHAR(50) NOT NULL,
    puede_select BIT NOT NULL DEFAULT 0,
    puede_insert BIT NOT NULL DEFAULT 0,
    puede_update BIT NOT NULL DEFAULT 0,
    puede_delete BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_rol) REFERENCES Roles(id_rol) ON DELETE CASCADE
);