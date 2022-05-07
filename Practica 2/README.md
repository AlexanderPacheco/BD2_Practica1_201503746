# Full Backup & Incremental Backup

### Comando instalación MSSQL Server

```bash
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=yourStrong()Password" --name mssqlbd -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-latest
```

### Comando instalación MySQL

```bash
docker run --name some-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql
# Con un volumen
docker run --name some-mysql -p 3306:3306 -v $(pwd)/ArchivosPractica2:/var/ArchivosPractica2 -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql
```

### Ingresando a la base de datos en docker
```
docker exec -it <Nombre contenedor> /bin/bash
docker exec -it some-mysql /bin/bash
apt update
// Moviendo los archivos del volumen a la carpeta de datos mysql, carpeta ARCHIVOS2 tiene que estar creado
# mv *.sql /var/lib/mysql/ARCHIVOSP2/
// Nos ubicamos en /var/lib/mysql/
# mysql -u root -p
mysql> show databases;
```

### Día #1

>Cargando los datos del primer archivo
```sql
# Cargando archivo Carga1.sql
mysql -u root -p
show databases;
use PRACTICA2;

# Nuestros archivos estan en /var/lib/mysql/ARCHIVOSP2
source /var/lib/mysql/ARCHIVOSP2/Carga1.sql;
exit
```

>Creando Full Backup (Nos ubicamos dentro del contenedor)
```
# Entrando a donde se almacena la data de mysql
cd /var/lib/mysql/
# Generamos un archivo con toda la data de la BD 'PRACTICA2', el archivo se llamara FULLD1.sql
mysqldump -u root -p "PRACTICA2">FULLD1.sql
# Para ver la informacion de FULLD1.sql
cat FULLD1.sql
```

>Creando Incremental Backup (Nos ubicamos dentro del contenedor)
```sql
# Entrando a donde se almacena la data de mysql
# cd /var/lib/mysql/				
mysql -u root -p
# Nos posicionamos en la BD
use PRACTICA2;	
#Cremos binario del backup incremental	
#El 'flush logs' se hace antes de guardar la nueva información, al crear otro binario con el comando flush se cierra el anterior	    
flush logs;                 
```

### Día #2

>Cargando los datos del primer archivo
```sql
# Cargando archivo Carga2.sql
mysql -u root -p
show databases;
use PRACTICA2;

# Nuestros archivos estan en /var/lib/mysql/ARCHIVOSP2
source /var/lib/mysql/ARCHIVOSP2/Carga2.sql;
exit
```

>Creando Full Backup (Nos ubicamos dentro del contenedor)
```
cd /var/lib/mysql/
mysqldump -u root -p "PRACTICA2">FULLD2.sql
cat FULLD2.sql
```

>Creando Incremental Backup (Nos ubicamos dentro del contenedor)
```sql
# cd /var/lib/mysql/				
mysql -u root -p
use PRACTICA2;		    
flush logs;                 
```

### Día #3

>Cargando los datos del primer archivo
```sql
# Cargando archivo Carga3.sql
mysql -u root -p
show databases;
use PRACTICA2;

# Nuestros archivos estan en /var/lib/mysql/ARCHIVOSP2
source /var/lib/mysql/ARCHIVOSP2/Carga3.sql;
exit
```

>Creando Full Backup (Nos ubicamos dentro del contenedor)
```
cd /var/lib/mysql/
mysqldump -u root -p "PRACTICA2">FULLD3.sql
cat FULLD3.sql
```

>Creando Incremental Backup (Nos ubicamos dentro del contenedor)
```sql
# cd /var/lib/mysql/				
mysql -u root -p
use PRACTICA2;		    
flush logs;
```

### Día #4

>Cargando los datos del primer archivo
```sql
# Cargando archivo Carga4.sql
mysql -u root -p
show databases;
use PRACTICA2;

# Nuestros archivos estan en /var/lib/mysql/ARCHIVOSP2
source /var/lib/mysql/ARCHIVOSP2/Carga4.sql;
exit
```

>Creando Full Backup (Nos ubicamos dentro del contenedor)
```
cd /var/lib/mysql/
mysqldump -u root -p "PRACTICA2">FULLD4.sql
cat FULLD4.sql
```

>Creando Incremental Backup (Nos ubicamos dentro del contenedor)
```sql
# cd /var/lib/mysql/				
mysql -u root -p
use PRACTICA2;		    
flush logs;
```

### Día #5

>Cargando los datos del primer archivo
```sql
# Cargando archivo Carga5.sql
mysql -u root -p
show databases;
use PRACTICA2;

# Nuestros archivos estan en /var/lib/mysql/ARCHIVOSP2
source /var/lib/mysql/ARCHIVOSP2/Carga5.sql;
exit
```

>Creando Full Backup (Nos ubicamos dentro del contenedor)
```
cd /var/lib/mysql/
mysqldump -u root -p "PRACTICA2">FULLD5.sql
cat FULLD5.sql
```

>Creando Incremental Backup (Nos ubicamos dentro del contenedor)
```sql
# cd /var/lib/mysql/				
mysql -u root -p
use PRACTICA2;		    
flush logs;
```

## Restaurando los Full Backup
>En esta fase se eliminara la base de datos y se probaran cada uno de los backups hechos en los dias anteriores.

> Restaurando desde la terminal host
```
cd /var/lib/mysql/

# Restaura el full backup del archivo ARCHIVO.sql
mysqldump -u root -p "PRACTICA2"<./ARCHIVO.sql

# Restaura el full backup y muestra el tiempo que tomo hacer toda la carga
time mysqldump -u root -p "PRACTICA2"<./FULLD1.sql
```

> Restaurando desde la terminal de mysql
```
# cd /var/lib/mysql/
# mysql -u root -p
mysql> show databases;
mysql> use PRACTICA2;   #Nos posicionamos en la BD a restaurar
mysql> source /var/lib/mysql/FULLD1.sql;	#Especificamos la ruta y nombre de nuestro archivo backup a cargar
mysql> exit
```

## Restaurando los Incremental Backup
>En esta fase se eliminara la base de datos y se cargaran las copias de seguridad incrementales creados en los dias anteriores.

```
//Nos posicionamos en la carpeta donde se encuentran los binarios
cd /var/lib/mysql/
//Restauramos nuestro backup incremental indicando el binario y la BD 
mysqlbinlog binlog.000003 | mysql -u root -p "PRACTICA2"

//Este restaura y retorna el tiempo que tomo
time mysqlbinlog binlog.000003 | mysql -u root -p "PRACTICA2"
time mysqlbinlog binlog.000005 | mysql -u root -p "PRACTICA2"
time mysqlbinlog binlog.000007 | mysql -u root -p "PRACTICA2"
time mysqlbinlog binlog.000008 | mysql -u root -p "PRACTICA2"
time mysqlbinlog binlog.000009 | mysql -u root -p "PRACTICA2"
```
