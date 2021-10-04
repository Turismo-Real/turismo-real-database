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

-- SP BUSCAR USUARIO POR RUT
declare
    rut_entrada usuario.numrut%type;
    type ref_cur is ref cursor;
    c_usuario ref_cur;
    numrut usuario.numrut%type;
    dvrut usuario.dvrut%type;
    pnombre usuario.pnombre%type;
    snombre usuario.snombre%type;
    apepat usuario.apepat%type;
    apemat usuario.apemat%type;
    fec_nac usuario.fec_nac%type;
    correo usuario.correo%type;
    telefono_movil usuario.telefono_movil%type;
    telefono_fijo usuario.telefono_fijo%type;
    genero varchar2(100);
    pais varchar2(100);
    tipo tipo_usuario.tipo%type;
begin
    rut_entrada := '18565249';
    sp_usuario_por_rut(rut_entrada, c_usuario);

    loop fetch c_usuario into numrut, dvrut, pnombre, snombre, apepat, apemat,
            fec_nac, correo, telefono_movil, telefono_fijo, genero, pais, tipo;
        exit when c_usuario%notfound;
        dbms_output.put_line('RUT: '||numrut||'-'||dvrut);
        dbms_output.put_line('Nombre: '||pnombre||' '||snombre||' '||apepat||' '||apemat);
        dbms_output.put_line('Fecha Nacimiento: '||fec_nac);
        dbms_output.put_line('Correo: '||correo);
        dbms_output.put_line('Telefono fijo: '||telefono_fijo);
        dbms_output.put_line('Telefono Movil: '||telefono_movil);
        dbms_output.put_line('Genero: '||genero);
        dbms_output.put_line('Pais: '||pais);
        dbms_output.put_line('Perfil: '||tipo);
    end loop;
    close c_usuario;
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
declare
    id_pais integer;
    pais varchar2(100);
begin
    pais := 'Chile';
    id_pais := fn_obten_id_pais(pais);
    dbms_output.put_line('ID PAIS: '||id_pais);
end;

-- FN OBTENER ID TIPO USUARIO
declare
    id_tipo integer;
    tipo varchar2(50);
begin
    tipo := 'cliente';
    id_tipo := fn_obten_id_tipo_usuario(tipo);
    dbms_output.put_line('ID TIPO USUARIO: '||id_tipo);
end;