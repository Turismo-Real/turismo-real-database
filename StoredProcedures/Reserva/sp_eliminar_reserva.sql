-- -- SP ELIMINAR RESERVA
create or replace procedure sp_eliminar_reserva(reserva_id in number, removed out number)
is
    id_r turismo_real.reserva.id_reserva%type;
begin
    -- comprobar existencia de reserva
    select id_reserva into id_r
    from reserva
    where id_reserva = reserva_id;
    
    delete from reserva
    where id_reserva = reserva_id;
    commit;
    removed := 1; -- reserva eliminada
exception
    when no_data_found then
        removed := -1; -- no existe reserva
    when others then
        removed := 0; -- error al eliminar
end;

-- PRUEBA SP
declare
    id_r turismo_real.reserva.id_reserva%type;
    removed number;
begin
    id_r := 5;
    sp_eliminar_reserva(id_r, removed);
    
    if removed = 1 then
        dbms_output.put_line('Reserva eliminada.');
    elsif removed = -1 then
        dbms_output.put_line('Reserva no existe');
    else
        dbms_output.put_line('Error al eliminar reserva');
    end if;
end;