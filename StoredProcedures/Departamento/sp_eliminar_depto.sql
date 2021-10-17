-- SP ELIMINAR DEPARTAMENTO
create or replace procedure sp_eliminar_depto(depto_id in number, removed out number)
is 
    id_d number;
begin
    -- comprobar existencia de depto
    select id_departamento into id_d
    from departamento
    where id_departamento = depto_id;

    delete from departamento
    where id_departamento = depto_id;
    
    commit;
    removed := 1; -- depto eliminado
exception
    when no_data_found then
        removed := -1; -- no existe depto
    when others then
        removed := 0; -- error al eliminar
end;

-- PRUEBA SP
declare
    depto_id turismo_real.departamento.id_departamento%type;
    removed number;
begin
    depto_id := 7;
    sp_eliminar_depto(depto_id, removed);
    
    if removed = 1 then
        dbms_output.put_line('Departamento eliminado.');
    elsif removed = -1 then
        dbms_output.put_line('Departamento no existe.');
    else
        dbms_output.put_line('Error al eliminar departamento.');
    end if;
end;