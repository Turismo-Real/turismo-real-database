-- SP ELIMINAR IMAGEN
create or replace procedure sp_eliminar_imagen_depto(
    imagen_id in number,
    deleted out number
) is
    existe_imagen number;
begin
    -- comprobar existencia de imagen
    select count(*) into existe_imagen
    from imagen where id_imagen = imagen_id;

    if existe_imagen > 0 then
        delete from imagen
        where id_imagen = imagen_id;
        commit;
        deleted := 1; -- IMAGEN ELIMINADA
    else
        deleted := -1; -- NO EXISTE IMAGEN
    end if;
exception
    when others then deleted := 0; -- ERROR
end;

-- PRUEBA SP
declare
    imagen_id turismo_real.imagen.id_imagen%type;
    deleted number;
begin
    imagen_id := 13;
    sp_eliminar_imagen_depto(imagen_id, deleted);
    
    if deleted = 1 then
        dbms_output.put_line('Imagen eliminada.');
    elsif deleted = -1 then
        dbms_output.put_line('No existe la imagen con id '||imagen_id||'.');
    else
        dbms_output.put_line('Error al eliminar imagen.');
    end if;
end;