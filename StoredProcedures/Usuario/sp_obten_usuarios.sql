-- SP OBTEN USUARIOS
create or replace procedure sp_obten_usuarios(usuarios out sys_refcursor)
is begin
    open usuarios for
        select numrut, dvrut,
            pnombre, snombre, apepat, apemat,
            fec_nac, correo,
            telefono_movil, telefono_fijo,
            genero, pais, tipo, region, comuna,
            calle, numero, depto, casa
        from usuario join genero using(id_genero)
        join pais using(id_pais)
        join tipo_usuario using(id_tipo)
        join direccion using(numrut)
        join comuna using(id_comuna)
        join region using(id_region);
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    c_usuario ref_cur;
    numrut turismo_real.usuario.numrut%type;
    dvrut turismo_real.usuario.dvrut%type;
    pnombre turismo_real.usuario.pnombre%type;
    snombre turismo_real.usuario.snombre%type;
    apepat turismo_real.usuario.apepat%type;
    apemat turismo_real.usuario.apemat%type;
    fec_nac turismo_real.usuario.fec_nac%type;
    correo turismo_real.usuario.correo%type;
    telefono_movil turismo_real.usuario.telefono_movil%type;
    telefono_fijo turismo_real.usuario.telefono_fijo%type;
    genero turismo_real.genero.genero%type;
    pais turismo_real.pais.pais%type;
    tipo turismo_real.tipo_usuario.tipo%type;
    region turismo_real.region.region%type;
    comuna turismo_real.comuna.comuna%type;
    calle turismo_real.direccion.calle%type;
    numero turismo_real.direccion.numero%type;
    depto turismo_real.direccion.depto%type;
    casa turismo_real.direccion.casa%type;
begin
    sp_obten_usuarios(c_usuario);

    loop fetch c_usuario into numrut,dvrut,pnombre,snombre,apepat,apemat,
        fec_nac,correo,telefono_movil,telefono_fijo,genero,pais,tipo,
        region,comuna,calle,numero,depto,casa;
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
        dbms_output.put_line('Region: '||region);
        dbms_output.put_line('Comuna: '||comuna);
        dbms_output.put_line('Calle: '||calle);
        dbms_output.put_line('Numero: '||numero);
        dbms_output.put_line('Depto: '||depto);
        dbms_output.put_line('Casa: '||casa);
        dbms_output.put_line('-----------------------------');
        dbms_output.put_line('');
    end loop;
    close c_usuario;
end;