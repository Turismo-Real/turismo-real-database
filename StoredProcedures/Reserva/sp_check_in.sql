-- SP CHECK IN
create or replace procedure sp_check_in(
    reserva_id in number,
    conforme in number,
    estado in varchar,
    check_in out number
)
is
    id_r turismo_real.reserva.id_reserva%type;
    estado_id turismo_real.estado_depto.id_estado%type;
begin
    -- comprobar existencia de reserva
    select id_reserva into id_r
    from reserva
    where id_reserva = reserva_id;

    -- id de estado (check in)
    estado_id := fn_obten_id_estado_reserva('CHECK IN');

    -- ingresar check in
    update reserva
        set fechora_checkin = sysdate,
            checkin_conforme = conforme,
            estado_checkin = estado
    where id_reserva = id_r;

    commit;
    check_in := 1; -- check in ingresado
exception
    when no_data_found then
        check_in := -1; -- RESERVA NO EXISTE
    when others then
        check_in := 0; -- ERROR EN CHECK IN
end;

-- PRUEBA SP
declare
    reserva turismo_real.reserva.id_reserva%type;
    estado turismo_real.reserva.estado_checkin%type;
    conforme number;
    check_in number;
begin
    reserva := 8;
    estado := 'Se entrega departamento a cliente en perfectas condiciones';
    conforme := 1;

    sp_check_in(reserva,conforme,estado,check_in);

    if check_in = 1 then
        -- agregado
        dbms_output.put_line('Check in ingresado.');
    elsif check_in = -1 then
        dbms_output.put_line('No existe la reserva ingresada.');
    else
        dbms_output.put_line('Error al ingresar check in');
    end if;
end;