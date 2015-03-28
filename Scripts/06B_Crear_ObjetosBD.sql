--*********************************************************************
-- LABORATORIO CREAR OBJETOS DE BASE DE DATOS
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio será realizado en grupo dirigido por el instructor.
- Solo ejecute las instrucciones cuando el instructor lo indica para no 
  sobrescribir objetos de bases de datos

REQUERIMIENTOS
Previamente debe ejecutar el laboratorio anterior en el cual se creo la BD Norte.

1. Verifique que se encuentra posicionado en la BD Norte.
   Seleccione Nore de la lista desplegable de BD: "Available Databases"
2. Presione el botón ejecutar para crear los objetos de BD
3. Cierre el script 

-----------------------------------------------------------------------
-- CONSULTAR
-----------------------------------------------------------------------
1. ¿Cómo generar un script de los objetos de la BD con SQL?

-----------------------------------------------------------------------
-- RECOMENDACIONES
-----------------------------------------------------------------------
1. Cuando diseñe una aplicación, incluya dentro de los entregables los scripts de los
   objetos de BD de generados.
2. Contar con un script le evitara inconvenientes cuando se presenten fallas en la BD
3. Mantenga la versión actual y la anterior en caso que tenga que devolverse.
4. Generar un script no le quita mucho tiempo, no tenerlo puede implicarle tener que 
   empezar desde el principio.
5. Documente el código usando comentarios.


USE [Norte]
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Regiones]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Regiones](
	[IdRegion] [int] NOT NULL,
	[Nombre] [nchar](50) NOT NULL,
 CONSTRAINT [Regiones_PK] PRIMARY KEY NONCLUSTERED 
(
	[IdRegion] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Telefono]') AND OBJECTPROPERTY(id, N'IsDefault') = 1)
EXEC dbo.sp_executesql N'
CREATE DEFAULT [dbo].[DF_Telefono]  
 AS ''(000)000-0000''  
'
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_Pais]') AND OBJECTPROPERTY(id, N'IsDefault') = 1)
EXEC dbo.sp_executesql N'
CREATE DEFAULT  [dbo].[DF_Pais]  
 AS ''Colombia''  
'
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[RL_Porcentaje]') AND OBJECTPROPERTY(id, N'IsRule') = 1)
EXEC dbo.sp_executesql N'
CREATE RULE [dbo].[RL_Porcentaje]  
 AS @Descuento >= 0 AND @Descuento <= 1
'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Categorias]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Categorias](
	[IdCategoria] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](15) NOT NULL,
	[Descripcion] [ntext] NULL,
	[Imagen] [image] NULL,
 CONSTRAINT [Categorias_PK] PRIMARY KEY CLUSTERED 
(
	[IdCategoria] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Categorias_1] UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos_Historia]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Pedidos_Historia](
	[IdProducto] [int] NOT NULL,
	[IdPedido] [int] NOT NULL,
	[Cantidad] [int] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Clientes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Clientes](
	[IdCliente] [nchar](5) NOT NULL,
	[Compania] [nvarchar](40) NOT NULL,
	[ContactoNombre] [nvarchar](30) NULL,
	[ContactoTitulo] [nvarchar](30) NULL,
	[Direccion] [nvarchar](60) NULL,
	[Ciudad] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[Pais] [nvarchar](15) NULL,
	[Telefono] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL,
 CONSTRAINT [Clientes_PK] PRIMARY KEY CLUSTERED 
(
	[IdCliente] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Clientes]') AND name = N'tblClientes_1')
CREATE NONCLUSTERED INDEX [tblClientes_1] ON [dbo].[Clientes] 
(
	[Compania] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Clientes]') AND name = N'tblClientes_2')
CREATE NONCLUSTERED INDEX [tblClientes_2] ON [dbo].[Clientes] 
(
	[Ciudad] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Clientes]') AND name = N'tblClientes_3')
CREATE NONCLUSTERED INDEX [tblClientes_3] ON [dbo].[Clientes] 
(
	[Region] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Despachadores]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Despachadores](
	[IdDespachador] [int] IDENTITY(1,1) NOT NULL,
	[Compania] [nvarchar](40) NOT NULL,
	[Telefono] [nvarchar](24) NULL,
 CONSTRAINT [Despachadores_PK] PRIMARY KEY CLUSTERED 
(
	[IdDespachador] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proveedores]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Proveedores](
	[IdProveedor] [int] IDENTITY(1,1) NOT NULL,
	[Compania] [nvarchar](40) NOT NULL,
	[ContactoNom] [nvarchar](30) NULL,
	[ContactoTitulo] [nvarchar](30) NULL,
	[Direccion] [nvarchar](60) NULL,
	[Ciudad] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[Pais] [nvarchar](15) NULL,
	[Telefono] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL,
 CONSTRAINT [Proveedores_PK] PRIMARY KEY CLUSTERED 
(
	[IdProveedor] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Proveedores]') AND name = N'Proveedores_1')
CREATE NONCLUSTERED INDEX [Proveedores_1] ON [dbo].[Proveedores] 
(
	[Compania] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Zonas]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Zonas](
	[IdZona] [nvarchar](20) NOT NULL,
	[Nombre] [nchar](50) NOT NULL,
	[IdRegion] [int] NOT NULL,
 CONSTRAINT [Zonas_PK] PRIMARY KEY NONCLUSTERED 
(
	[IdZona] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Empleados_Zonas]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Empleados_Zonas](
	[IdEmpleado] [int] NOT NULL,
	[IdZona] [nvarchar](20) NOT NULL,
 CONSTRAINT [Empleados_Zonas_PK] PRIMARY KEY NONCLUSTERED 
(
	[IdEmpleado] ASC,
	[IdZona] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Pedidos](
	[IdPedido] [int] IDENTITY(1,1) NOT NULL,
	[IdCliente] [nchar](5) NULL,
	[IdEmpleado] [int] NULL,
	[FPedido] [datetime] NULL,
	[FRequerida] [datetime] NULL,
	[FDespacho] [datetime] NULL,
	[IdDespachador] [int] NULL,
	[Flete] [money] NULL CONSTRAINT [DF_Orders_Freight]  DEFAULT (0),
	[EntregaNombre] [nvarchar](40) NULL,
	[EntregaDireccion] [nvarchar](60) NULL,
	[EntregaCiudad] [nvarchar](15) NULL,
	[EntregaRegion] [nvarchar](15) NULL,
	[EntregaPais] [nvarchar](15) NULL,
 CONSTRAINT [Pedidos_PK] PRIMARY KEY CLUSTERED 
(
	[IdPedido] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos]') AND name = N'Pedidos_1')
CREATE NONCLUSTERED INDEX [Pedidos_1] ON [dbo].[Pedidos] 
(
	[IdEmpleado] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos]') AND name = N'Pedidos_2')
CREATE NONCLUSTERED INDEX [Pedidos_2] ON [dbo].[Pedidos] 
(
	[FPedido] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos]') AND name = N'Pedidos_3')
CREATE NONCLUSTERED INDEX [Pedidos_3] ON [dbo].[Pedidos] 
(
	[FDespacho] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos]') AND name = N'Pedidos_4')
CREATE NONCLUSTERED INDEX [Pedidos_4] ON [dbo].[Pedidos] 
(
	[IdDespachador] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos]') AND name = N'Pedidos_5')
CREATE NONCLUSTERED INDEX [Pedidos_5] ON [dbo].[Pedidos] 
(
	[IdEmpleado] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos]') AND name = N'Pedidos_6')
CREATE NONCLUSTERED INDEX [Pedidos_6] ON [dbo].[Pedidos] 
(
	[IdCliente] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos]') AND name = N'Pedidos_7')
CREATE NONCLUSTERED INDEX [Pedidos_7] ON [dbo].[Pedidos] 
(
	[IdCliente] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Productos]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Productos](
	[IdProducto] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](40) NOT NULL,
	[ProveedorId] [int] NULL,
	[IdCategoria] [int] NULL,
	[CantidadPorUnd] [nvarchar](20) NULL,
	[PrecioUnd] [money] NULL CONSTRAINT [DF_Products_UnitPrice]  DEFAULT (0),
	[UnidadesEnStock] [smallint] NULL CONSTRAINT [DF_Products_UnitsInStock]  DEFAULT (0),
	[UnidadesEnPedido] [smallint] NULL CONSTRAINT [DF_Products_UnitsOnOrder]  DEFAULT (0),
	[NivelReorder] [smallint] NULL CONSTRAINT [DF_Products_ReorderLevel]  DEFAULT (0),
	[Descontinuado] [bit] NOT NULL CONSTRAINT [DF_Products_Discontinued]  DEFAULT (0),
	[TotalVentas] [float] NULL CONSTRAINT [DF_Products_TotalVentas]  DEFAULT (0),
 CONSTRAINT [Productos_PK] PRIMARY KEY CLUSTERED 
(
	[IdProducto] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Productos]') AND name = N'CategoriesProducts')
CREATE NONCLUSTERED INDEX [CategoriesProducts] ON [dbo].[Productos] 
(
	[IdCategoria] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Productos]') AND name = N'Productos_1')
CREATE NONCLUSTERED INDEX [Productos_1] ON [dbo].[Productos] 
(
	[IdCategoria] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Productos]') AND name = N'Productos_2')
CREATE NONCLUSTERED INDEX [Productos_2] ON [dbo].[Productos] 
(
	[Nombre] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Productos]') AND name = N'Productos_3')
CREATE NONCLUSTERED INDEX [Productos_3] ON [dbo].[Productos] 
(
	[ProveedorId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Productos]') AND name = N'Productos_4')
CREATE NONCLUSTERED INDEX [Productos_4] ON [dbo].[Productos] 
(
	[ProveedorId] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos_Detalles]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Pedidos_Detalles](
	[IdPedido] [int] NOT NULL,
	[IdProducto] [int] NOT NULL,
	[PrecioUnd] [money] NOT NULL CONSTRAINT [DF_Order_Details_UnitPrice]  DEFAULT (0),
	[Cantidad] [smallint] NOT NULL CONSTRAINT [DF_Order_Details_Quantity]  DEFAULT (1),
	[Descuento] [real] NOT NULL CONSTRAINT [DF_Order_Details_Discount]  DEFAULT (0),
 CONSTRAINT [Pedidos_Detalles_PK] PRIMARY KEY NONCLUSTERED 
(
	[IdPedido] ASC,
	[IdProducto] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos_Detalles]') AND name = N'Pedidos_Detalles_1')
CREATE NONCLUSTERED INDEX [Pedidos_Detalles_1] ON [dbo].[Pedidos_Detalles] 
(
	[IdPedido] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos_Detalles]') AND name = N'Pedidos_Detalles_2')
CREATE NONCLUSTERED INDEX [Pedidos_Detalles_2] ON [dbo].[Pedidos_Detalles] 
(
	[IdPedido] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos_Detalles]') AND name = N'Pedidos_Detalles_3')
CREATE NONCLUSTERED INDEX [Pedidos_Detalles_3] ON [dbo].[Pedidos_Detalles] 
(
	[IdProducto] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Pedidos_Detalles]') AND name = N'Pedidos_Detalles_4')
CREATE NONCLUSTERED INDEX [Pedidos_Detalles_4] ON [dbo].[Pedidos_Detalles] 
(
	[IdProducto] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
EXEC sys.sp_bindrule @rulename=N'[dbo].[RL_Porcentaje]', @objname=N'[dbo].[Pedidos_Detalles].[Descuento]' , @futureonly='futureonly'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwPedidos_Cantidades]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwPedidos_Cantidades] AS
SELECT Pedidos.IdPedido, Pedidos.IdCliente, Pedidos.IdEmpleado, Pedidos.FPedido, Pedidos.FRequerida, 
	Pedidos.FDespacho, Pedidos.IdDespachador, Pedidos.Flete, Pedidos.EntregaNombre, Pedidos.EntregaDireccion, Pedidos.EntregaCiudad, 
	Pedidos.EntregaRegion, Pedidos.EntregaPais, 
	Clientes.Compania, Clientes.Direccion, Clientes.Ciudad, Clientes.Region, Clientes.Pais
FROM Clientes INNER JOIN Pedidos ON Clientes.IdCliente = Pedidos.IdCliente

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwProductos_Lista_Alfabetica]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwProductos_Lista_Alfabetica] AS
SELECT Productos.*, Categorias.Nombre As Categoria
FROM Categorias INNER JOIN Productos ON Categorias.IdCategoria = Productos.IdCategoria
WHERE Productos.Descontinuado=0

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwProductos_Categoria]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwProductos_Categoria] AS
SELECT Categorias.Nombre As Categoria, Productos.Nombre As Producto, 
Productos.CantidadPorUnd, Productos.UnidadesEnStock, Productos.Descontinuado
FROM Categorias INNER JOIN Productos ON Categorias.IdCategoria = Productos.IdCategoria
WHERE Productos.Descontinuado <> 1
--ORDER BY Categorias.Nombre, Productos.Nombre

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwProductos_Por_Encima_Precio_Promedio]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwProductos_Por_Encima_Precio_Promedio] AS
SELECT Productos.Nombre, Productos.PrecioUnd
FROM Productos
WHERE Productos.PrecioUnd>(SELECT AVG(PrecioUnd) From Productos)
--ORDER BY Productos.PrecioUnd DESC

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwProductos_Lista_Actual]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwProductos_Lista_Actual] AS
SELECT P.IdProducto, P.Nombre FROM Productos AS P WHERE P.Descontinuado = 0
-- ORDER BY P.Nombre

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Empleados]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Empleados](
	[IdEmpleado] [int] IDENTITY(1,1) NOT NULL,
	[Apellidos] [nvarchar](20) NOT NULL,
	[Nombres] [nvarchar](10) NOT NULL,
	[Cargo] [nvarchar](30) NULL,
	[TituloCortesia] [nvarchar](25) NULL,
	[FCumpleanos] [datetime] NULL,
	[FContrato] [datetime] NULL CONSTRAINT [DF_FechaActual]  DEFAULT (getdate()),
	[Direccion] [nvarchar](60) NULL,
	[Ciudad] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[Pais] [nvarchar](15) NULL,
	[TelCasa] [nvarchar](13) NULL,
	[Extension] [nvarchar](4) NULL,
	[Foto] [image] NULL,
	[Notas] [ntext] NULL,
	[Reporta_A] [int] NULL,
	[RutaFoto] [nvarchar](255) NULL,
 CONSTRAINT [Empleado_PK] PRIMARY KEY CLUSTERED 
(
	[IdEmpleado] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Empleados]') AND name = N'Empleados_1')
CREATE NONCLUSTERED INDEX [Empleados_1] ON [dbo].[Empleados] 
(
	[Apellidos] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[DF_Pais]', @objname=N'[dbo].[Empleados].[Pais]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[DF_Telefono]', @objname=N'[dbo].[Empleados].[TelCasa]' , @futureonly='futureonly'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwClientes_Y_Proveedores_Ciudad]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwClientes_Y_Proveedores_Ciudad] AS
SELECT Ciudad, Compania, ContactoNombre, ''Clientes'' As Clentes FROM Clientes
UNION SELECT Ciudad, Compania, ContactoNom, ''Proveedores'' As Proveedores FROM Proveedores
-- ORDER BY Ciudad, Compania

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwFacturas]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwFacturas] AS
SELECT Pedidos.EntregaNombre, Pedidos.EntregaDireccion, Pedidos.EntregaCiudad, Pedidos.EntregaRegion,  
	Pedidos.EntregaPais, Pedidos.IdCliente, Clientes.Compania AS CustomerName, Clientes.Direccion, Clientes.Ciudad, 
	Clientes.Region, Clientes.Pais, 
	(Nombres + '' '' + Apellidos) AS Vendedor, 
	Pedidos.IdPedido, Pedidos.FPedido, Pedidos.FRequerida, Pedidos.FDespacho, Despachadores.Compania As ShipperName, 
	Pedidos_Detalles.IdProducto, Productos.Nombre, Pedidos_Detalles.PrecioUnd, Pedidos_Detalles.Cantidad, 
	Pedidos_Detalles.Descuento, 
	(CONVERT(money,(Pedidos_Detalles.PrecioUnd*Cantidad*(1-Descuento)/100))*100) AS Precio_Extendido, Pedidos.Flete
FROM 	Despachadores INNER JOIN 
		(Productos INNER JOIN 
			(
				(Empleados INNER JOIN 
					(Clientes INNER JOIN Pedidos ON Clientes.IdCliente = Pedidos.IdCliente) 
				ON Empleados.IdEmpleado = Pedidos.IdEmpleado) 
			INNER JOIN Pedidos_Detalles ON Pedidos.IdPedido = Pedidos_Detalles.IdPedido) 
		ON Productos.IdProducto = Pedidos_Detalles.IdProducto) 
	ON Despachadores.IdDespachador = Pedidos.IdDespachador

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwVentas_Productos_1997]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwVentas_Productos_1997] AS
SELECT Categorias.Nombre As Categoria, Productos.Nombre As Producto, 
Sum(CONVERT(money,(Pedidos_Detalles.PrecioUnd*Cantidad*(1-Descuento)/100))*100) AS Subtotal
FROM (Categorias INNER JOIN Productos ON Categorias.IdCategoria = Productos.IdCategoria) 
	INNER JOIN (Pedidos 
		INNER JOIN Pedidos_Detalles ON Pedidos.IdPedido = Pedidos_Detalles.IdPedido) 
	ON Productos.IdProducto = Pedidos_Detalles.IdProducto
WHERE (((Pedidos.FDespacho) Between ''19970101'' And ''19971231''))
GROUP BY Categorias.Nombre, Productos.Nombre

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwPedidos_Detalles_Extendidos]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwPedidos_Detalles_Extendidos] AS
SELECT Pedidos_Detalles.IdPedido, Pedidos_Detalles.IdProducto, Productos.Nombre, 
	Pedidos_Detalles.PrecioUnd, Pedidos_Detalles.Cantidad, Pedidos_Detalles.Descuento, 
	(CONVERT(money,(Pedidos_Detalles.PrecioUnd*Cantidad*(1-Descuento)/100))*100) AS Precio_Extendido
FROM Productos INNER JOIN Pedidos_Detalles ON Productos.IdProducto = Pedidos_Detalles.IdProducto
--ORDER BY Pedidos_Detalles.IdPedido

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwPedidos_Subtotales]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwPedidos_Subtotales] AS
SELECT Pedidos_Detalles.IdPedido, Sum(CONVERT(money,(Pedidos_Detalles.PrecioUnd*Cantidad*(1-Descuento)/100))*100) AS Subtotal
FROM Pedidos_Detalles
GROUP BY Pedidos_Detalles.IdPedido

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwVentas_Totales_Por_Cantidad]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwVentas_Totales_Por_Cantidad] AS
SELECT V.Subtotal AS SaleAmount, Pedidos.IdPedido, Clientes.Compania, Pedidos.FDespacho
FROM 	Clientes INNER JOIN 
		(Pedidos INNER JOIN viwPedidos_Subtotales As V ON Pedidos.IdPedido = V.IdPedido) 
	ON Clientes.IdCliente = Pedidos.IdCliente
WHERE (V.Subtotal >2500) AND (Pedidos.FDespacho BETWEEN ''19970101'' And ''19971231'')

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwVentas_Categoria]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwVentas_Categoria] AS
SELECT Categorias.IdCategoria, Categorias.Nombre As Categoria, Productos.Nombre As Producto, 
	Sum("viwPedidos_Detalles_Extendidos".Precio_Extendido) AS Ventas_Producto
FROM 	Categorias INNER JOIN 
		(Productos INNER JOIN 
			(Pedidos INNER JOIN "viwPedidos_Detalles_Extendidos" ON Pedidos.IdPedido = "viwPedidos_Detalles_Extendidos".IdPedido) 
		ON Productos.IdProducto = "viwPedidos_Detalles_Extendidos".IdProducto) 
	ON Categorias.IdCategoria = Productos.IdCategoria
WHERE Pedidos.FPedido BETWEEN ''19970101'' And ''19971231''
GROUP BY Categorias.IdCategoria, Categorias.Nombre, Productos.Nombre
--ORDER BY Productos.Nombre

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwVentas_Por_Cuatrienio]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwVentas_Por_Cuatrienio] AS
SELECT Pedidos.FDespacho, Pedidos.IdPedido, V.Subtotal
FROM Pedidos INNER JOIN viwPedidos_Subtotales As V ON Pedidos.IdPedido = V.IdPedido
WHERE Pedidos.FDespacho IS NOT NULL
--ORDER BY Pedidos.FDespacho

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwVentas_Totales_Por_Ano]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwVentas_Totales_Por_Ano] AS
SELECT Pedidos.FDespacho, Pedidos.IdPedido, V.Subtotal
FROM Pedidos INNER JOIN viwPedidos_Subtotales As V ON Pedidos.IdPedido = V.IdPedido
WHERE Pedidos.FDespacho IS NOT NULL
--ORDER BY Pedidos.FDespacho

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[viwVentas_Categoria_1997]'))
EXEC dbo.sp_executesql @statement = N'
create view [dbo].[viwVentas_Categoria_1997] AS
SELECT V.Producto, Sum(V.Subtotal) AS Subtotal
FROM viwVentas_Productos_1997 As V
GROUP BY V.Producto

' 
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Zonas_Regiones]') AND parent_object_id = OBJECT_ID(N'[dbo].[Zonas]'))
ALTER TABLE [dbo].[Zonas]  WITH NOCHECK ADD  CONSTRAINT [FK_Zonas_Regiones] FOREIGN KEY([IdRegion])
REFERENCES [dbo].[Regiones] ([IdRegion])
GO
ALTER TABLE [dbo].[Zonas] CHECK CONSTRAINT [FK_Zonas_Regiones]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Empleados_Zonas_Empleados]') AND parent_object_id = OBJECT_ID(N'[dbo].[Empleados_Zonas]'))
ALTER TABLE [dbo].[Empleados_Zonas]  WITH NOCHECK ADD  CONSTRAINT [FK_Empleados_Zonas_Empleados] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleados] ([IdEmpleado])
GO
ALTER TABLE [dbo].[Empleados_Zonas] CHECK CONSTRAINT [FK_Empleados_Zonas_Empleados]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Empleados_Zonas_Zonas]') AND parent_object_id = OBJECT_ID(N'[dbo].[Empleados_Zonas]'))
ALTER TABLE [dbo].[Empleados_Zonas]  WITH NOCHECK ADD  CONSTRAINT [FK_Empleados_Zonas_Zonas] FOREIGN KEY([IdZona])
REFERENCES [dbo].[Zonas] ([IdZona])
GO
ALTER TABLE [dbo].[Empleados_Zonas] CHECK CONSTRAINT [FK_Empleados_Zonas_Zonas]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Pedidos_Clientes]') AND parent_object_id = OBJECT_ID(N'[dbo].[Pedidos]'))
ALTER TABLE [dbo].[Pedidos]  WITH NOCHECK ADD  CONSTRAINT [FK_Pedidos_Clientes] FOREIGN KEY([IdCliente])
REFERENCES [dbo].[Clientes] ([IdCliente])
GO
ALTER TABLE [dbo].[Pedidos] CHECK CONSTRAINT [FK_Pedidos_Clientes]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Pedidos_Despachadores]') AND parent_object_id = OBJECT_ID(N'[dbo].[Pedidos]'))
ALTER TABLE [dbo].[Pedidos]  WITH NOCHECK ADD  CONSTRAINT [FK_Pedidos_Despachadores] FOREIGN KEY([IdDespachador])
REFERENCES [dbo].[Despachadores] ([IdDespachador])
GO
ALTER TABLE [dbo].[Pedidos] CHECK CONSTRAINT [FK_Pedidos_Despachadores]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Pedidos_Empleados]') AND parent_object_id = OBJECT_ID(N'[dbo].[Pedidos]'))
ALTER TABLE [dbo].[Pedidos]  WITH NOCHECK ADD  CONSTRAINT [FK_Pedidos_Empleados] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleados] ([IdEmpleado])
GO
ALTER TABLE [dbo].[Pedidos] CHECK CONSTRAINT [FK_Pedidos_Empleados]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Productos_Categorias]') AND parent_object_id = OBJECT_ID(N'[dbo].[Productos]'))
ALTER TABLE [dbo].[Productos]  WITH NOCHECK ADD  CONSTRAINT [FK_Productos_Categorias] FOREIGN KEY([IdCategoria])
REFERENCES [dbo].[Categorias] ([IdCategoria])
GO
ALTER TABLE [dbo].[Productos] CHECK CONSTRAINT [FK_Productos_Categorias]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Productos_Proveedores]') AND parent_object_id = OBJECT_ID(N'[dbo].[Productos]'))
ALTER TABLE [dbo].[Productos]  WITH NOCHECK ADD  CONSTRAINT [FK_Productos_Proveedores] FOREIGN KEY([ProveedorId])
REFERENCES [dbo].[Proveedores] ([IdProveedor])
GO
ALTER TABLE [dbo].[Productos] CHECK CONSTRAINT [FK_Productos_Proveedores]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_NivelReorder]') AND parent_object_id = OBJECT_ID(N'[dbo].[Productos]'))
ALTER TABLE [dbo].[Productos]  WITH NOCHECK ADD  CONSTRAINT [CK_NivelReorder] CHECK  (([NivelReorder] >= 0))
GO
ALTER TABLE [dbo].[Productos] CHECK CONSTRAINT [CK_NivelReorder]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_Productos_PrecioUnd]') AND parent_object_id = OBJECT_ID(N'[dbo].[Productos]'))
ALTER TABLE [dbo].[Productos]  WITH NOCHECK ADD  CONSTRAINT [CK_Productos_PrecioUnd] CHECK  (([PrecioUnd] >= 0))
GO
ALTER TABLE [dbo].[Productos] CHECK CONSTRAINT [CK_Productos_PrecioUnd]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_UnidadesEnPedido]') AND parent_object_id = OBJECT_ID(N'[dbo].[Productos]'))
ALTER TABLE [dbo].[Productos]  WITH NOCHECK ADD  CONSTRAINT [CK_UnidadesEnPedido] CHECK  (([UnidadesEnPedido] >= 0))
GO
ALTER TABLE [dbo].[Productos] CHECK CONSTRAINT [CK_UnidadesEnPedido]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_UnidadesEnStock]') AND parent_object_id = OBJECT_ID(N'[dbo].[Productos]'))
ALTER TABLE [dbo].[Productos]  WITH NOCHECK ADD  CONSTRAINT [CK_UnidadesEnStock] CHECK  (([UnidadesEnStock] >= 0))
GO
ALTER TABLE [dbo].[Productos] CHECK CONSTRAINT [CK_UnidadesEnStock]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Pedidos_Detalles_Productos]') AND parent_object_id = OBJECT_ID(N'[dbo].[Pedidos_Detalles]'))
ALTER TABLE [dbo].[Pedidos_Detalles]  WITH NOCHECK ADD  CONSTRAINT [FK_Pedidos_Detalles_Productos] FOREIGN KEY([IdProducto])
REFERENCES [dbo].[Productos] ([IdProducto])
GO
ALTER TABLE [dbo].[Pedidos_Detalles] CHECK CONSTRAINT [FK_Pedidos_Detalles_Productos]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Pedidos_Pedidos_Detalles]') AND parent_object_id = OBJECT_ID(N'[dbo].[Pedidos_Detalles]'))
ALTER TABLE [dbo].[Pedidos_Detalles]  WITH NOCHECK ADD  CONSTRAINT [FK_Pedidos_Pedidos_Detalles] FOREIGN KEY([IdPedido])
REFERENCES [dbo].[Pedidos] ([IdPedido])
GO
ALTER TABLE [dbo].[Pedidos_Detalles] CHECK CONSTRAINT [FK_Pedidos_Pedidos_Detalles]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_Cantidad]') AND parent_object_id = OBJECT_ID(N'[dbo].[Pedidos_Detalles]'))
ALTER TABLE [dbo].[Pedidos_Detalles]  WITH NOCHECK ADD  CONSTRAINT [CK_Cantidad] CHECK  (([Cantidad] > 0))
GO
ALTER TABLE [dbo].[Pedidos_Detalles] CHECK CONSTRAINT [CK_Cantidad]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_PrecioUnd]') AND parent_object_id = OBJECT_ID(N'[dbo].[Pedidos_Detalles]'))
ALTER TABLE [dbo].[Pedidos_Detalles]  WITH NOCHECK ADD  CONSTRAINT [CK_PrecioUnd] CHECK  (([PrecioUnd] >= 0))
GO
ALTER TABLE [dbo].[Pedidos_Detalles] CHECK CONSTRAINT [CK_PrecioUnd]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Empleados_Empleados]') AND parent_object_id = OBJECT_ID(N'[dbo].[Empleados]'))
ALTER TABLE [dbo].[Empleados]  WITH NOCHECK ADD  CONSTRAINT [FK_Empleados_Empleados] FOREIGN KEY([Reporta_A])
REFERENCES [dbo].[Empleados] ([IdEmpleado])
GO
ALTER TABLE [dbo].[Empleados] CHECK CONSTRAINT [FK_Empleados_Empleados]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_FCumpleanos]') AND parent_object_id = OBJECT_ID(N'[dbo].[Empleados]'))
ALTER TABLE [dbo].[Empleados]  WITH NOCHECK ADD  CONSTRAINT [CK_FCumpleanos] CHECK  (([FCumpleanos] < getdate()))
GO
ALTER TABLE [dbo].[Empleados] CHECK CONSTRAINT [CK_FCumpleanos]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK_Telefono]') AND parent_object_id = OBJECT_ID(N'[dbo].[Empleados]'))
ALTER TABLE [dbo].[Empleados]  WITH NOCHECK ADD  CONSTRAINT [CK_Telefono] CHECK  (([TelCasa] like '(200)[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Empleados] CHECK CONSTRAINT [CK_Telefono]
