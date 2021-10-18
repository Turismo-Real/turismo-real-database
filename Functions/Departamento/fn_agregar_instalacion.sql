-- FN AGREGAR INSTALACION
create or replace function fn_agregar_instalacion(instalacion in varchar)
return number
is
    instalacion_id turismo_real.instalacion.id_instalacion%type;
begin
    instalacion_id := seq_instalacion.nextval;

    insert into instalacion(id_instalacion, instalacion)
        values(instalacion_id, initcap(instalacion));
    commit;
    return instalacion_id;
exception
    when others then
        instalacion_id := 0;
end;

-- PRUEBA FN
declare
    instalacion_id turismo_real.instalacion.id_instalacion%type;
    instalacion turismo_real.instalacion.instalacion%type;
begin
    instalacion := 'jacuzzi';
    instalacion_id := fn_agregar_instalacion(instalacion);
    
    if instalacion_id = 0 then
        dbms_output.put_line('Error al agregar instalación.');
    else
        dbms_output.put_line('Instalación agregada: '||instalacion_id);
    end if;
end;