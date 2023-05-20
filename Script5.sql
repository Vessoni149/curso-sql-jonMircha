create database curso_sql_5;

use curso_sql_5;

show databases;
show tables;


#Motores de bases de datos. Antes por defecto mysql creaba las tablas con el motor MyISAM, que crea tablas planas, donde no se podian hacer relaciones, restricciones, trasacciones.
#con "engine=motor" se especifica el motor.
#servira cuando no necesitemos relaciones en nuestras dbs
CREATE table armadurasMyisam (
armadura_id int unsigned auto_increment PRIMARY KEY,
armadura varchar(30) NOT null
)engine=MyISAM;

CREATE table armadurasInnodb (
armadura_id int unsigned auto_increment PRIMARY KEY,
armadura varchar(30) NOT null
)engine=InnoDB ;

#InnoDB es el motor que ahora tiene mysql x default, hacique teniendo mysql actualizado no haria falta especificar el motor.


#Luego de especificar el motor, tambien podemos especificar en cada tabla el formato de caracteres, x ej:
CREATE table armadurasMyisam2 (
armadura_id int unsigned auto_increment PRIMARY KEY,
armadura varchar(30) NOT null
)engine=MyISAM default charset=utf8mb4;

show tables;


#RESTRICCIONES
#suelen darse en operaciones de actualizacion y eliminacion de tablas.
#de tipo cascade: elimina o actualiza automaticamente los registros relacionados a la tabla relacionada. Es decir so cambio un valor en la tabla que hace ref como llave foranea de otra, el cambio de ese valor se vera reflejado automaticamente en la otra tabla.
#set null: actualiza el valor a null
#set default: si en algun momento algun valor que este relacionado como llave foranea se ve eliminado, el valor que van a tomar los campos que tenais relacion con la FK, va a ser el valor x defecto que hayas especificado en ese campo en la definicio de la columna.
#restrict: evita o restringe la eliminacion o actualiz. del registro en la tabla ppal. Tendremos que eliminar el registro relacionado en la tabla secundaria primero (creo).


create table lenguajes (
lenguaje_id int unsigned auto_increment primary key,
lenguaje varchar(30) not null
);

insert into lenguajes (lenguaje) values
("javascript"),
("PHP"),
("python"),
("ruby"),
("java");

create table frameworks (
framework_id int unsigned auto_increment primary key,
framework varchar(30) not null,
lenguaje int unsigned,
foreign key (lenguaje) references lenguajes(lenguaje_id)
);

insert into frameworks (framework, lenguaje) values
("react",1),
("angular",1),
("vue",1),
("slvelte",1),
("laravel",2),
("symfony",2),
("flask",3),
("django",3),
("on rails",4);
#no le ponemos framework a java a proposito para despues poder eliminarlo.

select * from lenguajes;
select * from frameworks;

select * from frameworks f
inner join lenguajes l
on f.lenguaje = l.lenguaje_id;

#al querer ejecutar esto, no permite que se elimine porque ese campo lenguaje_id tiene dependencias con la tabla frameworks. No se pued eeliminar un registro en una tabla que funciona como llave foranea de otra, mientras en la tabla ppal tenga registros con ese valor.
delete from lenguajes where lenguaje_id = 3;

delete from lenguajes where lenguaje_id = 5;
#Este campo si lo podemos eliminar, ya que no está siendo usado como fk en otra tabla.


#lo mismo con el update, no podemos modificarlo.
update lenguajes set lenguaje_id = 13 where lenguaje_id = 3;

#para cambiar la restriccion, hay que hacerlo al crear las tablas.

drop table lenguajes;
drop table frameworks;


#las restricciones se especifican donde se crean las llaves foraneas. Entonces solo necesitamos hacerlo en la tabla frameworks, no en lenguajes. 
#borro las tablas y las creo de nuevo con estas restricciones.

#Se debe agregar seguido de la fk "on delete restriccion" por defecto viene en restrict, seguidamente hacemos lo mismo con update
create table frameworks (
framework_id int unsigned auto_increment primary key,
framework varchar(30) not null,
lenguaje int unsigned,
foreign key (lenguaje) references lenguajes(lenguaje_id)
on delete restrict on update cascade
);

insert into frameworks (framework, lenguaje) values
("react",1),
("angular",1),
("vue",1),
("slvelte",1),
("laravel",2),
("symfony",2),
("flask",3),
("django",3),
("on rails",4);

select * from frameworks f
inner join lenguajes l
on f.lenguaje = l.lenguaje_id;

#probamos actualizar con la restriccion en cascada
update lenguajes set lenguaje_id = 13 where lenguaje_id = 3;

#se ejecuto correctamente, si vemos el select de la linea 106 veremos que el id del lenguaje 3 ahora es 13.



#veamos en caso de set null
create table frameworks (
framework_id int unsigned auto_increment primary key,
framework varchar(30) not null,
lenguaje int unsigned,
foreign key (lenguaje) references lenguajes(lenguaje_id)
on delete set null on update cascade
);

insert into frameworks (framework, lenguaje) values
("react",1),
("angular",1),
("vue",1),
("slvelte",1),
("laravel",2),
("symfony",2),
("flask",3),
("django",3),
("on rails",4);

select * from frameworks f
inner join lenguajes l
on f.lenguaje = l.lenguaje_id;

#intentemos eliminar el id 3
delete from lenguajes where lenguaje_id = 3;

#si ejecutamos el inner join de arriba no veremos el id, ya que justamente no se relacionan las tablas xq se elimino el id. Pero si vemos la tabla frameworks veremos que esta con un id null
select * from frameworks;


#RESTRICCIONE MULTIPLES
#primero dropeamso las 2 tablas de lenguajes y framework.
#luego creo las tablas lenguajes, entornos y por ultimo la tabla framework de más abajo:

create table frameworks (
framework_id int unsigned auto_increment primary key,
framework varchar(30) not null,
lenguaje int unsigned,
entorno int unsigned,
foreign key (lenguaje) 
	references lenguajes(lenguaje_id)
	on delete restrict 
	on update cascade,
foreign key (entorno) 
references entornos(entorno_id)
on delete restrict 
on update cascade
);

insert into frameworks (framework, lenguaje,entorno) values
("react",1,1),
("angular",1,1),
("vue",1,1),
("slvelte",1,1),
("laravel",2,2),
("symfony",2,2),
("flask",3,2),
("django",3,2),
("on rails",4,2);


create table entornos (
entorno_id int unsigned auto_increment primary key,
entorno varchar (30) not null
);

insert into entornos (entorno) values
("Frontend"),
("Backend");

describe entornos;


select * from lenguajes;
select * from frameworks;
select * from entornos;

select * 
from frameworks f
inner join lenguajes l on f.lenguaje = l.lenguaje_id
inner join entornos e on f.entorno = e.entorno_id;

delete entornos  where entorno_id = 1;	#esto no lo va a permitir
update entornos set entorno_id = 1 where entorno_id = 19; #pero esto si xq tiene el cascade



#TRANSACCIONES

start transaction;
	update frameworks set framework = "Vue.js" where framework 	= "vue";
	delete from frameworks;
	insert into frameworks values (0, "Spring", 5, 2);
rollback;
commit;

select * from frameworks;

#Se pueden limitar el n° de datos que devuelve una consulta, esto sirve para las que devuelven muchos. por defecto dbeaver nos muestra 200 por pagina.

select* from lenguajes limit 2;	#con 1 solo valor, se indica cuantos registros mostrar
select* from lenguajes limit 2,4;	#si tenemos 2 valores es desde donde y cauntos mostrar respectivamente.



#FUNCIONES DE ENCRIPTACION
#md5 convierne una cadena de texto a vun valor de tipo hash de 128 bits.
select MD5("fdafa124sa{");
#cuando querramos hacer un insert, en vez de poner la cadena de texto, la encerramos en un md5. Ej passwords
#no es un mecanismo tan seguro.

# un mecanismo un poco mas seguro es sha1 que genera un hash de hasta 160 bits.
select sha1("fdafa124sa{");

#sha2 es una segunda version que permite indicar el numero de bits que formara el hash, a maroy el n° es mas dificil de hakear.

select sha2("fdafa124sa{",256);	#el 2do param es el n° de bits.



#el mecanismo mas seguro popular y actual es:
select AES_ENCRYPT("fdafa124sa{", 'palara_secreta'); 
#posee un factor de doble autenticacion.
#para desencriptar un campo encriptado en una tabla:
select AES_DECRYPT(nombre_campo, 'palara_secreta'); 


create table pagos_recurrentes(
	cuenta varchar(8) primary key,
	nombre varchar(50) not null,
	tarjeta blob
);

insert into pagos_recurrentes values
('12345678', 'Jon', AES_ENCRYPT('1234567890123456788', '12345678')),
('12345677', 'Irma', AES_ENCRYPT('12345678901234567887', '12345677')),
('12345676', 'Kenai', AES_ENCRYPT('1234567890123456786', '12345676')),
('12345674', 'Kala', AES_ENCRYPT('1234567890123456785', 'super_llave')),
('12345673', 'Miguel', AES_ENCRYPT('1234567890123456784', 'super_llave'));

select * from pagos_recurrentes;

select cast(AES_DECRYPT(tarjeta, '12345678') as char) tdc from pagos_recurrentes;
#solo trae una porque puse solo la llade que corresponde a Jon,
select cast(AES_DECRYPT(tarjeta, 'super_llave') as char) tdc from pagos_recurrentes;
#aca desectypta las 2 primeras.








