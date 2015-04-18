--*********************************************************************
-- LABORATORIO CONSTRAINT CHECK
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio sera realizado por los alumnos con la supervisión del instructor.
- Seleccione las instrucciones y ejecutelas por partes.

-----------------------------------------------------------------------
-- 1. Constraint Check 
-----------------------------------------------------------------------
1.1 Crear un constrait para el formato del numero de telefono
USE Norte_2015
GO
-- SELECT * FROM sys.objects WHERE Type = 'C' AND Name = 'CK_Telefono'
IF EXISTS (SELECT * FROM sys.check_constraints WHERE Name = 'CK_Telefono')
 ALTER TABLE Empleados
  DROP CONSTRAINT CK_Telefono
GO

ALTER TABLE Empleados WITH NOCHECK
 ADD CONSTRAINT CK_Telefono CHECK (TelCasa LIKE '(200)[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
GO

1.2 Crear un constrait para el formato del email
IF EXISTS (SELECT * FROM sys.check_constraints WHERE Name = 'CK_Email')
 ALTER TABLE Empleados
  DROP CONSTRAINT CK_Email
GO

ALTER TABLE Empleados 
 ADD CONSTRAINT CK_Email CHECK (Email LIKE '%@%.[a-z][a-z][a-z]' OR 
  Email LIKE '%@%.[a-z][a-z].[a-z][a-z]')

1.3 La cantidad de un producto en un pedido debe ser > 0 
IF EXISTS (SELECT * FROM sys.check_constraints WHERE Name = 'CK_Cantidad')
 ALTER TABLE Pedidos_Detalles
  DROP CONSTRAINT CK_Cantidad
GO

ALTER TABLE Pedidos_Detalles WITH NOCHECK
 ADD CONSTRAINT CK_Cantidad CHECK (Cantidad > 0)
GO

1.4 El descuento de un producto debe estar entre 0 y 1
IF EXISTS (SELECT * FROM sys.check_constraints WHERE Name = 'CK_Descuento')
 ALTER TABLE Pedidos_Detalles
  DROP CONSTRAINT CK_Descuento
GO

Escriba la instrucción correspondiente ...

1.5 La tabla Pedidos, de la BD Norte_2015, la fecha de despacho (FDespacho) debe ser >= 
    a la fecha de pedido (FPedido)

Escriba las instrucción correspondientes ...

-----------------------------------------------------------------------
-- 2. Validar las restricciones (constraints)
-----------------------------------------------------------------------
En la ventana "Object explorer" de un clic secundario en la tabla y luego en 
 Open table. Adicione y modifique datos que validen las restricciones creadas.

En el caso de la columna Email de la tabla empleados adicione la 
siguiente dirección de correo: Juan.Pedro@Servidor.net.co
Corrija el error e intente de nuevo.

-----------------------------------------------------------------------
-- 3. Habilitar y Deshabilitar constraints
-----------------------------------------------------------------------
USE Norte_2015
INSERT INTO dbo.Pedidos_Detalles(IdPedido, IdProducto, PrecioUnd, Cantidad, Descuento)
 VALUES (10248, 1, 1, -10, 500)
GO
ALTER TABLE Pedidos_Detalles
 NOCHECK CONSTRAINT CK_Cantidad 
GO
INSERT INTO dbo.Pedidos_Detalles(IdPedido, IdProducto, PrecioUnd, Cantidad, Descuento)
 VALUES (10248, 1, 1, -10, 500)
GO
ALTER TABLE Pedidos_Detalles
 NOCHECK CONSTRAINT CK_Descuento 
GO
INSERT INTO dbo.Pedidos_Detalles(IdPedido, IdProducto, PrecioUnd, Cantidad, Descuento)
 VALUES (10248, 1, 1, -10, 500)
GO

SELECT * FROM dbo.Pedidos_Detalles WHERE IdPedido = 10248

ALTER TABLE Pedidos_Detalles
 CHECK CONSTRAINT CK_Cantidad 
GO
ALTER TABLE Pedidos_Detalles
 CHECK CONSTRAINT CK_Descuento 
GO
INSERT INTO dbo.Pedidos_Detalles(IdPedido, IdProducto, PrecioUnd, Cantidad, Descuento)
 VALUES (100, 2, 1, -10, 500)
GO
SELECT * FROM dbo.Pedidos_Detalles WHERE IdPedido = 10248

-----------------------------------------------------------------------
-- 4. Trabajo en forma gráfica
-----------------------------------------------------------------------
4.1 Deshabilitar check constraint para instrucciones INSERT y UPDATE

A. En Object Explorer, expanda la carpeta Databases, expanda la BD Norte_2015, Tables y 
 en la tabla Pedidos_Detalles, expanda Constraints, de un clic secundario en uno 
 de los constraints y seleccione Modify.
B. En el cuadro de diálogo Check Constraints, el constraint aparece seleccionado a 
   mano izquierda.
C. En la grid, de un click en "Enforce For INSERTS And UPDATES", y seleccione No
D. También puede deshabilitar y habilitar el constraint para replicación.


4.2 Cree un constraint, en forma gráfico, en la tabla Productos de la BD Norte_2015 para 
    que el precio unitario sea > 0.  

