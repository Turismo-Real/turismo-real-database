-- FN OBTENER ID GENERO
create or replace function fn_obten_id_genero(genero_in in varchar)
return number is 
    idgenero number := 0;
begin
    select g.id_genero into idgenero
    from genero g
    where upper(g.genero) = upper(genero_in);

    return idgenero; 

exception
    when no_data_found then return 0;
end;

-- PRUEBA FN
declare
    id_genero integer;
    genero varchar2(100);
begin
    genero := 'femenino';
    id_genero := fn_obten_id_genero(genero);
    dbms_output.put_line('ID GENERO: '||id_genero);
end;