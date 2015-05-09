--procedimiento básico
CREATE PROCEDURE usp_info_error
AS
	SELECT	ERROR_NUMBER () AS NumeroError
			, ERROR_LINE () AS LineaDelError
			, ERROR_MESSAGE () AS MensajeError
			, ERROR_SEVERITY () AS SeveridadError
			, ERROR_STATE () AS Estado
			, ERROR_PROCEDURE () AS ProcedenciaError
GO

--prueba básica
BEGIN TRY
 SELECT 1/0;
END TRY 
BEGIN CATCH
 EXEC usp_info_error;
END CATCH;

--tabla para control de errores
CREATE TABLE [dbo].[tbl_control_error](
	[IdError] [int] IDENTITY(1,1) NOT NULL,
	[LineaDelError] [int] NULL,
	[NumeroError] [int] NULL,
	[MensajeError] [nvarchar](4000) NULL,
	[SeveridadError] [int] NULL,
	[Estado] [int] NULL,
	[ProcedenciaError] [nvarchar](128) NULL,
	[FechaError] [datetime] NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tbl_control_error] ADD  CONSTRAINT [DF_tbl_control_error_FechaError]  DEFAULT (sysdatetime()) FOR [FechaError]
GO

--crear procedimiento con escritura en tabla de errores
CREATE PROCEDURE usp_info_error_2
AS
	INSERT INTO dbo.tbl_control_error (NumeroError
										,LineaDelError
										, MensajeError
										, SeveridadError
										, Estado
										, ProcedenciaError)
	SELECT	ERROR_NUMBER () AS NumeroError
			, ERROR_LINE () AS LineaDelError
			, ERROR_MESSAGE () AS MensajeError
			, ERROR_SEVERITY () AS SeveridadError
			, ERROR_STATE () AS Estado
			, ERROR_PROCEDURE () AS ProcedenciaError
GO

--nueva prueba
BEGIN TRY
 SELECT 1/0;
END TRY 
BEGIN CATCH
 EXEC usp_info_error_2;
 SELECT * FROM dbo.tbl_control_error where IdError = @@IDENTITY;
END CATCH;

--verificar registros insertados en la tabla
select * from dbo.tbl_control_error;



