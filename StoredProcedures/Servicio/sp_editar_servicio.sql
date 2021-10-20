-- SP EDITAR SERVICIO
create or replace procedure sp_editar_servicio(
    servicio_id in number,
    nombre_s in varchar,
    descripcion_s in varchar,
    valor_s in number,
    tipo_s in varchar,
    updated out number
) is
    id_s turismo_real.servicio.id_servicio%type;
    tipo_id turismo_real.tipo_servicio.id_tipo_servicio%type;
begin
    -- comprobar existencia de servicio
    select id_servicio into id_s
    from servicio
    where id_servicio = servicio_id;

    -- obtener id tipo servicio
    tipo_id := fn_obten_id_tipo_servicio(tipo_s);
    
    if tipo_id > 0 then -- tipo existe
        update servicio
            set nombre_servicio = nombre_s,
                descripcion = descripcion_s,
                valor = valor_s,
                id_tipo_servicio = tipo_id
            where id_servicio = servicio_id;
        commit;
        updated := 1;
    else
        updated := -2; -- no existe tipo servicio
    end if;
exception
    when no_data_found then
        updated := -1; -- no existe id servicio
    when others then
        updated := 0; -- error al editar
end;

-- PRUEBA SP
declare
    id_s turismo_real.servicio.id_servicio%type;
    updated number;
begin
    id_s := 5;
    sp_editar_servicio(id_s,'Paseo de personas','Servicio de paseo de personas como mascotas',30000,'tOUR',updated);
    
    if updated = 1 then
        dbms_output.put_line('Servicio editado.');
    elsif updated = -2 then
        dbms_output.put_line('No existe el tipo de servicio.');
    elsif updated = -1 then
        dbms_output.put_line('No existe el servicio con id'||id_s||'.');
    else
        dbms_output.put_line('Error al editar servicio');
    end if;
end;