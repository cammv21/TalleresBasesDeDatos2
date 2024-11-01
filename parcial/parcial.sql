create table usuarios(
	id serial primary key,
	nombre varchar not null,
	direccion varchar(55),
	email varchar(55),
	fecha_registro date,
	estado varchar(10)
);

insert into usuarios(nombre, direccion, email, fecha_registro, estado) values 
	('Juan Camilo Muñoz', 'M1#17', 'juan21@gmail.com', '2024-10-1', 'activo');

create table tarjetas(
	id serial primary key,
	numero_tarjeta varchar(15),
	fecha_expiracion date,
	cvv varchar(3),
	tipo_tarjeta varchar(20)
);

insert into tarjetas(numero_tarjeta, fecha_expiracion, cvv, tipo_tarjeta) values 
	('123456789', '2027-08-1', '231', 'VISA');

create table productos(
	id serial primary key,
	codigo_producto varchar(10),
	nombre varchar(55),
	categoria varchar(55),
	porcentaje_impuesto numeric,
	precio numeric
);

insert into productos(codigo_producto, nombre, categoria, porcentaje_impuesto, precio) values 
	('PGD-100', 'Mac', 'PC', 10, 1000);

create table pagos(
	id serial primary key,
	codigo_pago varchar(10),
	fecha date,
	estado varchar(20),
	monto numeric,
	producto_id int not null,
	tarjeta_id int not null,
	usuario_id int not null,
	foreign key (producto_id) references productos(id),
	foreign key (tarjeta_id) references tarjetas(id),
	foreign key (usuario_id) references usuarios(id)
);

insert into pagos(codigo_pago, fecha, estado, monto, producto_id, tarjeta_id, usuario_id) values 
	('C-100', '2024-11-01', 'pago', 1000, 1, 1, 1);


-- Primera pregunta

create or replace function obtener_pagos_usuario(p_id int, p_fecha date)
returns table (
	codigo_pago varchar,
	nombre_producto varchar,
	monto numeric,
	estado varchar
)
as $$
begin
	return query
	select pg.codigo_pago, pd.nombre, pg.monto, pg.estado
	from parcial.pagos as pg
	join parcial.productos as pd
		on pg.producto_id = pd.id
	where pg.fecha = p_fecha
	and pg.usuario_id = p_id; 
end;
$$ language plpgsql;

create or replace function parcial.obtener_tarjetas_usuario(p_id int)
returns table (
	nombre varchar,
	email varchar,
	numero_tarjeta varchar,
	cvvv varchar,
	tipo_tarjeta varchar
) 
as $$
begin
	return query
	select t.nombre, t.email, t.numero_tarjeta, t.cvv, t.tipo_tarjeta
	from parcial.tarjetas as t
	join parcial.pagos as pg
		on pg.usuario_id = p_id
	where pg.monto > 1000
	and pg.usuario_id = p_id; 
end;
$$ language plpgsql;

-- Segunda pregunta

-- Obtener tarjetas con detalle de usuario cursores, p usuario id
-- retornar en varchar numero_tarjeta, fecha_expiracion, nombre, email

create or replace procedure parcial.obtener_tarjetas_detalle(p_id int)
language plpgsql
as $$
declare
    v_cursor cursor for 
        select id from parcial.pagos as pg
        where  pg.usuario_id = p_id;
	v_id int;
	numero_t varchar;
	fecha_exp date;
	p_nombre varchar;
	p_email varchar;
begin
    open v_cursor;
    loop
        fetch v_cursor into v_id;
        exit when not found;
        select t.numero_tarjeta, t.fecha_expiracion, u.nombre, u.email into numero_t, fecha_exp, p_nombre, p_email
		from parcial.pagos as pg	
		join parcial.tarjetas as t
			on pg.tajeta_id = t.id
		join parcial.usuarios as u
			on pg.usuario_id = u.id
		where pg.usuario_id = v_id;
        
        raise notice 'No. de tarjeta: %', numero_t ;
	 	raise notice 'Fecha expiracion: %', fecha_exp ;
		raise notice 'Nombre usuario: %', p_nombre;
		raise notice 'Email usuario: %', p_email;
    end loop;
    close v_cursor;
end;
$$;
-- pagos menores a 1000 dada una fecha, p fecha
-- retornar en varchar, monto, estado, nombre_prodcuto, porcentaje_impuesto, usuario_direccion, email

create or replace procedure parcial.obtener_tarjetas_detalle(p_fecha int)
language plpgsql
as $$
declare
    v_cursor cursor for 
        select id from parcial.pagos as pg
        where  pg.fecha = p_fecha;
	v_id int;
	p_monto numeric;
	p_estado varchar;
	p_nombre_producto varchar;
	p_porcentaje_impuesto numeric;
	p_direccion varchar;
	p_email varchar;
begin
    open v_cursor;
    loop
        fetch v_cursor into v_id;
        exit when not found;
        select pg.monto, pg.estado, p.nombre, p.porcentaje_impuesto, u.direccion, u.email 
			into p_monto, p_estado, p_nombre_producto, p_porcentaje_impuesto, p_direccion, p_email
		from parcial.pagos as pg	
		join parcial.productos as p
			on pg.producto_id = p.id
		join parcial.usuarios as u
			on pg.usuario_id = u.id
		where pg.usuario_id = v_id;
        
        raise notice 'Monto: %', p_monto ;
	 	raise notice 'Estado %', p_estado ;
		raise notice 'Nombre producto: %', p_nombre_producto;
		raise notice 'Porcentaje impuesto: %', p_porcentaje_impuesto;
		raise notice 'Direccion: %', p_direccion;
		raise notice 'Email: %', p_email;
    end loop;
    close v_cursor;
end;
$$;


-- Tercera pregunta

create or replace function parcial.validaciones_producto()
returns trigger as
$$
begin 
	if(new.precio > 0 and new.precio < 20000){
		insert into productos(codigo_producto, nombre, categoria, porcentaje_impuesto, precio)
		values (new.codigo_producto, new.nombre, new.categoria, new.porcentaje_impuesto, new.precio);
		return new;
	}
	raise exception 'El precio debe ser mayor a 0  y menos a 20000'
end;
$$
language plpgsql;

create trigger tg_validaciones_producto
after update on parcial.productos 
for each row 
execute procedure parcial.validaciones_producto();



