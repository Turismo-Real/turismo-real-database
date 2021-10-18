-- FN OBTENER TIPO USUARIO
create or replace function fn_obten_id_tipo_usuario(tipo_u varchar)
return number is
    tipo_id integer := 0;
begin
    select t.id_tipo into tipo_id
    from tipo_usuario t
    where upper(t.tipo) = upper(tipo_u);

    return tipo_id;
exception
    when no_data_found then return 0;
end;

-- PRUEBA FN
declare
    id_tipo integer;
    tipo varchar2(50);
begin
    tipo := 'cliente';
    id_tipo := fn_obten_id_tipo_usuario(tipo);
    dbms_output.put_line('ID TIPO USUARIO: '||id_tipo);
end;