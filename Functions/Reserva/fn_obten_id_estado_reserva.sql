-- FN OBTEN ESTADO RESERVA
create or replace function fn_obten_id_estado_reserva(estado_r in varchar)
return number is
    estado_id turismo_real.estado_reserva.estado%type;
begin
    select id_estado into estado_id
    from estado_reserva
    where upper(estado) = upper(estado_r);

    return estado_id;
exception
    when no_data_found then
        return 0;
    when others then
        return 0;
end;

-- PRUEBA FN
declare
    estado turismo_real.estado_reserva.estado%type;
    estado_id turismo_real.estado_reserva.id_estado%type;
begin
    estado := 'cargada';
    estado_id := fn_obten_id_estado_reserva(estado);
    
    dbms_output.put_line('ID estado: '||estado_id);
end;