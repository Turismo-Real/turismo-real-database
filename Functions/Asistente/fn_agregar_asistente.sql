-- FN AGREGAR ASISTENTE
create or replace function fn_agregar_asistente(
    pasaporte_a in varchar,
    numrut_a in varchar, dvrut_a in varchar,
    pnom_a in varchar, snom_a in varchar,
    pape_a in varchar, sape_a in varchar, correo_a in varchar
) return number is
    new_id turismo_real.asistente.id_asistente%type;
begin
    new_id := seq_asistente.nextval;
    insert into asistente(id_asistente,pasaporte,numrut_asistente,dvrut_asistente,pnombre_asistente,snombre_asistente,apepat_asistente,apemat_asistente,correo_asistente)
    values (new_id,pasaporte_a,numrut_a,dvrut_a,pnom_a,snom_a,pape_a,sape_a,correo_a);
    commit;
    return new_id; -- ASISTENTE AGREGADO
exception
    when others then return 0; -- ERROR AL AGREGAR
end;

-- PRUEBA FN
declare
    pasaporte turismo_real.asistente.pasaporte%type;
    numrut turismo_real.asistente.numrut_asistente%type;
    dvrut turismo_real.asistente.dvrut_asistente%type;
    pnom turismo_real.asistente.pnombre_asistente%type;
    snom turismo_real.asistente.snombre_asistente%type;
    pape turismo_real.asistente.apepat_asistente%type;
    sape turismo_real.asistente.apemat_asistente%type;
    correo turismo_real.asistente.correo_asistente%type;
    saved number;
begin
    pasaporte := '333222';
    numrut := '';
    dvrut := '';
    pnom := 'Luis';
    snom := 'Antonio';
    pape := 'Gutierrez';
    sape := 'Fernandez';
    correo := 'lu.guti.fern@gmail.com';
    saved := fn_agregar_asistente(pasaporte,numrut,dvrut,pnom,snom,pape,sape,correo);
    
    if saved > 0 then
        dbms_output.put_line('Asistente agregado con id '||saved||'.');
    else
        dbms_output.put_line('Error al agregar asistente.');
    end if;
end;