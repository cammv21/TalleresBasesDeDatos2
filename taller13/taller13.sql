create table empleado(
	id serial primary key,
	name varchar(50),
	identificacion varchar(10) unique,
	edad int,
	correo varchar(50),
	salario decimal(10,2)
);

create table nomina(
	id serial primary key,
	fecha date,
	total_ingresos decimal(10,2),
	total_deduciones decimal(10,2),
	total_neto decimal(10,2),
	empleado_id integer,
	foreign key (empleado_id) references empleado(id) 
);

create table detalle_nomina(
	id serial primary key,
	concepto varchar(255),
	tipo varchar(50),
	valor decimal(10,2),
	nomina_id integer,
	foreign key (nomina_id) references nomina(id)
);

create table auditoria_nomina (
    id serial primary key,
    fecha date,
    nombre varchar(50),
    identificacion varchar(10),
    total_neto decimal(10, 2)
);

create table auditoria_empleado (
    id serial primary key,
    fecha timestamp default now(), 
    nombre varchar(50),
    identificacion varchar(10),
    concepto varchar(20), -- 'AUMENTO' o 'DISMINUCION'
    valor decimal(10, 2) 
);

insert into empleado (name, identificacion, edad, correo, salario) values 
('Juan Pérez', '1234567890', 35, 'juan.perez@email.com', 3500000),
('Ana López', '0987654321', 28, 'ana.lopez@email.com', 2800000),
('Carlos Méndez', '1122334455', 40, 'carlos.mendez@email.com', 4500000);

insert into nomina (fecha, total_ingresos, total_deduciones, total_neto, empleado_id)
values 
('2024-10-01', 3500000, 500000, 3000000, 1),  -- Para Juan Pérez
('2024-10-05', 2800000, 300000, 2500000, 2),  -- Para Ana López
('2024-10-10', 4500000, 700000, 3800000, 3);  -- Para Carlos Méndez

insert into detalle_nomina (concepto, tipo, valor, nomina_id)
values 
('Salario base', 'Ingreso', 3000000, 1), -- Juan Pérez
('Bonificación', 'Ingreso', 500000, 1), 

('Salario base', 'Ingreso', 2500000, 2), -- Ana López
('Deducción por salud', 'Deducción', 300000, 2),

('Salario base', 'Ingreso', 3800000, 3), -- Carlos Méndez
('Deducción por pensión', 'Deducción', 700000, 3); 


-- Punto 1: Validar que no se sobrepasen los 12.000.000 de nomina en el mes
create or replace function validar_nomina()
returns trigger as
$$
declare 
	total_neto_mes decimal(10,2);
begin 
	
    select sum(n.total_neto)
    into total_neto_mes
    from taller13.nomina n
    where n.empleado_id = new.empleado_id
    and date_part('year', n.fecha) = date_part('year', new.fecha)
    and date_part('month', n.fecha) = date_part('month', new.fecha);

    if (total_neto_mes + new.total_neto) > 12000000 then
        raise exception 'El total neto de la nómina en este mes excede el límite de 12,000,000.';
    end if;

    return new;
end;
$$
language plpgsql;

create trigger trigger_before_insert_nomina
before insert on taller13.nomina
for each row
execute function validar_nomina();


-- Punto 2: Auditoria nomina
create or replace function registrar_auditoria_nomina()
returns trigger as
$$
begin
    insert into auditoria_nomina (fecha, nombre, identificacion, total_neto)
    select now(), e.name, e.identificacion, new.total_neto
    from empleado e
    where e.id = new.empleado_id;

    return new;
end;
$$
language plpgsql;

-- Crear el trigger AFTER INSERT
create trigger trigger_after_insert_nomina
after insert on nomina
for each row
execute function registrar_auditoria_nomina();


-- Punto 3: Validar salario de los empleados
create or replace function validar_salario_empleados()
returns trigger as
$$
declare 
	salario_total_mes decimal(10,2);
begin 
    select sum(e.salario)
    into salario_total_mes
	from taller13.empleado
	where id != new.id;

	salario_total_mes := salario_total_mes + new.salario;

    if salario_total_mes > 12000000 then
        raise exception 'La suma total de los salarios excede el límite de 12.000.000.';
    end if;

    return new;
end;
$$
language plpgsql;

create trigger trigger_before_update_empleado
before update on empleado
for each row
execute function validar_salario_empleados()

-- Punto 4: Auditoria empleado

create or replace function auditoria_empleado()
returns trigger as
$$
declare
    diferencia_salario decimal(10, 2);
    concepto varchar(20);
begin
    
    diferencia_salario := new.salario - old.salario;

    if diferencia_salario > 0 then
        concepto := 'AUMENTO';
    else
        concepto := 'DISMINUCION';
    end if;

    insert into auditoria_empleado (nombre, identificacion, concepto, valor)
    values (new.name, new.identificacion, concepto, abs(diferencia_salario));

    return new;
end;
$$
language plpgsql;

create trigger trigger_after_update_empleado
after update of salario on empleado
for each row
execute function auditoria_empleado();





