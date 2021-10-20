-- SP AGREGAR SERVICIO
create or replace procedure sp_agregar_servicio(
    nombre_s in varchar,
    descripcion_s in varchar,
    valor_s in number,
    tipo_s in varchar,
    saved out number
) is
    id_s turismo_real.servicio.id_servicio%type;
    tipo_id turismo_real.tipo_servicio.id_tipo_servicio%type;
begin
    tipo_id := fn_obten_id_tipo_servicio(tipo_s);
    id_s := seq_tipo_servicio.nextval;
    
    if tipo_id > 0 then
        insert into servicio(id_servicio,nombre_servicio,descripcion,valor,id_tipo_servicio)
            values(id_s,nombre_s,descripcion_s,valor_s,tipo_id);
        commit;
        saved := id_s; -- servicio agregado
    else
        saved := -1; -- no existe tipo servicio
    end if;
exception
    when others then
        saved := 0; -- error al agregar
end;

-- PRUEBA SP
declare
    saved number;
begin
    sp_agregar_servicio('Paseo de mascotas','Servicio para el paseo de las mascotas',20000,'comida',saved);
    
    if saved > 0 then
        dbms_output.put_line('Servicio agregado con id '||saved||'.');
    elsif saved = -1 then
        dbms_output.put_line('No existe el tipo de servicio.');
    else
        dbms_output.put_line('Error al agregar servicio.');
    end if;
end;