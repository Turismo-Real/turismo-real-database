-- SP AGREGAR IMAGEN
create or replace procedure sp_agregar_imagen(
    depto_id in number,
    nombre_i in varchar,
    formato_i in varchar,
    imagen_i in blob,
    saved out number
) is 
    imagen_id turismo_real.imagen.id_imagen%type;
    id_d turismo_real.departamento.id_departamento%type;
begin
    -- comprobar existencia de depto
    id_d := fn_obten_depto(depto_id);

    if id_d > 0 then
        imagen_id := seq_imagen.nextval;
        insert into imagen(id_imagen, id_departamento, nombre, formato, imagen)
        values (imagen_id, depto_id, nombre_i, formato_i, imagen_i);
        commit;
        saved := imagen_id; -- IMAGEN GUARDADA
    else
        saved := -1; -- NO EXISTE DEPTO    
    end if;
exception
    when others then saved := 0; -- ERROR
end;