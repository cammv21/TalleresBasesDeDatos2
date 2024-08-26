create table clientes(
	cliente_id SERIAL primary key,
	nombre varchar(30),
	identificacion varchar(10),
	edad int,
	correo varchar(30)
);

create table productos(
	producto_id SERIAL primary key,
	codigo varchar(10),
	nombre varchar(30),
	stock int,
	valor_unitario int
);

create table pedidos(
	pedido_id SERIAL primary key, 
	fecha date,
	cantidad int,
	valor_total int,
	producto_id int,
	cliente_id int,
	constraint fk_cliente_id foreign key (cliente_id) references clientes(cliente_id)
);

-- Agregar llave foranea 'producto_id' tabla 'pedidos'
alter table pedidos add constraint fk_producto_id foreign key (producto_id) references productos(producto_id);

-- Inicio de transacción
begin;

-- Insertar datos 'cleintes'
insert into clientes(nombre, identificacion, edad, correo) values 
('Camilo Muñoz', '123', '22', 'camilo@gmail.com'),
('Ana López', '456', 30, 'ana@gmail.com'),
('Jorge Pérez', '789', 25, 'jorge@gmail.com');

-- Actualizar datos 'clientes'
update clientes set nombre = 'Camilo Muñoz Valencia' where identificacion = '123';
update clientes set correo = 'ana.lopez@ejemplo.com' where identificacion = '456';

-- Insertar datos 'productos'
insert into productos (codigo, nombre, stock, valor_unitario) values 
('P001', 'Laptop', 15, 1500),
('P002', 'Smartphone', 30, 800),
('P003', 'Tablet', 25, 600);

-- Actulizar datos 'productos'
update productos set stock = 20  where codigo = 'P001';
update productos set valor_unitario = 850 where codigo = 'P002';

-- Insertar datos 'pedidos'
insert into pedidos (fecha, cantidad, valor_total, producto_id, cliente_id) values 
('2024-08-01', 2, 3000, 1, 1),
('2024-08-05', 1, 800, 2, 2),
('2024-08-10', 3, 1800, 3, 3);

-- Actulizar datos 'pedidos'
update pedidos set cantidad = 4 where pedido_id = 1;
update pedidos set valor_total = 1000 where pedido_id = 2;

-- Confirmar transacción
commit; 

-- Transacción para eliminar
begin;
delete from pedidos where pedido_id = 3;
delete from productos where producto_id = 3;
delete from clientes where cliente_id = 3;
commit;