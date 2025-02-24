# Coding-Case-Sql-Server
Sistema de Control de Permisos en una API para Stone prueba tecnica

📖 Descripción

Este sistema permite gestionar la nómina de empleados y controlar los permisos de acceso a nivel de tabla y registro en SQL Server. Incluye funciones de auditoría de accesos y generación de reportes de nómina.

🚀 Tecnologías Utilizadas

SQL Server (Base de datos y gestión de permisos)

Django Rest Framework (DRF) (Exposición de API REST)

Python (Generación de reportes en CSV/PDF)

Estructura de la Base de Datos

🏢 Empleados
📌 Descripción: Registra la información de los empleados.
CREATE TABLE Empleados (
    id_empleado INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    apellido NVARCHAR(100) NOT NULL,
    departamento NVARCHAR(50) NOT NULL,
    salario DECIMAL(18,2) NOT NULL
);

💰 Pagos de Nómina
📌 Descripción: Almacena los pagos realizados a los empleados.
CREATE TABLE PagosNomina (
    id_pago INT IDENTITY(1,1) PRIMARY KEY,
    id_empleado INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado) ON DELETE CASCADE
);

🔐 Usuarios y Roles
📌 Descripción: Gestiona los usuarios y sus roles en el sistema.
CREATE TABLE Roles (
    id_rol INT IDENTITY(1,1) PRIMARY KEY,
    nombre_rol NVARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE Usuarios (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    activo BIT NOT NULL DEFAULT 1
);
CREATE TABLE UsuarioRol (
    id_usuario INT,
    id_rol INT,
    PRIMARY KEY (id_usuario, id_rol),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_rol) REFERENCES Roles(id_rol) ON DELETE CASCADE
);

⚙️ Permisos (Tablas y Registros)
📌 Descripción: Define permisos de acceso a nivel de tabla y registro.
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

📝 Auditoría de Accesos
📌 Descripción: Registra todas las acciones realizadas en la base de datos.
CREATE TABLE AuditoriaAccesos (
    id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    accion NVARCHAR(10) CHECK (accion IN ('SELECT', 'INSERT', 'UPDATE', 'DELETE')),
    nombre_tabla NVARCHAR(50) NOT NULL,
    id_registro INT NULL,
    fecha_hora DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

📊 📜 Vistas SQL
📌 Descripción: Muestra los pagos de nómina con la información del empleado.
CREATE VIEW vw_Nomina AS
SELECT
    P.id_pago,
    E.id_empleado,
    E.nombre AS nombre_empleado,
    E.apellido AS apellido_empleado,
    E.departamento,
    P.fecha_pago,
    P.monto
FROM PagosNomina P
INNER JOIN Empleados E ON P.id_empleado = E.id_empleado;

