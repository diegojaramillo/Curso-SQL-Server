--*********************************************************************
-- LABORATORIO CONSTRAINTS DEFAULTS Y RULES
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio sera realizado por los alumnos con la supervisión del instructor.
- Seleccione las instrucciones y ejecutelas por partes.
- Escriba sus inquietudes para discutirlas al final del laboratorio.

-----------------------------------------------------------------------
-- 1. Constraint Default
-----------------------------------------------------------------------
1.1 El valor por defecto para la fecha es la fecha actual
USE Norte_2015 
GO

--IF EXISTS (SELECT * FROM sys.objects WHERE Type = 'D' AND Name = 'DF_FechaActual')
IF EXISTS (SELECT * FROM sys.default_constraints WHERE Name = 'DF_FechaActual')
 ALTER TABLE Empleados
  DROP CONSTRAINT DF_FechaActual
GO

ALTER TABLE Empleados 
 ADD CONSTRAINT DF_FechaActual DEFAULT GetDate() FOR FContrato

-----------------------------------------------------------------------
-- 2. Objeto Default a nivel de BD
-----------------------------------------------------------------------
2.1 Default generico para el telefono
--IF EXISTS (SELECT * FROM sys.default_constraints WHERE Name = 'DF_Telefono')
IF EXISTS (SELECT * FROM sys.objects WHERE Type = 'D' AND Name = 'DF_Telefono')
BEGIN 
 EXEC sp_unbindefault 'Empleados.TelCasa'
 DROP DEFAULT DF_Telefono
END
GO

CREATE DEFAULT DF_Telefono  
 AS '(000)000-0000'  
GO 
-- Vincular el defaul
sp_bindefault DF_Telefono, 'Empleados.TelCasa' 
GO

2.2 Default generico para el Pais
--IF EXISTS (SELECT * FROM sys.default_constraints WHERE Name = 'DF_Pais')
IF EXISTS (SELECT * FROM sys.objects WHERE Type = 'D' AND Name = 'DF_Pais')
BEGIN 
 EXEC sp_unbindefault 'Empleados.Pais'
 DROP DEFAULT DF_Pais
END
GO

CREATE DEFAULT DF_Pais  
 AS 'Colombia'  
GO 
-- Vincular el defaul
sp_bindefault DF_Pais, 'Empleados.Pais' 
GO

-----------------------------------------------------------------------
-- 3. Reglas a nivel de BD
-----------------------------------------------------------------------
3.1 Regla para porcentaje
IF EXISTS (SELECT * FROM sys.objects WHERE Type = 'R' AND Name = 'RL_Porcentaje')
BEGIN 
 EXEC sp_unbindrule 'Pedidos_Detalles.Descuento'
 DROP RULE RL_Porcentaje
END
GO

CREATE RULE RL_Porcentaje  
 AS @Descuento >= 0 AND @Descuento <= 1
GO 
-- Vincular la regla
sp_bindrule RL_Porcentaje, 'Pedidos_Detalles.Descuento'
GO


-----------------------------------------------------------------------
-- 5. Obtener informacion de los objetos creados
-----------------------------------------------------------------------
Execute sp_help 'DF_Telefono'
GO
Execute sp_helptext 'DF_Telefono'
GO
Execute sp_depends 'RL_Porcentaje'
GO

-----------------------------------------------------------------------
-- 6. Trabajo en forma gráfica
-----------------------------------------------------------------------
6.1 Revise los valores por defecto y las reglas para las tablas de Empleados y 
    Pedidos_Detalles. Inserte y modifique datos para validar las restricciones creadas
    
6.2 En la BD Norte_2015 en la carpeta Programmability, revise las carpetas Rules y Defaults

-----------------------------------------------------------------------
-- PREGUNTAS PARA EL ALUMNO:
-----------------------------------------------------------------------
1. ¿Cuál es la diferencia en el defaul creado en el diseño de la tabla y el vinculado 
   con un objeto Default?
2. ¿Qué diferencia hay en utilizar una regla y un check constraint?
3. ¿Cuándo usar default genéricos y cuándo crear el default en el diseño de la tabla?
4. ¿Cuándo usar una regla y cuándo usar un check constraint?
