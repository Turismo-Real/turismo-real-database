-- SP OBTEN FECHAS RESERVADAS
create or replace procedure sp_obten_fechas_reservadas(depto_id in number, fechas_reservadas out sys_refcursor)
is begin
    -- obtener fechas reservadas
    -- maximo 30 dias por reserva
    open fechas_reservadas for
        select
            to_char(fec_desde,'dd/mm/yyyy') as fec_desde,
            to_char(fec_hasta,'dd/mm/yyyy') as fec_hasta
        from reserva
        where id_departamento = depto_id
        and fec_desde >= sysdate-35
        order by fec_desde, fec_hasta;
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    fechas_reservadas ref_cur;
    depto turismo_real.departamento.id_departamento%type;
    desde varchar2(10);
    hasta varchar2(10);
    contador number;
begin
    depto := 3;
    sp_obten_fechas_reservadas(depto, fechas_reservadas);

    contador := 0;
    loop  fetch fechas_reservadas into desde, hasta;
        exit when fechas_reservadas%notfound;
        
        contador := contador + 1;
        dbms_output.put_line(contador||': '||desde||' - '||hasta);
    end loop;
    close fechas_reservadas;
end;