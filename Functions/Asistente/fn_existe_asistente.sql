-- FN EXISTE ASISTENTE
create or replace function fn_existe_asistente(
    pasaporte_a in varchar,
    rut_a in varchar
) return number is
    asistente_id turismo_real.asistente.id_asistente%type;
begin
    select id_asistente into asistente_id
    from asistente
    where pasaporte = pasaporte_a
    or numrut_asistente = rut_a;
    
    return asistente_id; -- RETORNA ID ASISTENTE
exception
    when no_data_found then
        return 0; -- ASISTENTE NO ENCONTRADO
    when others then
        return -1; -- ERROR
end;

-- PRUEBA FN
declare
    pasaporte turismo_real.asistente.pasaporte%type;
    rut turismo_real.asistente.numrut_asistente%type;
    asistente_id turismo_real.asistente.id_asistente%type;
begin
    pasaporte := '';
    rut := '12658987';
    asistente_id := fn_existe_asistente(pasaporte, rut);
    
    if asistente_id > 0 then
     dbms_output.put_line('Asistente existe con id '||asistente_id||'.');
    elsif asistente_id = 0 then
        dbms_output.put_line('Asistente no encontrado.');
    else
        dbms_output.put_line('Error al buscar asistente.');
    end if;
end;