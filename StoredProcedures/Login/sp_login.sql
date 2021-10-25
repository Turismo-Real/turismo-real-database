-- SP LOGIN
--  true cuando la combinación correo y password existe
--  false cuando la combinación no existe
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

-- PRUEBA SP
declare
    usuario turismo_real.usuario.id_usuario%type;
    tipo turismo_real.tipo_usuario.tipo%type;
    emailOK varchar2(100);
    passOK varchar2(255);
    emailBAD varchar2(100);
    passBAD varchar2(255);
begin
    emailOK := 'f.donoso@gmail.com';
    passOK := 'f09ebc929ba427bb41aa5f34858aca0adce3ffcb4681808cdaf446df67c28005';
    emailBAD := 'correo_inexistente@gmail.com';
    passBAD := '117735823fadae51db091c7d6123310';
    
    sp_login(emailOK, passBAD, tipo, usuario);
    
    if tipo = 'ERROR' then
        dbms_output.put_line('false');
    else
        dbms_output.put_line('true');
        dbms_output.put_line('Tipo Usuario: '||tipo);
        dbms_output.put_line('ID Usuario: '||usuario);
    end if;
end;