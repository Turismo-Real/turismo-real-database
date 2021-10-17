-- SP OBTEN INSTALACIONES POR ID
create or replace procedure sp_obten_instalaciones(depto_id in number, instalaciones out sys_refcursor)
is begin
    open instalaciones for
        select instalacion
        from departamento join instalacion_departamento using(id_departamento)
        join instalacion using(id_instalacion)
        where id_departamento = 6
        order by instalacion;
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    instalaciones ref_cur;
    id_depto turismo_real.departamento.id_departamento%type;
    instalacion turismo_real.instalacion.instalacion%type;
begin
    id_depto := 3;
    sp_obten_instalaciones(id_depto, instalaciones);
    
    dbms_output.put_line('Instalaciones depto '||id_depto);
    loop fetch instalaciones into instalacion;
        exit when instalaciones%notfound;
        
        dbms_output.put_line(instalacion);
    end loop;
    close instalaciones;
    
end;