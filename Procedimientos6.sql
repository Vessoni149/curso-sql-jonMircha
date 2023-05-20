#PROCEDIMIENTOS ALMACEDADOS
#CONJUNTO DE INSTRUCCIOES SQL Q SE ALMACENA EN LA DB COMO SI FUESE UNA FUNCION. recibe prams de entrada y de salida.

show databases;
create database curso_sql_6;
use curso_sql_6;

create table suscripciones (
suscripcion_id int unsigned auto_increment primary key,
suscription varchar(30) not null,
costo decimal(5,2) not null
);

insert into suscripciones values
(0,'Bronce', 199.99),
(0,'Plata', 299.99),
(0,'Oro', 399.99);

describe suscripciones;
select * from suscripciones;

create table clientes (
cliente_id int unsigned auto_increment primary Key,
nombre varchar(30) not null,
correo varchar(50) unique
);

create table tarjetas (
tarjeta_id int unsigned auto_increment primary key,
cliente int unsigned,
tarjeta blob,
foreign key(cliente)
	references  clientes(cliente_id)
		on delete restrict
		on update cascade
);

create table servicios (
servicio_id int unsigned auto_increment primary key,
cliente int unsigned,
tarjeta int unsigned,
suscripcion int unsigned,
foreign key(cliente)
	references clientes(cliente_id)
	on delete restrict
	on update cascade,
foreign key(tarjeta)
	references tarjetas(tarjeta_id)
	on delete restrict
	on update cascade,
foreign key(suscripcion)
	references suscripciones(suscripcion_id)
	on delete restrict
	on update cascade
);

select * from clientes;
select * from suscripciones;
select * from tarjetas;
select * from servicios;


#Ahora creare un store proceure para añadir elementos la las tablas.

#la estructura basica es la siguiente, primero se usa un delimeter y algun caracter especial que querramos, podria ser $ x ej. Luego se crea el procedimiento y se le da un nombre seguido de () ya que es una funcion, y la logica de la misma va a ir entre el begin y del end
delimiter //

create procedure sp_nombre_procedimiento()
	begin 
		
	end //
delimiter ;



#Como dbeaver no permite ejecutar muchas lineas de codigo a la vez, voy a copair y pegar este codigo en un nuevo script para con el 3er boton de ejecucion ejecute todo el script
DELIMITER //

CREATE PROCEDURE sp_obtener_suscripciones()
BEGIN
    SELECT * FROM suscripciones;
END //

DELIMITER ;

#una ves creado en el otro script sql así se ejecuta.
call sp_obtener_suscripciones();


show procedure status where db = "curso_sql_6";
 
drop procedure sp_obtener_suscripciones;

# ejercicio:
#este proceure lo escribo aca pero se ejecuta en otro script
#este procedure va a tener parametros de entrada, que se definen con in. Para diferenciar los parametros de entrada de las variables que pueda crear dentro del procedimiento, a las variables de entrada las nombramos con i_...
#los parametros de salida tmb se definen en los (), se especifica que o son con out y nos nombramos x convenion con o_...
# con la palabra reservada declare declaramos una variable.
#con into existe_correo estamso guardando el select count(*)
#last_insert_id() esta funcion devuelve el ultimo id autoincremental registrado en la tabla que le indicamos.

drop procedure sp_asignar_servicio;
DELIMITER //

CREATE PROCEDURE sp_asignar_servicio(
	in i_suscripcion int unsigned,
	in i_nombre varchar(30),
	in i_correo varchar (50),
	in i_tarjeta varchar(16),
	out o_respuesta varchar(50)
) 
begin
	declare existe_correo int default 0;
	declare cliente_id int default 0;
declare tarjeta_id int default 0;
    start transaction;
    select count(*) into exsite_correo 
    	from clientes 
    	where correo = i_correo;
    
    if existe_correo <> 0 then
    	select 'Tu correo ya ha sido registrado' into o_respuesta; 
    else 
   		insert clientes values (0, i_nombre, i_correo);
    	select last_insert_id() into clinete_id;
    insert into tarjetas 
    	values (0, cliente_id, AES_ENCRYPT(i_tarjeta, cliente_id));
    	select last_insert_id() into tarjeta_id;
    insert into servicios 	values(0,cliente_id,tarjeta_id,i_suscripcion;)
    select 'Servicio asignado con exito' into o_respuesta;
    end if;
    	
    commit;
END //

DELIMITER ;

select * from suscripciones;
select * from clientes;
select * from tarjetas;
select * from servicios;
call sp_asignar_servicio(3,'Agustin', 'agustin@gmail.com',1234567891234567,@res);
#el ultimo parametro es donde se almacenara la respuesta y el parametro de salida, lo que va a deolver la funcion.
#duera del store procedure para declarar una variale usamos "$".
select @res;


# TRIGGUERS o DISPARADORES
#son como los event listeners de sql, se usan para ejeutar una acion en respuesta a ciertos eventos en la db. Los eventos se dispararan cunado se ejecute alguna operacion que afete datos, insert update o delete.
#tambien es una funcion, com oun store procedure, pero este ultimo hay que invocarlo manualmente, el trigger responde a un evento automaticamente.

#sintaxis:

/*delimiter //
 * 
 * create trigger nombre
 * [before | after]					indicamos si se ejecutara antes o despues del evento.
 * [insert | update | delete]		que evento debe escuchar
 * on nombre_tabla
 * for each row						esta instrucicon es obligatoria y le dice al trigger que hay que ejecutarlo x cada registro o fila afectado/a
 * begin
 * 
 * end
 * 
 * delimiter //
 */


create table actividad_clientes(
ac_id int unsigned auto_increment primary key,
cliente int unsigned,
fecha datetime,
foreign key (cliente)
	references clientes(cliente_id)
	on delete restrict
	on update cascade
);

select * from actividad_clientes;

#con esta tabla vamos a usar el triguer. Cuando creemos un neuvo servicio, automaticamente cuand ola db lo detecte, que se incerte en la tabla actividad un registro para llevar el registro de las actiidades de los clientes.








