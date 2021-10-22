-- FN CALCULAR TOTAL ARRIENDO
create or replace function fn_caclular_total_arriendo(depto_id in number, dias in number)
return number is
    total number;
begin
    select (valor_diario * dias) into total
    from departamento
    where id_departamento = depto_id;
    
    return total;
exception
    when no_data_found then
        return 0;
    when others then return 0;
end;

-- PRUEBA FN
declare
    depto_id turismo_real.departamento.id_departamento%type;
    dias number;
    total number;
begin
    depto_id := 3;
    dias := 10;
    total := fn_caclular_total_arriendo(depto_id, dias);
    
    if total > 0 then
        dbms_output.put_line('Valor total por '||dias||' días: '||trim(to_char(total, '$9g999g999')));
    else
        dbms_output.put_line('No existe departamento');
    end if;
end;