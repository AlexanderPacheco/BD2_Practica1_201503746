docker run -h publisher --name publisher -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Pa55w0rd!' -p 1451:1433 -d mcr.microsoft.com/mssql/server:2019-CU15-ubuntu-20.04
docker run -h subscriber --name subscriber -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Pa55w0rd!' -p 1452:1433 -d mcr.microsoft.com/mssql/server:2019-CU15-ubuntu-20.04
docker run -h distributor --name distributor -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Pa55w0rd!' -p 1453:1433 -d mcr.microsoft.com/mssql/server:2019-CU15-ubuntu-20.04


docker exec -it -u 0 distributor /opt/mssql/bin/mssql-conf set sqlagent.enabled true
docker exec -it -u 0 publisher  /opt/mssql/bin/mssql-conf set sqlagent.enabled true 
docker exec -it -u 0 subscriber  /opt/mssql/bin/mssql-conf set sqlagent.enabled true 


//stop and up

docker network create replication
docker network connect replication publisher
docker network connect replication distributor
docker network connect replication subscriber

docker network ls
docker nerwork inspect replication


//distributor
