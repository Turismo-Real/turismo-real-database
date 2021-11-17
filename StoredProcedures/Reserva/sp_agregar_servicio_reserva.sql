-- SP AGREGAR SERVICIO RESERVA
create or replace procedure sp_agregar_servicio_reserva(
    reserva_id in number,
    servicio_id in number,
    conductor_id in number,
    saved out number
)is
    servicio_reserva_id turismo_real.servicio_reserva.id_servicio_reserva%type;
    existe_reserva number;
    existe_servicio number;
    existe_r_y_s number; -- pareja reserva-servicio
begin
    -- verificar id reserva
    select count(*) into existe_reserva
    from reserva where id_reserva = reserva_id;
    -- verificar id servicio
    select count(*) into existe_servicio
    from servicio where id_servicio = servicio_id;
    -- verificar existencia id_r && id_s
    select count(*) into existe_r_y_s
    from servicio_reserva
    where id_servicio = servicio_id
    and id_reserva = reserva_id;
    
    if existe_reserva > 0 and existe_servicio > 0 and existe_r_y_s = 0 then
        -- obtener id servicio-reserva
        servicio_reserva_id := seq_servicio_reserva.nextval;
        -- insertar servicio reserva
        insert into servicio_reserva(id_servicio_reserva,valor,id_servicio,id_conductor,id_reserva)
            values(servicio_reserva_id,valor,servicio_id,conductor_id,reserva_id);
        commit;
        saved := 1; -- SERVICIO AGREGADO
    else
        if existe_reserva = 0 then
            saved := -1; -- NO EXISTE RESERVA
        elsif existe_servicio = 0 then
            saved := -2; -- NO EXISTE SERVICIO
        elsif existe_r_y_s = 1 then
            saved := -3; -- YA EXISTE PAREJA RESERVA-SERVICIO
        end if;
    end if;
exception
    when others then saved := 0; -- ERROR AL AGREGAR SERVICIO
end;


-- PRUEBA SP
declare
    reserva_id turismo_real.reserva.id_reserva%type;
    servicio_id turismo_real.servicio.id_servicio%type;
    conductor_id turismo_real.conductor.id_conductor%type;
    saved number;
begin
    reserva_id := 2;
    servicio_id := 1;
    conductor_id := 1;
    sp_agregar_servicio_reserva(reserva_id,servicio_id,conductor_id,saved);
    
    if saved > 0 then
        dbms_output.put_line('Servicio-reserva agregado con id '||saved||'.');
    elsif saved = -1 then
        dbms_output.put_line('No existe la reserva con id '||reserva_id||'.');
    elsif saved = -2 then
        dbms_output.put_line('No existe el servicio con id '||servicio_id||'.');
    elsif saved = -3 then
        dbms_output.put_line('Ya existe el par servicio-reserva.');
    else
        dbms_output.put_line('Error al agregar servicio reserva');
    end if;
end;