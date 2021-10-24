-- FN OBTEN VALOR ARRIENDO
create or replace function fn_obten_valor_arriendo(depto_id in number)
return number is
    valor turismo_real.departamento.valor_diario%type;
begin
    select valor_diario into valor
    from departamento
    where id_departamento = depto_id;

    return valor;
exception
    when no_data_found then return 0;
    when others then return 0;
end;

-- PRUEBA FN
declare
    depto_id turismo_real.departamento.id_departamento%type;
    valor turismo_real.departamento.valor_diario%type;
begin
    depto_id := 1;
    valor := fn_obten_valor_arriendo(depto_id);

    dbms_output.put_line('Valor diario arriendo: '||trim(to_char(valor,'$99g999g999')));
end;