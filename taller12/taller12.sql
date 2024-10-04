create table envios(
	id serial primary key,
	fecha_envio date,
	destino varchar(100),
	observacion varchar(255),
	estado varchar,
	check (estado in ('pendiente', 'en_ruta', 'entregado'))
)

-- Insertamos algunos envíos de prueba
insert into envios (fecha_envio, destino, observacion, estado)
values 
    (current_date - interval '6 days', 'Ciudad A', 'Envío en progreso', 'en_ruta'), -- Actualizar
    (current_date - interval '4 days', 'Ciudad B', 'Envío en ruta', 'en_ruta'),     -- No actualizar
    (current_date - interval '7 days', 'Ciudad C', 'Envío en progreso', 'en_ruta'), -- Actualizar
    (current_date - interval '2 days', 'Ciudad D', 'Pendiente de entrega', 'pendiente'), -- No actualizar
    (current_date - interval '8 days', 'Ciudad E', 'Envío ya entregado', 'entregado'); -- Ya está entregado

    
select * from envios;

call ultima_fase_envio();

select * from envios;


create or replace procedure taller12.ultima_fase_envio()
language plpgsql
as $$
declare
    v_cursor cursor for 
        select id from taller12.envios 
        where estado = 'en_ruta' 
        and fecha_envio <= current_date - interval '5 days';
    v_id int;
begin
    open v_cursor;
    loop
        fetch v_cursor into v_id;
        exit when not found;
        update taller12.envios 
        set estado = 'entregado', 
            observacion = 'Envio realizado satisfactoriamente' 
        where id = v_id;
        
        raise notice 'El envio con ID % ha sido actualizado a entregado.', v_id;
    end loop;
    close v_cursor;
end;
$$;
