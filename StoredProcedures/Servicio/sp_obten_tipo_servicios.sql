-- SP OBTEN TIPO SERVICIO
create or replace procedure sp_obten_tipo_servicios(t_servicios out sys_refcursor)
is begin
    open t_servicios for
        select tipo_servicio
        from tipo_servicio;
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    t_servicios ref_cur;
    tipo_servicio turismo_real.tipo_servicio.tipo_servicio%type;
    contador number;
begin
    sp_obten_tipo_servicios(t_servicios);
    
    contador := 1;
    loop fetch t_servicios into tipo_servicio;
        exit when t_servicios%notfound;
        
        dbms_output.put_line(contador||': '||tipo_servicio);
    end loop;
    close t_servicios;
end;