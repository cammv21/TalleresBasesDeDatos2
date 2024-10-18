create table libros(
	isbn varchar(13) primary key,
	descripcion xml
);

-- Guardar un libro
create or replace function guardar_libro(p_isbn varchar, p_descripcion xml)
returns void as
$$
declare
	v_titulo varchar;
	v_titulo_existente varchar;
begin   
	 -- Extraer titulo
	select xpath('//titulo/text()', p_descripcion) into v_titulo;
	
	raise notice 'El titulo es: %', v_titulo;
	
	-- Validar ISBN
	if exists (select 1 from libros where isbn = p_isbn) then
        raise exception 'El ISBN ya existe en la tabla.';
    end if;
    
	-- Validar titulo no repetido
	select xpath('//titulo/text()', descripcion)::text
	into v_titulo_existente
	from libros
	where xpath('//titulo/text()', descripcion)::text = v_titulo;

	
	if v_titulo_existente is not null then
		raise exception 'Ya existe un libro con el título "%".', v_titulo;
	end if;
	
    -- Insertar el libro
    insert into libros(isbn, descripcion)
    values (p_isbn, p_descripcion);
end;
$$
language plpgsql;

select guardar_libro(
	'9781233597931', 
    '<libro>
        <titulo>El Principito 3</titulo>
        <autor>Antoine de Saint-Exupéry</autor>
        <anio>1943</anio>
     </libro>');
    
 
-- Actualizar un libro
create or replace procedure actualizar_libro(p_isbn varchar, p_nueva_descripcion xml)
language plpgsql
as
$$
declare
    v_titulo varchar;
begin
    -- Validar si el ISBN existe
    if not exists (select 1 from libros where isbn = p_isbn) then
        raise exception 'El ISBN no existe en la tabla.';
    end if;

    -- Extraer nuevo título y mostrarlo en el log
    select xpath('//titulo/text()', p_nueva_descripcion)::text into v_titulo;
    
    raise notice 'El nuevo título es: %', v_titulo;

    -- Actualizar el libro
    update libros
    set descripcion = p_nueva_descripcion
    where isbn = p_isbn;
    
    raise notice 'Libro con ISBN % ha sido actualizado.', p_isbn;
end;
$$;

call actualizar_libro(
    '9781234597832', 
    '<libro>
        <titulo>El Principito 3 - Edición actualizada</titulo>
        <autor>Camilo Valencia</autor>
        <año>1943</año>
     </libro>');


-- Obtener el autor del libro por ISBN
create or replace function obtener_autor_libro_por_isbn(p_isbn varchar)
returns varchar as
$$
declare
    v_autor varchar;
begin
    -- Validar si el ISBN existe
    if not exists (select 1 from libros where isbn = p_isbn) then
        raise exception 'El ISBN no existe en la tabla.';
    end if;
    
    -- Extraer el autor del libro desde la descripción XML
    select xpath('//autor/text()', descripcion)::text into v_autor
    from libros
    where isbn = p_isbn;
    
    -- Retornar el autor
    return v_autor;
end;
$$
language plpgsql;

select obtener_autor_libro_por_isbn('9781234597832');


-- Obtener autor del libro por titulo
create or replace function obtener_autor_libro_por_titulo(p_titulo varchar)
returns varchar as
$$
declare
    v_autor varchar;
    v_titulo text[];
begin
    -- Extraer el título para comparar correctamente
    select xpath('//titulo/text()', descripcion)::text[] into v_titulo
    from libros;

    -- Verificar si existe un libro con ese título
    if not exists (
        select 1 
        from libros 
        where array_to_string(xpath('//titulo/text()', descripcion)::text[], '') = p_titulo
    ) then
        raise exception 'No se encontró un libro con el título especificado.';
    end if;

    -- Extraer el autor si el libro con el título existe
    select array_to_string(xpath('//autor/text()', descripcion)::text[], '') into v_autor
    from libros
    where array_to_string(xpath('//titulo/text()', descripcion)::text[], '') = p_titulo;

    -- Retornar el autor
    return v_autor;
end;
$$
language plpgsql;



select obtener_autor_libro_por_titulo('El Principito 3 - Edición actualizada');


-- Obtener libros por año de creación
create or replace function obtener_libros_por_anio(p_anio varchar)
returns table(isbn varchar, titulo varchar, autor varchar) as
$$
begin
    -- Retornar los libros que coincidan con el año proporcionado en la descripción XML
    return query
    select 
        l.isbn, 
        (xpath('//titulo/text()', descripcion))[1]::varchar as titulo,  -- Extraer el primer valor y convertirlo a varchar
        (xpath('//autor/text()', descripcion))[1]::varchar as autor      -- Extraer el primer valor y convertirlo a varchar
    from libros as l
    where (xpath('//año/text()', descripcion))[1]::varchar = p_anio;    -- Comparar el año extraído convertido a varchar
end;
$$
language plpgsql;

select * from obtener_libros_por_anio('1967');

-- Insertar un libro de un año diferente
select guardar_libro(
    '9789876543210', 
    '<libro>
        <titulo>Cien Años de Soledad</titulo>
        <autor>Gabriel García Márquez</autor>
        <año>1967</año>
     </libro>');


