create table clientes (
    id serial primary key,
    nombre varchar(30) ,
    identificacion varchar(10) unique,
    email varchar(30),
    direccion varchar(30),
    telefono varchar(30)
);


create table servicios (
    id serial primary key,
    codigo varchar(10) unique,
    tipo varchar(30),
    monto decimal(10, 2),
    cuota integer,
    intereses decimal(10, 2),
    valor_total decimal(10, 2),
    cliente_id integer,
    foreign key (cliente_id) references clientes(id)
);

create table pagos (
    id serial primary key,
    codigo varchar(50) unique,
    transaccion varchar(10),
    fecha date,
    pago decimal(10, 2),
    total decimal(10, 2),
    estado varchar(50),
    servicio_id integer,
    cliente_id integer,
    foreign key (servicio_id) references servicios(id),
    foreign key (cliente_id) references clientes(id)
);


-- Poblar tabla clientes
create or replace procedure poblar_clientes()
language plpgsql
as 
$$
declare
    i integer;
begin
    for i in 1..50 loop
        insert into clientes(nombre, identificacion, email, direccion, telefono)
        values (
            concat('Cliente_', i), 
            concat('ID_', i),
            concat('cliente', i , '@ejemplo.com'),
            concat('Dirección_', i),
            concat('555-1234-', i)
        );
    end loop;
end;
$$;

call poblar_clientes(); 


-- Poblar tabla servicios
create or replace procedure poblar_servicios()
language plpgsql
as $$
declare 
    cliente_id integer;
    tipo_servicio varchar;
    servicio_codigo varchar;
    monto decimal;
	intereses decimal;
    i integer := 1; -- Contador general de todos los servicios
	j integer; -- Auxiliar para el for anidado
begin
    for cliente_id in 1..50 loop  
        for j in 1..3 loop
            servicio_codigo := CONCAT('SVC_', i);
			case j
                when 1 then tipo_servicio := 'agua';
                when 2 then tipo_servicio := 'luz';
                when 3 then tipo_servicio := 'gas';
            end case;

            case tipo_servicio
                when 'agua' then monto := 50;
                when 'luz' then monto := 100;
                when 'gas' then monto := 75;
            end case;
			
			intereses := monto * 0.1;
            insert into servicios(codigo, tipo, monto, cuota, intereses, valor_total, cliente_id)
            values (
                servicio_codigo, 
                tipo_servicio, 
                monto, 
                12,
                intereses,
				monto + intereses, 
                cliente_id 
            );
            i := i + 1;
        end loop;
    end loop;
end;
$$;

call poblar_servicios();


-- Poblar tabla pagos
create or replace procedure poblar_pagos()
language plpgsql
as $$
declare 
    servicio_id integer;
    p_cliente_id integer;
	valor_pago decimal;
	fecha_pago date;
    pago_codigo varchar;
    transaccion_codigo varchar;
    pago decimal;
    total decimal;
    estado varchar;
    i integer := 1; -- Contador general para todos los pagos
begin
    for servicio_id, p_cliente_id, valor_pago in 
        (select id, cliente_id, valor_total from servicios limit 75) 
    loop
        pago_codigo := concat('PAGO_', i);
        transaccion_codigo := concat('TRANS_', i);
        
        pago := (30 + i * 1.3);
		
		-- 10% interés
        total := pago * 1.1;   

        -- Generar una fecha aleatoria dentro del año actual
        fecha_pago := make_date(
            extract(year from current_date)::int,  -- Año actual
            (floor(random() * 12) + 1)::int,       -- Mes aleatorio entre 1 y 12
            (floor(random() * 28) + 1)::int        -- Día aleatorio entre 1 y 28
        );
        
        
        if i % 3 = 0 then
            estado := 'pago';
        elsif i % 3 = 1 then
            estado := 'no_pago';
        else
            estado := 'pendiente';
        end if;
        
        insert into pagos (codigo, transaccion, fecha, pago, total, estado, servicio_id, cliente_id)
        values (
            pago_codigo,
            transaccion_codigo,
            fecha_pago,  
            pago,
            total,
            estado,
            servicio_id,
            p_cliente_id
        );
        
        i := i + 1;
    end loop;
end;
$$;

call poblar_pagos();

-- Función para obtener el pago total de un cliente en un mes
create or replace function transacciones_total_mes(mes integer, identificacion_cliente varchar)
returns decimal
language plpgsql
as $$
declare
    total_pagos decimal := 0; 
begin

    select coalesce(sum(p.pago), 0)  -- Si no hay pagos, devolver 0
    into total_pagos
    from pagos p
    join clientes c on p.cliente_id = c.id
    where extract(month from p.fecha) = mes  
    and c.identificacion = identificacion_cliente
    and p.estado = 'pago';  -- Solo considerar los pagos completados

    return total_pagos;
end;
$$;

insert into pagos (codigo, transaccion, fecha, pago, total, estado, servicio_id, cliente_id)
        values (
            'PAGO_76',
            'TRANS_76',
            '2024-07-16',  
            70,
            75,
            'pago',
          	76,
            1
        );

select transacciones_total_mes(7,'ID_1');


