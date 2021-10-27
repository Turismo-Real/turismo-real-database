-- SP OBTEN TIPO DEPTOS
create or replace procedure sp_obten_tipo_deptos(tipo_deptos out sys_refcursor)
is begin
    open tipo_deptos for    
        select tipo_departamento
        from tipo_departamento;
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    tipo_deptos ref_cur;
    tipo_depto turismo_real.tipo_departamento.tipo_departamento%type;
    contador number;
begin
    sp_obten_tipo_deptos(tipo_deptos);
    
    contador := 1;
    loop fetch tipo_deptos into tipo_depto;
        exit when tipo_deptos%notfound;
        
        dbms_output.put_line(contador||': '||tipo_depto);
        contador := contador + 1;
    end loop;
    close tipo_deptos;
end;