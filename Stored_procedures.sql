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
end;

/

-- SP BUSCAR USUARIO POR TIPO

-- SP OBTEN REGIONES
create or replace procedure sp_obten_regiones(regiones out cursor)
is begin

end;


-- SP OBTEN COMUNAS POR REGION
create or replace procedure sp_obten_comuna_por_region(region in varchar, comunas out cursor)
is begin 

end;