create table clientes(
	cliente_id int primary key,
	nombre varchar(30),
	identificacion varchar(10),
	edad int,
	correo varchar(30)
);

create table productos(
	producto_id int primary key,
	codigo varchar(10),
	nombre varchar(30),
	stock int,
	valor_unitario int
);

create table pedidos(
	pedido_id int primary key, 
	fecha date,
	cantidad int,
	valor_total int,
	producto_id int,
	cliente_id int,
	constraint fk_cliente_id foreign key (cliente_id) references clientes(cliente_id),
	constraint fk_producto_id foreign key (producto_id) references productos(producto_id)
);


-- Inicio de transacción con rollback
begin;

-- Insertar datos 'clientes'
insert into clientes(cliente_id, nombre, identificacion, edad, correo) values 
(1, 'Camilo Muñoz', '123', '22', 'camilo@gmail.com'),
(2, 'Ana López', '456', 30, 'ana@gmail.com'),
(3, 'Jorge Pérez', '789', 25, 'jorge@gmail.com');

-- Actualizar datos 'clientes'
update clientes set nombre = 'Camilo Muñoz Valencia' where identificacion = '123';
update clientes set correo = 'ana.lopez@ejemplo.com' where identificacion = '456';

-- Insertar datos 'productos'
insert into productos (producto_id, codigo, nombre, stock, valor_unitario) values 
(1, 'P001', 'Laptop', 15, 1500),
(2, 'P002', 'Smartphone', 30, 800),
(3, 'P003', 'Tablet', 25, 600);

-- Actulizar datos 'productos'
update productos set stock = 20  where codigo = 'P001';
update productos set valor_unitario = 850 where codigo = 'P002';

-- Insertar datos 'pedidos'
insert into pedidos (pedido_id, fecha, cantidad, valor_total, producto_id, cliente_id) values 
(1, '2024-08-01', 2, 3000, 1, 1),
(2, '2024-08-05', 1, 800, 2, 2),
(3, '2024-08-10', 3, 1800, 3, 3);

-- Actulizar datos 'pedidos'
update pedidos set cantidad = 4 where pedido_id = 1;
update pedidos set valor_total = 1000 where pedido_id = 2;

-- Eliminar datos
delete from pedidos where pedido_id = 3;
delete from productos where producto_id = 3;
delete from clientes where cliente_id = 3;

-- Devolver la transacion
rollback;

-- Inicio de transacción con savepoint
begin;
-- Insertar datos 'clientes'
insert into clientes(cliente_id, nombre, identificacion, edad, correo) values 
(1, 'Camilo Muñoz', '123', '22', 'camilo@gmail.com'),
(2, 'Ana López', '456', 30, 'ana@gmail.com'),
(3, 'Jorge Pérez', '789', 25, 'jorge@gmail.com');

-- Insertar datos 'productos'
insert into productos (producto_id, codigo, nombre, stock, valor_unitario) values 
(1, 'P001', 'Laptop', 15, 1500),
(2, 'P002', 'Smartphone', 30, 800),
(3, 'P003', 'Tablet', 25, 600);

-- Insertar datos 'pedidos'
insert into pedidos (pedido_id, fecha, cantidad, valor_total, producto_id, cliente_id) values 
(1, '2024-08-01', 2, 3000, 1, 1),
(2, '2024-08-05', 1, 800, 2, 2),
(3, '2024-08-10', 3, 1800, 3, 3);

savepoint inserts_;

-- Actualizar datos 'clientes'
update clientes set nombre = 'Camilo Muñoz Valencia' where identificacion = '123';
update clientes set correo = 'ana.lopez@ejemplo.com' where identificacion = '456';

-- Actulizar datos 'productos'
update productos set stock = 20  where codigo = 'P001';
update productos set valor_unitario = 850 where codigo = 'P002';

-- Actulizar datos 'pedidos'
update pedidos set cantidad = 4 where pedido_id = 1;
update pedidos set valor_total = 1000 where pedido_id = 2;

-- Eliminar datos
delete from pedidos where pedido_id = 3;
delete from productos where producto_id = 3;
delete from clientes where cliente_id = 3;

rollback to savepoint inserts_;

-- Finalizar transaccion con savepoint
commit; 

select * from clientes;
