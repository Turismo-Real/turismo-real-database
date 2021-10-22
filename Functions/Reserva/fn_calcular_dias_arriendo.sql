-- FN CALCULAR DIAS ARRIENDO
create or replace function fn_calcular_dias_arriendo(fec_desde in date, fec_hasta in date)
return number is
    dias_arriendo number;
begin
    select
        to_date(fec_hasta) - to_date(fec_desde) into dias_arriendo
    from dual;
    return dias_arriendo;
end;

-- PRUEBA FN
declare
    dias_arriendo number;
    fec_desde date;
    fec_hasta date;
begin
    fec_desde := to_date('10/10/2021');
    fec_hasta := to_date('15/10/2021');
    dias_arriendo := fn_calcular_dias_arriendo(fec_desde, fec_hasta);
    
    dbms_output.put_line('Días arriendo: '||dias_arriendo||' días.');
end;