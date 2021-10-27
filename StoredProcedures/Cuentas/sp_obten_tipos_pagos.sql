-- SP OBTEN TIPO PAGO
create or replace procedure sp_obten_tipos_pago(tipos out sys_refcursor)
is begin
    open tipos for
        select tipo_pago
        from tipo_pago;
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    tipos ref_cur;
    tipo turismo_real.tipo_pago.tipo_pago%type;
    contador number;
begin
    sp_obten_tipos_pago(tipos);
    
    contador := 1;
    loop fetch tipos into tipo;
        exit when tipos%notfound;
        
        dbms_output.put_line(contador||': '||tipo);
        contador := contador + 1;
    end loop;
    close tipos;
end;