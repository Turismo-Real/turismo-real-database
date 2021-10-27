-- SP OBTEN LISTA INSTALACIONES
create or replace procedure sp_obten_lista_instalaciones(instalaciones out sys_refcursor)
is begin
    open instalaciones for
        select instalacion
        from instalacion;
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    instalaciones ref_cur;
    instalacion turismo_real.instalacion.instalacion%type;
    contador number;
begin
    sp_obten_lista_instalaciones(instalaciones);

    contador := 1;
    loop fetch instalaciones into instalacion;
        exit when instalaciones%notfound;

        dbms_output.put_line(contador||': '||instalacion);
        contador := contador + 1;
    end loop;
    close instalaciones;
end;