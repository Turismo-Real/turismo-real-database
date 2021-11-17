-- SP OBTENER SERVICIOS DE RESERVA
create or replace procedure sp_obten_servicios_reserva(
    reserva_id in number,
    servicios out sys_refcursor
) is begin
    open servicios for
        select
            id_servicio_reserva, id_servicio, nombre_servicio,
            tipo_servicio, sr.valor, id_conductor
        from servicio_reserva sr join servicio s using(id_servicio)
        join tipo_servicio ts using(id_tipo_servicio)
        where id_reserva = reserva_id;
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    servicios ref_cur;
    reserva_id turismo_real.reserva.id_reserva%type;
    id_sr turismo_real.servicio_reserva.id_servicio_reserva%type;
    id_s turismo_real.servicio_reserva.id_servicio%type;
    servicio turismo_real.servicio.nombre_servicio%type;
    tipo turismo_real.tipo_servicio.tipo_servicio%type;
    valor turismo_real.servicio_reserva.valor%type;
    conductor turismo_real.servicio_reserva.id_conductor%type;
begin
    reserva_id := 2;
    sp_obten_servicios_reserva(reserva_id, servicios);
    
    loop fetch servicios into id_sr,id_s,servicio,tipo,valor,conductor;
        exit when servicios%notfound;
        
        dbms_output.put_line('ID: '||id_sr);
        dbms_output.put_line('ID Servicio: '||id_s);
        dbms_output.put_line('Servicio: '||servicio);
        dbms_output.put_line('Tipo: '||tipo);
        dbms_output.put_line('Valor: '||trim(to_char(valor, '$99g999g999')));
        dbms_output.put_line('Conductor: '||conductor);
        dbms_output.put_line('--------------------------');
        dbms_output.put_line('');
    end loop;
    close servicios;
end;