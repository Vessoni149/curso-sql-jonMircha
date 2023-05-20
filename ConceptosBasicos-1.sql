#Comentario en una liena.
/*
 * 
 * Comentario en varias lineas*/


#con shift + home selecciona todo lo uqe esté antes del cursor. Sirme para poner el cursor al final de una linea y seleccionarla toda.
#tambien se puede comentar con #


show databases;


create database curso_sql;
#creo una DB

#drop elimina la db completa
drop database curso_sql;

 #Creo un usuario, que en principio no podrá ver la DB creada anteriormente.
create user 'agustin'@'localhost' identified by 'qwerty';
# veremos que en la carpeta users aparecera este usuario.

#otorgando privilegios:
# Le voy a otorgar privi para que vea la DB creada (curso_sql)
#se pueden asignar dentro de un array para especificar ada privilegio, o para dar todos los privis:
grant all privileges on curso_sql.* to 'agustin'@'localhost'

#Ésto actualiza la lista de privilegios. Como entramos usando localhost no hace falta realmente, pero si usaramos otro servidor si, para que el usuario pueda ver sus privilegios y usarlos.
flush privileges;


show grants for 'agustin'@'localhost';
#mostrara que tenemos todos los privis con *.*, en la db curso_sql

#Para revocar privilegios:
revoke all, grant option from 'agustin'@'localhost';

drop user 'agustin'@'localhost';
#si tenemos la sesion abierta en la terminal seguira abierta, pero si la cerramos no podremos volver a loguear.


#Trabajando con DBs:
#hay que indicar cual db vamos a usar
use curso_sql;


#creando tabla:
create table usuarios(
	nombre varchar(50),
	correo varchar(50)
);

show tables;

#describe nomreTabla permite ver una tabla en particular.

describe usuarios;


#MODIFICAR TABLA:

#modificar nomre de la tabla:
alter table nombreTabla rename to nuevoNombre;

alter table usuarios add column cumpleaños varchar(15);


#modificamos tipo de dato de un atributo
alter table usuarios modify cumpleaños DATE;

#modificando el nombre del atributo cumpleaños a nacimiento
alter table usuarios rename column cumpleaños to nacimiento;

#eliminamso la columna nacimiento
alter table usuarios drop column nacimiento

#eliminar tabla:
drop table usuarios;


create table usuarios(
usuario_id INT unsigned auto_increment primary key,
nombre varchar(30) not null,
apellidos varchar(30) not null,
correo varchar(50) unique,
direcccion varchar(100),
edad INT default 0
);
#unsigned es para evitar la insercion designos, x ej negativo.
#not null para que no pueda ir vacio
#unique es para evitar que un nuevo registro tenga ese valor.
#default es para asignar un valor por defecto a un atributo
# Otra forma de asignarle pk a un atributo es, dentro de la creacion de la table, especificar como si fuere un atriuto: primary key(usuario_id)

#operaciones de crud:

#CREAR. insertar registros o valores en una tabla:
#Como el id es autoincremental, solo va a detectar que numero poner
insert into usuarios values (0,"jon","Mircha","jonmircha@gmail.com", "direccion de Mircha", 38)
#esta forma de insertar datos se hace poniendo los valores en el orden en el que están las propiedades de la tabla. Es mala practica para insertar datos, lo correccto sería especificar los campos:
insert into usuarios (apellidos, edad, nombre) values ("Mircha", 10, "kenai");
#acá no importa el orden de los datos y se pueden poner los que queramos, no todos ya que no todos son requeridos.

#otra forma de insertar no muy usada es:
insert into usuarios set nombre = "Irma", apellidos="Campos", edad=23; 

#Insertar varios registros en 1 query.
insert into usuarios (nombre, apellidos, edad,  correo) values 
("pepito", "pepon", 12, "pepe@gmail.com"), 
("rosita", "rozas", 40, "rosa@gmail.com")

#LEER 
select * from usuarios;
#* es para que traiga todos los campos o atributos.

#leer cmapos especificos:
select nombre, edad, usuario_id from usuarios;

#leer el numero de registros que hay:
select COUNT(*) from usuarios;
#mostrara la cantidad de usuarios
#Podemos darle un alias al count para que la respuesta no salga con count(*) el nombre de la columna.
select count(*) as total_usuarios from usuarios;

select * from usuarios where nombre = "Jon";

#buscar diferentes valores en un campo: where in 
select * from usuarios where nombre in ("jon", "kenai","irma");

#buscar por letra
select * from usuarios where apellidos like 'M%';
# busca en la tabla usuarios los apellidos que empieocen con m, sin importar los caracteres siguientes (con %)

select * from usuarios where correo like '%@gmail.com';
#buscamso correos que terminen en @gmail.com

select * from usuarios where nombre like '%it%';
#busca nombres que contengan una i y una t juntas


#not like
#hace exactamente lo inverso:
#apellidos que no empiecen con "M", correos que no terminen en gmail y nombres que no contengan "it"
select * from usuarios where apellidos not like 'M%';
select * from usuarios where correo not like '%@gmail.com';
select * from usuarios where nombre not like '%it%';

# operadores relcionales: <>=!=...

select * from usuarios where edad != 38;
select * from usuarios where edad <> 38;
#ambos buscan edades que no tengan el valor 38

select * from usuarios where edad = 38;
# busca usuarios con 38 años

select * from usuarios where edad > 38;
select * from usuarios where edad >= 38;


#Operadores logicos: not and or

select * from usuarios where not direcccion = "sin direccion";
#trae todos cuando la direccion no SEA esa direccion indicada.

#otra forma de usar el not con !.
select * from usuarios where  direcccion != "sin direccion" and edad <= 38;
#Se podrian pones más and seguido de 38. Se deen cumplir todas las condiciones para que devuelva algo.

select * from usuarios where direcccion != "sin direccion" or edad <= 38;

#UPDATE
update usuarios set correo = "irma@gmail.com", direcccion = "Direccion de irma" where usuario_id = 3;
#es sumamente importante el "where", si no está va a editar todos los campos.
select * from usuarios;


#delete
#no borra la table, sino los registros de la tabla, para borrar la tabla hay que usar drop.
delete from usuarios where usuario_id = 4;
#tambien es impresindible el where. no hace falta usar * como el el select.

#Como puede verse al eliminar un registro entrero, el id al ser autoincremental, va a quedar con un id inexistente, podemos reserear esto con el comando TRUNCATE.
#Borra todos los usuarios, pero reinicia su numeracion, ya que el delete no olvida la informacion de los valotes autoincrementales. Igualmente vamos a tener que volver a crear a todos los usuarios(registro) de nuevo.
truncate table usuarios;







