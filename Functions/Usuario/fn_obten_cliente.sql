-- FN OBTEN CLIENTE
create or replace function fn_obten_cliente(cliente_id in number)
return number
is
    id_c turismo_real.usuario.id_usuario%type;
begin
    select id_usuario into id_c
    from usuario join tipo_usuario using(id_tipo)
    where upper(tipo) = 'CLIENTE'
    and id_usuario = cliente_id;
    
    return id_c; -- RETORNA ID CLIENTE
exception
    when no_data_found then
        return 0; -- NO EXISTE ID CLIENTE
    when others then
        return 0; -- ERROR
end;

-- PRUEBA FN
declare
    cliente_id turismo_real.usuario.id_usuario%type;
    id_c turismo_real.usuario.id_usuario%type;
begin
    cliente_id := 4;
    id_c := fn_obten_cliente(cliente_id);
    
    if id_c > 0 then
        dbms_output.put_line('Cliente existe');
    else
        dbms_output.put_line('Cliente no existe');
    end if;
end;