#Instalando Bases de Datos con Docker

### Comando instalación MSSQL

```bash
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=yourStrong()Password" --name mssqlbd -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-latest
```

### Comando instalación MySQL

```bash
docker run --name some-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql
```



***ABRIR CONTENEDOR MYSQL DOCKER
docker exec -it <Nombre contenedor> /bin/bash
docker exec -it some-mysql /bin/bash
apt update
# mysql -u root -p
mysql> show databases;
mysql> exit

	CREANDO UN FULL BACKUP
***Creando una copia de seguridad
# cd /var/lib/mysql/				#Entrando a donde se almacena la data de mysql
# mysqldump -u root -p "DB4">FULL.sql		#Generamos un archivo con toda la data de la BD 'BD4', el archivo se llamara FULL.sql
# cat FULL.sql					#Para ver la informacion de FULL.sql

***Restaurando una BD desde una copia de seguridad(Debe estar la creada la BD en blanco)
# mysql -u root -p
mysql> show databases;
mysql> use DB4;				#Nos posicionamos en la BD a restaurar
mysql> source /var/lib/mysql/FULL.sql;	#Especificamos la ruta de nuestro archivo backup a cargar
mysql> exit

	CREANDO UN BACKUP INCREMENTAL
***Creando una copia de seguridad
# cd /var/lib/mysql/				#Entrando a donde se almacena la data de mysql
# mysql -u root -p
mysql> use DB4;				#Nos posicionamos en la BD
mysql> flush logs;				#Crea un binario con el backup incremental

***Restaurando una BD desde una copia de seguridad(Debe estar la creada la BD en blanco)
# mysql -u root -p
mysql> show databases;
mysql> use DB4;				#Nos posicionamos en la BD a restaurar
mysql> source /var/lib/mysql/FULL.sql;	#Restauramos nuestra BD con full incremental
mysql> exit
/var/lib/mysql# mysqlbinlog binlog.000004 | mysql -u root -p "DB4"; #

