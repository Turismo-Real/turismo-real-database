-- SP EDITAR DEPARTAMENTO
create or replace procedure sp_editar_depto(
    depto_id in number,
    rol_d in varchar,
    dormitorios_d in number,
    banios_d in number,
    descripcion_d in varchar,
    superficie_d in number,
    valor_diario_d in number,
    tipo_d in varchar,
    estado_d in varchar,
    comuna_d in varchar,
    calle_d in varchar,
    numero_d in varchar,
    depto_d in varchar,
    updated out number
) is
    tipo_id turismo_real.tipo_departamento.tipo_departamento%type;
    estado_id turismo_real.estado_depto.estado%type;
    comuna_id turismo_real.comuna.comuna%type;
    id_d turismo_real.departamento.id_departamento%type;
begin
    -- comprobar existencia de depto
    select id_departamento into id_d
    from departamento
    where id_departamento = depto_id;
    -- obtener ids
    tipo_id := fn_obten_id_tipo_depto(tipo_d);
    estado_id := fn_obten_id_estado_depto(estado_d);
    comuna_id := fn_obten_id_comuna(comuna_d);

    update departamento
        set rol = rol_d,
            dormitorio = dormitorios_d,
            banios = banios_d,
            descripcion = descripcion_d,
            superficie = superficie_d,
            valor_diario = valor_diario_d,
            id_tipo = tipo_id,
            id_estado = estado_id
        where id_departamento = id_d;
    
    update direccion
        set id_comuna = comuna_id,
            calle = calle_d,
            numero = numero_d,
            depto = depto_d
        where id_departamento = id_d;
        
    commit;
    updated := 1; -- depto actualizado
exception
    when no_data_found then
        updated := -1; -- depto no encontrado
    when others then
        rollback;
        updated := 0; -- error al actualizar
end;

-- PRUEBA SP
declare
    depto_id turismo_real.departamento.id_departamento%type;
    updated number;
begin
    depto_id := 4;
    sp_editar_depto(depto_id,'666-666',3,1,'Ubicado en la orilla de un acantilado',120,120000,'normal','cargado','cabildo','Los acantilados','1243','17C',updated);
    
    if updated = 1 then
        dbms_output.put_line('Departamento actualizado.');
    elsif updated = -1 then
        dbms_output.put_line('Departamento no existe.');
    else
        dbms_output.put_line('Error al actualizar departamento.');
    end if;
end;