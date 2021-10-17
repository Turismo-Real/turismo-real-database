-- SP OBTEN REGIONES
create or replace procedure sp_obten_regiones(regiones out sys_refcursor)
is begin
    open regiones for select region from region;
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    c_region ref_cur;
    region turismo_real.region.region%type;
begin
    sp_obten_regiones(c_region);

    loop fetch c_region into region;
        exit when c_region%notfound;

        dbms_output.put_line(region);
    end loop;
    close c_region;
end;