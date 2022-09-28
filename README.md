# Instalando Bases de Datos con Docker

### Comando instalación MSSQL Server

```bash
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=yourStrong()Password" --name mssqlbd -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-latest
```

### Comando instalación MySQL

```bash
docker run --name some-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql
```

### Comando instalación Postgresql usando docker-compose

```yaml
#See file docker-compose.yml
#sudo docker-compose up --build
version: "3.8"

services: 
  postgres:
    image: postgres
    restart: always
    environment: 
      - DATABASE_HOST=127.0.0.1
      - POSTGRES_USER=root
      - POSTGRES_PASSWORD=root
      - POSTGRES_DB=root
    ports: 
      - 5432:5432

  pgadmin:
    image: dpage/pgadmin4
    environment: 
      PGADMIN_DEFAULT_EMAIL: "admin@admin.com"
      PGADMIN_DEFAULT_PASSWORD: "admin"
    ports:
      - "80:80"
    depends_on: 
      - postgres 
```

## ABRIR CONTENEDOR MYSQL DOCKER
```
docker exec -it <Nombre contenedor> /bin/bash
docker exec -it some-mysql /bin/bash
apt update
# mysql -u root -p
mysql> show databases;
mysql> exit
```
# Creando un Full Backup
>Creando una copia de seguridad
```
# cd /var/lib/mysql/				#Entrando a donde se almacena la data de mysql
# mysqldump -u root -p "DB4">FULL.sql		#Generamos un archivo con toda la data de la BD 'BD4', el archivo se llamara FULL.sql
# mysqldump -u root -p "DB4">./FBackups/FULL.sql    #Genera el archivo full backup en la carpeta FBackups
# cat FULL.sql					#Para ver la informacion de FULL.sql
```

>Restaurando una BD desde una copia de seguridad full backup (Debe estar la creada la BD en blanco)
```
# mysql -u root -p
mysql> show databases;
mysql> use DB4;				#Nos posicionamos en la BD a restaurar
mysql> source /var/lib/mysql/FULL.sql;	#Especificamos la ruta de nuestro archivo backup a cargar
mysql> exit
```

>Otra forma de restaurar una BD desde una copia de seguridad full backup (Debe estar la creada la BD en blanco)
```
# mysql -u root -p db_name < /route/script.sql
```

# Creando un Backup Incremental
>Creando una copia de seguridad
```
# cd /var/lib/mysql/				#Entrando a donde se almacena la data de mysql
# mysql -u root -p
mysql> use DB4;				    #Nos posicionamos en la BD
mysql> flush logs;				#Crea un binario con el backup incremental, todo lo que se haga en la BD se guardara en el nuevo binario creado
                                #El 'flush logs' se hace antes de guardar la nueva información, al crear otro binario con el comando flush se cierra el anterior
```

>Restaurando una BD desde una copia de seguridad incremental (Debe estar la creada la BD en blanco)
```
# cd /var/lib/mysql/                                #Nos posicionamos en la carpeta donde se encuentran los binarios
# mysqlbinlog binlog.00000X | mysql -u root -p "BD4"       #Restauramos nuestro backup incremental indicando el binario y la BD 
```



