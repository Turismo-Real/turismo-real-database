-- ******************************
-- *********** RESET ************
-- ******************************
drop function fn_obten_id_comuna;
drop function fn_obten_id_estado_depto;
drop function fn_obten_id_genero;
drop function fn_obten_id_pais;
drop function fn_obten_id_tipo_depto;
drop function fn_obten_id_tipo_usuario;
drop function fn_obten_id_instalacion;
drop function fn_agregar_instalacion;
drop function fn_obten_id_tipo_servicio;

drop procedure sp_agregar_usuario;
drop procedure sp_editar_usuario;
drop procedure sp_eliminar_usuario;
drop procedure sp_obten_usuarios;
drop procedure sp_usuario_por_id;
drop procedure sp_obten_comuna_por_region;
drop procedure sp_obten_regiones;
drop procedure sp_login;
drop procedure sp_agregar_depto;
drop procedure sp_obten_deptos;
drop procedure sp_obten_depto_por_id;
drop procedure sp_editar_depto;
drop procedure sp_eliminar_depto;
drop procedure sp_agregar_instalaciones;
drop procedure sp_obten_instalaciones;
drop procedure sp_eliminar_instalaciones;
drop procedure sp_agregar_servicio;
drop procedure sp_editar_servicio;
drop procedure sp_eliminar_servicio;
drop procedure sp_obten_servicio_id;
drop procedure sp_obten_servicios;
drop procedure sp_obten_paises;
drop procedure sp_obten_reservas;

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

-- FN OBTEN ID INSTALACION
create or replace function fn_obten_id_instalacion(instalacion_d in varchar)
return number
is
    instalacion_id number := 0;
begin
    select id_instalacion into instalacion_id
    from instalacion
    where upper(instalacion) = upper(instalacion_d);
    
    return instalacion_id;
exception
    when no_data_found then
        return instalacion_id;
    when others then
        return instalacion_id;
end;

/

create or replace function fn_agregar_instalacion(instalacion in varchar)
return number
is
    instalacion_id turismo_real.instalacion.id_instalacion%type;
begin
    instalacion_id := seq_instalacion.nextval;

    insert into instalacion(id_instalacion, instalacion)
        values(instalacion_id, initcap(instalacion));
    commit;
    return instalacion_id;
exception
    when others then
        instalacion_id := 0;
end;

/

-- FN OBTEN ID TIPO SERVICIO
create or replace function fn_obten_id_tipo_servicio(tipo in varchar)
return number
is
    servicio_id turismo_real.tipo_servicio.id_tipo_servicio%type;
begin
    select id_tipo_servicio into servicio_id
    from tipo_servicio
    where upper(tipo_servicio) = upper(tipo);
    return servicio_id;
exception
    when no_data_found then
        servicio_id := 0;
        return servicio_id;
    when others then
        servicio_id := 0;
        return servicio_id;
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
    pasaporte_u in varchar,
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
    casa_u in varchar,
    ok out number -- retorna id de usuario
) is 
    genero_id number;
    pais_id number;
    tipo_id number;
    comuna_id number;
    fecha_nac date;
    usuario_id number;
begin
    genero_id := fn_obten_id_genero(genero_u);
    pais_id := fn_obten_id_pais(pais_u);
    tipo_id := fn_obten_id_tipo_usuario(tipo_u);
    comuna_id := fn_obten_id_comuna(comuna_u);
    fecha_nac := to_date(fecnac_u, 'dd/mm/yyyy');
    usuario_id := seq_usuario.nextval;

    insert into usuario(id_usuario,pasaporte,numrut,dvrut,pnombre,snombre,apepat,apemat,fec_nac,correo,telefono_movil,telefono_fijo,password,id_genero,id_pais,id_tipo)
    values(usuario_id,pasaporte_u,rut_u,dv_u,pnombre_u,snombre_u,apepat_u,apemat_u,fecha_nac,email_u,telmovil_u,telfijo_u,pass_u,genero_id,pais_id,tipo_id);

    insert into direccion(id_direccion,id_departamento,id_usuario,id_comuna,calle,numero,depto,casa)
    values(seq_direccion.nextval,null,usuario_id,comuna_id,calle_u,numero_u,depto_u,casa_u);
    commit;
    ok := usuario_id;
exception
    when others then
    rollback;
    ok := 0;
end;

/

-- SP EDITAR USUARIO
create or replace procedure sp_editar_usuario(
    usuario_id in number,
    pasaporte_u in varchar,
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
    genero_u in varchar,
    pais_u in varchar,
    tipo_u in varchar,
    comuna_u in varchar,
    calle_u in varchar,
    numero_u in varchar,
    depto_u in varchar,
    casa_u in varchar,
    updated out number -- retorna el id del usuario
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

    update usuario
    	set pasaporte = pasaporte_u,
            numrut = rut_u,
            dvrut = dv_u,
            pnombre = pnombre_u,
        	snombre = snombre_u,
        	apepat = apepat_u,
        	apemat = apemat_u,
        	fec_nac = fecha_nac,
        	correo = email_u,
        	telefono_movil = telmovil_u,
        	telefono_fijo = telfijo_u,
        	id_genero = genero_id,
        	id_pais = pais_id,
        	id_tipo = tipo_id
        where id_usuario = usuario_id;

    update direccion
        set id_comuna = comuna_id,
            calle = calle_u,
            numero = numero_u,
            depto = depto_u,
            casa = casa_u
        where id_usuario = usuario_id;

    commit;
    updated := usuario_id;
exception
    when others then
        updated := 0;
end;

/

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

-- SP OBTEN USUARIOS
create or replace procedure sp_obten_usuarios(usuarios out sys_refcursor)
is begin
    open usuarios for
        select id_usuario, pasaporte, numrut, dvrut,
            pnombre, snombre, apepat, apemat,
            fec_nac, correo,
            telefono_movil, telefono_fijo,
            genero, pais, tipo, region, comuna,
            calle, numero, depto, casa
        from usuario join genero using(id_genero)
        join pais using(id_pais)
        join tipo_usuario using(id_tipo)
        join direccion using(id_usuario)
        join comuna using(id_comuna)
        join region using(id_region)
        order by id_usuario;
end;

/

-- SP BUSCAR USUARIO POR ID
create or replace procedure sp_usuario_por_id(usuario_id in number, cur_user out sys_refcursor)
is begin
    open cur_user for 
        select
            id_usuario, pasaporte, numrut, dvrut,
            pnombre, snombre, apepat, apemat,
            fec_nac, correo,
            telefono_movil, telefono_fijo,
            genero, pais, tipo, region, comuna,
            calle, numero, depto, casa
        from usuario join genero using(id_genero)
        join pais using(id_pais)
        join tipo_usuario using(id_tipo)
        join direccion using(id_usuario)
        join comuna using(id_comuna)
        join region using(id_region)
        where id_usuario = usuario_id;
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
    insert into direccion(id_direccion,id_departamento,id_comuna,calle,numero,depto)
        values(seq_direccion.nextval,depto_id,comuna_id,calle_d,numero_d,depto_d);

    -- RETORNA EL ID DEL DEPARTAMENTO
    saved := depto_id;
    commit;

exception when others then
    saved := 0;
    rollback;
end;

/

-- SP OBTEN DEPARTAMENTOS
create or replace procedure sp_obten_deptos(deptos out sys_refcursor)
is begin
    open deptos for
        select
            id_departamento, rol, dormitorio, banios, descripcion,
            superficie, valor_diario, tipo_departamento, estado,
            region, comuna, calle, numero, depto
        from departamento join direccion using(id_departamento)
        join comuna using(id_comuna)
        join region using(id_region)
        join tipo_departamento using(id_tipo)
        join estado_depto using(id_estado)
        order by id_departamento;
end;

/

-- SP OBTEN DEPTO POR ID
create or replace procedure sp_obten_depto_por_id(depto_id in number, depto out sys_refcursor)
is begin
    open depto for
        select
            id_departamento, rol, dormitorio, banios, descripcion,
            superficie, valor_diario, tipo_departamento, estado,
            region, comuna, calle, numero, depto
        from departamento join direccion using(id_departamento)
        join comuna using(id_comuna)
        join region using(id_region)
        join tipo_departamento using(id_tipo)
        join estado_depto using(id_estado)
        where id_departamento = depto_id;
end;

/

-- SP EDITAR DEPARTAMENTO
create or replace procedure sp_editar_depto(
    depto_id in number,
    rol_d in varchar,
    dormitorios_d in number,
    banios_d in number,
    descripcion_d in varchar,
    superficie_d in number,
    valor_diario_d in number,
    tipo_d in varchar,
    estado_d in varchar,
    comuna_d in varchar,
    calle_d in varchar,
    numero_d in varchar,
    depto_d in varchar,
    updated out number
) is
    tipo_id turismo_real.tipo_departamento.tipo_departamento%type;
    estado_id turismo_real.estado_depto.estado%type;
    comuna_id turismo_real.comuna.comuna%type;
    id_d turismo_real.departamento.id_departamento%type;
begin
    -- comprobar existencia de depto
    select id_departamento into id_d
    from departamento
    where id_departamento = depto_id;
    -- obtener ids
    tipo_id := fn_obten_id_tipo_depto(tipo_d);
    estado_id := fn_obten_id_estado_depto(estado_d);
    comuna_id := fn_obten_id_comuna(comuna_d);

    update departamento
        set rol = rol_d,
            dormitorio = dormitorios_d,
            banios = banios_d,
            descripcion = descripcion_d,
            superficie = superficie_d,
            valor_diario = valor_diario_d,
            id_tipo = tipo_id,
            id_estado = estado_id
        where id_departamento = id_d;
    
    update direccion
        set id_comuna = comuna_id,
            calle = calle_d,
            numero = numero_d,
            depto = depto_d
        where id_departamento = id_d;
        
    commit;
    updated := 1; -- depto actualizado
exception
    when no_data_found then
        updated := -1; -- depto no encontrado
    when others then
        rollback;
        updated := 0; -- error al actualizar
end;

/

-- SP ELIMINAR DEPARTAMENTO
create or replace procedure sp_eliminar_depto(depto_id in number, removed out number)
is 
    id_d number;
begin
    -- comprobar existencia de depto
    select id_departamento into id_d
    from departamento
    where id_departamento = depto_id;

    delete from departamento
    where id_departamento = depto_id;
    
    commit;
    removed := 1; -- depto eliminado
exception
    when no_data_found then
        removed := -1; -- no existe depto
    when others then
        removed := 0; -- error al eliminar
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
    open regiones for select region from region;
end;

/

-- SP OBTEN PAISES
create or replace procedure sp_obten_paises(paises out sys_refcursor)
is begin
    open paises for select pais from pais;
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

-- SP AGREGAR INSTALACION
create or replace procedure sp_agregar_instalaciones(
    depto_id in number,
    instalacion_d in varchar,
    success_sp out number
) is
    instalacion_id turismo_real.instalacion.id_instalacion%type;
    departamento_id turismo_real.departamento.id_departamento%type;
begin
    -- comprobar existencia de departamento
    select id_departamento into departamento_id
    from departamento
    where id_departamento = depto_id;

    -- obtener id instalacion
    instalacion_id := fn_obten_id_instalacion(instalacion_d);
    
    -- agregar instalacion si no existe
    if instalacion_id = 0 then
        instalacion_id := fn_agregar_instalacion(instalacion_d);
    end if;
    
    insert into instalacion_departamento(id_instalacion_depto, id_instalacion, id_departamento)
        values(seq_instalacion_departamento.nextval, instalacion_id, depto_id);
    
    success_sp := 1; -- agregado correctamente
    commit;
exception
    when no_data_found then
        success_sp := -1; -- no existe depto
    when others then
        success_sp := 0; -- error al agregar
end;

/

-- SP ELIMINAR INSTALACIONES
create or replace procedure sp_eliminar_instalaciones(depto_id in number)
is begin
    delete from instalacion_departamento
    where id_departamento = depto_id;
end;

/

-- SP OBTEN INSTALACIONES POR ID
create or replace procedure sp_obten_instalaciones(depto_id in number, instalaciones out sys_refcursor)
is begin
    open instalaciones for
        select instalacion
        from departamento join instalacion_departamento using(id_departamento)
        join instalacion using(id_instalacion)
        where id_departamento = depto_id
        order by instalacion;
end;

/

-- SP AGREGAR SERVICIO
create or replace procedure sp_agregar_servicio(
    nombre_s in varchar,
    descripcion_s in varchar,
    valor_s in number,
    tipo_s in varchar,
    saved out number
) is
    id_s turismo_real.servicio.id_servicio%type;
    tipo_id turismo_real.tipo_servicio.id_tipo_servicio%type;
begin
    tipo_id := fn_obten_id_tipo_servicio(tipo_s);
    id_s := seq_tipo_servicio.nextval;
    
    if tipo_id > 0 then
        insert into servicio(id_servicio,nombre_servicio,descripcion,valor,id_tipo_servicio)
            values(id_s,nombre_s,descripcion_s,valor_s,tipo_id);
        commit;
        saved := id_s; -- servicio agregado
    else
        saved := -1; -- no existe tipo servicio
    end if;
exception
    when others then
        saved := 0; -- error al agregar
end;

/

-- SP EDITAR SERVICIO
create or replace procedure sp_editar_servicio(
    servicio_id in number,
    nombre_s in varchar,
    descripcion_s in varchar,
    valor_s in number,
    tipo_s in varchar,
    updated out number
) is
    id_s turismo_real.servicio.id_servicio%type;
    tipo_id turismo_real.tipo_servicio.id_tipo_servicio%type;
begin
    -- comprobar existencia de servicio
    select id_servicio into id_s
    from servicio
    where id_servicio = servicio_id;

    -- obtener id tipo servicio
    tipo_id := fn_obten_id_tipo_servicio(tipo_s);
    
    if tipo_id > 0 then -- tipo existe
        update servicio
            set nombre_servicio = nombre_s,
                descripcion = descripcion_s,
                valor = valor_s,
                id_tipo_servicio = tipo_id
            where id_servicio = servicio_id;
        commit;
        updated := 1;
    else
        updated := -2; -- no existe tipo servicio
    end if;
exception
    when no_data_found then
        updated := -1; -- no existe id servicio
    when others then
        updated := 0; -- error al editar
end;

/

-- SP ELIMINAR SERVICIO
create or replace procedure sp_eliminar_servicio(servicio_id in number, removed out number)
is
    id_s turismo_real.servicio.id_servicio%type;
begin
    -- comprobar existencia de servicio
    select id_servicio into id_s
    from servicio
    where id_servicio = servicio_id;
    -- eliminar
    delete from servicio
    where id_servicio = servicio_id;
    commit;
    removed := 1; -- servicio eliminado
exception
    when no_data_found then
        removed := -1; -- no existe id servicio
    when others then
        removed := 0; -- error al eliminar
end;

/

-- OBTEN SERVICIO POR ID
create or replace procedure sp_obten_servicio_id(servicio_id in number, servicio out sys_refcursor)
is begin
    open servicio for
        select id_servicio, nombre_servicio, descripcion, valor, tipo_servicio
        from servicio join tipo_servicio using(id_tipo_servicio)
        where id_servicio = servicio_id;
end;

/

-- SP OBTEN SERVICIOS
create or replace procedure sp_obten_servicios(servicios out sys_refcursor)
is begin
    open servicios for
        select
            id_servicio, nombre_servicio, descripcion, valor, tipo_servicio
        from servicio join tipo_servicio using(id_tipo_servicio);
end;

/
-- SP OBTEN RESERVAS
create or replace procedure sp_obten_reservas(reservas out sys_refcursor)
is begin
    open reservas for
        select
            id_reserva,fechora_reserva,
            to_char(fec_desde,'dd/mm/yyyy') as fec_desde,to_char(fec_hasta,'dd/mm/yyyy') as fec_hasta,
            valor_arriendo,fechora_checkin,fechora_checkout,checkin_conforme,checkout_conforme,
            estado_checkin,estado_checkout,estado,id_usuario,id_departamento
        from reserva join estado_reserva using(id_estado);
end;

/

commit;