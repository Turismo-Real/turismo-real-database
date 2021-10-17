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

-- PRUEBA SP
declare
    ok number;
begin
    --sp_agregar_usuario(null,'12264558','K','Raul','Antonio','Gonzalez','Zurita','20/06/1987','ran.zurita','+56942565555',null,'a60b85d409a01d46023f90741e01b79543a3cb1ba048eaefbe5d7a63638043bf','masculino','chile','cliente','Cabildo','Santa Helena','354',null,'12A',ok);
    sp_agregar_usuario('785458965',null,null,'Francesca','Antonella','Vyndjak','Saez','26/07/1991','fran.vyndjak@gmail.com','+56484465215',null,'a60b85d409a01d46023f90741e01b79543a3cb1ba048eaefbe5d7a63638043bf','femenino','holanda','cliente','Sin comuna','Van dijk','666','11',null,ok);

    if ok > 0 then
        dbms_output.put_line('Usuario Agregado.');
    else
        dbms_output.put_line('Error al agregar usuario.');
    end if;
end;