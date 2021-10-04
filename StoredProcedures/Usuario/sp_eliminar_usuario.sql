-- SP ELIMINAR USUARIO
create or replace procedure sp_eliminar_usuario(rut_u in varchar, removed out boolean)
is begin
    delete from usuario
    where numrut = rut_u;

    removed := true;
exception
    when others then
        dbms_output.put_line('Se deben eliminar los registros de las tablas dependientes');
        removed := false;
end;

/
-- todo: se deben eliminar registros de tablas dependientes

declare
    rut varchar2(8);
    removed boolean;
begin
    rut := '15624578';
    removed := false;
    sp_eliminar_usuario(rut, removed);
    
    if removed = true then
        dbms_output.put_line('Usuario Eliminado.');
    else
        dbms_output.put_line('Error al eliminar usuasrio');
    end if;
end;