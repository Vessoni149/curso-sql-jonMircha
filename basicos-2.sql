create database curso_sql_2;

drop database curso_sql_2;

use curso_sql_2;


create table usuarios(
usuario_id INT unsigned auto_increment primary key,
nombre varchar(30) not null,
apellidos varchar(30) not null,
correo varchar(50) unique,
edad INT default 0
);

show tables; #muestra las tablas que hay

describe usuarios;	#muestra la tabla usuarios pero sin los valores.

select * from usuarios; # muestra todos las filas de la tabla con sus valores.

insert into usuarios (nombre, apellidos, correo, edad) values 
("jon","Mircha","jonmircha@gmail.com", 38),
("kenai","Mircha","kenai@gmail.com", 10),
("irma","campos", "irma@outlook.com", 38),
("pepito", "pepon", "pepe@gmail.com",28), 
("rosita", "rozas", "rosa@gmail.com", 40),
("macario", "Guzman", "macario@outlook.com", 55);

create table productos (
producto_id int unsigned auto_increment primary key,
nombre varchar(50) not null,
descripcion varchar(50),
precio DECIMAL (7,2),
cantidad INT unsigned
);
#decimal siginfica que es flotante, el primer parametro indica que va a ser un numero de 7 digitos, y el segundo parametro la cantidad de decimales.

select * from productos;

drop table productos;

insert into productos (nombre, descripcion,precio, cantidad) values
("Computadora", "Macbook Air M2", 29999.99, 5),
("Celular", "Nothing Phone 1", 11999.99, 15),
("Cámara web", "Logitech C920",1500, 13),
("Microfono", "Blue Yeti", 2500, 19),
("Audífonos", "Audífonos Bose", 6500, 10);

#select es como un console.log, lo podemos usar para mostrar calculos. Tambien podemos asignarle un alias a la operacion.


#calculos aritmeticos.
select 6+5;
select 2-3 as calculo;
select 4*5;
select 6/5;
#para sacar el modulo no se puede usar el operador %, debemos usar la funcion mod que recibe como parametro el dividendo y el divisor separados x ','.

#funciones matematicas.
select mod(4,2);

select ceiling(7.23);
#redonde hacia arriba como el ceil de js.

select floor(7.9);
#redondea hacia abajo.

select round(7.5);
select round(7.49);
#redondea al int mas cercano

select power(2,6);
#potencia

select sqrt(81);
#raiz cuadrada

#columnas calculadas
select nombre, precio, cantidad, (precio * cantidad) as ganancia  from productos;
esto devuelve una lista de todos los productos con 4 columnas, nombre, precio, cantidad, y la multiplicacion de cantidad x precio cuyo campo se llamará ganancia.



#funciones de agrupamiento

select max(precio) as precio_maximo from productos;
#max busca el maximo numero de algo

select min(precio) as precio_minimo from productos;

select sum(cantidad) as existencias from productos;	
#suma todo el stok

select avg(precio) as precio_promedio from productos;
#saca el promedio

#todas las operaciones las estamos haciendo sobre la columna o cmapo precio, que tendra en cuenta a todos los precios de todos los elementos de la tabla, si queremos especificar otras cosas en particular deberiamos usar where.

select count(*) as productos_total from productos;
#cuenta todo de productos.


#group by:
#Se usa en conjunto con las funciones de agrupamiento
select nombre, precio, max(precio) as precio_maximo from productos group by precio, nombre;

create table caballeros (
caballero_id INT unsigned auto_increment primary key,
nombre varchar(30),
armadura varchar(30),
rango varchar(30),
signo varchar(30),
ejercito varchar(30),
pais varchar(30)
);


insert into caballeros values
(0, "Seiya", "Pegaso", "Bronce", "Sagitario", "Athena", "Japon"),
(0, "Shiryu", "Dragón", "Bronce", "Libra", "Athena", "Japon"),
(0, "Hyoga", "Cisne", "Bronce", "Acuario", "Athena", "Rusia"),
(0, "Shun", "Andromeda", "Bronce", "Virgo", "Athena", "Japon"),
(0, "Ikki", "Fénix", "Bronce", "Leo", "Athena", "Japon"),
(0, "Kanon", "Géminis", "Oro", "Géminis", "Athena", "Grecia"),
(0, "Saga", "Géminis", "Oro", "Géminis", "Athena", "Grecia"),
(0, "Camus", "Acuario", "Oro", "Acuario", "Athena", "Francia"),
(0, "Rhadamanthys", "Wyvern", "Espectro", "Escorpión", "Hades", "Inglaterra"),
(0, "Kanon", "Dragón Marino", "Marino", "Géminis", "Poseidón", "Grecia"),
(0, "Kagaho", "Bennu", "Espectro", "Leo", "Hades", "Rusia");

drop table caballeros;

select * from caballeros;


select signo, count(*) as total from caballeros group by signo;

select armadura, count(*) as total from caballeros group by armadura;

select rango, count(*) as total from caballeros group by rango;

select pais, count(*) as total from caballeros group by pais;

#having
# es como el where de las funciones de agrupamiento, sire para agragar condicionales

#se puede usar igualmente el where pero los where son mas para campos que si existen en la tala, no para campos geenrados con funciones de agrupamiento como total. Si usamos where no podemos usar and, entonces solo podemos poner una condicion. Por eso es mejor usar having.
select rango, count(*) as total from caballeros where ejercito = "Athena" group by rango;

select rango, count(*) as total from caballeros where ejercito = "Athena" group by rango having total >=4;

select nombre, precio, max(precio) as precio_maximo from productos group by precio, nombre having precio_maximo >= 10000;



# DISTINCT: con esta clausua podemos eliminar campos repetidos y devolver campos unicos.

select distinct signo from caballeros;
select distinct armadura from caballeros;
select distinct ejercito from caballeros;


# ORDER

select * from caballeros;
#esto los trae por oren de id, pero con order los podemos ordenar de varias formas.

select * from caballeros order by nombre asc;
#así los ordenamos en forma ascendente alfabeticamente ya que usamos como referencia al campo nombre. Si no especificamos asc lo hace por default.
select * from caballeros order by nombre desc;
# Ahora descendente.

#Podemos ordenar por varios campos

select * from caballeros order by nombre, signo asc;

#Se puede combinar con group by, donde order by iría al final de la consulta.

select * from caballeros where ejercito = "Athena" order by nombre, armadura;

select ejercito, count(*) as total from caballeros group by ejercito order by ejercito desc;

select nombre, precio, max(precio) as precio_maximo from productos group by precio, nombre having precio_maximo >= 1000 order by nombre;

#las consultas siempre deben tener un orden, select campo, de que (from) tabla, luego vienen funciones de agrupamiento (group by) luego condicionales (having) y luego clausulas de agrupamiento(order by).


#BETWEEN

#sirve para sseleccionar campos por rango, precios, fechas x ej.
# sin el between se puede hacer así:
select * from productos where precio >= 5000 and precio <= 15000;
#Con between:
select * from productos where precio between 5000 and 15000;



#expresiones regulares

select * from productos where nombre regexp "[j-z]";



#funciones de cadenas:
select ('Hola Mundo');
select lower('Hola Mundo');
select lcase('Hola Mundo'); # es igual que lower
select upper('Hola Mundo');
select ucase('Hola Mundo');	# = que upper
select left('Hola Mundo', 5); # obtiene x n° de caracteres desde la izq.
select right('Hola Mundo',5);
select length('Hola Mundo');
select repeat('Hola Mundo',3);
select reverse('Hola Mundo');
select replace('Hola Mundo','o','x');
#Quitar espacios en blanco a la izquierda, derecha y ambos lados respectivamente:
select ltrim('     Hola Mundo      ');
select rtrim('     Hola Mundo      ');
select trim('     Hola Mundo      ');
select concat('Hola Mundo', ' desde', ' sql');
select concat_ws('-','Hola Mundo', 'desde', 'sql'); #concatena pero sin espacios en blanco como separador, usara el que le pasemos como primer parametro. Sirve para constuir urls amigables x ej.

#aplicacion en una consulta:
select upper(nombre), lower(descripcion), precio from productos;













