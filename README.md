# turismo-real-database
Scripts base de datos turismo real - Oracle

## Levantar Base de Datos  
A continuación, se explica como levantar la base de datos de turismo real.  
  
**NOTA:** Si se utiliza el motor de oracle 11g instalado directamente en la máquina local y no desde un contenedor de docker, al momento de conectarse desde SQL developer o al levantar alguno de los servicios REST, se debe tener en cuenta el número de puerto utilizado, ya que los servicios fueron desarrollados utilizando la base de datos en docker.  
  
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
  
---
## Orden de ejecución de scripts  
1. En el usuario `system` ejecutar el script de creación de usuario ubicado en el archivo `1. creacion_seleccion.sql`.  
2. Conectarse al usuario `turismo_real` con contraseña `portafolio` y ejecutar el script de creación de tablas y poblado ubicado en el archivo `2. script_turismo_real.sql`.  
3. Ejecutar el script de creación de funciones y procedimientos almacenados ubicado en el archivo `3. turismo_real_objects.sql`.  