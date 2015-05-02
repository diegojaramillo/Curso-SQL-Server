--*********************************************************************
-- LABORATORIO AGRUPAR DATOS
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio será por el alumno sin la supervisión del instructor.

-----------------------------------------------------------------------
-- 1. Usando funciones agregadas
-----------------------------------------------------------------------
1.1  Calcular el precio promedio de todos los productos de la tabla productos

USE Norte
SELECT AVG(PrecioUnd) FROM Productos 

1.2 Sumar todos las cantidades de la tabla Pedidos_Detalles

USE Norte
SELECT SUM(Cantidad) FROM Pedidos_Detalles 

1.3 Usando funciones agregadas con valores Null. Contar el número de empleados

USE Norte
SELECT COUNT(*) FROM Empleados 

-----------------------------------------------------------------------
-- 2. Usando GROUP BY 
-----------------------------------------------------------------------
2.1 Agrupa los productos por codigo y código de oferta

USE AdventureWorks2012;
GO
SELECT ProductID, SpecialOfferID, AVG(UnitPrice) AS 'Precio promedio', 
 SUM(LineTotal) AS SubTotal
 FROM Sales.SalesOrderDetail
 GROUP BY ProductID, SpecialOfferID
 ORDER BY ProductID
GO

-----------------------------------------------------------------------
-- 2. Usando GROUP BY con HAVING 
-----------------------------------------------------------------------
2.1 Agrupar datos de la tabla SalesOrderDetail por código de producto y mostrar los 
    grupos que tienen pedidos de más de  $1,000,000 y en promedio cantidad < 3 elementos

USE AdventureWorks2012;
GO
SELECT ProductID, AVG(OrderQty) AS AverageQuantity, SUM(LineTotal) AS Total
 FROM Sales.SalesOrderDetail
 GROUP BY ProductID
 HAVING SUM(LineTotal) > 1000000 AND AVG(OrderQty) < 3;
GO


-----------------------------------------------------------------------
-- 3. Uso de Pivot y UnPivot
-----------------------------------------------------------------------
3.1 Mostrar el promedio de horas de vacaciones de los empleados asalariados y 
    no asalariados

USE AdventureWorks2012
SELECT *
 FROM
 (SELECT SalariedFlag, VacationHours
  FROM HumanResources.Employee
 ) AS H
 PIVOT
 (AVG(VacationHours)
  FOR SalariedFlag IN ([0], [1])
 ) AS Pvt

3.2. Mostrar información de intereses de pagos y la fecha de cambio de la tasa de interes

SELECT EPH.BusinessEntityID, EPH.Rate, EPH.RateChangeDate
 FROM HumanResources.EmployeePayHistory EPH

A. Para encontrar el ínteres actual debe encontrar la fecha de cambio máxima
   para cada empleado

SELECT EPH.BusinessEntityID, EPH.Rate, EPH.RateChangeDate
 FROM HumanResources.EmployeePayHistory EPH
 WHERE EPH.RateChangeDate = 
  (SELECT MAX(EPH1.RateChangeDate)
   FROM HumanResources.EmployeePayHistory EPH1);

Esta consulta, retorna filas para algunos empleados; utiliza una subconsulta 
no correlacionada, la cual retorna la fecha de cambio para la tabla completa.
Solo los empleados que tengan esta fecha son retornados, en lugar de esto 
necesita usar subconsulta correlacionada. Para cada empleado debe comparar la 
mas reciente fecha de cambio. 

SELECT EPH.BusinessEntityID, EPH.Rate, EPH.RateChangeDate
 FROM HumanResources.EmployeePayHistory EPH
 WHERE EPH.RateChangeDate =
  (SELECT MAX(EPH1.RateChangeDate)
    FROM HumanResources.EmployeePayHistory EPH1
    WHERE EPH1.BusinessEntityID = EPH.BusinessEntityID);

B. Uso de Pivot para retornar el cambio del interes en cada año

SELECT BusinessEntityID, YEAR(RateChangeDate) AS ChangeYear, Rate
 FROM HumanResources.EmployeePayHistory

C. Esta información es almacenada en una tabla derivada

SELECT * FROM
 (SELECT BusinessEntityID, YEAR(RateChangeDate) AS ChangeYear, Rate
   FROM HumanResources.EmployeePayHistory) AS EmpRates

Note que los datos estan entre los años 2000 y 2007

D. Ahora va ha ser un Pivot (giro) en la tabla derivada. Debe usar una función agregada 
   en el dato que sera girado. Por que los datos son salario de empleado será usado MAX
   para encontrar el máximo cambio por año

SELECT * FROM
 (SELECT BusinessEntityID, YEAR(RateChangeDate) AS ChangeYear, Rate
  FROM HumanResources.EmployeePayHistory) AS EmpRates
 PIVOT
 (MAX(Rate)
  FOR ChangeYear IN([2000], [2001], [2002], [2003], [2004], [2005], [2006], [2007])
  ) AS Pvt


3.3 Consultar encabezado de ordenes de compra (PurchaseOrderHeader) para determinar 
    el número de ordenes de compra colocadas por ciertos empleados. 
    El siguiente reporte, muestra hacia abajo los vendedores

USE AdventureWorks2012;
GO
SELECT VendorID, [250] AS Emp1, [252] AS Emp2, [255] AS Emp3, [258] AS Emp4, [260] AS Emp5
 FROM 
 (SELECT PurchaseOrderID, EmployeeID, VendorID
  FROM Purchasing.PurchaseOrderHeader) p
 PIVOT
 (COUNT (PurchaseOrderID)
  FOR EmployeeID IN
  ([250], [252], [255], [258], [260])
 ) AS pvt
 ORDER BY VendorID

-----------------------------------------------------------------------
-- No ejecute el siguiente código en clase, reviselo y corralo en casa.
-----------------------------------------------------------------------
3.4 Suponga que la tabla generada en el ejemplo de arriba es almacenada en la BD como 
    pvt, y usted desa rotar las columnas identificadas como: Emp1, Emp2, Emp3, Emp4 y
    Emp5 en valores filas para un vendedor en particular. Esto significa que debe 
    identificar dos columnas adicionales. La columna que contiene los valores columna 
    que serán rotados (Emp1, Emp2,...) serán llamados Employee, y la columna que mantiene
    los valores que residen bajo las columnas que están siendo rotadas serán llamadas
    Orders. Estas columnas corresponden a pivot_column y value_column, respectivamente.

A. Cree la tabla e inserte los valores del ejemplo de arriba

USE AdventureWorks2012
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pvt]') AND type in (N'U'))
 DROP TABLE [dbo].[pvt]
GO

CREATE TABLE dbo.pvt (
 VendorID int, 
 Emp1 int, 
 Emp2 int,
 Emp3 int, 
 Emp4 int, 
 Emp5 int)
GO
INSERT INTO pvt VALUES (1, 4,3,5,4,4)
INSERT INTO pvt VALUES (2, 4,1,5,5,5)
INSERT INTO pvt VALUES (3, 4,3,5,4,4)
INSERT INTO pvt VALUES (4, 4,2,5,5,4)
INSERT INTO pvt VALUES (5, 5,1,5,5,5)
GO

B.Unpivot la tabla

SELECT VendorID, Employee, Orders
 FROM 
  (SELECT VendorID, Emp1, Emp2, Emp3, Emp4, Emp5 FROM pvt) p
 UNPIVOT
  (Orders FOR Employee IN (Emp1, Emp2, Emp3, Emp4, Emp5) 
  )AS unpvt
GO

-----------------------------------------------------------------------
-- 4. APPLY
-----------------------------------------------------------------------
No ejecute este punto en clase, revise el código y ejecutelo en casa.

--Create Employees table and insert values
CREATE TABLE Employees
(
  empid   int         NOT NULL,
  mgrid   int         NULL,
  empname varchar(25) NOT NULL,
  salary  money       NOT NULL,
  CONSTRAINT PK_Employees PRIMARY KEY(empid),
)
GO
INSERT INTO Employees VALUES(1 , NULL, 'Nancy'   , $10000.00)
INSERT INTO Employees VALUES(2 , 1   , 'Andrew'  , $5000.00)
INSERT INTO Employees VALUES(3 , 1   , 'Janet'   , $5000.00)
INSERT INTO Employees VALUES(4 , 1   , 'Margaret', $5000.00) 
INSERT INTO Employees VALUES(5 , 2   , 'Steven'  , $2500.00)
INSERT INTO Employees VALUES(6 , 2   , 'Michael' , $2500.00)
INSERT INTO Employees VALUES(7 , 3   , 'Robert'  , $2500.00)
INSERT INTO Employees VALUES(8 , 3   , 'Laura'   , $2500.00)
INSERT INTO Employees VALUES(9 , 3   , 'Ann'     , $2500.00)
INSERT INTO Employees VALUES(10, 4   , 'Ina'     , $2500.00)
INSERT INTO Employees VALUES(11, 7   , 'David'   , $2000.00)
INSERT INTO Employees VALUES(12, 7   , 'Ron'     , $2000.00)
INSERT INTO Employees VALUES(13, 7   , 'Dan'     , $2000.00)
INSERT INTO Employees VALUES(14, 11  , 'James'   , $1500.00)
GO
--Create Departments table and insert values
CREATE TABLE Departments
(
  deptid    INT NOT NULL PRIMARY KEY,
  deptname  VARCHAR(25) NOT NULL,
  deptmgrid INT NULL REFERENCES Employees
)
GO
INSERT INTO Departments VALUES(1, 'HR',           2)
INSERT INTO Departments VALUES(2, 'Marketing',    7)
INSERT INTO Departments VALUES(3, 'Finance',      8)
INSERT INTO Departments VALUES(4, 'R&D',          9)
INSERT INTO Departments VALUES(5, 'Training',     4)
INSERT INTO Departments VALUES(6, 'Gardening', NULL)
go

--Most departments in the Departments table have a manager ID who corresponds to an employee in the Employees table. The following table-valued function accepts an employee ID as an argument and returns that employee and all of his or her subordinates:

CREATE FUNCTION dbo.fn_getsubtree(@empid AS INT) 
RETURNS @TREE TABLE
(
  empid   INT NOT NULL,
  empname VARCHAR(25) NOT NULL,
  mgrid   INT NULL,
  lvl     INT NOT NULL
)
AS
BEGIN
  WITH Employees_Subtree(empid, empname, mgrid, lvl)
  AS
  ( 
    -- Anchor Member (AM)
    SELECT empid, empname, mgrid, 0
    FROM employees
    WHERE empid = @empid

    UNION all
    
    -- Recursive Member (RM)
    SELECT e.empid, e.empname, e.mgrid, es.lvl+1
    FROM employees AS e
      JOIN employees_subtree AS es
        ON e.mgrid = es.empid
  )
  INSERT INTO @TREE
    SELECT * FROM Employees_Subtree

  RETURN
END
GO

--To return all of the subordinates in all levels for the manager of each department, use the following query:

SELECT *
FROM Departments AS D
  CROSS APPLY fn_getsubtree(D.deptmgrid) AS ST
 




