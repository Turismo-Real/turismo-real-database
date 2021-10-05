-- SP ELIMINAR USUARIO
create or replace procedure sp_eliminar_usuario(rut_u in varchar, removed out number)
is 
    user_c number;
begin
    select count(*) into user_c
    from usuario
    where numrut = rut_u;

    if user_c = 0 then
        removed := 0;
    else
        delete from usuario
        where numrut = rut_u;
        removed := 1;
        commit;
    end if;
exception
    when others then
        removed := 0;
end;

/

declare
    rut varchar2(8);
    removed number;
begin
    rut := '15624578';
    removed := 0;
    sp_eliminar_usuario(rut, removed);
    
    if removed = 1 then
        dbms_output.put_line('Usuario Eliminado.');
    else
        dbms_output.put_line('Error al eliminar usuasrio');
    end if;
end;