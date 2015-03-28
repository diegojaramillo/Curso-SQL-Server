--*********************************************************************
-- LABORATORIO CONSULTA DINAMICA
-- INSTRUCTOR: David Esteban Echeverri Duque
-----------------------------------------------------------------------
-- Este laboratorio será realizado por el estudiante.

-----------------------------------------------------------------------
-- 1. Script SQL Server
-----------------------------------------------------------------------
DECLARE @sBD varchar(30), @sTabla varchar(30), @sSQL nvarchar (200)

SET @sBD = 'AdventureWorks2012'
SET @sTabla = 'HumanResources.Employee'

SET @sSQL = 'USE ' + @sBD + ' SELECT BusinessEntityID, JobTitle, BirthDate FROM ' + @sTabla

PRINT 'Lista de Empleados'
PRINT ''
PRINT @sSQL
EXECUTE sp_executesql @sSQL 
-- EXECUTE (@sSQL)
-- sp_executesql: genera un plan de ejecución más eficiente que EXECUTE
GO



-----------------------------------------------------------------------
-- TAREA PARA EL ALUMNO
-----------------------------------------------------------------------
/* En SQL Express edition, que no tiene Jobs para ejecutar procesos automáticos, 
   Utilice lo visto para programar un backup a la BD en forma períodica, utilizando 
   tareas programadas del sistema operativo
   NOTA: Sin crear un programa en Visual Studio .Net
*/