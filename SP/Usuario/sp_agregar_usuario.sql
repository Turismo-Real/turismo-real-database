-- SP AGREGAR USUARIO
create or replace procedure sp_agregar_usuario(
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
    tipo_u in varchar
) is 
    genero_id number;
    pais_id number;
    tipo_id number;
begin
    genero_id := fn_obten_id_genero(genero_u);
    pais_id := fn_obten_id_pais(pais_u);
    tipo_id := fn_obten_id_tipo_usuario(tipo_u);

-- todo: insert exceptions

    insert into usuario(numrut,dvrut,pnombre,snombre,apepat,apemat,fec_nac,correo,telefono_movil,telefono_fijo,password,id_genero,id_pais,id_tipo)
    values(rut_u,dv_u,pnombre_u,snombre_u,apepat_u,apemat_u,fecnac_u,email_u,telmovil_u,telfijo_u,pass_u,genero_id,pais_id,tipo_id);
    commit;
end;

/

-- PRUEBA SP
exec sp_agregar_usuario('15645878','2','Juan','Patricio','Rodriguez','Zamora','12/06/84','jp.rodza@gmail.com','+56994562154',null,'asdasd','Masculino','Chile','Cliente');
exec sp_agregar_usuario('18542556','K','Fernanda','Isabela','Toro','Vicencio','26/02/89','f.isa@gmail.com','+56911112222',null,'clave','femeNiNO','FRANcia','funCiOnARIO');