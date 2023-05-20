create database practica;
show databases;
use practica;

show tables;

create table producos(
producto_id int unsigned auto_increment primary key,
nombre varchar(50) not null,
cantidad int,
precio int,
marca varchar(50)
);

alter table producos rename to productos;
alter table productos modify precio float;

describe productos;
#insertando datos de distintas maneras:
insert into productos values (0, "computadora", 16, 19999.99, "lenovo");
insert into productos (nombre, cantidad, precio, marca) values ("computadora", 12, 15600.50, "hp");
select * from productos;
insert into productos (nombre, cantidad, precio, marca) values
("computadora", 11,27000,"apple"),
("computadora", 7, 15999.50, "acer"),
("celular", 6, 8000, "samsung"),
("celular", 8, 7000, "huawei"),
("celular", 12, 12000, "apple"),
("celular", 11, 9500, "xiaomi");

select * from productos;
select nombre, cantidad from productos;
select count(*) from productos; #cuenta el total de registros
select count(*) as total_productos from productos;
select * from productos where nombre = "computadora";
select * from productos where nombre = "computadora" and precio > 17000;
select * from productos where marca in ("lenovo", "acer");
select * from productos where marca like 'x%';
select * from productos where marca not like 'x%';


update productos set cantidad = 12, precio = 11500 where producto_id = 4;
update productos set cantidad = 5 where producto_id = 5;
update productos set precio = 26000 where marca = "apple";
select * from productos;

delete from productos where marca = 'huawei'; 


select *, (precio*cantidad) as ganancia from productos;

select nombre, precio, cantidad, (precio*cantidad) as ganancia from productos where nombre = 'computadora';

select sum(cantidad) as stok from productos where nombre = 'computadora';

select avg(precio) as precio_promedio_celulares from productos where nombre = 'celular';

select min(precio) as celular_mas_barato from productos where nombre = 'celular';
select max(precio) as compu_mas_cara from productos where nombre = 'computadora';

select count(nombre) from productos; # cuenta el n° de campos.


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

#group by es como where pero para usar con funciones de agrupamiento.
select nombre,  from productos group by marca, nombre, cantidad, precio;

select nombre,marca, (precio*cantidad) from productos group by nombre,marca, precio, cantidad;
#es lo mismo que la linea de abajo porque no usa funciones a agrupamiento:
select nombre,marca, (precio*cantidad) from productos;
#lo relevante del group by es que se puede usar con funciones de agrupamiento, la línea siguiente no se puede ejecutar asi:
select signo, count(*) from caballeros;
#debe ser:
select signo, count(*) from caballeros group by signo;



# luego del group by vamos a neccesitar insertar los datos que pusimos antes el from.
select signo, count(*) from caballeros group by signo;

select  marca,nombre, max(precio) from productos group by  marca, precio, nombre having precio > 7000 and nombre = 'celular';


select nombre, marca, precio from productos where precio between 7000 and 11000 order by nombre;
