-- SP OBTEN ESTADOS DEPTO
create or replace procedure sp_obten_estados_depto(estados out sys_refcursor)
is begin
    open estados for
        select estado
        from estado_depto;
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    estados ref_cur;
    estado turismo_real.estado_depto.estado%type;
    contador number;
begin
    sp_obten_estados_depto(estados);

    contador := 1;
    loop fetch estados into estado;
        exit when estados%notfound;
        
        dbms_output.put_line(contador||': '||estado);
        contador := contador + 1;
    end loop;
    close estados;
end;