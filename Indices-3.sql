#INDICES

#ppalmente hay 3 tipos: llaves primarias, campos unicos, e índices que nosotros podamos crear.
#los indices ocupan espacio en el disoc duro de la DB, pero van a ayudar a que se pueda ubicar el indice en una tabla para que las consultas sean mas veloces.

#para ver indices de una tabla:
show index from caballeros;

show index from usuarios;


create database curso_sql_3;

use curso_sql_3;

#crearemos una tabla con indices. Es como crear un valor mas pero se usa la palabra reservada index, su nombre x convencion debe ser por i_campo, y se debe indicar entre() el campo al que hace referencia.
create table caballeros (
caballero_id INT unsigned auto_increment primary key,
nombre varchar(30),
armadura varchar(30),
rango varchar(30),
signo varchar(30),
ejercito varchar(30),
pais varchar(30),
index i_rango (rango),
index i_signo (signo),
index i_caballeros (ejercito, pais),		# aca con 1 solo alias hacemos referencia a 2 campos.

#este indice fulltext crea un i a partir de varios campos para poder hacer un select especial para hacer una busqueda hacia varios campos. Esos indices demandan mas a la db asique no hay que abusar de ellos. Jon le llama indice google, veremos xq en el ej del select
fulltext index fi_search (armadura,rango,signo,ejercito,pais)
);

drop table caballeros;
describe caballeros;
insert into caballeros values
(0, "Seiya", "Pegaso", "Bronce", "Sagitario", "Athena", "Japon"),
(0, "Shiryu", "Dragón", "Bronce", "Libra", "Athena", "Japon"),
(0, "Hyoga", "Cisne", "Bronce", "Acuario", "Athena", "Rusia"),
(0, "Shun", "Andromeda", "Bronce", "Virgo", "Athena", "Japon"),
(0, "Ikki", "Fénix", "Bronce", "Leo", "Athena", "Japon"),
(0, "Kanon", "Géminis", "Oro", "Géminis", "Athena", "Grecia"),
(0, "Saga", "Junini", "Oro", "Junini", "Athena", "Grecia"),
(0, "Camus", "Acuario", "Oro", "Acuario", "Athena", "Francia"),
(0, "Rhadamanthys", "Wyvern", "Espectro", "Escorpión oro", "Hades", "Inglaterra"),
(0, "Kanon", "Dragón Marino", "Marino", "Géminis oro", "Poseidón", "Grecia"),
(0, "Kagaho", "Bennu", "Espectro", "Leo", "Hades", "Rusia");

select * from caballeros; 
truncate table caballeros; #borra los campos de la tabla, no la tabla en si.

drop table caballeros;
create table caballeros (
caballero_id INT unsigned auto_increment primary key,
nombre varchar(30),
armadura varchar(30),
rango varchar(30),
signo varchar(30),
ejercito varchar(30),
pais varchar(30),
index i_rango (rango),
index i_signo (signo),
index i_caballeros (ejercito, pais),		# aca con 1 solo alias hacemos referencia a 2 campos.
)
show index from caballeros;

drop table caballeros;
create table caballeros (
caballero_id INT unsigned auto_increment primary key,
nombre varchar(30),
armadura varchar(30),
rango varchar(30),
signo varchar(30),
ejercito varchar(30),
pais varchar(30),
#este indice fulltext crea un i a partir de varios campos para poder hacer un select especial para hacer una busqueda hacia varios campos. Esos indices demandan mas a la db asique no hay que abusar de ellos. Jon le llama indice google, veremos xq en el ej del select
fulltext index fi_search (armadura,rango,signo,ejercito,pais)
);
show index from caballeros;

SELECT * FROM caballeros
WHERE MATCH(armadura, rango, signo, ejercito, pais)
AGAINST('Oro' IN BOOLEAN MODE);
#donde detecte la palabra "Oro" en cualqueira de esos campos, lo va a traer. Como busca las coicidencias en muchso campos le llama indice google.


##Modificar tabla.

#creamos una tabla sin PK para despues modificarla (tmb eliminamos el auto_increment ya que éste solo puede ir en un campo PK).
drop table caballeros;
create table caballeros (
caballero_id INT unsigned,
nombre varchar(30),
armadura varchar(30),
rango varchar(30),
signo varchar(30),
ejercito varchar(30),
pais varchar(30)
);

#vamos a asignar una PK y luego le damos el valor auto_increment.
#contraint se usa para PK fK y campos unique
show index from caballeros;
alter table caballeros add constraint pk_caballero_id primary key (caballero_id);
#lo que va seguido del constraint es un alias.
#para hacerla autoincremental:
alter table caballeros modify column caballero_id INT auto_increment;
show index from caballeros;
alter table caballeros add constraint uq_armadura unique (armadura);
show index from caballeros;

#agregar un indice comun y correinte:
alter table caballeros add index i_rango (rango);
show index from caballeros;

#insertando 2 indices a la vez
alter table caballeros add index i_ejercito_pais (rango,pais);
show index from caballeros;

#insertanto index fulltext:
alter table caballeros add fulltext index fi_search (nombre,signo);
show index from caballeros;

#eliminar indices:
alter table caballeros drop index fi_search;
alter table caballeros drop index i_ejercito_pais;
alter table caballeros drop index i_rango;
show index from caballeros;

#para eliminar cmapos unicos como PK FK o unique hay que usar constraint:
alter table caballeros drop constraint uq_armadura;
# se puede hacer con la llave PK pero n oes recomendable xq ya tenemos datos cargados autoincrementales. Primero habria que haer un altertable y quitarle el autoincrement para despues poder eliminarla.

