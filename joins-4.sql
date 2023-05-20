#Los joins o uniones permiten combinar filas de distintas tablas para mostrar info.
# un INNER JOIN deuelve todas las filas en las que haya alguna coincidencia en ambas tablas.

#LEFT JOIN devuelve todos los cmapos de la tabla izq mas las coincidencias que tenga con la tabla derecha.
#RIGHT JOIN es exactamente lo contrario
#FULL OUTER JOIN devuelve todas las filas de las 2 tablas

create database curso_sql_4;

use curso_sql_4;

show databases;

CREATE table armaduras (
armadura_id int unsigned auto_increment PRIMARY KEY,
armadura varchar(30) NOT null
);

CREATE table rangos(
rango_id int unsigned auto_increment PRIMARY KEY,
rango varchar(30) NOT null
);

CREATE table signos (
signo_id int unsigned auto_increment PRIMARY KEY,
signo varchar(30) NOT null
);

CREATE table ejercitos (
ejercito_id int unsigned auto_increment PRIMARY KEY,
ejercito varchar(30) NOT null
);
drop table signos;

CREATE table paises (
pais_id int unsigned auto_increment PRIMARY KEY,
pais varchar(30) NOT null
);

create table caballeros (
caballero_id INT unsigned auto_increment PRIMARY key,
nombre varchar(30),
armadura int unsigned,
rango int unsigned,
signo int unsigned,
ejercito int unsigned,
pais int unsigned,
FOREIGN KEY (armadura) REFERENCES armaduras(armadura_id),
FOREIGN KEY (rango) REFERENCES rangos(rango_id),
FOREIGN KEY (ejercito) REFERENCES ejercitos(ejercito_id),
FOREIGN KEY (pais) REFERENCES paises(pais_id),
FOREIGN KEY (signo) REFERENCES signos(signo_id)
);

describe caballeros;
show tables;

insert into armaduras values
(1,"Pegaso"),
(2,"Dragón"),
(3,"Cisne"),
(4,"Andromeda"),
(5,"Fénix"),
(6,"Géminis"),
(7,"Acuario"),
(8,"Wyvern"),
(9,"Dragón Marino"),
(10,"Bennu");

insert into signos values
(1,"Aries"),
(2,"Tauro"),
(3,"Géminis"),
(4,"Cancer"),
(5,"Leo"),
(6,"Virgo"),
(7,"Libra"),
(8,"Escorpion"),
(9,"Sagitario"),
(10,"Capricornio"),
(11,"Acuario"),
(12,"Pisis");

insert into paises values
(1,"Japón"),
(2,"Rusia"),
(3,"Grecia"),
(4,"Francia"),
(5,"Inglaterra");

insert into ejercitos values
(1,"Atena"),
(2,"Hades"),
(3,"Poseidon");

insert into rangos values
(1,"Bronce"),
(2,"Oro"),
(3,"Espectro"),
(4,"Marino");

insert into caballeros values
(1, "Seiya",1,1,9,1,1),
(2, "Shiryu",2, 1,7,1,1),
(3, "Hyoga",3,1,11,1,2),
(4, "Shun",4,1,6,1,1),
(5, "Ikki",5,1,5,1,1 ),
(6, "Kanon", 6,2,3,1,3 ),
(7, "Saga", 6,2,3,1,3 ),
(8, "Camus", 7,2,11,1,4  ),
(9, "Rhadamanthys",8,3,8,2,5 ),
(10, "Kanon", 9,4,3,3,3),
(11, "Kagaho", 10,3,5,2,2 );
 
SELECT * FROM caballeros;
SELECT * FROM rangos;
SELECT * FROM signos;
SELECT * FROM ejercitos;
SELECT * FROM paises;
SELECT * FROM armaduras;

select * from caballeros c 
left join signos s on c.signo = s.signo_id;
#c es el alias, no hace falta poner as
#left muestra lo que coincida de ambas tablas mas toda la tabla izquierda
#Lo que se muestra es toda la tabla caballeros (que es la izquierda) con una columna agregada con los signos (que es lo que coincide)

select * from caballeros c 
right join signos s on c.signo = s.signo_id;
#right muestra lo que coincida de ambas tablas y toda la tabla de la derecha (signos)

select * from caballeros c 
inner join signos s on c.signo = s.signo_id;
#trae  solo la info que coincida en ambas tablas.


select * from caballeros c 
full join signos s on c.signo = s.signo_id;
#full join no es soportado por mysql, pero hay una forma de hacer lo mismo uniendo un left join con un rigth join:
select * from caballeros c 
left join signos s on c.signo = s.signo_id
union 
select * from caballeros c 
right join signos s on c.signo = s.signo_id;
#union es para unir consultas.


select c.caballero_id, c.nombre, a.armadura,
s.signo, r.rango, e.ejercito, p.pais
from caballeros c
inner join armaduras a on c.armadura = a.armadura_id 
inner join signos s on c.signo = s.signo_id 
inner join rangos r on c.rango = r.rango_id 
inner join ejercitos e on c.ejercito = e.ejercito_id 
inner join paises p on c.pais = p.pais_id;


#SUBCONSULTAS
#son una consulta dentro de otra.

select signo, 
(select count(*) from caballeros c where c.signo = s.signo_id) as total_caballeros 
from signos s;

select rango, 
(select count(*) from caballeros c where c.rango = r.rango_id) as total_caballeros 
from rangos r;


select ejercito, 
(select count(*) from caballeros c where c.ejercito = e.ejercito_id) as total_caballeros 
from ejercitos e;

select pais, 
(select count(*) from caballeros c where c.pais = p.pais_id) as total_caballeros 
from paises p;


#VISTAS
#dentro de la db ademas de tener las tablas tenemos las views (ver el panel de la izq.)
#es una tabla virtual que se deriva de una o varias tablas existentes dentro de la misma. No ocupan espacio en la db es una consulta mas.
#una vez definida puede ser tratada como una tabla en la db  como consultas actualizacion y eliminacion de registros.

#Las vistas proporcionan una capa de abstraccion para que personas que no sepan de dbs entiendan la info de la vista.

#basicamente tomamos una consulta y creamos la vista con ella.
create view vista_caballeros as 
select c.caballero_id, c.nombre, a.armadura,
s.signo, r.rango, e.ejercito, p.pais
from caballeros c
inner join armaduras a on c.armadura = a.armadura_id 
inner join signos s on c.signo = s.signo_id 
inner join rangos r on c.rango = r.rango_id 
inner join ejercitos e on c.ejercito = e.ejercito_id 
inner join paises p on c.pais = p.pais_id;

select * from vista_caballeros;

drop view vista_caballeros;

#así se visualiza la vista:
show full tables in curso_sql_4 where table_type like 'view';


create view vista_signos as
select signo, 
(select count(*) from caballeros c where c.signo = s.signo_id) as total_caballeros 
from signos s;

select * from vista_signos;







