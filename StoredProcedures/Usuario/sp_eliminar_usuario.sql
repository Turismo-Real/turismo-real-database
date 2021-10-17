-- SP ELIMINAR USUARIO
create or replace procedure sp_eliminar_usuario(usuario_id in number, removed out number)
is begin
    delete from usuario
    where id_usuario = usuario_id;

    commit;
    removed := 1;
exception
    when no_data_found then
        rollback;
        removed := 0;
    when others then
        rollback;
        removed := 0;
end;

/

-- PRUEBA SP
declare
    usuario_id number;
    removed number;
begin
    usuario_id := 8;
    
    sp_eliminar_usuario(usuario_id, removed);
    
    if removed = 1 then
        dbms_output.put_line('Usuario Eliminado.');
    else
        dbms_output.put_line('Error al eliminar usuasrio');
    end if;
end;