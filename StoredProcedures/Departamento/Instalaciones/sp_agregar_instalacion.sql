-- SP AGREGAR INSTALACION
create or replace procedure sp_agregar_instalaciones(
    depto_id in number,
    instalacion_d in varchar,
    success_sp out number
) is
    instalacion_id turismo_real.instalacion.id_instalacion%type;
    departamento_id turismo_real.departamento.id_departamento%type;
begin
    -- comprobar existencia de departamento
    select id_departamento into departamento_id
    from departamento
    where id_departamento = depto_id;

    -- obtener id instalacion
    instalacion_id := fn_obten_id_instalacion(instalacion_d);
    
    -- agregar instalacion si no existe
    if instalacion_id = 0 then
        instalacion_id := fn_agregar_instalacion(instalacion_d);
    end if;
    
    insert into instalacion_departamento(id_instalacion_depto, id_instalacion, id_departamento)
        values(seq_instalacion_departamento.nextval, instalacion_id, depto_id);
    
    success_sp := 1; -- agregado correctamente
    commit;
exception
    when no_data_found then
        success_sp := -1; -- no existe depto
    when others then
        success_sp := 0; -- error al agregar
end;

-- PRUEBA SP
declare
    depto_id turismo_real.departamento.id_departamento%type;
    instalacion_d turismo_real.instalacion.instalacion%type;
    success_sp number;
begin
    depto_id := 4;
    instalacion_d := 'internet';
    sp_agregar_instalaciones(depto_id, instalacion_d, success_sp);
    
    if success_sp = 1 then
        dbms_output.put_line('Instalación agregada.');
    elsif success_sp = -1 then
        dbms_output.put_line('Departamento no existe.');
    else
        dbms_output.put_line('Error al agregar instalación.');
    end if;
end;