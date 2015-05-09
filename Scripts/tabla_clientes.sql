USE [01TestDB]
GO

/****** Object:  Table [dbo].[Clientes]    Script Date: 5/8/2015 11:39:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Clientes](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[PrimerNombre] [nvarchar](50) NOT NULL,
	[SegundoNombre] [nvarchar](50) NULL,
	[Apellidos] [nvarchar](50) NOT NULL,
	[NombreCompleto] [nvarchar](150) NULL,
	[Telefono] [nvarchar](25) NULL,
	[Direccion] [nvarchar](60) NULL,
	[Ciudad] [nvarchar](30) NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[FechaModificacion] [datetime] NOT NULL,
 CONSTRAINT [PK_Clientes] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Clientes] ADD  CONSTRAINT [DF_Clientes_FechaCreacion]  DEFAULT (getdate()) FOR [FechaCreacion]
GO

ALTER TABLE [dbo].[Clientes] ADD  CONSTRAINT [DF_Clientes_FechaModificacion]  DEFAULT (getdate()) FOR [FechaModificacion]
GO


