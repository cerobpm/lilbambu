#/lib/psql

Aquí se incluyen los scripts .SQL para crear el esquema de tablas ODM en una base de datos PostgreSQL. Primero debe instalarse postgresql>=9.5, crear un superusuario y crear una base de datos. Luego se puede ejecutar:
  less ODMforPSQL_1.1.sql | psql myDB   # <- crea la estructura de tablas vacía
  less ODMforPSQL_1.1_case.sql | psql myDB   # <- crea la estructura de tablas con datos de prueba 
  


    
