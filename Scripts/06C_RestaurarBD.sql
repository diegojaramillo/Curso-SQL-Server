--*********************************************************************
-- LABORATORIO RESTAURAR BASE DE DATOS
-- INSTRUCTOR: David Esteban Echeverri
-----------------------------------------------------------------------
- Este laboratorio será realizado en grupo dirigido por el instructor.
- Solo ejecute las instrucciones cuando el instructor lo indique 

REQUERIMIENTOS
Carpeta creada en el disco: \Curso_SQL

-----------------------------------------------------------------------
-- 1. Restaurar la BD utilizando SSMS
-----------------------------------------------------------------------
1.1 Borrar la BD Norte

1. En Object explorer expanda la carpeta Databases y seleccione la BD Norte
2. De un clic secundario en la BD Norte y luego en Delete
3. Seleccione cancelar puesto que no será borrada la BD si no sobrescrita en el 
   siguiente punto
   
1.2 Restaurar backup de la BD Norte

1. En Object explorer de un clic secundario en la carpeta Databases y luego en 
   Restore database y llene la siguiente informacion:
   A. To database: Norte
   B. From device: Activado
   C. Presione el botón (...) al final de: From device
      i. Backup media: File
      ii. Si hay archivos en Backup location, seleccionelos y quitelos con el botón Remove
      ii. Presione el botón Add y seleccione el archivo backup en la ruta:
          \Curso_SQL\Norte_Backup.bak
      iii. Presione OK

   D. Debajo de Select the backup sets to restore, active la casilla de verificación
      del backup completo (full)
   E. Seleccione la página Optios a mano izquierda
      i. Active la casilla: Overwrite the existing database
      ii. En restore the database files as:
          Norte_Data: \Curso_SQL\Norte_Data.mdf
          Norte_Log:  \Curso_SQL\Norte_Log.ldf
      i. Active la opción RESTORE WITH RECOVERY
   F. Presione OK
  
1.3 Revise la BD y consulte una de las tablas en forma gráfica en SSMS.
    Revise los archivos físicos creados en el disco. 



