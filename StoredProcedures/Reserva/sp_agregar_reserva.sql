-- SP AGREGAR RESERVA
create or replace procedure sp_agregar_reserva(
    fec_desde_r in varchar,
    fec_hasta_r in varchar,
    id_usuario_r in number,
    id_departamento_r in number,
    saved out number
) is
    reserva_id turismo_real.reserva.id_reserva%type;
    fec_desde_in turismo_real.reserva.fec_desde%type;
    fec_hasta_in turismo_real.reserva.fec_hasta%type;
    estado_id turismo_real.estado_depto.estado%type;
    tope_reservas number;
    dias_arriendo number;
    valor_total_arriendo number;
    cliente_id number;
    depto_id number;
    tope_reserva number;
begin
    -- comprobar existencia de cliente
    cliente_id := fn_obten_cliente(id_usuario_r);
    -- comprobar existencia de departamento
    depto_id := fn_obten_depto(id_departamento_r);   
    
    if cliente_id > 0 and depto_id > 0 then
        -- convertir str fecha entrada a tipo fecha
        fec_desde_in := to_date(fec_desde_r);
        fec_hasta_in := to_date(fec_hasta_r);
        -- obtener topes de fecha con otras reservas
        tope_reserva := fn_obten_tope_reserva(depto_id, fec_desde_in, fec_hasta_in);
        -- obtener dias de arriendo
        dias_arriendo := fn_calcular_dias_arriendo(fec_desde_in, fec_hasta_in);
        
        if tope_reserva = 0 and dias_arriendo <= 30 then
            -- obtener valor arriendo
            valor_total_arriendo := fn_caclular_total_arriendo(depto_id, dias_arriendo);
            -- obtener id estado reserva (default CARGADA)
            estado_id := fn_obten_id_estado_reserva('CARGADA');
            -- generar id reserva
            reserva_id := seq_reserva.nextval;
            
            -- crear nueva reserva
            insert into reserva(id_reserva,fechora_reserva,fec_desde,fec_hasta,valor_arriendo,id_estado,id_departamento,id_usuario)
                values(reserva_id,sysdate,fec_desde_in,fec_hasta_in,valor_total_arriendo,estado_id,depto_id,cliente_id);

            commit;            
            saved := reserva_id; -- OK: RETORNA ID RESERVA
        else
            if tope_reserva > 0 then
                saved := -3; -- ERROR: YA EXISTE UNA RESERVA EN TAL FECHA
            elsif dias_arriendo > 30 then
                saved := -4; -- ERROR: 30 DIAS MAXIMO RESERVA
            end if;
        
        end if;       
    else
        if cliente_id = 0 then
            saved := -1; -- ERROR: CLIENTE NO EXISTE 
        elsif depto_id = 0 then
            saved := -2; -- ERROR: DEPTO NO EXISTE
        end if;
    end if;
exception
    when others then
        saved := 0; -- ERROR AL AGREGAR RESERVA
end;

-- PRUEBA SP
declare
    desde turismo_real.reserva.fec_desde%type := to_date('20/11/2021');
    hasta turismo_real.reserva.fec_hasta%type := to_date('23/11/2021');
    usuario turismo_real.usuario.id_usuario%type := 5;
    depto turismo_real.departamento.id_departamento%type := 3;
    saved number;
begin
    sp_agregar_reserva(desde,hasta,usuario,depto,saved);
    
    if saved > 0 then
        dbms_output.put_line('Reserva agregada.');
    elsif saved = -1 then
        dbms_output.put_line('Cliente no existe.');
    elsif saved = -2 then
        dbms_output.put_line('Departamento no existe.');
    elsif saved = -3 then
        dbms_output.put_line('Ya existe una reserva en las fechas ingresadas.');
    elsif saved = -4 then
        dbms_output.put_line('La reserva no debe superar los 30 días.');
    else
        dbms_output.put_line('Error al agregar reserva.');
    end if;
end;