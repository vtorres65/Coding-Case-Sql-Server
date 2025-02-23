-- Tabla de Pagos de Nómina
CREATE TABLE PagosNomina (
    id_pago INT IDENTITY(1,1) PRIMARY KEY,
    id_empleado INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado) ON DELETE CASCADE
);