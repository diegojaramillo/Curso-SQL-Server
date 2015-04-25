--*********************************************************************
-- LABORATORIO TRABAJO CON INDICES
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio sera realizado por los alumnos con la supervisi�n del instructor.
- Seleccione las instrucciones y ejecutelas por partes.

-----------------------------------------------------------------------
-- 1. Listar los �ndices de una tabla
-----------------------------------------------------------------------
Use AdventureWorks2012
SELECT * FROM sys.indexes
EXECUTE sp_helpindex 'Production.WorkOrder'

1. En Object Explorer expanda el servidor y la carpeta Databases
2. Expanda la BD AdventureWorks2012 y la carpeta Tables
3. Expada la tabla 'Production.WorkOrder' y la carpeta Index
4. De un click secundario en uno de los �ndices y seleccione propiedades

-----------------------------------------------------------------------
-- 2. Crear �ndice clusterado
-----------------------------------------------------------------------
3.1 Crear �ndice  clusterado para la tabla Person.Person

Use AdventureWorks2012
EXECUTE sp_helpindex 'Person.Person' -- Muestra informaci�n de �ndices
EXECUTE sp_help 'Person.Person'      -- Muestra informaci�n de la tabla

-- �Por qu� falla la siguiente instrucci�n?
IF EXISTS (SELECT * FROM sys.indexes WHERE Name = 'PK_Person_BusinessEntityID')
 DROP INDEX PK_Person_BusinessEntityID ON Person.Person
GO

-- No borre el �ndice, observe la siguiente instrucci�n, pero no la ejecute.
-- �Qu� otro m�todo podr�a utilizar para borrar el �ndice?
-- �Qu� otras acciones tendr�a que realizar para poder borrar la PK?
CREATE INDEX CLUSTERED PK_Person_BusinessEntityID ON Person.Person 
 (LastName, FirstName)
 WITH (FILLFACTOR = 70);

-----------------------------------------------------------------------
-- 3. Crear �ndice no clusterado
-----------------------------------------------------------------------
3.1 Crear �ndice no clusterado para la tabla Person.Person

EXECUTE sp_helpindex 'Person.Person' -- Muestra informaci�n de �ndices

IF EXISTS (SELECT * FROM sys.indexes WHERE Name = 'Contac_Indice1')
 DROP INDEX Contac_Indice1 ON Person.Person
GO

-- Ejecute la siguiente l�nea la cual falla. �Por qu� no se puede crear el �ndice 
--  como unico (UNIQUE)?
CREATE UNIQUE INDEX Contac_Indice1 ON Person.Person (LastName, FirstName)

CREATE INDEX Contac_Indice1 ON Person.Person 
 (LastName, FirstName)
 WITH (FILLFACTOR = 70);

-- �Por qu� no falla est� instrucci�n si el �ndice fue creado en la l�nea de arriba?
CREATE INDEX Contac_Indice1 ON Person.Person 
 (LastName, FirstName)
 WITH (FILLFACTOR = 70, 
      SORT_IN_TEMPDB = ON, 
      DROP_EXISTING = ON);
--    ONLINE = ON,          Solo para Enterprise edition

3.2 Revise las propiedades del �ndice en Object Explorer, si no ve el �ndice de 
    un clic secundario sobre la carpeta �ndices y luego en Refresh

-----------------------------------------------------------------------
-- 4. Buscar un �ndice para mejorar el desempe�o de una consulta
-----------------------------------------------------------------------
4.1 Borrar el �ndice que sera creado en esta practica
Use AdventureWorks2012
GO
EXECUTE sp_helpindex 'Production.WorkOrderRouting'

IF EXISTS (SELECT * FROM sys.indexes WHERE Name = 'WorkOrderRouting_Indice1')
 DROP INDEX WorkOrderRouting_Indice1 ON Production.WorkOrderRouting
GO

4.2 �Cuantas filas tiene la tabla, cuantas filas retorna la consulta
    y cuanto tiempo toma realizar las siguientes consulta?

SELECT * FROM Production.WorkOrderRouting
 WHERE ScheduledStartDate Between '2004-06-01' AND '2004-06-02'
 ORDER BY ScheduledStartDate

SELECT * FROM Production.WorkOrderRouting
 WHERE ScheduledStartDate Between '2004-06-01' AND '2004-06-20'
 ORDER BY ScheduledStartDate

SELECT * FROM Production.WorkOrderRouting
 WHERE ScheduledStartDate = '2004-06-01' 

4.3 Realice un plan de ejecuci�n para las instrucciones anteriores, presionando el bot�n 
 "Display estimated execution plan". Observe los siguientes datos en el ultimo icono:

- Fisica operacion: Busqueda en �ndice
- Logica operacion: Busqueda en �ndice
- Filas: 224 (0.33%)
- Total filas: 67131
- Costo I/O: 0.003125 (Anterior 0.51578) 
- Costo CPU: 0.0002 (Anterior 0.0740011)
- Costo operacion: 0.0033251 (3%) (Anterior 0.589719 (89%))

- Fisica operacion: Busqueda en �ndice clusterado
- Logica operacion: Busqueda en �ndice clusterado
- Filas: 224 (0.33%)
- Total filas: 67131
- Costo I/O: 0.003125 (Anterior 0.51578) 
- Costo CPU: 0.00016 (Anterior 0.0740011)
- Costo operacion: 0.12 (97%) (Anterior 0.589719 (89%))

4.4 Cree un �ndice por las columnas de la condici�n (WHERE)

CREATE INDEX WorkOrderRouting_Indice1 
 ON Production.WorkOrderRouting (ScheduledStartDate)
 WITH (FILLFACTOR = 80);

EXECUTE sp_helpindex 'Production.WorkOrderRouting'

4.5 Ejecute de nuevo el plan de ejecuci�n y las consultas. Compare los resultados

- Fisica operacion: Scaneo de indice clusterado
- Logica operacion: Scaneo de indice clusterado
- Filas: 5923 (8.82%)
- Total filas: 67131
- Costo I/O: 0.51578
- Costo CPU: 0.0740011
- Costo operacion 0.589719 (72%)

-----------------------------------------------------------------------
-- 5. Deshabilitar y habilitar el �ndice creado en la practica anterior
-----------------------------------------------------------------------
5.1 Deshabilitar indice
Use AdventureWorks2012
ALTER INDEX WorkOrderRouting_Indice1 ON Production.WorkOrderRouting DISABLE;

5.2 Presione el bot�n "Include actual execution plan" y ralice la consulta siguiente.
    Note que no utiliza el indice en el plan de ejecucion, si el indice hubiera sido 
    clusterado no podria ver los datos

SELECT * FROM Production.WorkOrderRouting
 WHERE ScheduledStartDate = '2004-06-01' 

5.3 Habilite el �ndice. 
    �Cual es el costo de reconstruir el �ndice?

ALTER INDEX WorkOrderRouting_Indice1 ON Production.WorkOrderRouting REBUILD;

5.4 Realice de nuevo la consulta y observe en el plan de ejecuci�n, que la consulta
    utiliza de nuevo el indice

-----------------------------------------------------------------------
-- 6. Borre el �ndice creado en la practica anterior
-----------------------------------------------------------------------
Use AdventureWorks2012
EXECUTE sp_helpindex 'Production.WorkOrderRouting'
IF EXISTS (SELECT * FROM sys.indexes WHERE Name = 'WorkOrderRouting_Indice1')
 DROP INDEX WorkOrderRouting_Indice1 ON Production.WorkOrderRouting
GO

-----------------------------------------------------------------------
-- 6. Crear �ndices en forma gr�fica 
-----------------------------------------------------------------------
En Object Explorer, expanda la BD Norte, expanda la tabla, en el nodo �ndice
 de un clic secundario y seleccione "New index"

6.1 �ndice UNIQUE en la columna Nombre de la tabla Regiones
6.2 �ndice no clusterado en las columnas: Pais, Ciudad, Region de la tabla Clientes
6.3 Escriba una consulta contra la tabla Clientes que filtre por region y revise en 
    el plan de ejecuci�n si la consulta utiliza el �ndice creado.

