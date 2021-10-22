-- FN OBTEN TOPE RESERVA
create or replace function fn_obten_tope_reserva(
    depto_id in number,
    fec_desde_in in date,
    fec_hasta_in in date
)return number is
    tope_reserva number;
begin
    -- comprobar que fechas no topen con otra reserva  
    select
        count(*) into tope_reserva
    from reserva join estado_reserva using(id_estado)
    where id_departamento = depto_id
    and upper(estado) != 'CANCELADA'
    and ((fec_desde_in between fec_desde and fec_hasta)
    or (fec_hasta_in between fec_desde and fec_hasta));
    
    return tope_reserva;
end;

-- PRUEBA FN
declare
    depto_id turismo_real.departamento.id_departamento%type;
    fec_desde date;
    fec_hasta date;
    topes number;
begin
    depto_id := 2;
    fec_desde := to_date('25/10/2021');
    fec_hasta := to_date('28/10/2021');
    
    topes := fn_obten_tope_reserva(depto_id, fec_desde, fec_hasta);
    
    if topes > 0 then
        dbms_output.put_line('Ya existe una reserva en la fecha para el depto con id '||depto_id||'.');
    else
        dbms_output.put_line('Fecha disponible para reservar.');
    end if;
end;