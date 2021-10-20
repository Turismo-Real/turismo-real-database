-- FN OBTEN ID TIPO SERVICIO
create or replace function fn_obten_id_tipo_servicio(tipo in varchar)
return number
is
    servicio_id turismo_real.tipo_servicio.id_tipo_servicio%type;
begin
    select id_tipo_servicio into servicio_id
    from tipo_servicio
    where upper(tipo_servicio) = upper(tipo);
    return servicio_id;
exception
    when no_data_found then
        servicio_id := 0;
        return servicio_id;
    when others then
        servicio_id := 0;
        return servicio_id;
end;

-- PRUEBA FN
declare
    tipo turismo_real.tipo_servicio.tipo_servicio%type;
    servicio_id turismo_real.tipo_servicio.id_tipo_servicio%type;
begin
    tipo := 'tour';
    servicio_id := fn_obten_id_tipo_servicio(tipo);
    
    if servicio_id > 0 then
        dbms_output.put_line('ID Servicio: '||servicio_id);
    else
        dbms_output.put_line('Servicio no encontrado.');
    end if;
end;