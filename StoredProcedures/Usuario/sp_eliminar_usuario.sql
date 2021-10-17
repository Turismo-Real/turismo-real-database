-- SP ELIMINAR USUARIO
create or replace procedure sp_eliminar_usuario(usuario_id in number, removed out number)
is
    verify_id number;
begin
    select id_usuario into verify_id
    from usuario
    where id_usuario = usuario_id;

    delete from usuario
    where id_usuario = verify_id;

    commit;
    removed := 1; -- ELIMINADO
exception
    when no_data_found then
        removed := -1; -- NO EXISTE USUARIO
    when others then
        removed := 0; -- ERROR AL ELIMINAR
end;

/

-- PRUEBA SP
declare
    usuario_id number;
    removed number;
begin
    usuario_id := 50;
    
    sp_eliminar_usuario(usuario_id, removed);
    dbms_output.put_line(removed);
    if removed = 1 then
        dbms_output.put_line('Usuario Eliminado.');
    else
        dbms_output.put_line('Error al eliminar usuario');
    end if;
end;