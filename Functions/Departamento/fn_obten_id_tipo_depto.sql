-- FN OBTEN ID TIPO DEPTO
create or replace function fn_obten_id_tipo_depto(tipo_d in varchar)
return number is 
    tipo_id integer := 0;
begin
    select t.id_tipo into tipo_id
    from tipo_departamento t
    where upper(t.tipo_departamento) = upper(tipo_d);

    return tipo_id;
exception
    when no_data_found then return 0;
end;

-- PRUEBA FN
declare
    tipo_id integer;
    tipo turismo_real.tipo_departamento.tipo_departamento%type;
begin
    tipo := 'normal';
    tipo_id := fn_obten_id_tipo_depto(tipo);
    dbms_output.put_line('ID TIPO ('||tipo||'): '||tipo_id);
end;