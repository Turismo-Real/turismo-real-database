-- PRUEBA DE STORED PROCEDURES
-------------------------------

-- SP EXISTE CORREO
declare
    salida boolean;
    correo_existente varchar2(50);
    correo_inexistente varchar2(50);
begin
    correo_existente := 'f.donoso@gmail.com';
    correo_inexistente := 'inexistente@correo.com';
    sp_existe_correo(correo_existente, salida);
   
    if salida = true then
        dbms_output.put_line('true');
    else
        dbms_output.put_line('false');
    end if;
end;

-- SP LOGIN
declare
    login boolean;
    emailOK varchar2(100);
    passOK varchar2(255);
    emailBAD varchar2(100);
    passBAD varchar2(255);
begin
    emailOK := 'l.andres@gmail.com';
    passOK := '117735823fadae51db091c7d63e60eb0';
    emailBAD := 'correo_inexistente@gmail.com';
    passBad := '117735823fadae51db091c7d6123310';
    
    sp_login(emailOK, passBad, login);
    
    if login = true then
        dbms_output.put_line('true');
    else
        dbms_output.put_line('false');
    end if;
end;



------------------------------------
-- PRUEBA FUNCTIONS
--------------------
-- FN OBTENER ID GENERO
declare
    id_genero integer;
    genero varchar2(100);
begin
    genero := 'femenino';
    id_genero := fn_obten_id_genero(genero);
    dbms_output.put_line('ID GENERO: '||id_genero);
end;

-- FN OBTENER ID PAIS

-- FN OBTENER ID TIPO USUARIO

