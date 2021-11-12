-- SP OBTEN ASISTENTES DE RESERVA
create or replace procedure sp_obten_asistentes_reserva(
    reserva_id in number,
    asistentes out sys_refcursor
) is begin
    open asistentes for
        select
            pasaporte, numrut_asistente, dvrut_asistente,
            pnombre_asistente, snombre_asistente, apepat_asistente,
            apemat_asistente, correo_asistente
        from asistente_reserva join asistente using(id_asistente)
        where id_reserva = reserva_id;
end;


-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    asistentes ref_cur;
    reserva_id turismo_real.reserva.id_reserva%type;
    pasaporte turismo_real.asistente.pasaporte%type;
    numrut turismo_real.asistente.numrut_asistente%type;
    dvrut turismo_real.asistente.dvrut_asistente%type;
    pnombre turismo_real.asistente.pnombre_asistente%type;
    snombre turismo_real.asistente.snombre_asistente%type;
    apepat turismo_real.asistente.apepat_asistente%type;
    apemat turismo_real.asistente.apemat_asistente%type;
    correo turismo_real.asistente.correo_asistente%type;
begin
    reserva_id := 2;
    sp_obten_asistentes_reserva(reserva_id, asistentes);

    loop fetch asistentes into pasaporte,numrut,dvrut,pnombre,snombre,
        apepat,apemat,correo;
        exit when asistentes%notfound;
    
        dbms_output.put_line('Pasaporte: '||pasaporte);
        dbms_output.put_line('RUT: '||numrut||'-'||dvrut);
        dbms_output.put_line('Nombres: '||pnombre||' '||snombre);
        dbms_output.put_line('Apellidos: '||apepat||' '||apemat);
        dbms_output.put_line('Correo: '||correo);
        dbms_output.put_line('');
        dbms_output.put_line('------------------------');
    end loop;
    close asistentes;
end;