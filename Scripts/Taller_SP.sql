
--Crear procedimiento almacenado para consultar clientes por CustomerID
CREATE PROCEDURE usp_consulta_clientes 
@customerid int
AS
	SELECT * FROM dbo.Clientes WHERE CustomerID = @customerid
GO

execute dbo.usp_consulta_clientes 3

--crear procedimiento almacenado para insertar un cliente nuevo, agrega una variable para que indique el mensaje de respuesta
--Nota: haga llamado al procedimiento almacenado de control de errores

CREATE PROCEDURE usp_crear_cliente
@PrimerNombre nvarchar(50)
, @SegundoNombre nvarchar(50)
, @Apellidos nvarchar(50)
, @Telefono nvarchar(25)
, @Direccion nvarchar(60)
, @Ciudad nvarchar(30)
, @MensajeEjecucion nvarchar(4000) OUTPUT
AS
BEGIN TRANSACTION;
	BEGIN TRY	
		INSERT INTO dbo.Clientes (PrimerNombre
									,SegundoNombre
									,Apellidos
									,NombreCompleto
									,Telefono
									,Direccion
									,Ciudad
									,FechaCreacion
									,FechaModificacion)
		VALUES (@PrimerNombre
				, @SegundoNombre
				, @Apellidos
				, CONCAT(@PrimerNombre,' ', @SegundoNombre, ' ', @Apellidos)
				, @Telefono
				, @Direccion
				, @Ciudad
				, GETDATE()
				, GETDATE())
		SET @MensajeEjecucion = 'Creacion exitosa'
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		EXEC [dbo].[usp_info_error_2]
		SELECT @MensajeEjecucion = MensajeError FROM dbo.tbl_control_error where IdError = @@IDENTITY;
	END CATCH

--Prueba ejecución fallida
declare @Mensaje nvarchar(4000) 
EXECUTE dbo.usp_crear_cliente 'Diego', 'L', 'Jaramillo Celis', '444 88 82', 'Crra 1', NULL, @MensajeEjecucion = @Mensaje OUTPUT
print @Mensaje

--Prueba ejecución exitosa
declare @Mensaje nvarchar(4000) 
EXECUTE dbo.usp_crear_cliente 'Diego', 'L', 'Jaramillo Celis', '444 88 82', 'Crra 1', 'Medellin', @MensajeEjecucion = @Mensaje OUTPUT
print @Mensaje

--Verificar el registro insertado
select * from dbo.Clientes where PrimerNombre = 'Diego'
--Verificar el registro en la tabla de errores
select * from dbo.tbl_control_error;

