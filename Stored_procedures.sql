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

-- SP LOGIN
--  true cuando la combinación correo y password existe
--  false cuando la combinación no existe
create or replace procedure sp_login(email in varchar, pass in varchar, login out boolean)
is
    cantidad number := 0;
begin
    select count(*) into cantidad
    from usuario u
    where u.correo = email and u.password = pass;

    if cantidad = 0 then
        login := false;
    else 
        login := true;
    end if;
end;

/

-- SP AGREGAR USUARIO
create or replace procedure sp_agregar_usuario(
    rut in varchar, dv in varchar, pnombre in varchar, snombre in varchar,
    apepat in varchar, apemat in varchar, fecnac in date, email in varchar,
    telmovil in varchar, telfijo in varchar, pass in varchar,
    genero in varchar, pais in varchar, tipo in varchar
) is 
    id_genero integer;
    id_pais integer;
    id_tipo integer;
begin
    id_genero := fn_obten_id_genero(genero);
    id_pais := fn_obten_id_pais(pais);
    id_tipo := fn_obten_id_tipo(tipo);

    


end;

/

-- SP BUSCAR USUARIO POR RUT

-- SP BUSCAR USUARIO POR TIPO

-- SP EDITAR USUARIO

-- SP ELIMINAR USUARIO

-- SP OBTEN REGIONES
create or replace procedure sp_obten_regiones(regiones out cursor)
is begin

end;


-- SP OBTEN COMUNAS POR REGION
create or replace procedure sp_obten_comuna_por_region(region in varchar, comunas out cursor)
is begin 

end;