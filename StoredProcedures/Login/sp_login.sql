-- SP LOGIN
--  true cuando la combinación correo y password existe
--  false cuando la combinación no existe
create or replace procedure sp_login(email in varchar, pass in varchar, login out number)
is
    cantidad number := 0;
begin
    select count(*) into cantidad
    from usuario u
    where u.correo = email and u.password = pass;

    if cantidad = 0 then
        login := 0;
    else 
        login := 1;
    end if;
exception
    when no_data_found then login := 0;
    when others then login := 0;
end;

/

-- PRUEBA SP
declare
    login number;
    emailOK varchar2(100);
    passOK varchar2(255);
    emailBAD varchar2(100);
    passBAD varchar2(255);
begin
    emailOK := 'l.andres@gmail.com';
    passOK := '117735823fadae51db091c7d63e60eb0';
    emailBAD := 'correo_inexistente@gmail.com';
    passBAD := '117735823fadae51db091c7d6123310';
    
    sp_login(emailOK, passBAD, login);
    
    if login = 1 then
        dbms_output.put_line('true');
    else
        dbms_output.put_line('false');
    end if;
end;