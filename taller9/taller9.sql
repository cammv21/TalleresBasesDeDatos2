
create table tipo_contrato (
    id serial primary key,
    descripcion varchar(255),
    cargo varchar(100) not null,
    salario_total numeric(10, 2) not null
);


create table empleados (
    id serial primary key,
    nombre varchar(255),
    identificacion varchar(100) unique not null,
    tipo_contrato_id int not null,
    foreign key (tipo_contrato_id) references tipo_contrato(id)
);


create table conceptos (
    id serial primary key,
    codigo varchar(50) unique not null,
    nombre varchar(255) not null,
    salario numeric(10, 2) not null,
    horas_extras numeric(10, 2),
    prestaciones numeric(10, 2),
    impuestos numeric(10, 2),
    porcentaje numeric(5, 2) 
);


create table nomina (
    id serial primary key,
    mes varchar(20),
    año numeric,
    fecha_pago date not null,
    total_devengado numeric(10, 2),
    total_deducciones numeric(10, 2),
    total numeric(10, 2),
    empleado_id int NOT null,
    foreign key (empleado_id) references empleados(id)
);


create table detalles_nomina (
    id serial primary key,
    valor numeric(10, 2),
    nomina_id int,
    concepto_id int,
    foreign key (concepto_id) references conceptos(id),
    foreign key (nomina_id) references nomina(id)
);

INSERT INTO tipo_contrato (descripcion, cargo, salario_total) VALUES
('Contrato indefinido', 'Desarrollador', 3000.00),
('Contrato temporal', 'Diseñador gráfico', 2200.00),
('Contrato indefinido', 'Gerente de proyecto', 4500.00),
('Contrato por horas', 'Soporte técnico', 1500.00),
('Contrato temporal', 'Analista de datos', 2700.00),
('Contrato indefinido', 'Administrador de redes', 3200.00),
('Contrato temporal', 'Marketing', 2500.00),
('Contrato por horas', 'Consultor IT', 1600.00),
('Contrato indefinido', 'QA Tester', 3100.00),
('Contrato temporal', 'Especialista en ventas', 2300.00);

INSERT INTO empleados (nombre, identificacion, tipo_contrato_id) VALUES
('Juan Pérez', '1234567890', 1),
('Ana Gómez', '9876543210', 2),
('Carlos López', '1231231234', 3),
('María Fernández', '4321432143', 4),
('Luis García', '5432154321', 5),
('Patricia Sánchez', '6789012345', 6),
('Roberto Jiménez', '5678901234', 7),
('Laura Martínez', '4567890123', 8),
('Daniel Herrera', '3456789012', 9),
('Carmen Torres', '2345678901', 10);

INSERT INTO conceptos (codigo, nombre, salario, horas_extras, prestaciones, impuestos, porcentaje) VALUES
('C001', 'Salario Base', 1000.00, 0, 100, 50, 10),
('C002', 'Bonificación', 500.00, 0, 0, 0, 5),
('C003', 'Horas Extras', 200.00, 50, 0, 0, 2),
('C004', 'Prestaciones', 0.00, 0, 200, 50, 10),
('C005', 'Impuestos', 0.00, 0, 0, 150, 15),
('C006', 'Seguro de salud', 0.00, 0, 100, 0, 5),
('C007', 'Descuento', 0.00, 0, 0, 100, 5),
('C008', 'Vacaciones', 300.00, 0, 0, 0, 5),
('C009', 'Seguro de vida', 0.00, 0, 50, 0, 3),
('C010', 'Bono de productividad', 700.00, 0, 0, 0, 5),
('C011', 'Auxilio de transporte', 150.00, 0, 0, 0, 3),
('C012', 'Prima de navidad', 800.00, 0, 0, 0, 10),
('C013', 'Comisiones', 400.00, 0, 0, 0, 6),
('C014', 'Subsidio familiar', 200.00, 0, 0, 0, 2),
('C015', 'Descuento por préstamo', 0.00, 0, 0, 250, 10);

INSERT INTO nomina (mes, año, fecha_pago, total_devengado, total_deducciones, total, empleado_id) VALUES
('Enero', 2024, '2024-01-31', 3000.00, 500.00, 2500.00, 1),
('Febrero', 2024, '2024-02-28', 3200.00, 400.00, 2800.00, 2),
('Marzo', 2024, '2024-03-31', 3500.00, 600.00, 2900.00, 3),
('Abril', 2024, '2024-04-30', 2700.00, 500.00, 2200.00, 4),
('Mayo', 2024, '2024-05-31', 3100.00, 400.00, 2700.00, 5);

INSERT INTO detalles_nomina (valor, nomina_id, concepto_id) VALUES
(1000.00, 1, 1),
(500.00, 1, 2),
(200.00, 1, 3),
(100.00, 2, 1),
(400.00, 2, 10),
(150.00, 2, 11),
(500.00, 3, 2),
(150.00, 3, 11),
(200.00, 3, 14),
(800.00, 4, 12),
(200.00, 4, 13),
(150.00, 5, 15),
(100.00, 5, 9),
(300.00, 5, 8),
(400.00, 5, 13);

-- Primer ejercicio
create or replace function obtener_nomina_empleado(
    p_identificacion varchar,
    p_mes varchar,
    p_año numeric
)
returns table(
    nombre_empleado varchar,
    total_devengado numeric,
    total_deducciones numeric,
    total_nomina numeric
) as $$
begin
    return QUERY
    select e.nombre, n.total_devengado, n.total_deducciones, n.total
    from empleados as e
    join nomina as n 
		on e.id = n.empleado_id
    where e.identificacion = p_identificacion
    and n.mes = p_mes
    and n.año = p_año;
end;
$$ language plpgsql;

-- Llamado a la función
select * from obtener_nomina_empleado('1234567890', 'Enero', 2024);


-- Segundo ejercicio
create or replace function total_por_contrato(
    p_tipo_contrato varchar
)
returns table(
    nombre_empleado varchar,
    fecha_pago date,
    año numeric,
    mes varchar,
    total_devengado numeric,
    total_deducciones numeric,
    total_nomina numeric
) as $$
begin
    return QUERY
    select e.nombre, n.fecha_pago, n.año, n.mes, n.total_devengado, n.total_deducciones, n.total
    from empleados as e
    join tipo_contrato as tc 
		on e.tipo_contrato_id = tc.id
    join nomina as n 
		on e.id = n.empleado_id
    where tc.descripcion = p_tipo_contrato;
end;
$$ language plpgsql;

-- Llamado a la función
select * from total_por_contrato('Contrato indefinido');