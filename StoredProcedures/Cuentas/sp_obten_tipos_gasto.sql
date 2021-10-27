-- SP OBTEN TIPOS GASTO
create or replace procedure sp_obten_tipos_gasto(tipos out sys_refcursor)
is begin
    open tipos for
        select tipo_gasto
        from tipo_gasto;
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    tipos ref_cur;
    tipo turismo_real.tipo_gasto.tipo_gasto%type;
    contador number;
begin
    sp_obten_tipos_gasto(tipos);
    
    contador := 1;
    loop fetch tipos into tipo;
        exit when tipos%notfound;
        
        dbms_output.put_line(contador||': '||tipo);
        contador := contador + 1;
    end loop;
    close tipos;
end;