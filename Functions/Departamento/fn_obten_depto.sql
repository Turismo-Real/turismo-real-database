-- FN OBTEN DEPTO
create or replace function fn_obten_depto(depto_id in number)
return number is
    id_d turismo_real.departamento.id_departamento%type;
begin
    select id_departamento into id_d
    from departamento
    where id_departamento = depto_id;
    
    return id_d;
exception
    when no_data_found then return 0;
    when others then return 0;
end;

-- PRUEBA FN
declare
    depto_id turismo_real.departamento.id_departamento%type;
    id_d turismo_real.departamento.id_departamento%type;
begin
    depto_id := 1;
    id_d := fn_obten_depto(depto_id);
    
    if id_d > 0 then
        dbms_output.put_line('Departamento existe.');
    else
        dbms_output.put_line('Departamento no existe.');
    end if;
end;