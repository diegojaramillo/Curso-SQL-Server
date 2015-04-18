--*********************************************************************
-- LABORATORIO CONSTRAINT PK, UNIQUE Y FK
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio será realizado por los alumnos con la supervisión del instructor.

REQUERIMIENTOS
- Algunos de los constraints serán creados en la BD Norte_2015 creada en los scripts anteriores.

-----------------------------------------------------------------------
-- 1. Clave Primaria
-----------------------------------------------------------------------
1.1 Borrar la PK, si existe, y luego crearla
USE Norte_2015
GO

IF EXISTS (SELECT * FROM sys.objects WHERE Type = 'PK' AND Name = 'Pedidos_Detalles_PK')
 ALTER TABLE Pedidos_Detalles
  DROP CONSTRAINT Pedidos_Detalles_PK
GO


ALTER TABLE Pedidos_Detalles
 ADD CONSTRAINT Pedidos_Detalles_PK PRIMARY KEY NONCLUSTERED 
 (IdPedido, IdProducto) WITH FILLFACTOR = 80
GO

1.2 Listar todas las claves primarias de una BD

SELECT OP.name As Tabla, O.name As PK 
 FROM sys.objects As O INNER JOIN sys.objects As OP ON 
 O.Parent_Object_id = OP.Object_id WHERE O.Type = 'PK'



-----------------------------------------------------------------------
-- 2. CONSTRAINT FK: Clave Foranea
-----------------------------------------------------------------------
2.1 Observe la sintaxis para crear la FK cuando crea una tabla, 
    No ejecute las siguientes instrucciones

CREATE TABLE dbo.CustomerAddress
 ( ...
  StateProvinceID int NULL REFERENCES dbo.StateProvince(StateProvinceID),
 ...)

CREATE TABLE dbo.CustomerAddress
( ...
  StateProvinceID int NULL FOREIGN KEY (StateProvinceID)
   REFERENCES dbo.StateProvince(StateProvinceID),
 ...)

2.2 Borrar la FK, si existe, y luego crearla
USE Norte_2015
GO
--IF EXISTS (SELECT * FROM sys.objects WHERE Type='F' AND Name='FK_Pedidos_Pedidos_Detalles')
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE Name = 'FK_Pedidos_Pedidos_Detalles')
 ALTER TABLE Pedidos_Detalles
  DROP CONSTRAINT FK_Pedidos_Pedidos_Detalles
GO

ALTER TABLE Pedidos_Detalles WITH NOCHECK
 ADD CONSTRAINT FK_Pedidos_Pedidos_Detalles 
 FOREIGN KEY (IdPedido) 
 REFERENCES Pedidos (IdPedido)
GO

2.3 Listar todas las claves foraneas de una BD
SELECT OP.name As Tabla, F.name As FK 
 FROM sys.foreign_keys As F INNER JOIN sys.objects As OP ON 
 F.Parent_Object_id = OP.Object_id 

-----------------------------------------------------------------------
-- 3. CONSTRAINT UNIQUE. (Automáticamente crea un índice único)
-----------------------------------------------------------------------
3.1 Borrar el constraint, si existe, y luego crearlo
IF EXISTS (SELECT * FROM sys.objects WHERE Type = 'UQ' AND Name = 'Categorias_1')
 ALTER TABLE Categorias
  DROP CONSTRAINT Categorias_1
GO

ALTER TABLE Categorias
 ADD CONSTRAINT Categorias_1 UNIQUE NONCLUSTERED (Nombre) 
 WITH FILLFACTOR = 80

/*
IF EXISTS (SELECT name FROM sysindexes WHERE name = 'Categorias_1')
 DROP INDEX Categorias.Categorias_1
*/

3.2 Listar todas todas las Constraint Unique de una BD
SELECT OP.name As Tabla, O.name As UQ 
 FROM sys.objects As O INNER JOIN sys.objects As OP ON 
 O.Parent_Object_id = OP.Object_id WHERE O.Type = 'UQ'

NOTA: Usualmente no se crea un constraint único, si no un índice único.

-----------------------------------------------------------------------
-- 4. Trabajo en forma gráfica
-----------------------------------------------------------------------
4.1 Crear la siguiente tabla en la BD Norte_2015 utilizando "Object explorer"
NOTA: En FK diseñar campos diferentes, para que al crear la FK se produzca un error 
para corrección
Inserte filas en las tablas para validar los constraints 

DROP TABLE dbo.Regiones
DROP TABLE dbo.Clientes
DROP TABLE dbo.Clientes_Direcciones
DROP TABLE dbo.Paises
DROP TABLE dbo.Direcciones_Tipos

dbo.Regiones
(
	IdRegion int IDENTITY(1,1) NOT NULL,
	Nombre   varchar(50) NOT NULL,
 FActualizacion datetime NULL
) 
PK = IdRegion

dbo.Clientes
(
	IdCliente char(5) NOT NULL,
	Compania varchar(40) NOT NULL,
	ContactoNombre varchar(30) NULL,
	ContactoTitulo varchar(30) NULL,
	Direccion varchar(60) NOT NULL,
	Ciudad varchar(15) NULL,
	Region varchar(15) NULL,
	Pais varchar(15) NULL,
	Telefono varchar(24) NULL,
	Fax varchar(24) NULL,
) 
PK = IdCliente

dbo.Clientes_Direcciones
(
IdCliente int IDENTITY(1,1),
 IdDirTipo char(4) NOT NULL,
 bEsDirPrimaria bit NOT NULL,
	Direccion varchar(60) NOT NULL,
 IdPais char(3) NOT NULL,
 Ciudad varchar(50) NOT NULL);
PK = IdCliente

Diseñe la tabla de paises
¿Cual otra tabla debe crear?

4.2 Cree un diagrama de la BD, adicione solo las tablas creadas en este punto
    en forma gráfica cree las FK

ADVERTENCIA:
Al crear las FK obtiene errores, corrijalos e intente crear de nuevo las FK





