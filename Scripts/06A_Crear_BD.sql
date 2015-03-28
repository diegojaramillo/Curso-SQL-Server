--*********************************************************************
-- LABORATORIO CREAR BASE DE DATOS
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio será realizado en grupo dirigido por el instructor.
- Solo ejecute las instrucciones cuando el instructor lo indica para no 
  sobrescribir bases de datos

REQUERIMIENTOS
Verifique que su disco contenga la siguiente carpeta:
C:\Curso_SQL

Si lo requiere cambie la ruta usando el menú: 
 Edit, "Find and replace", "Quick replace" 

-----------------------------------------------------------------------
-- 1. Crar una BD con un archivo de datos y uno de log
-----------------------------------------------------------------------
USE [master]
GO
--IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'Norte')
-- DROP DATABASE [Norte]
--GO

-- No Olvide validar la ruta de creación
 
CREATE DATABASE Norte 
 ON
 PRIMARY 
 (NAME = N'Norte_Data',
  -- Por favor buscar una ruta válida
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Norte_Data.mdf', 
  SIZE = 5MB, 
  MAXSIZE = UNLIMITED, 
  FILEGROWTH = 10%)
 LOG ON 
 (NAME = N'Norte_Log', 
  -- Por favor buscar una ruta válida
  FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Norte_Log.ldf' , 
  SIZE = 1024KB , 
  MAXSIZE = 200MB, 
  FILEGROWTH = 1MB)
GO

EXEC [Norte].sys.sp_addextendedproperty @name=N'Curso_SQL', 
 @value=N'Norte base de datos para el curso de SQL' 
GO

-----------------------------------------------------------------------
-- 2. Crar BD con Filegroups
-----------------------------------------------------------------------
Analice la siguiente instrucción, pero no la ejecute.

CREATE DATABASE Proyectos
 ON
 PRIMARY
 (NAME = Proyectos_Data,
  FILENAME = 'C:\Curso_SQL\Proyectos_Data.mdf',
  SIZE = 2MB,
  MAXSIZE = UNLIMITED,
  FILEGROWTH = 10%),
 FILEGROUP ProyectosFG
 (NAME = Proyectos_Data1,
  FILENAME = 'D:\ACME\Curso_SQL\Proyectos_Data1.ndf',
  SIZE = 2MB,
  MAXSIZE = UNLIMITED,
  FILEGROWTH = 10%),
 (NAME = Proyectos_Data2,
  FILENAME = 'E:\ACME\Curso_SQL\Proyectos2_Data2.ndf',
  SIZE = 2MB,
  MAXSIZE = UNLIMITED,
  FILEGROWTH = 10%),
 FILEGROUP ProyectosHistoricoFG
 (NAME = ProyectosHistorico,
  FILENAME = 'E:\ACME\Curso_SQL\ProyectosHistorico_Data.ndf',
  SIZE = 2MB,
  MAXSIZE = UNLIMITED,
  FILEGROWTH = 10%)
 LOG ON
 (NAME = Proyectos_Log,
  FILENAME = 'F:\ACME\Curso_SQL\Proyectos_Log.ldf',
  SIZE = 2MB,
  MAXSIZE = UNLIMITED,
  FILEGROWTH = 10%)

PREGUNTAS PARA EL ALUMNO:
1. Dibuje, en papel, la distribucion de archivos y grupos de archivos en los discos 

-----------------------------------------------------------------------
-- 3. Adicionar un grupo de archivo con dos archivos de datos a una BD
-----------------------------------------------------------------------
USE master
GO
ALTER DATABASE Norte
 ADD FILEGROUP NorteFG1;
GO
-- Ruta de la carpeta Data de SQL Server
DECLARE @sRuta nvarchar(256);
SET @sRuta = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)
                  FROM master.sys.master_files
                  WHERE database_id = 1 AND file_id = 1);
PRINT @sRuta

SET @sRuta = 'C:\Curso_SQL\'

EXECUTE (
'ALTER DATABASE Norte 
ADD FILE 
(
    NAME = Norte_Data1,
    FILENAME = '''+ @sRuta + 'Norte_Data1.ndf'',
    SIZE = 1MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10%
),
(
    NAME = Norte_Data2,
    FILENAME = '''+ @sRuta + 'Norte_Data2.ndf'',
    SIZE = 1MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10%
)
TO FILEGROUP NorteFG1'
);
GO

-----------------------------------------------------------------------
-- 4. Cambiar el filegroup por defecto de una BD
-----------------------------------------------------------------------
4.1 Cambiar filegroup por defecto a NorteFG1
ALTER DATABASE Norte
 MODIFY FILEGROUP NorteFG1 DEFAULT
GO

4.2 Retornar el filegroup por defecto a PRIMARY (Observe los corchetes [ ])
ALTER DATABASE Norte
 MODIFY FILEGROUP [PRIMARY] DEFAULT
GO

-----------------------------------------------------------------------
-- 5. Remover un archivo de la BD
-----------------------------------------------------------------------
USE master;
GO
ALTER DATABASE Norte
 REMOVE FILE Norte_Data2;
GO

-----------------------------------------------------------------------
-- 6. Cambiar el modo de recuperación
-----------------------------------------------------------------------
5.1 Guardar todas las transacciones en el log
ALTER DATABASE Norte
 SET RECOVERY FULL
GO

5.2 Guarda transacciones en el log, apropiado en forma temporal cuando 
    realiza procesos de carga masiva de datos
ALTER DATABASE Norte
 SET RECOVERY BULK_LOGGED
GO

5.3 No generar registro de transacciones
ALTER DATABASE Norte
 SET RECOVERY SIMPLE
GO

-----------------------------------------------------------------------
-- 7. Revisar las propiedades de la BD en forma gráfica
-----------------------------------------------------------------------
7.1 Abra la ventana: "Object explorer"
7.2 Expanda la carpeta Databases
7.3 De un clic secundario en la BD Norte y seleccione: "Properties"
7.4 Navegue por las diferentes opciones

