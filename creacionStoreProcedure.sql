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
   
    select count(*) into existe_correo 
    	from clientes 
    	where correo = i_correo;
    
    if existe_correo <> 0 then
    	select 'Tu correo ya ha sido registrado' into o_respuesta; 
    
    else 
    
   		insert into clientes values (0, i_nombre, i_correo);
    	select last_insert_id() into cliente_id;
    
    	insert into tarjetas values (0, cliente_id, AES_ENCRYPT(i_tarjeta, cliente_id));
    	select last_insert_id() into tarjeta_id;
    
    	insert into servicios values(0,cliente_id,tarjeta_id,i_suscripcion);
    select 'Servicio asignado con exito' into o_respuesta;
    end if;
    	
    commit;
END //

DELIMITER ;

