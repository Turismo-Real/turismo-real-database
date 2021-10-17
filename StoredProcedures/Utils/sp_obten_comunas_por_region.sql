-- SP OBTEN COMUNAS POR REGION
create or replace procedure sp_obten_comuna_por_region(region_in in varchar, comunas out sys_refcursor)
is begin 
    open comunas for select c.comuna
        from comuna c join region r
        using(id_region)
        where upper(r.region) = upper(region_in)
        order by c.comuna;
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    c_comuna ref_cur;
    comuna turismo_real.comuna.comuna%type;
begin
    sp_obten_comuna_por_region('Metropolitana de SantiaGO', c_comuna);

    loop fetch c_comuna into comuna;
        exit when c_comuna%notfound;

        dbms_output.put_line(comuna);
    end loop;
    close c_comuna;
end;