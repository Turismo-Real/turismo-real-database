-- SP AGREGAR ASISTENTE RESERVA
create or replace procedure sp_agregar_asistente_reserva(
    reserva_id in number,
    pasaporte in varchar,
    numrut in varchar,
    dvrut in varchar,
    pnombre in varchar,
    snombre in varchar,
    papellido in varchar,
    sapellido in varchar,
    correo in varchar,
    saved out number
)is
    id_a_r turismo_real.asistente_reserva.id_asistente_reserva%type;
    asistente_id turismo_real.asistente.id_asistente%type;
    existe_reserva_asistente turismo_real.asistente_reserva.id_asistente_reserva%type;
    existe_reserva number;
begin
    -- comprobar existencia reserva
    select count(*) into existe_reserva
    from reserva where id_reserva = reserva_id;

    if existe_reserva > 0 then -- existe reserva
        -- comprobar existencia asistente
        asistente_id := fn_existe_asistente(pasaporte, numrut);

        if asistente_id = 0 then -- no existe asistente
            asistente_id := fn_agregar_asistente(pasaporte,numrut,dvrut,pnombre,snombre,papellido,sapellido,correo);
        end if;
        
        -- comprobar existencia par asistente-reserva
        select count(*) into existe_reserva_asistente
        from asistente_reserva
        where id_reserva = reserva_id and id_asistente = asistente_id;
        
        if existe_reserva_asistente = 0 then -- no existe par asistente-reserva
            if asistente_id > 0 then
                -- obtener id asistente-reserva
                id_a_r := seq_asistente_reserva.nextval;
                insert into asistente_reserva(id_asistente_reserva,id_reserva,id_asistente)
                values(id_a_r,reserva_id,asistente_id);
                commit;
                saved := id_a_r; -- ASISTENTE-RESERVA AGREGADO
            end if;
        else
            saved := -2; -- EXISTE PAR RESERVA-ASISTENTE
        end if;
    else
        saved := -1; -- NO EXISTE RESERVA
    end if;
exception
    when others then saved := 0; -- ERROR
end;

-- PRUEBA SP
declare
    reserva_id turismo_real.reserva.id_reserva%type;
    pasaporte turismo_real.asistente.pasaporte%type;
    numrut turismo_real.asistente.numrut_asistente%type;
    dvrut turismo_real.asistente.dvrut_asistente%type;
    pnombre turismo_real.asistente.pnombre_asistente%type;
    snombre turismo_real.asistente.snombre_asistente%type;
    papellido turismo_real.asistente.apepat_asistente%type;
    sapellido turismo_real.asistente.apemat_asistente%type;
    correo turismo_real.asistente.correo_asistente%type;
    saved number;
begin
    reserva_id := 1;
    pasaporte := '222222';
    numrut := '';
    dvrut := '';
    pnombre := 'Filomena';
    snombre := 'Adelina';
    papellido := 'Hervas';
    sapellido := 'Fonseca';
    correo := 'fhervas@gmail.com';
    sp_agregar_asistente_reserva(reserva_id,pasaporte,numrut,dvrut,pnombre,snombre,papellido,sapellido,correo,saved);
    
    if saved > 0 then
        dbms_output.put_line('Reserva agregada con id '||saved||'.');
    elsif saved = -1 then
        dbms_output.put_line('Reserva no existe.');
    elsif saved = -2 then
        dbms_output.put_line('Existe par asistente-reserva.');
    else
        dbms_output.put_line('Error al agregar reserva.');
    end if;
end;