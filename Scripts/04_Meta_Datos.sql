--*********************************************************************
-- LABORATORIO CONSULTAR META DATOS
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio sera realizado por los alumnos sin la supervisión del instructor.
- Seleccione las instrucciones y ejecutelas por partes, observe los resultados. 

-----------------------------------------------------------------------
-- 1. Ejemplo de vistas de catalogo
-----------------------------------------------------------------------
use AdventureWorks2012
go
SELECT * FROM sys.tables
SELECT * FROM sys.dm_exec_requests

-----------------------------------------------------------------------
-- 2. Listar los tipos de objetos almacenados en una BD
-----------------------------------------------------------------------
SELECT Distinct type As 'Tipo de objeto' FROM sys.sysobjects

-----------------------------------------------------------------------
-- 3. Listar tipos de objectos 
-----------------------------------------------------------------------
Tablas de Usuario (U), Vistas (V), Procedimientos (P), Triggers (T), Funiciones (FN)

SELECT S.name As 'Esquema', O.name As Nombre_Objeto
 FROM sys.sysobjects As O INNER JOIN sys.schemas As S ON O.uid = S.Schema_id 
 WHERE O.type = 'U' -- 'V' 'U' 'P' 'TR', 'FN' 
GO

-----------------------------------------------------------------------
-- 4. Utilizar funciones del sistema para consultar meta datos
-----------------------------------------------------------------------
SELECT DB_NAME() AS [BD actual];
GO

USE AdventureWorks2012;
GO
DECLARE @Id int;
SET @Id = (SELECT OBJECT_ID('AdventureWorks2012.Production.Product', 'U'));
SELECT name, object_id, type_desc FROM sys.objects
 WHERE name = OBJECT_NAME(@Id);

-----------------------------------------------------------------------
-- 5. Listar los objetos de la BD activa
-----------------------------------------------------------------------
Use AdventureWorks2012
GO
sp_help

-----------------------------------------------------------------------
-- 6. Obtener información de un objeto especifico
-----------------------------------------------------------------------
Use AdventureWorks2012
GO
EXEC sp_help 'HumanResources.Employee'

-----------------------------------------------------------------------
-- CONSULTAR
-----------------------------------------------------------------------
¿Qué utilidad practica le puede dar a consultar metadatos?

