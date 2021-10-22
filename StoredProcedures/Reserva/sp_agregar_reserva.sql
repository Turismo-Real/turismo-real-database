-- SP AGREGAR RESERVA
create or replace procedure sp_agregar_reserva(
    fec_desde_r in varchar,
    fec_hasta_r in varchar,
    valor_arriendo_r in number,
    fechora_checkin_r in varchar,
    fechora_checkout_r in varchar,
    checkin_conforme_r in varchar,
    checkout_conforme_r in varchar,
    estado_checkin_r in varchar,
    estado_checkout_r in varchar,
    estado_r in varchar,
    id_usuario_r in number,
    id_departamento_r in number,
    saved out number
) is
    reserva_id turismo_real.reserva.id_reserva%type;
    fec_desde_in turismo_real.reserva.fec_desde%type;
    fec_hasta_in turismo_real.reserva.fec_hasta%type;
    fechora_checkin turismo_real.reserva.fechora_checkin%type;
    fechora_checkout turismo_real.reserva.fechora_checkout%type;
    estado_id turismo_real.estado_departamento.estado%type;
    tope_reservas number;
    dias_arriendo number;
    valor_total_arriendo number;
begin
    -- comprobar existencia de cliente

    -- comprobar existencia de departamento

    -- convertir str fecha entrada a tipo fecha
    fec_desde_in := to_date(fec_desde_r);
    fec_hasta_in := to_date(fec_hasta_r);

    -- comprobar que fechas no topen con otra reserva
    select
        count(*) into tope_reservas
    from reserva join estado_reserva using(id_estado)
    where id_departamento = 2
    and upper(estado) != 'CANCELADA'
    and ((fec_desde_in between fec_desde and fec_hasta)
    or (fec_hasta_in between fec_desde and fec_hasta));

    -- obtener id estado reserva
    estado_id := fn_obten_id_estado_reserva(estado_r);

    -- obtener dias de arriendo
    dias_arriendo := fn_calcular_dias_arriendo(fec_desde, fec_hasta);
        
    -- obtener valor arriendo
    valor_total_arriendo := fn_caclular_total_arriendo(id_departamento_id, dias_arriendo);

end;