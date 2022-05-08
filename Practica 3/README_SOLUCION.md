# REPLICAS EN CONTENEDORES - SQL SERVER

## CONFIGURACION: SNAPSHOT REPLICATION

> Modelo Snapshot Replication

![](https://github.com/AlexanderPacheco/Databases_Build/blob/master/Practica%203/model0.png)

### Comando Docker: instalación MSSQL Server

```bash
docker run -h publisher --name publisher -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Pa55w0rd!' -p 1451:1433 -d mcr.microsoft.com/mssql/server:2019-CU15-ubuntu-20.04
docker run -h subscriber --name subscriber -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Pa55w0rd!' -p 1452:1433 -d mcr.microsoft.com/mssql/server:2019-CU15-ubuntu-20.04
docker run -h distributor --name distributor -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Pa55w0rd!' -p 1453:1433 -d mcr.microsoft.com/mssql/server:2019-CU15-ubuntu-20.04
docker run -h subscriber1 --name subscriber1 -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Pa55w0rd!' -p 1454:1433 -d mcr.microsoft.com/mssql/server:2019-CU15-ubuntu-20.04
docker run -h subscriber2 --name subscriber2 -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Pa55w0rd!' -p 1455:1433 -d mcr.microsoft.com/mssql/server:2019-CU15-ubuntu-20.04
```

### Activar Agentes de las Bases de Datos

Nota: Por defecto estos agentes estan desactivados, se pueden activar con la interfaz grafica, pero en este caso lo haremos con comandos.

```bash
docker exec -it -u 0 distributor /opt/mssql/bin/mssql-conf set sqlagent.enabled true
docker exec -it -u 0 publisher  /opt/mssql/bin/mssql-conf set sqlagent.enabled true 
docker exec -it -u 0 subscriber  /opt/mssql/bin/mssql-conf set sqlagent.enabled true 
docker exec -it -u 0 subscriber1  /opt/mssql/bin/mssql-conf set sqlagent.enabled true 
docker exec -it -u 0 subscriber2  /opt/mssql/bin/mssql-conf set sqlagent.enabled true 

#Respuesta comandos: SQL Server needs to be restarted in order to apply this setting. Please run 'systemctl restart mssql-server.service'.
```

> Reiniciamos nuestros servicios de base de datos para que apliquen los cambios

```bash
docker stop distributor publisher subscriber subscriber1 subscriber2
docker start distributor publisher subscriber subscriber1 subscriber2
```

### Crear y Asignar Red a las Bases de Datos

```bash
docker network create replication
docker network connect replication distributor
docker network connect replication publisher
docker network connect replication subscriber
docker network connect replication subscriber1
docker network connect replication subscriber2

#Verificamos que la red
docker network ls
docker network inspect replication
```

### Comandos de Configuración: DISTRIBUTOR

```sql
-- make sure your on the right server
SELECT @@version AS Version
SELECT @@SERVERNAME AS Server_Name

-- step 1, tell this server it is a distributor
EXEC sp_adddistributor @distributor = 'distributor', @password = 'Pa55w0rd!'

-- step 2, create the distribution db
EXEC sp_adddistributiondb @database = 'distribution';

-- step 3 (Activación de agentes), tell the distributor who the publisher is
-- NOTE! (make the directory '/var/opt/mssql/ReplData',
-- it doesn't exist and this command will try and verify that it does)
-- docker exec -it distributor bin/bash
-- mkdir /var/opt/mssql/ReplData
-- CTRL+Z get back out
EXEC sp_adddistpublisher @publisher = 'publisher', @distribution_db = 'distribution'


-- let's check the DB
USE distribution;
GO

-- see the repl commands table
SELECT *
FROM [dbo].[MSrepl_commands]

-- and let's see the jobs we made
SELECT name, date_modified
FROM msdb.dbo.sysjobs
ORDER by date_modified desc
```

### Comandos de Configuración: PUBLISHER

```sql
-- make sure were on the right server
SELECT @@version AS Version;
SELECT @@SERVERNAME AS Server_Name;

-- tell the publisher who the remote distributor is
EXEC sp_adddistributor @distributor = 'distributor',
                       @password = 'Pa55w0rd!';

-- create a test database
CREATE DATABASE USAC_201503746;
GO

-- create a test table
USE [USAC_201503746];
GO

-- NOTE! in this point we're gonna build the Northwind database

-- show tables
USE [USAC_201503746];
GO
SELECT * FROM INFORMATION_SCHEMA.TABLES;
GO

-- *********************************************************************************************** --
-- ************************************* INICIA SUBSCRIBER 2 ************************************* --
-- *********************************************************************************************** --

-- lets enable the database for replication
USE [USAC_201503746];
EXEC sp_replicationdboption @dbname = N'USAC_201503746',
                            @optname = N'publish',
                            @value = N'true';

-- Add the publication (this will create the snapshot agent if we wanted to use it)
-- Rename the BD name to expose to subscriber
EXEC sp_addpublication @publication = N'USAC_201503746DB',
                       @description = N'',
                       @retention = 0,
                       @allow_push = N'true',
                       @repl_freq = N'continuous',
                       @status = N'active',
                       @independent_agent = N'true';

-- now let's add an article to our publication
-- an article(or table) let will published
USE [USAC_201503746];
EXEC sp_addarticle @publication = N'USAC_201503746DB', --aliasBD
                   @article = N'suppliers',
                   @source_owner = N'dbo',
                   @source_object = N'suppliers',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'suppliers',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB', --aliasBD
                   @article = N'products',
                   @source_owner = N'dbo',
                   @source_object = N'products',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'products',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB', --aliasBD
                   @article = N'order details',
                   @source_owner = N'dbo',
                   @source_object = N'order details',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'order details',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB', --aliasBD
                   @article = N'categories',
                   @source_owner = N'dbo',
                   @source_object = N'categories',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'categories',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB', --aliasBD
                   @article = N'territories',
                   @source_owner = N'dbo',
                   @source_object = N'territories',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'territories',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB', --aliasBD
                   @article = N'region',
                   @source_owner = N'dbo',
                   @source_object = N'region',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'region',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB', --aliasBD
                   @article = N'employeeTerritories',
                   @source_owner = N'dbo',
                   @source_object = N'employeeTerritories',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'employeeTerritories',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB', --aliasBD
                   @article = N'employees',
                   @source_owner = N'dbo',
                   @source_object = N'employees',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'employees',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB', --aliasBD
                   @article = N'orders',
                   @source_owner = N'dbo',
                   @source_object = N'orders',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'orders',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB', --aliasBD
                   @article = N'shippers',
                   @source_owner = N'dbo',
                   @source_object = N'shippers',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'shippers',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB', --aliasBD
                   @article = N'customers',
                   @source_owner = N'dbo',
                   @source_object = N'customers',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'customers',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB', --aliasBD
                   @article = N'customercustomerdemo',
                   @source_owner = N'dbo',
                   @source_object = N'customercustomerdemo',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'customercustomerdemo',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

EXEC sp_addarticle @publication = N'USAC_201503746DB', --aliasBD
                   @article = N'customerdemographics',
                   @source_owner = N'dbo',
                   @source_object = N'customerdemographics',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'customerdemographics',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';

-- now let's add a subscriber to our publication
use [USAC_201503746]
exec sp_addsubscription
@publication = N'USAC_201503746DB', --aliasBD
@subscriber = 'subscriber',
@destination_db = 'USAC_201503746',
@subscription_type = N'Push',
@sync_type = N'none',
@article = N'all',
@update_mode = N'read only',
@subscriber_type = 0

-- and add the push agent
exec sp_addpushsubscription_agent
@publication = N'USAC_201503746DB',
@subscriber = 'subscriber',
@subscriber_db = 'USAC_201503746',
@subscriber_security_mode = 0,
@subscriber_login =  'sa',
@subscriber_password =  'Pa55w0rd!',
@frequency_type = 64,
@frequency_interval = 0,
@frequency_relative_interval = 0,
@frequency_recurrence_factor = 0,
@frequency_subday = 0,
@frequency_subday_interval = 0,
@active_start_time_of_day = 0,
@active_end_time_of_day = 0,
@active_start_date = 0,
@active_end_date = 19950101
GO

-- by default it sets up the log reader agent with a default account that won�t work, you need to change that to something that will.
EXEC sp_changelogreader_agent @publisher_security_mode = 0,
                              @publisher_login = 'sa',
                              @publisher_password = 'Pa55w0rd!';

-- *********************************************************************************************** --
-- ************************************ FINALIZA SUBSCRIBER 2 ************************************ --
-- *********************************************************************************************** --

-- in this point, the subscriber and publisher we have the same data
-- show tables
USE [USAC_201503746];
GO
SELECT * FROM INFORMATION_SCHEMA.TABLES;
GO

-- apply this after the subscriber configuration
-- NOTE! applying changes in the publisher, this changes appear in the subscriber, if not show the same data the configurations failed
USE [USAC_201503746];
GO
SELECT * FROM INFORMATION_SCHEMA.TABLES;
GO

USE [USAC_201503746];
GO
INSERT INTO shippers
VALUES ('RAYMUNDO','(502) 6633-0505')

USE [USAC_201503746];
GO
select * from shippers;
select * from region;
select * from territories;
```

### Comandos de Configuración: SUBSCRIBER

```sql
-- make sure were on the right server
SELECT @@version AS Version;
SELECT @@SERVERNAME AS Server_Name;

-- NOTE! in Subscriber, we need to create the database, like a mirror (to set in context)

-- create a test database
CREATE DATABASE USAC_201503746;
GO

-- create a test table
USE [USAC_201503746];
GO

-- NOTE! in this point we're gonna build the Northwind database

-- show tables
USE [USAC_201503746];
GO
SELECT * FROM INFORMATION_SCHEMA.TABLES;
GO

-- select data
-- in this point, the subscriber and publisher we have the same data
-- if subscriber and publisher not show the same data, the configurations failed
USE [USAC_201503746];
GO
select * from shippers;
select * from region;
select * from territories;
```