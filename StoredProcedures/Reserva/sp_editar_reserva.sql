-- SP EDITAR RESERVA
create or replace procedure sp_editar_reserva(
    reserva_id in number,
    checkin_conforme_r in number,
    checkout_conforme_r in number,
    estado_checkin_r in varchar,
    estado_checkout_r in varchar,
    estado_r in varchar,
    updated out number
) is
    id_r turismo_real.reserva.id_reserva%type;
    estado_id turismo_real.estado_reserva.estado%type;
begin
    -- comprobar existencia de reserva
    select id_reserva into id_r
    from reserva
    where id_reserva = reserva_id;
    -- obtener id estado
    estado_id := fn_obten_id_estado_reserva(estado_r);

    -- actualizar reserva
    update reserva
        set checkin_conforme = checkin_conforme_r,
            checkout_conforme = checkout_conforme_r,
            estado_checkin = estado_checkin_r,
            estado_checkout = estado_checkout_r,
            id_estado = estado_id
    where id_reserva = id_r;

    commit;
    updated := 1;
exception
    when no_data_found then updated := -1;
    when others then updated := 0;
end;

-- PRUEBA SP
declare
    reserva turismo_real.reserva.id_reserva%type;
    estado turismo_real.estado_reserva.estado%type;
    estado_checkin turismo_real.reserva.estado_checkin%type;
    estado_checkout turismo_real.reserva.estado_checkout%type;
    checkin_conforme number;
    checkout_conforme number;
    updated number;
begin
    reserva := 24;
    estado := 'Cancelada';
    estado_checkin := 'blabla';
    estado_checkout := 'BLABLA';
    checkin_conforme := 0;
    checkout_conforme := 0;

    sp_editar_reserva(reserva,checkin_conforme,checkout_conforme,estado_checkin,estado_checkout,estado,updated);

    if updated = 1 then
        dbms_output.put_line('Reserva actualizada.');
    elsif updated = -1 then
        dbms_output.put_line('No existe la reserva con id '||reserva||'.');
    else
        dbms_output.put_line('Error al actualizar reserva');
    end if;
end;