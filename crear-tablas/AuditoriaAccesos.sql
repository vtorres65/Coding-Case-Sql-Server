CREATE TABLE AuditoriaAccesos (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    accion NVARCHAR(10) CHECK (accion IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE')),
    nombre_tabla NVARCHAR(50) NOT NULL,
    id_registro INT NULL,
    fecha_hora DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);