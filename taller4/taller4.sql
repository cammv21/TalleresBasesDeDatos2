create table clientes(
	cliente_id varchar(10) primary key,
	identificacion varchar(10) unique,
	nombre varchar(30),
	edad integer,
	correo varchar(30)
);

create table productos(
	producto_id varchar(10) primary key,
	codigo_producto varchar(10) unique,
	nombre varchar(30),
	stock integer,
	valor_unitario numeric
);

create table facturas(
	factura_id varchar(10) primary key,
	codigo_factura varchar(10),
	fecha date,
	cantidad integer,
	valor_total numeric,
	pedido_estado varchar(10),
	producto_id varchar(10),
	cliente_id varchar(10),
	foreign key (producto_id) references productos(producto_id),
    foreign key (cliente_id) references clientes(cliente_id),
);

alter table facturas 
add check (pedido_estado IN ('PENDIENTE', 'BLOQUEADO', 'ENTREGADO'));

insert into clientes (cliente_id, identificacion, nombre, edad, correo) values
('C001', '1234567890', 'Juan Perez', 30, 'juan.perez@example.com'),
('C002', '0987654321', 'Maria Gomez', 25, 'maria.gomez@example.com'),
('C003', '1122334455', 'Luis Martinez', 40, 'luis.martinez@example.com');

insert into productos (producto_id, codigo_producto, nombre, stock, valor_unitario) values
('P001', 'PROD001', 'Laptop', 10, 750.00),
('P002', 'PROD002', 'Smartphone', 20, 500.00),
('P003', 'PROD003', 'Tablet', 15, 300.00);

insert into facturas (factura_id, codigo_factura, fecha, cantidad, valor_total, pedido_estado, producto_id, cliente_id) values
('F001', 'FAC001', '2024-08-30', 1, 750.00, 'PENDIENTE', 'P001', 'C001'),
('F002', 'FAC002', '2024-08-31', 2, 1000.00, 'ENTREGADO', 'P002', 'C002'),
('F003', 'FAC003', '2024-09-01', 1, 300.00, 'BLOQUEADO', 'P003', 'C003');


-- Funcion para verificar el stock
create or replace procedure verificar_stock(
	p_producto_id varchar(10),
	p_cantidad_compra integer
)

language plpgsql
as $$
declare 
	stock_producto integer; 
begin

	-- Obtenemos el valor del stock del producto
	select stock into stock_producto from productos where producto_id = p_producto_id;
	raise notice '----------------------------------------------------';
	raise notice 'Stock del producto: ';
	raise notice '%', stock_producto;
	raise notice 'Cantidad a comprar: ';
	raise notice '%', p_cantidad_compra;

	if stock_producto < p_cantidad_compra THEN
		raise notice 'No hay stock suficiente del producto';
	else
		raise notice 'Compra hecha correctamente';
	end if;
end;
$$;

call verificar_stock('P001', '11');


-- Funcion para actualizar el estado del pedido
create or replace procedure actualizar_estado_pedido(
	p_factura_id varchar(10),
	p_nuevo_estado varchar(10)
)

language plpgsql
as $$
declare 
	anterior_estado varchar(10); 
begin

	-- Obtenemos el estado actual de la factura 
	select pedido_estado into anterior_estado from facturas where factura_id = p_factura_id;
	raise notice '----------------------------------------------------';
	raise notice 'Estado del pedido: ';
	raise notice '%', anterior_estado;
	
	if anterior_estado = 'ENTREGADO' THEN
		raise notice 'El producto ya fue entregado';
	else
		update facturas set pedido_estado = p_nuevo_estado where factura_id = p_factura_id;
		raise notice 'El estado del pedido se actualizó a:';
		raise notice '%', p_nuevo_estado;
	end if;
end;
$$;

call actualizar_estado_pedido('F002','PENDIENTE');

