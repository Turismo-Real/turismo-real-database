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

-- PRUEBA SP
declare
    id_usuario turismo_real.usuario.id_usuario%type;
    updated number;
begin
    id_usuario := 55;
    sp_editar_usuario(id_usuario,'154256545',null,null,'Sharon','Clementine','Mclean','Mendoza','06/04/1989','s.clementine@gmail.com','+56911112222',null,'femeNINO','Argentina','clienTE','sin comunA','Los Dolares','1999',null,'25B',updated);

    if updated > 0 then
        dbms_output.put_line('Usuario Actualizado.');
    elsif updated = -1 then
        dbms_output.put_line('No existe usuario con id '||id_usuario);
    else
        dbms_output.put_line('Error al actualizar usuario.');
    end if;
end;