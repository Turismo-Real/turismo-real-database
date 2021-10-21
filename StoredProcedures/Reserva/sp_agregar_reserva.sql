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
    fec_desde turismo_real.reserva.fec_desde%type;
    fec_hasta turismo_real.reserva.fec_hasta%type;
    fechora_checkin turismo_real.reserva.fechora_checkin%type;
    fechora_checkout turismo_real.reserva.fechora_checkout%type;
    estado_id turismo_real.estado_departamento.estado%type;
begin
    -- comprobar que fechas no coincidan con otra reserva

    -- obtener id estado reserva
    estado_id := fn_obten_id_estado_reserva(estado_r);

    
    
end;