-- FN OBTEN ID ESTADO DEPTO
create or replace function fn_obten_id_estado_depto(estado_d in varchar)
return number is 
    estado_id integer := 0;
begin
    select e.id_estado into estado_id
    from estado_depto e
    where upper(e.estado) = upper(estado_d);

    return estado_id;
exception
    when no_data_found then return 0;
end;

-- PRUEBA FN
declare
    estado_id integer;
    estado turismo_real.estado_depto.estado%type;
begin
    estado := 'mantención';
    estado_id := fn_obten_estado_depto(estado);
    dbms_output.put_line('ID ESTADO ('||estado||'): '||estado_id);
end;