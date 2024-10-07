create table taller14.factura(
	id serial primary key,
	codigo bigint,
	cliente varchar(55),
	producto varchar(55),
	descuento decimal(10,2),
	valor_total decimal(10,2),
	numero_fe bigint
);

create sequence taller14.codigo_factura_seq
	start with 1
	increment by 1;

create sequence taller14.numero_fe_factura_seq
	start with 1
	increment by 100;
	
insert into taller14.factura(codigo, cliente, producto, descuento, valor_total, numero_fe) values
	(nextval('codigo_factura_seq'), 'Juan Valencia', 'Tablet', 0, 199.99, nextval('numero_fe_factura_seq')),
	(nextval('codigo_factura_seq'), 'Critian Duque', 'Tablet', 0, 199.99, nextval('numero_fe_factura_seq')),
	(nextval('codigo_factura_seq'), 'Juanito Perez', 'Laptop', 0, 679.99, nextval('numero_fe_factura_seq')),
	(nextval('codigo_factura_seq'), 'Esteban Quiñones', 'Tablet', 0, 199.99, nextval('numero_fe_factura_seq')),
	(nextval('codigo_factura_seq'), 'Sara Maria', 'Tablet', 0, 199.99, nextval('numero_fe_factura_seq')),
	(nextval('codigo_factura_seq'), 'Sofia Jaramillo', 'Phone', 0, 399.99, nextval('numero_fe_factura_seq')),
	(nextval('codigo_factura_seq'), 'Valeria Duque', 'Tablet', 0, 199.99, nextval('numero_fe_factura_seq')),
	(nextval('codigo_factura_seq'), 'Sebastian Muñoz', 'Tablet', 0, 199.99, nextval('numero_fe_factura_seq')),
	(nextval('codigo_factura_seq'), 'Oscar Marin', 'Laptop', 0, 679.9, nextval('numero_fe_factura_seq')),
	(nextval('codigo_factura_seq'), 'Migue Angel', 'Phone', 0, 399.9, nextval('numero_fe_factura_seq'));
	
	
	
	