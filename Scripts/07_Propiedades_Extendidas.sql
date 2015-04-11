--*********************************************************************
-- LABORATORIO PROPIEDADES EXTENDIDAS
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio sera realizado por los alumnos sin la supervisión del instructor.
- Seleccione las instrucciones y ejecutelas por partes, observe los resultados, 

-----------------------------------------------------------------------
-- 1. Propiedad extendida en la misma BD
-----------------------------------------------------------------------
USE AdventureWorks2012;
GO
SELECT objtype, objname, name, value
 FROM fn_listextendedproperty(default, default, default, default, default, default, default);
GO
USE AdventureWorks2012;
GO
EXEC sys.sp_addextendedproperty 
 @name = N'Curso_SQL', 
 @value = N'Base de datos AdventureWorks2012 curso de SQL';
GO
SELECT objtype, objname, name, value
 FROM fn_listextendedproperty(default, default, default, default, default, default, default);
GO

-----------------------------------------------------------------------
-- 2. Propiedad extendida en la función definida por el usuario ufnGetStock
-----------------------------------------------------------------------
USE AdventureWorks2012;
GO
SELECT objtype, objname, name, value
 FROM fn_listextendedproperty(NULL, 'SCHEMA', 'dbo', 'FUNCTION', 'ufnGetStock', default, default);
GO
EXEC sys.sp_addextendedproperty 
 @name = N'Curso_SQL', 
 @value = N'Funcion escalar retorna la cantidad de inventario de un producto dado por ProductID.', 
 @level0type = N'SCHEMA', @level0name = [dbo],
 @level1type = N'FUNCTION', @level1name = ufnGetStock;
GO

-----------------------------------------------------------------------
-- 3. Propiedad extendida en la tabla Address en el esquema Person 
-----------------------------------------------------------------------
USE AdventureWorks2012;
GO
SELECT objtype, objname, name, value
 FROM fn_listextendedproperty(NULL, 'SCHEMA', 'Person', 'TABLE', 'Address', default, default);
GO
EXEC sys.sp_addextendedproperty 
 @name = N'Curso_SQL', 
 @value = N'Tabla de direcciones para clientes, empleados y vendedores.', 
 @level0type = N'SCHEMA', @level0name = Person, 
 @level1type = N'TABLE',  @level1name = Address;
GO

-----------------------------------------------------------------------
-- 4. Propiedad extendida en el índice IX_Address_StateProviceID en la tabla Address 
--    en el esquema Person 
-----------------------------------------------------------------------
USE AdventureWorks2012;
GO
SELECT objtype, objname, name, value
 FROM fn_listextendedproperty(NULL, 'SCHEMA', 'Person', 'TABLE', 'Address', 'INDEX', default);
GO
EXEC sys.sp_addextendedproperty 
 @name = N'Curso_SQL', 
 @value = N'Indice no clusterado en StateProvinceID.', 
 @level0type = N'SCHEMA', @level0name = Person, 
 @level1type = N'TABLE',  @level1name = Address,
 @level2type = N'INDEX',  @level2name = IX_Address_StateProvinceID;
GO

-----------------------------------------------------------------------
-- 5. Listar todas las propieades extendidas en todas las tablas de un esquema
-----------------------------------------------------------------------
USE AdventureWorks2012;
GO
SELECT objtype, objname, name, value
 FROM fn_listextendedproperty (NULL, 'SCHEMA', 'Sales', 'TABLE', default, NULL, NULL);
GO


-----------------------------------------------------------------------
-- PREGUNTAS PARA EL ALUMNO:
-----------------------------------------------------------------------
1. ¿Cómo utilizaría las propiedades extendidas cuando desarrolla una aplicación?
2. ¿Cómo recupera las propiedades extendidas en una aplicación cliente?
