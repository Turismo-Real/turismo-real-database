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
drop function fn_obten_tope_reserva;
drop function fn_calcular_dias_arriendo;
drop function fn_caclular_total_arriendo;
drop function fn_obten_depto;
drop function fn_obten_valor_arriendo;
drop function fn_obten_cliente;

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
drop procedure sp_obten_reserva_id;
drop procedure sp_eliminar_reserva;
drop procedure sp_agregar_reserva;
drop procedure sp_obten_fechas_reservadas;
drop procedure sp_obten_lista_instalaciones;
drop procedure sp_obten_tipo_servicios;
drop procedure sp_obten_tipo_deptos;
drop procedure sp_obten_estados_depto;
drop procedure sp_obten_estados_reserva;
drop procedure sp_obten_tipo_mantencion;
drop procedure sp_obten_estados_mantencion;
drop procedure sp_obten_tipos_gasto;
drop procedure sp_obten_tipos_pago;

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

-- FN AGREGAR INSTALACION
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

-- FN OBTEN TOPE RESERVA
create or replace function fn_obten_tope_reserva(
    depto_id in number,
    fec_desde_in in date,
    fec_hasta_in in date
)return number is
    tope_reserva number;
begin
    -- comprobar que fechas no topen con otra reserva  
    select
        count(*) into tope_reserva
    from reserva join estado_reserva using(id_estado)
    where id_departamento = depto_id
    and upper(estado) != 'CANCELADA'
    and ((fec_desde_in between fec_desde and fec_hasta)
    or (fec_hasta_in between fec_desde and fec_hasta));
    
    return tope_reserva;
end;

/

-- FN CALCULAR DIAS ARRIENDO
create or replace function fn_calcular_dias_arriendo(fec_desde in date, fec_hasta in date)
return number is
    dias_arriendo number;
begin
    select
        to_date(fec_hasta) - to_date(fec_desde) into dias_arriendo
    from dual;
    return dias_arriendo;
end;

/

-- FN CALCULAR TOTAL ARRIENDO
create or replace function fn_caclular_total_arriendo(depto_id in number, dias in number)
return number is
    total number;
begin
    select (valor_diario * dias) into total
    from departamento
    where id_departamento = depto_id;
    
    return total;
exception
    when no_data_found then
        return 0;
    when others then return 0;
end;

/

-- FN OBTEN ESTADO RESERVA
create or replace function fn_obten_id_estado_reserva(estado_r in varchar)
return number is
    estado_id turismo_real.estado_reserva.estado%type;
begin
    select id_estado into estado_id
    from estado_reserva
    where upper(estado) = upper(estado_r);

    return estado_id;
exception
    when no_data_found then
        return 0;
    when others then
        return 0;
end;

/

-- FN OBTEN VALOR ARRIENDO
create or replace function fn_obten_valor_arriendo(depto_id in number)
return number is
    valor turismo_real.departamento.valor_diario%type;
begin
    select valor_diario into valor
    from departamento
    where id_departamento = depto_id;

    return valor;
exception
    when no_data_found then return 0;
    when others then return 0;
end;

/

-- FN OBTEN DEPTO
create or replace function fn_obten_depto(depto_id in number)
return number is
    id_d turismo_real.departamento.id_departamento%type;
begin
    select id_departamento into id_d
    from departamento
    where id_departamento = depto_id;
    
    return id_d;
exception
    when no_data_found then return 0;
    when others then return 0;
end;

/

-- FN OBTEN CLIENTE
create or replace function fn_obten_cliente(cliente_id in number)
return number
is
    id_c turismo_real.usuario.id_usuario%type;
begin
    select id_usuario into id_c
    from usuario join tipo_usuario using(id_tipo)
    where upper(tipo) = 'CLIENTE'
    and id_usuario = cliente_id;
    
    return id_c; -- RETORNA ID CLIENTE
exception
    when no_data_found then
        return 0; -- NO EXISTE ID CLIENTE
    when others then
        return 0; -- ERROR
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
    id_u turismo_real.usuario.id_usuario%type;
    genero_id number;
    pais_id number;
    tipo_id number;
    comuna_id number;
    fecha_nac date;
begin
    -- comprobar existencia de usuario
    select id_usuario into id_u
    from usuario
    where id_usuario = usuario_id;

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
    updated := usuario_id; -- usuario actualizado
exception
    when no_data_found then -- usuario no existe
        updated := -1;
    when others then
        updated := 0; -- error al actualizar
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
    open paises for select pais from pais order by pais;
end;

/

-- SP LOGIN
create or replace procedure sp_login(
    email_u in varchar2, 
    pass_u in varchar2, 
    tipo_u out varchar2,
    usuario_id out number
) is 
    tipo_usuario varchar2(50) := 'ERROR';
begin
    usuario_id := 0;

    select 
        id_usuario, tipo into usuario_id, tipo_usuario
    from usuario join tipo_usuario using(id_tipo)
    where upper(correo) = upper(email_u) and upper(password) = upper(pass_u);
    
    tipo_u := tipo_usuario;
exception
    when no_data_found then 
        tipo_u := tipo_usuario;
    when others then
        tipo_u := tipo_usuario;
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

-- SP OBTEN RESERVA POR ID
create or replace procedure sp_obten_reserva_id(reserva_id in number, reserva out sys_refcursor)
is begin
    open reserva for
        select
            id_reserva,fechora_reserva,
            to_char(fec_desde,'dd/mm/yyyy') as fec_desde,to_char(fec_hasta,'dd/mm/yyyy') as fec_hasta,
            valor_arriendo,fechora_checkin,fechora_checkout,checkin_conforme,checkout_conforme,
            estado_checkin,estado_checkout,estado,id_usuario,id_departamento
        from reserva join estado_reserva using(id_estado)
        where id_reserva = reserva_id;
end;

/

-- -- SP ELIMINAR RESERVA
create or replace procedure sp_eliminar_reserva(reserva_id in number, removed out number)
is
    id_r turismo_real.reserva.id_reserva%type;
begin
    -- comprobar existencia de reserva
    select id_reserva into id_r
    from reserva
    where id_reserva = reserva_id;
    
    delete from reserva
    where id_reserva = reserva_id;
    commit;
    removed := 1; -- reserva eliminada
exception
    when no_data_found then
        removed := -1; -- no existe reserva
    when others then
        removed := 0; -- error al eliminar
end;

/

-- SP AGREGAR RESERVA
create or replace procedure sp_agregar_reserva(
    fec_desde_r in varchar,
    fec_hasta_r in varchar,
    id_usuario_r in number,
    id_departamento_r in number,
    saved out number
) is
    reserva_id turismo_real.reserva.id_reserva%type;
    fec_desde_in turismo_real.reserva.fec_desde%type;
    fec_hasta_in turismo_real.reserva.fec_hasta%type;
    estado_id turismo_real.estado_depto.estado%type;
    valor_arriendo turismo_real.reserva.valor_arriendo%type;
    tope_reservas number;
    dias_arriendo number;
    cliente_id number;
    depto_id number;
    tope_reserva number;
begin
    -- comprobar existencia de cliente
    cliente_id := fn_obten_cliente(id_usuario_r);
    -- comprobar existencia de departamento
    depto_id := fn_obten_depto(id_departamento_r);   
    
    if cliente_id > 0 and depto_id > 0 then
        -- convertir str fecha entrada a tipo fecha
        fec_desde_in := to_date(fec_desde_r);
        fec_hasta_in := to_date(fec_hasta_r);
        -- obtener topes de fecha con otras reservas
        tope_reserva := fn_obten_tope_reserva(depto_id, fec_desde_in, fec_hasta_in);
        -- obtener dias de arriendo
        dias_arriendo := fn_calcular_dias_arriendo(fec_desde_in, fec_hasta_in);
        
        if tope_reserva = 0 and dias_arriendo <= 30 then
            -- obtener valor arriendo depto
            valor_arriendo := fn_obten_valor_arriendo(depto_id);
            -- obtener id estado reserva (default CARGADA)
            estado_id := fn_obten_id_estado_reserva('CARGADA');
            -- generar id reserva
            reserva_id := seq_reserva.nextval;
            
            -- crear nueva reserva
            insert into reserva(id_reserva,fechora_reserva,fec_desde,fec_hasta,valor_arriendo,id_estado,id_departamento,id_usuario)
                values(reserva_id,sysdate,fec_desde_in,fec_hasta_in,valor_arriendo,estado_id,depto_id,cliente_id);

            commit;            
            saved := reserva_id; -- OK: RETORNA ID RESERVA
        else
            if tope_reserva > 0 then
                saved := -3; -- ERROR: YA EXISTE UNA RESERVA EN TAL FECHA
            elsif dias_arriendo > 30 then
                saved := -4; -- ERROR: 30 DIAS MAXIMO RESERVA
            end if;
        
        end if;       
    else
        if cliente_id = 0 then
            saved := -1; -- ERROR: CLIENTE NO EXISTE 
        elsif depto_id = 0 then
            saved := -2; -- ERROR: DEPTO NO EXISTE
        end if;
    end if;
exception
    when others then
        saved := 0; -- ERROR AL AGREGAR RESERVA
end;

/

-- SP OBTEN FECHAS RESERVADAS
create or replace procedure sp_obten_fechas_reservadas(depto_id in number, fechas_reservadas out sys_refcursor)
is begin
    -- obtener fechas reservadas
    -- maximo 30 dias por reserva
    open fechas_reservadas for
        select
            to_char(fec_desde,'dd/mm/yyyy') as fec_desde,
            to_char(fec_hasta,'dd/mm/yyyy') as fec_hasta
        from reserva
        where id_departamento = depto_id
        and fec_desde >= sysdate-35
        order by fec_desde, fec_hasta;
end;

/

-- SP CHECK IN
create or replace procedure sp_check_in(
    reserva_id in number,
    conforme in number,
    estado in varchar,
    check_in out number
)
is
    id_r turismo_real.reserva.id_reserva%type;
    estado_id turismo_real.estado_depto.id_estado%type;
begin
    -- comprobar existencia de reserva
    select id_reserva into id_r
    from reserva
    where id_reserva = reserva_id;

    -- id de estado (check in)
    estado_id := fn_obten_id_estado_reserva('CHECK IN');

    -- ingresar check in
    update reserva
        set fechora_checkin = sysdate,
            checkin_conforme = conforme,
            estado_checkin = estado
    where id_reserva = id_r;

    commit;
    check_in := 1; -- check in ingresado
exception
    when no_data_found then
        check_in := -1; -- RESERVA NO EXISTE
    when others then
        check_in := 0; -- ERROR EN CHECK IN
end;

/

-- SP CHECK OUT
create or replace procedure sp_check_out(
    reserva_id in number,
    conforme in number,
    estado in varchar,
    check_out out number
)
is
    id_r turismo_real.reserva.id_reserva%type;
    estado_id turismo_real.estado_depto.id_estado%type;
begin
    -- comprobar existencia de reserva
    select id_reserva into id_r
    from reserva
    where id_reserva = reserva_id;

    -- id de estado (check out)
    estado_id := fn_obten_id_estado_reserva('CHECK OUT');

    -- ingresar check out
    update reserva
        set fechora_checkout = sysdate,
            checkout_conforme = conforme,
            estado_checkout = estado
    where id_reserva = id_r;

    commit;
    check_out := 1; -- check in ingresado
exception
    when no_data_found then
        check_out := -1; -- RESERVA NO EXISTE
    when others then
        check_out := 0; -- ERROR EN CHECK IN
end;

/

-- SP OBTEN LISTA DE INSTALACIONES DISPONIBLES
create or replace procedure sp_obten_lista_instalaciones(instalaciones out sys_refcursor)
is begin
    open instalaciones for
        select instalacion
        from instalacion;
end;

/

-- SP OBTEN TIPO SERVICIO
create or replace procedure sp_obten_tipo_servicios(t_servicios out sys_refcursor)
is begin
    open t_servicios for
        select tipo_servicio
        from tipo_servicio;
end;

/

-- SP OBTEN TIPO DEPTOS
create or replace procedure sp_obten_tipo_deptos(tipo_deptos out sys_refcursor)
is begin
    open tipo_deptos for    
        select tipo_departamento
        from tipo_departamento;
end;


/

-- SP OBTEN ESTADOS DEPTO
create or replace procedure sp_obten_estados_depto(estados out sys_refcursor)
is begin
    open estados for
        select estado
        from estado_depto;
end;

/

-- SP OBTEN ESTADOS RESERVA
create or replace procedure sp_obten_estados_reserva(estados out sys_refcursor)
is begin
    open estados for
        select estado
        from estado_reserva;
end;

/

-- SP OBTEN TIPO MANTENCION
create or replace procedure sp_obten_tipo_mantencion(tipos out sys_refcursor)
is begin
    open tipos for
        select tipo
        from tipo_mantencion;
end;

/

-- SP OBTEN ESTADO MANTENCION
create or replace procedure sp_obten_estados_mantencion(estados out sys_refcursor)
is begin
    open estados for
        select estado
        from estado_mantencion;
end;

/

-- SP OBTEN TIPOS GASTO
create or replace procedure sp_obten_tipos_gasto(tipos out sys_refcursor)
is begin
    open tipos for
        select tipo_gasto
        from tipo_gasto;
end;

/

-- SP OBTEN TIPO PAGO
create or replace procedure sp_obten_tipos_pago(tipos out sys_refcursor)
is begin
    open tipos for
        select tipo_pago
        from tipo_pago;
end;

/

-- SP CAMBIAR PASSWORD
create or replace procedure sp_cambiar_password(
    usuario_id in number,
    current_password in varchar,
    new_password in varchar,
    updated out number
) is 
    id_u turismo_real.usuario.id_usuario%type;
    pass turismo_real.usuario.password%type;
begin
    -- comprobar existencia de usuario
    select id_usuario into id_u
    from usuario
    where id_usuario = usuario_id;
    
    -- comprobar contraseña actual
    select password into pass
    from usuario
    where id_usuario = usuario_id;
    
    if current_password = pass then
        -- cambiar contraseña
        update usuario
            set password = new_password
        where id_usuario = id_u;
        commit;
        updated := 1; -- CONTRASEÑA ACTUALIZADA
    else
        updated := -2; -- CONTRASEÑA NO COINCIDE CON LA ACTUAL
    end if;
exception
    when no_data_found then updated := -1; -- NO EXISTE USUARIO
    when others then updated := 0; -- ERROR AL ACTUALIZAR
end;

/

commit;