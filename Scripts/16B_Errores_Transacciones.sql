--*********************************************************************
-- LABORATORIO MANEJADORES DE ERROR Y TRANSACCIONES
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio será realizado por el alumno sin la supervisión del instructor.
- En clase solo ejecute los puntos 1 al 3, las demás instrucciones son para 
  trabajo fuera de clase

-----------------------------------------------------------------------
-- 1. Usar mensajes de error creados por el usuario en bloques Try ... Catch
-----------------------------------------------------------------------
1.1 Crear un mensaje personalizado
IF EXISTS (SELECT message_id FROM sys.messages WHERE message_id = 50010)
 EXECUTE sp_dropmessage 50010;
GO

EXECUTE sp_addmessage @msgnum = 50010,
 @severity = 16, 
 @msgtext = N'Mensaje proveniente del bloque Try %s.';
GO

1.2 Uso de manejadores de error

BEGIN TRY 
 -- Generar error en bloque try externo.
 RAISERROR (50010, -- IdMensaje.
            16, -- Severidad,
            1, -- Estado,
            N'externo 1'); -- parámetro a ser reemplazado en texto de mensaje.
END TRY 
BEGIN CATCH 
 PRINT N'Error en bloque 1: ' + ERROR_MESSAGE();

 BEGIN TRY 
  -- Inicar TRY...CATCH anidado y generar un nuevo error 
  RAISERROR (50010, 10, 2, 'interno 2') WITH LOG; 
 END TRY 
 BEGIN CATCH 
  PRINT N'Error en bloque 2: ' + ERROR_MESSAGE();
 END CATCH; 

 PRINT N'Error en bloque 1: ' + ERROR_MESSAGE();
END CATCH; 
GO

-----------------------------------------------------------------------
-- 2. Funciones para recuperar datos de error en bloque Catch
-----------------------------------------------------------------------
2.1 Procedimiento que retorna información de error

USE AdventureWorks2012;
GO

IF OBJECT_ID ('spGetError_Informacion', 'P') IS NOT NULL
 DROP PROCEDURE spGetError_Informacion;
GO

CREATE PROCEDURE spGetError_Informacion
AS
 SELECT 
  ERROR_NUMBER() AS IdError,
  ERROR_SEVERITY() AS Severidad,
  ERROR_STATE() as Estado,
  ERROR_PROCEDURE() as Procedencia,
  ERROR_LINE() as Linea,
  ERROR_MESSAGE() as MensajeError;
GO

2.2 Retornar información al usuario sobre error por división por cero

BEGIN TRY
 SELECT 1/0; -- División por cero (0) que genera error
END TRY
BEGIN CATCH
 EXECUTE spGetError_Informacion; -- Llamar rutina de notificación de error
END CATCH;
GO

-----------------------------------------------------------------------
-- 3. Manejo de transacciones
-----------------------------------------------------------------------
USE Norte;
GO

IF OBJECT_ID (N'Libros_Transacciones', N'U') IS NOT NULL
 DROP TABLE Libros_Transacciones;
GO

CREATE TABLE Libros_Transacciones
(
 IdLibro int PRIMARY KEY,
 Titulo  NVARCHAR(100)
);
GO

BEGIN TRY
 BEGIN TRANSACTION;
 -- La siguiente instrucción genera error por que la columna Autor no existe en tabla
 ALTER TABLE Libros_Transacciones DROP COLUMN Autor;
 COMMIT TRANSACTION; -- Si la instrucción sucede, cometer la transacción 
END TRY
BEGIN CATCH
 SELECT ERROR_NUMBER() as IdError, ERROR_MESSAGE() as Error;

 -- XACT_STATE = 0 significa que no hay transaccion, y un COMMIT o ROLLBACK 
 -- puede generar error

 IF (XACT_STATE()) = -1 -- Evaluar si la transacción no fue cometida
 BEGIN
  PRINT 'Transacción en estado no cometido. La transacción será reversada.'
  ROLLBACK TRANSACTION;
 END;
 ELSE IF (XACT_STATE()) = 1 -- Evaluar si la transacción está activa y valida
 BEGIN
  PRINT 'La transacción puede ser cometida. Se hará un commit.'
  COMMIT TRANSACTION;   
 END;
END CATCH;
GO

-----------------------------------------------------------------------
-- LAS SIGUIENTES INSTRUCCIONES SON PARA EJECUTAR FUERA DE CLASE
-- CONTINUE CON EL SIGUIENTE LABORATORIO
-----------------------------------------------------------------------

-----------------------------------------------------------------------
-- 4. Uso de @@Error
-----------------------------------------------------------------------
4.1 Crear un mensaje personalizado. mensaje con texto sustituido por una cadena

IF EXISTS (SELECT message_id FROM sys.messages WHERE message_id = 50010)
 EXECUTE sp_dropmessage 50010;
GO

EXECUTE sp_addmessage @msgnum = 50010, 
 @severity = 16, 
 @msgtext = N'Mensaje del usuario = %s.';

GO
DECLARE @iError INT;
RAISERROR (50010, -- IdMensaje.
    15, -- Severidad,
    1, -- Estado,
    N'ABC'); -- Texto del usuario

SET @iError = @@ERROR; -- Guardar el código del ultimo error

-- El mensaje actual no es disponible fuera de bloque CATCH
SELECT @iError AS ErrorID, text FROM sys.messages
  WHERE message_id = @iError;
GO

-----------------------------------------------------------------------
-- 5. TRY ... CATCH con RAISERROR
-----------------------------------------------------------------------
USE AdventureWorks2012;
GO

IF OBJECT_ID (N'spRelanzarError',N'P') IS NOT NULL
 DROP PROCEDURE spRelanzarError;
GO

CREATE PROCEDURE spRelanzarError 
AS
/*
  Relanza el error con la información formateada del error actual
  Esta información es utilizada para construir el mensaje de un RAISERROR
*/
 IF ERROR_NUMBER() IS NULL
  RETURN;

 DECLARE 
  @ErrorMessage    NVARCHAR(4000),
  @IdError     INT,
  @ErrorSeverity   INT,
  @ErrorState      INT,
  @ErrorLine       INT,
  @ErrorProcedure  NVARCHAR(200);

 SELECT @IdError = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(),
  @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(),
  @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');

 SELECT @ErrorMessage = 'Error: %d, Nivel: %d, Estado: %d, Procedencia: %s, Linea: %d, ' + 
  'Mensaje: '+ ERROR_MESSAGE();

 -- Generar error con la información original
 RAISERROR 
 (
  @ErrorMessage, 
  @ErrorSeverity, 
  1,   
  @IdError,    -- parameter: original error number.
  @ErrorSeverity,  -- parameter: original error severity.
  @ErrorState,     -- parameter: original error state.
  @ErrorProcedure, -- parameter: original error procedure name.
  @ErrorLine -- parameter: original error line number.
 );
GO

IF OBJECT_ID (N'spGenerarError',N'P') IS NOT NULL
 DROP PROCEDURE spGenerarError;
GO

CREATE PROCEDURE spGenerarError 
AS 
/*
  Procedimiento que genera un error al violar un constraint. 
  El error es atrapado en el bloque Catch, donde es relanzado denuevo 
  al ejecutar spRelanzarError
*/
 BEGIN TRY
  -- La siguiente línea genera un error por un constraint FK
  DELETE FROM Production.Product WHERE ProductID = 980;
 END TRY
BEGIN CATCH
 EXEC spRelanzarError; -- Llama el PA que genera el error original
END CATCH;
GO

-- En el siguiente batch, un error ocurre dentro de un procedimieto externo 
BEGIN TRY  
 EXECUTE spGenerarError; -- Llama el PA que genera el error original
END TRY
BEGIN CATCH 
 SELECT ERROR_NUMBER() as IdError, ERROR_MESSAGE() as ErrorMessage;
END CATCH;
GO

-----------------------------------------------------------------------
-- 6. Uso de PRINT
-----------------------------------------------------------------------
-- Mensaje con información del servidor
PRINT 'La instancia '+ RTRIM(@@SERVERNAME)
    + ' está corriendo en SQL Server '
    + RTRIM(CAST(SERVERPROPERTY(N'ProductVersion') AS NVARCHAR(128)));
GO

-----------------------------------------------------------------------
-- 7. Uso de @@ERROR
-----------------------------------------------------------------------
DECLARE @iError INT

RAISERROR(N'Error generado por el usuario', 16, 1);
-- Guardar número de error antes que @@ERROR sea reseateado por la instrucción IF
SET @iError = @@ERROR 
IF @iError <> 0
 PRINT 'Error = ' + CAST(@iError AS NVARCHAR(8)); -- 'Error = 50000'
GO

USE AdventureWorks2012;
GO
DECLARE @iError INT;
DECLARE @RowCountVar INT;

DELETE FROM HumanResources.JobCandidate
  WHERE JobCandidateID = 13;
-- Save @@ERROR and @@ROWCOUNT while they are both
-- still valid.
SELECT @iError = @@ERROR,
    @RowCountVar = @@ROWCOUNT;
IF (@iError <> 0)
    PRINT N'Error = ' + CAST(@iError AS NVARCHAR(8));
PRINT N'Rows Deleted = ' + CAST(@RowCountVar AS NVARCHAR(8));
GO

-----------------------------------------------------------------------
-- 8. Solución para manejar errores en la BD AdventureWorks
-----------------------------------------------------------------------
IF OBJECT_ID (N'uspLogError',N'P') IS NOT NULL
 DROP PROCEDURE uspLogError;
GO

CREATE PROCEDURE [dbo].[uspLogError] 
    @ErrorLogID [int] = 0 OUTPUT  
AS
/* Los errores son almacenados en la tabla dbo.ErrorLog, para su analisis

   El parámetro output @ErrorLogID de uspLogError retorna el ErrorLogID de la fila 
   insertada por uspLogError en la tabla ErrorLog
*/
BEGIN
 SET NOCOUNT ON;

    -- Output parameter value of 0 indicates that error 
    -- information was not logged
    SET @ErrorLogID = 0;

    BEGIN TRY
        -- Return if there is no error information to log
        IF ERROR_NUMBER() IS NULL
            RETURN;

        -- Return if inside an uncommittable transaction.
        -- Data insertion/modification is not allowed when 
        -- a transaction is in an uncommittable state.
        IF XACT_STATE() = -1
        BEGIN
            PRINT 'Cannot log error since the current transaction is in an uncommittable state. ' 
                + 'Rollback the transaction before executing uspLogError in order to successfully log error information.';
            RETURN;
        END;

        INSERT [dbo].[ErrorLog] 
            (
            [UserName], 
            [ErrorNumber], 
            [ErrorSeverity], 
            [ErrorState], 
            [ErrorProcedure], 
            [ErrorLine], 
            [ErrorMessage]
            ) 
        VALUES 
            (
            CONVERT(sysname, CURRENT_USER), 
            ERROR_NUMBER(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_MESSAGE()
            );

        -- Pass back the ErrorLogID of the row inserted
        SELECT @ErrorLogID = @@IDENTITY;
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred in stored procedure uspLogError: ';
        EXECUTE [dbo].[uspPrintError];
        RETURN -1;
    END CATCH
END; 


CREATE PROCEDURE [dbo].[uspPrintError] 
AS
/* Imprime información del error, debe ser ejecutado dentro 
   de un bloque Catch, de lo contrario imprime nulo
*/
BEGIN
    SET NOCOUNT ON;

    -- Print error information. 
    PRINT 'Error ' + CONVERT(varchar(50), ERROR_NUMBER()) +
          ', Severidad ' + CONVERT(varchar(5), ERROR_SEVERITY()) +
          ', Estado ' + CONVERT(varchar(5), ERROR_STATE()) + 
          ', Procedure ' + ISNULL(ERROR_PROCEDURE(), '-') + 
          ', Line ' + CONVERT(varchar(5), ERROR_LINE());
    PRINT ERROR_MESSAGE();
END
GO

Para probar el PA intenta eliminar un producto, la FK aplica una restricción y la 
transacción es reversada y se almacena un registro e imprime el error

USE AdventureWorks2012;
GO

-- Variable to store ErrorLogID value of the row
-- inserted in the ErrorLog table by uspLogError 
DECLARE @ErrorLogID INT;

BEGIN TRY
    BEGIN TRANSACTION;

    -- A foreign key constraint exists on this table. This 
    -- statement will generate a constraint violation error.
    DELETE FROM Production.Product
        WHERE ProductID = 980;

    -- If the delete succeeds, commit the transaction
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Call procedure to print error information.
    EXECUTE dbo.uspPrintError;

    -- Rollback any active or uncommittable transactions before
    -- inserting information in the ErrorLog
    IF XACT_STATE() <> 0
    BEGIN
        ROLLBACK TRANSACTION;
    END

    EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
END CATCH; 

-- Retrieve logged error information
SELECT * FROM dbo.ErrorLog WHERE ErrorLogID = @ErrorLogID;
GO
 