
/*
Taller de JOINS
Profesor: David Esteban Echeverri Duque

Utilizando AdventureWorks2012

1. Recuperar TODOS los empleados (Employees) e indicar el número de orden en aquellos que eventualmente las tengan en la tabla PurchaseOrderHeader. 

2. Recuperar los productos de la tabla (Product) y listar la totalidad de modelos de producto disponibles (ProductModel).

Utilizando Norte 

3. Se le solicita al analista de Bases de Datos generar una sentencia SQL que permita Identificar cual fue el agente comercial o empleado asociado a las ventas de los productos Raclette Courdavault y Guaraná Fantástica en el año 1998. El usuario espera que el script de la consulta permita parametrizar los parámetros de selección.

4. Se solicita identificar los detalles de órdenes de pedido cuyas cantidades superan las 10 unidades por cada pedido.

*/



--1. Recuperar TODOS los empleados (Employees) e indicar elñ numero de orden en aquellos 
--que eventualmente las tengan en la tabla PurchaseOrderHeader. 


	SELECT 
		E.[BusinessEntityID]
		,E.LoginID
		,P.PurchaseOrderID
		,P.OrderDate
	FROM HumanResources.Employee E 
		LEFT JOIN Purchasing.PurchaseOrderHeader P
		ON E.[BusinessEntityID] = P.[EmployeeID]
		
--2. Recuperar los productos de la tabla (Product) y listar la totalidad de modelos 
--de producto disponibles (ProductModel).

-- El profesor nos enagano!!!

	SELECT 
		P.ProductID
		,PM.Name
	FROM Production.Product P RIGHT JOIN 
		Production.ProductModel PM
		ON P.ProductModelID = PM.ProductModelID 

--4. Se solicita identificar los detalles de ordenes de pedido cuyas cantidades 
--superan las 10 unidades

	SELECT 
		*
	FROM dbo.Pedidos_Detalles PD
	WHERE Cantidad > 10


	SELECT
		PD.IdPedido 
		,SUM(PD.Cantidad)
	FROM dbo.Pedidos_Detalles PD
		GROUP BY PD.IdPedido 
		HAVING SUM(PD.Cantidad)>10
		ORDER BY SUM(PD.Cantidad) DESC


USE Norte
GO 
-- COMMON TABLE EXPRESSION (No considera el pedido, considera el empleado)
WITH TEMP AS 
(SELECT 
	E.[IdEmpleado], 
	COUNT(P.[IdPedido]) AS Cantidad
  FROM	[Norte].[dbo].[Empleados] E
	INNER JOIN 
		[Norte].[dbo].[Pedidos] P 
	ON E.IdEmpleado = P.IdEmpleado
GROUP BY E.[IdEmpleado])
SELECT top 10 *
FROM TEMP where Cantidad > 10
order by Cantidad desc; 

--- Forma 2 
SELECT * FROM 
(SELECT 
	E.[IdEmpleado], 
	COUNT(P.[IdPedido]) AS Cantidad
  FROM	[Norte].[dbo].[Empleados] E
	INNER JOIN 
		[Norte].[dbo].[Pedidos] P 
	ON E.IdEmpleado = P.IdEmpleado
GROUP BY E.[IdEmpleado]) TEMP 



/*
3. Se le solicita al analista de Bases de Datos generar una sentencia SQL que permita
Identificar cual fue el agente comercial con mayores cantidades de pedidos en el 98. 
*/	


select Empleados .IdEmpleado, Empleados.Nombres
from Empleados
inner join (
select top 1 IdEmpleado, COUNT(*) as cantidad
from Pedidos
where
YEAR(FPedido)=1998
group by IdEmpleado
order by cantidad desc
) pedidos2 on pedidos2.IdEmpleado=Empleados.IdEmpleado

select top 1 IdEmpleado as Id
from Pedidos
where YEAR(FPedido)= 1998
group by IdEmpleado
order by COUNT(PEDIDOS.IdPedido) desc