-- FN OBTEN ID COMUNA
create or replace function fn_obten_id_comuna(comuna_c in varchar)
return number is
    comuna_id number;
begin
    select c.id_comuna into comuna_id
    from comuna c
    where upper(c.comuna) = upper(comuna_c);

    return comuna_id;
exception
    when no_data_found then return 0;
    when others then return 0;
end;

-- PRUEBA FN
declare
    comuna_id number;
begin
    comuna_id := fn_obten_id_comuna('Placilla');
    dbms_output.put_line(comuna_id);
end;