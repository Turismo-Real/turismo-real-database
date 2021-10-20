-- SP ELIMINAR SERVICIO
create or replace procedure sp_eliminar_servicio(servicio_id in number, removed out number)
is
    id_s turismo_real.servicio.id_servicio%type;
begin
    -- comprobar existencia de servicio
    select id_servicio into id_s
    from servicio
    where id_servicio = servicio_id;
    -- eliminar
    delete from servicio
    where id_servicio = servicio_id;
    commit;
    removed := 1; -- servicio eliminado
exception
    when no_data_found then
        removed := -1; -- no existe id servicio
    when others then
        removed := 0; -- error al eliminar
end;

-- PRUEBA SP
declare
    id_s turismo_real.servicio.id_servicio%type;
    removed number;
begin
    id_s := 6;
    sp_eliminar_servicio(id_s, removed);
    
    if removed = 1 then
        dbms_output.put_line('Servicio eliminado.');
    elsif removed = -1 then
        dbms_output.put_line('No existe servicio con id '||id_s||'.');
    else
        dbms_output.put_line('Error al eliminar servicio.');
    end if;
end;