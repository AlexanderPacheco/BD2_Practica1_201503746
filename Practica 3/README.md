# REPLICAS EN CONTENEDORES - SQL SERVER

> Modelo

![](https://github.com/AlexanderPacheco/Databases_Build/blob/master/Practica%203/modelo.png)

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
docker nerwork inspect replication
```

### Día #1
docker network create replication
docker network connect replication publisher
docker network connect replication distributor
docker network connect replication subscriber
```bash

```
