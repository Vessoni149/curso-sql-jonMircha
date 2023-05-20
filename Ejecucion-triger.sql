delimiter //
  
create trigger tg_actividad_clientes
  after	insert	
  on clientes
  for each row						
  
  begin
  	insert into actividad_clientes values (0, new.cliente_id, now(())
  	#para obtener el id del cliente, usamos el objeto de los triggers new, que obtiene el valor que se inserto y que origino el evento del trigger. New guardara el objeto e la insercion que enero el disparo del trigguer. 
  	#por su parte now() es un evento que devuelve la fecha actual, con ella completamos el 3er parametro que necesitamos que es la fecha.
  end
 
delimiter //
