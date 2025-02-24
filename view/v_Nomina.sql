-- Vista que muestra la nómina de empleados y los pagos realizados.
CREATE VIEW v_Nomina AS
SELECT 
    P.id_pago,
    E.id_empleado,
    E.nombre AS nombre_empleado,
    E.departamento,
    P.fecha_pago,
    P.monto
FROM PagosNomina P
INNER JOIN Empleados E ON P.id_empleado = E.id_empleado;