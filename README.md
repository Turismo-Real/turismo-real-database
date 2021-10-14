# turismo-real-database
Scripts base de datos turismo real - Oracle

## Levantar Base de Datos  
A continuación, se explica como levantar la base de datos de turismo real
  
---
### Desde un contenedor Docker  
Antes se debe tener instalado docker en la máquina local.
A continuación, ejecutar el siguiente comando para descargar la imagen de oracle 11g.  
Descargar imagen: `docker pull oracleinanutshell/oracle-xe-11g`  

Levantar contenedor Oracle 11g en el puerto 49161: `docker run -d -p 49161:1521 oracleinanutshell/oracle-xe-11g`  

Para conectarse a Oracle 11g Docker desde SQL developer se deben utilizar las siguientes credenciales:  
- **Username:** system
- **Password:** oracle
- **SID:** xe
- **Port:** 49161
- **Host:** localhost  