create or replace procedure obtener_total_stock()
as $$
declare
	p_total_stock integer := 0;
	p_stock_actual integer;
	p_nombre_producto varchar;
begin 
	for p_nombre_producto, p_stock_actual in select nombre, stock from productos 
	loop 
		raise notice 'El nombre del producto es: %', p_nombre_producto;
		raise notice 'El stock actual del producto es: %', p_stock_actual;
		p_total_stock := p_total_stock + p_stock_actual;
	end loop;
	raise notice 'El stock total es de: %', p_total_stock;
end
$$ language plpgsql; 

call obtener_total_stock();