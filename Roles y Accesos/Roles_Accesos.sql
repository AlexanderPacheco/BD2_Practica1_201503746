CREATE DATABASE db201503746;
USE db201503746;

create table Personas (
	dpi INT,
	nombre VARCHAR(50)
);

insert into Personas values(12345678,'Alexander');
insert into Personas values(11111111,'Raymundo');
insert into Personas values(22222222,'Alejandro');
insert into Personas values(33333333,'Rene');
insert into Personas values(44444444,'Yimmi');

create table Animales (
	tipo VARCHAR(15),
	nombre VARCHAR(50)
);

insert into Animales values('Perro','Firulais');
insert into Animales values('Cerdo','Babe');
insert into Animales values('Rata','Donatelo');
insert into Animales values('Rata','Rafael');
insert into Animales values('Rata','Giamatei');

select * from Personas;
select * from Animales;

#Creando usuarios para acceder al servidor, sin accesos a las BD
create login S_Usuario1 with password = '$$201503746x';
create login S_Usuario2 with password = '$$201503746y';
create login S_Usuario3 with password = '$$201503746z';

#Creando usuarios para acceder a la base de datos
create user B_Usuario1 from login S_Usuario1;
create user B_Usuario2 from login S_Usuario2;
create user B_Usuario3 from login S_Usuario3;

#Creando 2 Roles
#RSC_201503746: Role que permite Select e Insert
create role RSC_201503746
GRANT USAGE ON SCHEMA myschema TO RSC_201503746;
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA myschema TO RSC_201503746;

#UD_201503746: Role que permite Update y Delete
create role UD_201503746
GRANT USAGE ON SCHEMA myschema TO UD_201503746;
GRANT UPDATE, DELETE ON ALL TABLES IN SCHEMA myschema TO UD_201503746;

#Asignar y Quitar Roles
#B_Usuario1: Asignar RSC_201503746
alter role RSC_201503746 add member B_Usuario1
alter role RSC_201503746 drop member B_Usuario1

#B_Usuario2: Asignar UD_201503746
alter role UD_201503746 add member B_Usuario2
alter role UD_201503746 drop member B_Usuario2

#B_Usuario3: Asignar RSC_201503746
alter role RSC_201503746 add member B_Usuario3
alter role RSC_201503746 drop member B_Usuario3


#Asignando y quitando permisos de tablas especificas de bases de datos a usuarios

#Asignando permisos para poder dar select a una tabla especifico
grant select on [dbo].[Information] to Urudy
grant select,insert on [dbo].[Information] to Urudy

#Quitando permisos asignados
revoke select,insert on [dbo].[Information] to Urudy

