-- FN OBTENER ID PAIS
create or replace function fn_obten_id_pais(nombre_pais varchar)
return number is 
    pais_id integer := 0;
begin
    select p.id_pais into pais_id
    from pais p
    where upper(p.pais) = upper(nombre_pais);

    return pais_id;
exception
    when no_data_found then return 0;
end;

-- PRUEBA FN
declare
    id_pais integer;
    pais varchar2(100);
begin
    pais := 'Chile';
    id_pais := fn_obten_id_pais(pais);
    dbms_output.put_line('ID PAIS: '||id_pais);
end;