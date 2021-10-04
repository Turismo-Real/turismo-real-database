-- SP VALIDA CORREO
--  true cuando el correo existe
--  false cuando no existe
create or replace procedure sp_existe_correo(email in varchar, existe out boolean)
is 
    cantidad number := 0;
begin
    select count(correo) into cantidad
    from usuario
    where correo = email;

    if cantidad = 0 then
        existe := false;
    else
        existe := true;
    end if;
exception
    when no_data_found then existe := false;
    when others then existe := false;
end;


-- SP BUSCAR USUARIO POR TIPO
