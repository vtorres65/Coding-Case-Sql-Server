CREATE TABLE Empleados (
    id_empleado INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    departamento NVARCHAR(50) NOT NULL,
    salario DECIMAL(18,2) NOT NULL
);