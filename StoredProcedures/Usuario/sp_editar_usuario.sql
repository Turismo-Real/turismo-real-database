-- SP MODIFICAR USUARIO
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
    updated out boolean
) is
    genero_id number;
    pais_id number;
    tipo_id number;
begin
    genero_id := fn_obten_id_genero(genero_u);
    pais_id := fn_obten_id_pais(pais_u);
    tipo_id := fn_obten_id_tipo_usuario(tipo_u);

    update usuario
    	set numrut = rut_u,
        	dvrut = dv_u,
        	pnombre = pnombre_u,
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
    updated := true;
exception
    when others then
        updated := false;
end;

/

-- PRUEBA SP
declare
    rut_editar_user varchar2(8);
    updated boolean;
begin
    rut_editar_user := '15624572';
    sp_editar_usuario(rut_editar_user,'0','Andrea','Fernanda','Espinoza','Vergara','21/09/89','a.fernan@correo.com','+56911234458','+56288884444','1c42f9c1ca2f65441465b43cd9339d6c','femenino','España','Administrador',updated);
    
    if updated = true then
        dbms_output.put_line('Usuario Actualizado.');
    else
        dbms_output.put_line('Error al actualizar usuario.');
    end if;
end;