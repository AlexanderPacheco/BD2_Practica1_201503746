# REPLICAS EN CONTENEDORES - SQL SERVER

## CONFIGURACION: SNAPSHOT REPLICATION

> Snapshot Replication

![](https://github.com/AlexanderPacheco/Databases_Build/blob/master/Practica%203/snapshot.png)

### Comando Docker: instalación MSSQL Server

```bash
docker run -h publisher --name publisher -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Pa55w0rd!' -p 1451:1433 -d mcr.microsoft.com/mssql/server:2019-CU15-ubuntu-20.04
docker run -h subscriber --name subscriber -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Pa55w0rd!' -p 1452:1433 -d mcr.microsoft.com/mssql/server:2019-CU15-ubuntu-20.04
docker run -h distributor --name distributor -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Pa55w0rd!' -p 1453:1433 -d mcr.microsoft.com/mssql/server:2019-CU15-ubuntu-20.04
```

### Activar Agentes de las Bases de Datos

Nota: Por defecto estos agentes estan desactivados, se pueden activar con la interfaz grafica, pero en este caso lo haremos con comandos.

```bash
docker exec -it -u 0 distributor /opt/mssql/bin/mssql-conf set sqlagent.enabled true
docker exec -it -u 0 publisher  /opt/mssql/bin/mssql-conf set sqlagent.enabled true 
docker exec -it -u 0 subscriber  /opt/mssql/bin/mssql-conf set sqlagent.enabled true 

#Respuesta comandos: SQL Server needs to be restarted in order to apply this setting. Please run 'systemctl restart mssql-server.service'.
```

> Reiniciamos nuestros servicios de base de datos para que apliquen los cambios

```bash
docker stop distributor subscriber publisher
docker start distributor subscriber publisher
```

### Crear y Asignar Red a las Bases de Datos

```bash
docker network create replication
docker network connect replication distributor
docker network connect replication subscriber
docker network connect replication publisher

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
CREATE DATABASE Sales;
GO

-- create a test table
USE [Sales];
GO
CREATE TABLE CUSTOMER
(
    [CustomerID] [INT] NOT NULL,
    [SalesAmount] [DECIMAL] NOT NULL
);
GO

-- add a PK (we can't replicate without one)
ALTER TABLE CUSTOMER ADD PRIMARY KEY (CustomerID);


-- let's insert a row
INSERT INTO CUSTOMER
(
    CustomerID,
    SalesAmount
)
VALUES
(1, 100);

-- select data
SELECT * FROM CUSTOMER;

-- lets enable the database for replication
USE [Sales];
EXEC sp_replicationdboption @dbname = N'Sales',
                            @optname = N'publish',
                            @value = N'true';

-- Add the publication (this will create the snapshot agent if we wanted to use it)
-- Rename the BD name to expose to subscriber
EXEC sp_addpublication @publication = N'SalesDB',
                       @description = N'',
                       @retention = 0,
                       @allow_push = N'true',
                       @repl_freq = N'continuous',
                       @status = N'active',
                       @independent_agent = N'true';

-- now let's add an article to our publication
-- an article(or table) let will published
USE [Sales];
EXEC sp_addarticle @publication = N'SalesDB', --aliasBD
                   @article = N'customer',
                   @source_owner = N'dbo',
                   @source_object = N'customer',
                   @type = N'logbased',
                   @description = NULL,
                   @creation_script = NULL,
                   @pre_creation_cmd = N'drop',
                   @schema_option = 0x000000000803509D,
                   @identityrangemanagementoption = N'manual',
                   @destination_table = N'customer',
                   @destination_owner = N'dbo',
                   @vertical_partition = N'false';


-- now let's add a subscriber to our publication
use [Sales]
exec sp_addsubscription
@publication = N'SalesDB', --aliasBD
@subscriber = 'subscriber',
@destination_db = 'sales',
@subscription_type = N'Push',
@sync_type = N'none',
@article = N'all',
@update_mode = N'read only',
@subscriber_type = 0

-- and add the push agent
exec sp_addpushsubscription_agent
@publication = N'SalesDB',
@subscriber = 'subscriber',
@subscriber_db = 'Sales',
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


-- in this point, the subscriber and publisher we have the same data
SELECT * FROM CUSTOMER;

-- apply this after the subscriber configuration
-- NOTE! applying changes in the publisher, this changes appear in the subscriber, if not show the same data the configurations failed
USE [Sales];
GO
INSERT INTO CUSTOMER
(
    CustomerID,
    SalesAmount
)
VALUES
(4, 400);

SELECT * FROM CUSTOMER;
```

### Comandos de Configuración: SUBSCRIBER

```sql
-- make sure were on the right server
SELECT @@version AS Version;
SELECT @@SERVERNAME AS Server_Name;

-- in Subscriber, we need to create the database, like a mirror (to set in context)

-- create a test database
CREATE DATABASE Sales;
GO

-- create a test table
USE [Sales];
GO
CREATE TABLE CUSTOMER
(
    [CustomerID] [INT] NOT NULL,
    [SalesAmount] [DECIMAL] NOT NULL
);
GO

-- add a PK (we can't replicate without one)
ALTER TABLE CUSTOMER ADD PRIMARY KEY (CustomerID);


-- let's insert a row
INSERT INTO CUSTOMER
(
    CustomerID,
    SalesAmount
)
VALUES
(1, 100);

-- select data
-- in this point, the subscriber and publisher we have the same data
-- if subscriber and publisher not show the same data, the configurations failed
USE [Sales];
GO
SELECT * FROM CUSTOMER;
```