-- Vista que muestra el historial de auditoría de accesos a tablas
CREATE VIEW v_AuditoriaAccesos AS
SELECT 
    A.id_auditoria,            
    A.id_usuario,              
    U.nombre AS nombre_usuario, 
    A.accion,                  
    A.nombre_tabla,            
    A.fecha_hora               
FROM AuditoriaAccesos A
INNER JOIN Usuarios U ON A.id_usuario = U.id_usuario;