-- SP OBTEN RESERVA POR ID
create or replace procedure sp_obten_reserva_id(reserva_id in number, reserva out sys_refcursor)
is begin
    open reserva for
        select
            id_reserva,fechora_reserva,
            to_char(fec_desde,'dd/mm/yyyy') as fec_desde,to_char(fec_hasta,'dd/mm/yyyy') as fec_hasta,
            valor_arriendo,fechora_checkin,fechora_checkout,checkin_conforme,checkout_conforme,
            estado_checkin,estado_checkout,estado,id_usuario,id_departamento
        from reserva join estado_reserva using(id_estado)
        where id_reserva = reserva_id;
end;

/

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    reserva ref_cur;
    reserva_id turismo_real.reserva.id_reserva%type;
    id_reserva turismo_real.reserva.id_reserva%type;
    fechora_reserva turismo_real.reserva.fechora_reserva%type;
    fec_desde turismo_real.reserva.fec_desde%type;
    fec_hasta turismo_real.reserva.fec_hasta%type;
    valor_arriendo turismo_real.reserva.valor_arriendo%type;
    fechora_checkin turismo_real.reserva.fechora_checkin%type;
    fechora_checkout turismo_real.reserva.fechora_checkout%type;
    checkin_conforme turismo_real.reserva.checkin_conforme%type;
    checkout_conforme turismo_real.reserva.checkout_conforme%type;
    estado_checkin turismo_real.reserva.estado_checkin%type;
    estado_checkout turismo_real.reserva.estado_checkout%type;
    estado turismo_real.estado_reserva.estado%type;
    id_usuario turismo_real.reserva.id_usuario%type;
    id_departamento turismo_real.reserva.id_departamento%type;
begin
    reserva_id := 3;
    sp_obten_reserva_id(reserva_id, reserva);

    loop fetch reserva into id_reserva,fechora_reserva,fec_desde,fec_hasta,
        valor_arriendo,fechora_checkin,fechora_checkout,checkin_conforme,
        checkout_conforme,estado_checkin,estado_checkout,estado,
        id_usuario,id_departamento;
        exit when reserva%notfound;
        
        dbms_output.put_line('ID: '||id_reserva);
        dbms_output.put_line('Fecha reserva: '||fechora_reserva);
        dbms_output.put_line('Desde: '||trunc(fec_desde));
        dbms_output.put_line('Hasta: '||trunc(fec_hasta));
        dbms_output.put_line('Valor: '||to_char(valor_arriendo,'$999g999'));
        dbms_output.put_line('Fecha check in: '||fechora_checkin);
        dbms_output.put_line('Fecha check out: '||fechora_checkout);
        dbms_output.put_line('Ingreso conforme: '||checkin_conforme);
        dbms_output.put_line('Retiro conforme: '||checkout_conforme);
        dbms_output.put_line('Estado check in: '||estado_checkin);
        dbms_output.put_line('Estado check out: '||estado_checkout);
        dbms_output.put_line('Estado reserva: '||estado);
        dbms_output.put_line('ID Usuario: '||id_usuario);
        dbms_output.put_line('ID Departamento: '||id_departamento);
        dbms_output.put_line('-----------------------------');
        dbms_output.put_line('');
    end loop;
    close reserva;
end;