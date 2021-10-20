-- SP OBTEN SERVICIOS
create or replace procedure sp_obten_servicios(servicios out sys_refcursor)
is begin
    open servicios for
        select
            id_servicio, nombre_servicio, descripcion, valor, tipo_servicio
        from servicio join tipo_servicio using(id_tipo_servicio);
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    servicios ref_cur;
    id_servicio turismo_real.servicio.id_servicio%type;
    nombre turismo_real.servicio.nombre_servicio%type;
    descripcion turismo_real.servicio.descripcion%type;
    valor turismo_real.servicio.valor%type;
    tipo turismo_real.tipo_servicio.tipo_servicio%type;
begin
    sp_obten_servicios(servicios);

    loop fetch servicios into id_servicio,nombre,descripcion,valor,tipo;
        exit when servicios%notfound;
        
        dbms_output.put_line('ID: '||id_servicio);
        dbms_output.put_line('Servicio: '||nombre);
        dbms_output.put_line('Descripción: '||descripcion);
        dbms_output.put_line('Valor: '||trim(to_char(valor, '$999g999')));
        dbms_output.put_line('Tipo: '||tipo);
        dbms_output.put_line('-----------------------------');
        dbms_output.put_line('');
    end loop;
    close servicios;
end;