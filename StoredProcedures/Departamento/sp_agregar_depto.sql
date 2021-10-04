-- SP AGREGAR DEPARTAMENTO
create or replace procedure sp_agregar_depto(
    rol_d in varchar,
    dormitorios_d in number,
    banios_d in number,
    descripcion_d in varchar,
    superficie_d in number,
    valor_diario_d in number,
    tipo_d in varchar,
    saved out boolean
)
is
    tipo_id number := 0;
    estado_id number; 
begin
    tipo_id := fn_obten_id_tipo_depto(tipo_d);
    estado_id := fn_obten_id_estado_depto('En espera'); -- default

    insert into departamento(id_departamento,rol,dormitorio,banios,descripcion,superficie,valor_diario,id_tipo,id_estado)
        values(seq_departamento.nextval,rol_d,dormitorios_d,banios_d,descripcion_d,superficie_d,valor_diario_d,tipo_id,estado_id);
    saved := true;
    commit;

exception when others then
    saved := false;
end;

-- PRUEBA SP
declare
    saved boolean;
begin
    sp_agregar_depto('023-455',3,2,'Descripcion de prueba a', 90,70000,'NORmal',saved);
    --sp_agregar_depto('026-456',4,2,'Descripcion de prueba b', 130,180000,'duPLEX',saved);
    --sp_agregar_depto('029-459',2,1,'Descripcion de prueba c', 110,120000,'ESTudiO',saved);
    
    if saved = true then
        dbms_output.put_line('true');
    else
        dbms_output.put_line('false');
    end if;
end;