-- SP CHECK OUT
create or replace procedure sp_check_out(
    reserva_id in number,
    conforme in number,
    estado in varchar,
    check_out out number
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
    estado_id := fn_obten_id_estado_reserva('CHECK OUT');

    -- ingresar check out
    update reserva
        set fechora_checkout = sysdate,
            checkout_conforme = conforme,
            estado_checkout = estado
    where id_reserva = id_r;

    commit;
    check_out := 1; -- check in ingresado
exception
    when no_data_found then
        check_out := -1; -- RESERVA NO EXISTE
    when others then
        check_out := 0; -- ERROR EN CHECK IN
end;

-- PRUEBA SP
declare
    reserva turismo_real.reserva.id_reserva%type;
    estado turismo_real.reserva.estado_checkin%type;
    conforme number;
    check_out number;
begin
    reserva := 8;
    estado := 'Cliente devuelve departamento en buenas condiciones';
    conforme := 1;

    sp_check_out(reserva,conforme,estado,check_out);

    if check_out = 1 then
        -- agregado
        dbms_output.put_line('Check out ingresado.');
    elsif check_out = -1 then
        dbms_output.put_line('No existe la reserva ingresada.');
    else
        dbms_output.put_line('Error al ingresar check out');
    end if;
end;