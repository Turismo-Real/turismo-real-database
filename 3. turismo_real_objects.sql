-- ******************************
-- *********** RESET ************
-- ******************************
drop function fn_obten_id_comuna;
drop function fn_obten_id_estado_depto;
drop function fn_obten_id_genero;
drop function fn_obten_id_pais;
drop function fn_obten_id_tipo_depto;
drop function fn_obten_id_tipo_usuario;

drop procedure sp_agregar_usuario;
drop procedure sp_editar_usuario;
drop procedure sp_eliminar_usuario;
drop procedure sp_obten_usuarios;
drop procedure sp_usuario_por_rut;
drop procedure sp_obten_comuna_por_region;
drop procedure sp_obten_regiones;
drop procedure sp_login;
drop procedure sp_agregar_depto;

/

-- ******************************
-- ********* FUNCTIONS **********
-- ******************************

-- FN OBTEN ID COMUNA
create or replace function fn_obten_id_comuna(comuna_c in varchar)
return number is
    comuna_id number;
begin
    select c.id_comuna into comuna_id
    from comuna c
    where upper(c.comuna) = upper(comuna_c);

    return comuna_id;
exception
    when no_data_found then return 0;
    when others then return 0;
end;

/

-- FN OBTEN ID ESTADO DEPTO
create or replace function fn_obten_id_estado_depto(estado_d in varchar)
return number is 
    estado_id integer := 0;
begin
    select e.id_estado into estado_id
    from estado_depto e
    where upper(e.estado) = upper(estado_d);

    return estado_id;
exception
    when no_data_found then return 0;
end;

/

-- FN OBTENER ID GENERO
create or replace function fn_obten_id_genero(genero_in in varchar)
return number is 
    idgenero number := 0;
begin
    select g.id_genero into idgenero
    from genero g
    where upper(g.genero) = upper(genero_in);

    return idgenero; 

exception
    when no_data_found then return 0;
end;

/

-- FN OBTENER ID PAIS
create or replace function fn_obten_id_pais(nombre_pais varchar)
return number is 
    pais_id integer := 0;
begin
    select p.id_pais into pais_id
    from pais p
    where upper(p.pais) = upper(nombre_pais);

    return pais_id;
exception
    when no_data_found then return 0;
end;

/

-- FN OBTEN ID TIPO DEPTO
create or replace function fn_obten_id_tipo_depto(tipo_d in varchar)
return number is 
    tipo_id integer := 0;
begin
    select t.id_tipo into tipo_id
    from tipo_departamento t
    where upper(t.tipo_departamento) = upper(tipo_d);

    return tipo_id;
exception
    when no_data_found then return 0;
end;

/

-- FN OBTENER TIPO USUARIO
create or replace function fn_obten_id_tipo_usuario(tipo_u varchar)
return number is
    tipo_id integer := 0;
begin
    select t.id_tipo into tipo_id
    from tipo_usuario t
    where upper(t.tipo) = upper(tipo_u);

    return tipo_id;
exception
    when no_data_found then return 0;
end;

/

-- ******************************
-- ********* PROCEDURES *********
-- ******************************

---------------------------------
-- ######### USUARIOS ###########
---------------------------------

-- SP AGREGAR USUARIO
create or replace procedure sp_agregar_usuario(
    rut_u in varchar,
    dv_u in varchar,
    pnombre_u in varchar,
    snombre_u in varchar,
    apepat_u in varchar,
    apemat_u in varchar,
    fecnac_u in varchar,
    email_u in varchar,
    telmovil_u in varchar,
    telfijo_u in varchar,
    pass_u in varchar,
    genero_u in varchar,
    pais_u in varchar,
    tipo_u in varchar,
    comuna_u in varchar,
    calle_u in varchar,
    numero_u in varchar,
    depto_u in varchar,
    casa_u in varchar
) is 
    genero_id number;
    pais_id number;
    tipo_id number;
    comuna_id number;
    fecha_nac date;
begin
    genero_id := fn_obten_id_genero(genero_u);
    pais_id := fn_obten_id_pais(pais_u);
    tipo_id := fn_obten_id_tipo_usuario(tipo_u);
    comuna_id := fn_obten_id_comuna(comuna_u);
    fecha_nac := to_date(fecnac_u, 'dd/mm/yyyy');

-- todo: insert exceptions

    insert into usuario(numrut,dvrut,pnombre,snombre,apepat,apemat,fec_nac,correo,telefono_movil,telefono_fijo,password,id_genero,id_pais,id_tipo)
    values(rut_u,dv_u,pnombre_u,snombre_u,apepat_u,apemat_u,fecha_nac,email_u,telmovil_u,telfijo_u,pass_u,genero_id,pais_id,tipo_id);

    insert into direccion(id_direccion,id_departamento,numrut,id_comuna,calle,numero,depto,casa)
    values(seq_direccion.nextval,null,rut_u,comuna_id,calle_u,numero_u,depto_u,casa_u);
    commit;
end;

/

-- SP EDITAR USUARIO
create or replace procedure sp_editar_usuario(
    rut_u in varchar,
    dv_u in varchar,
    pnombre_u in varchar,
    snombre_u in varchar,
    apepat_u in varchar,
    apemat_u in varchar,
    fecnac_u in date,
    email_u in varchar,
    telmovil_u in varchar,
    telfijo_u in varchar,
    pass_u in varchar,
    genero_u in varchar,
    pais_u in varchar,
    tipo_u in varchar,
    comuna_u in varchar,
    calle_u in varchar,
    numero_u in varchar,
    depto_u in varchar,
    casa_u in varchar,
    updated out number
) is
    genero_id number;
    pais_id number;
    tipo_id number;
    comuna_id number;
begin
    genero_id := fn_obten_id_genero(genero_u);
    pais_id := fn_obten_id_pais(pais_u);
    tipo_id := fn_obten_id_tipo_usuario(tipo_u);
    comuna_id := fn_obten_id_comuna(comuna_u);

    update usuario
    	set pnombre = pnombre_u,
        	snombre = snombre_u,
        	apepat = apepat_u,
        	apemat = apemat_u,
        	fec_nac = fecnac_u,
        	correo = email_u,
        	telefono_movil = telmovil_u,
        	telefono_fijo = telfijo_u,
        	password = pass_u,
        	id_genero = genero_id,
        	id_pais = pais_id,
        	id_tipo = tipo_id
        where numrut = rut_u;

    update direccion
        set id_comuna = comuna_id,
            calle = calle_u,
            numero = numero_u,
            depto = depto_u,
            casa = casa_u
        where numrut = rut_u;

    updated := 1;
exception
    when others then
        updated := 0;
end;

/

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

-- SP OBTEN USUARIOS
create or replace procedure sp_obten_usuarios(usuarios out sys_refcursor)
is begin
    open usuarios for
        select numrut, dvrut,
            pnombre, snombre, apepat, apemat,
            fec_nac, correo,
            telefono_movil, telefono_fijo,
            genero, pais, tipo, region, comuna,
            calle, numero, depto, casa
        from usuario join genero using(id_genero)
        join pais using(id_pais)
        join tipo_usuario using(id_tipo)
        join direccion using(numrut)
        join comuna using(id_comuna)
        join region using(id_region);
end;

/

-- SP BUSCAR USUARIO POR RUT
-- retorna datos del usuario si es que encuentra uno
create or replace procedure sp_usuario_por_rut(rut in varchar, cur_user out sys_refcursor)
is begin
    open cur_user for select numrut, dvrut,
        pnombre, snombre, apepat, apemat,
        fec_nac, correo,
        telefono_movil, telefono_fijo,
        genero, pais, tipo, region, comuna,
        calle, numero, depto, casa
    from usuario join genero using(id_genero)
    join pais using(id_pais)
    join tipo_usuario using(id_tipo)
    join direccion using(numrut)
    join comuna using(id_comuna)
    join region using(id_region)
    where numrut = rut;
end;

/

---------------------------------
-- ####### DEPARTAMENTOS ########
---------------------------------

-- SP AGREGAR DEPARTAMENTO
create or replace procedure sp_agregar_depto(
    rol_d in varchar,
    dormitorios_d in number,
    banios_d in number,
    descripcion_d in varchar,
    superficie_d in number,
    valor_diario_d in number,
    tipo_d in varchar,
    comuna_d in varchar,
    calle_d in varchar,
    numero_d in varchar,
    depto_d in varchar,
    saved out number
)
is
    comuna_id number;
    tipo_id number := 0;
    estado_id number;
    depto_id number;
begin
    comuna_id := fn_obten_id_comuna(comuna_d);
    tipo_id := fn_obten_id_tipo_depto(tipo_d);
    -- ESTADO POR DEFECTO
    estado_id := fn_obten_id_estado_depto('Cargado');
    depto_id := seq_departamento.nextval;

    -- INGRESAR DEPARTAMENTO
    insert into departamento(id_departamento,rol,dormitorio,banios,descripcion,superficie,valor_diario,id_tipo,id_estado)
        values(depto_id,rol_d,dormitorios_d,banios_d,descripcion_d,superficie_d,valor_diario_d,tipo_id,estado_id);    
    
    -- INGRESAR DIRECCION
    insert into direccion(id_direccion,id_departamento,numrut,id_comuna,calle,numero,depto)
        values(seq_direccion.nextval,depto_id,null,comuna_id,calle_d,numero_d,depto_d);

    -- RETORNA EL ID DEL DEPARTAMENTO
    saved := depto_id;
    commit;

exception when others then
    saved := 0;
    rollback;
end;

/

---------------------------------
-- ###### COMUNA - REGION #######
---------------------------------

-- SP OBTEN COMUNAS POR REGION
create or replace procedure sp_obten_comuna_por_region(region_in in varchar, comunas out sys_refcursor)
is begin 
    open comunas for select c.comuna
        from comuna c join region r
        using(id_region)
        where upper(r.region) = upper(region_in)
        order by c.comuna;
end;

/

-- SP OBTEN REGIONES
create or replace procedure sp_obten_regiones(regiones out sys_refcursor)
is begin
    open regiones for select r.region
        from region r;
end;

/

-- SP LOGIN
create or replace procedure sp_login(
    email_u in varchar2, 
    pass_u in varchar2, 
    tipo_u out varchar2
) is 
    tipo_usuario varchar2(50) := 'ERROR';
begin
    select 
        tipo into tipo_usuario
    from usuario join tipo_usuario using(id_tipo)
    where upper(correo) = upper(email_u) and upper(password) = upper(pass_u);
    
    tipo_u := tipo_usuario;
exception
    when no_data_found then tipo_u := tipo_usuario;
    when others then tipo_u := tipo_usuario;
end;

/

commit;