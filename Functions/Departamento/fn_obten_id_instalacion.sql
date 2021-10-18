-- FN OBTEN ID INSTALACION
create or replace function fn_obten_id_instalacion(instalacion_d in varchar)
return number
is
    instalacion_id number := 0;
begin
    select id_instalacion into instalacion_id
    from instalacion
    where upper(instalacion) = upper(instalacion_d);
    
    return instalacion_id;
exception
    when no_data_found then
        return instalacion_id;
    when others then
        return instalacion_id;
end;

-- PRUEBA FN
declare
    instalacion turismo_real.instalacion.instalacion%type;
    id_instalacion turismo_real.instalacion.id_instalacion%type;
begin
    instalacion := 'calefaccion';
    id_instalacion := fn_obten_id_instalacion(instalacion);
    
    if id_instalacion = 0 then
        dbms_output.put_line('Instalación no existe.');
    else
        dbms_output.put_line('ID instalación: '||id_instalacion);
    end if;
end;