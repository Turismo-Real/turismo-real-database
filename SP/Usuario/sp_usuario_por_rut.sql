-- SP BUSCAR USUARIO POR RUT
-- retorna datos del usuario si es que encuentra uno
create or replace procedure sp_usuario_por_rut(rut in varchar, cur_user out sys_refcursor)
is begin
    open cur_user for select numrut, dvrut,
            pnombre, snombre, apepat, apemat,
            fec_nac, correo,
            telefono_movil, telefono_fijo,
            genero, pais, tipo
        from usuario join genero using(id_genero)
        join pais using(id_pais)
        join tipo_usuario using(id_tipo)
        where numrut = rut;
end;

-- todo: exception
/

-- PRUEBA SP
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
    tipo pais varchar2(50);;
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