CREATE TABLE PermisosRegistros (
    id_permiso_registro INT IDENTITY(1,1) PRIMARY KEY,
    id_rol INT NOT NULL,
    nombre_tabla NVARCHAR(50) NOT NULL,
    id_registro INT NOT NULL,
    puede_ver BIT NOT NULL DEFAULT 0,
    puede_editar BIT NOT NULL DEFAULT 0,
    puede_eliminar BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_rol) REFERENCES Roles(id_rol) ON DELETE CASCADE
);