/*

Instructor: David Echeverri
Taller: 
DB: Norte
*/

--1. Liste la cantidad de zonas atendidas por cada empleado.

SELECT     IdEmpleado, count(IdZona) as Cantidad
FROM         Empleados_Zonas
GROUP BY IdEmpleado; 

--2. Liste la cantidad de pedidos asociados a cada despachador por cada año

SELECT COUNT(IdPedido) Cantidad, IdDespachador, year(fpedido) as Anno 
FROM dbo.Pedidos
GROUP BY IdDespachador, year(fpedido); 

--3. Calcule el promedio de las ventas netas asociadas a cada producto por año

Select 
P.Nombre,
AVG((D.Cantidad * D.PrecioUnd) - (D.Cantidad * D.PrecioUnd * D.Descuento)) Promedio,
YEAR(PE.FPedido) as Ano
from Productos P
inner join Pedidos_Detalles D
on P.IdProducto = D.IdProducto
inner join Pedidos PE
on PE.IdPedido = d.IdPedido
group by P.Nombre, YEAR(PE.FPedido)

Select P.IdProducto,
AVG(D.Cantidad)
from Productos P
inner join Pedidos_Detalles D
on P.IdProducto = D.IdProducto
group by P.IdProducto
	
--4. Liste los 5 y solo los 5 productos más solicitados 
-- en el primer año del que tenga datos (No debe quedar quemado el año en el código).
-- no olvide mostrar a que año pertenecen
select top 5 d.IdProducto, sum(d.Cantidad) as Suma from Pedidos_Detalles d inner join Pedidos p
on p.IdPedido= d.IdPedido
where YEAR(p.FPedido)=(
select MIN(YEAR(FPedido))from Pedidos)
group by d.IdProducto
order by SUM(d.Cantidad)desc

--5. Liste el producto con menores pedidos en 1998

	select	top 1
		pd.IdProducto,
		Cantidad=SUM(pd.cantidad)
	from Pedidos p 
		inner join Pedidos_Detalles pd
			on p.IdPedido = pd.idpedido
	where YEAR(fpedido)=1998
	group by pd.IdProducto
	order by SUM(pd.cantidad) ASC

--6. Entregue el valor de los pedidos totalizados anualmente 
--	por empleado (Tenga en cuenta que debe poseer el 
--	valor neto)
--	Pista emplear PIVOT


SELECT * FROM
	(Select 
		E.Apellidos + ' ' + E.Nombres Nombre,
		ROUND(SUM((D.Cantidad * D.PrecioUnd) - (D.Cantidad * D.PrecioUnd * D.Descuento)),2) Neto,
		YEAR(PE.FPedido) as Ano
	from Productos P
		inner join Pedidos_Detalles D
		on P.IdProducto = D.IdProducto
		inner join Pedidos PE
		on PE.IdPedido = d.IdPedido
		inner join Empleados E
		on E.IdEmpleado = PE.IdEmpleado
	group by E.Apellidos + ' ' + E.Nombres, YEAR(PE.FPedido)) AS T
	PIVOT
	(--Llamado a Función de agregado
		MAX(T.Neto) 
		FOR Ano IN ([1996],[1997],[1998])) AS PVT


SELECT * FROM
	(Select 
		E.Apellidos + ' ' + E.Nombres Nombre,
		ROUND((D.Cantidad * D.PrecioUnd) - (D.Cantidad * D.PrecioUnd * D.Descuento),2) Neto,
		YEAR(PE.FPedido) as Ano
	from Productos P
		inner join Pedidos_Detalles D
		on P.IdProducto = D.IdProducto
		inner join Pedidos PE
		on PE.IdPedido = d.IdPedido
		inner join Empleados E
		on E.IdEmpleado = PE.IdEmpleado
	--group by E.Apellidos + ' ' + E.Nombres, YEAR(PE.FPedido)
	) AS T
	PIVOT
	(--Llamado a Función de agregado
		SUM(T.Neto) 
		FOR Ano IN ([1996],[1997],[1998])) AS PVT

-- Esta muy easy!!!