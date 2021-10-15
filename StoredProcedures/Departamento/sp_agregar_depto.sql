-- SP AGREGAR DEPARTAMENTO
create or replace procedure sp_agregar_depto(
    rol_d in varchar,
    dormitorios_d in number,
    banios_d in number,
    descripcion_d in varchar,
    superficie_d in number,
    valor_diario_d in number,
    tipo_d in varchar,
    comuna_d in varchar,
    calle_d in varchar,
    numero_d in varchar,
    depto_d in varchar,
    saved out number
)
is
    comuna_id number;
    tipo_id number := 0;
    estado_id number;
    depto_id number;
begin
    comuna_id := fn_obten_id_comuna(comuna_d);
    tipo_id := fn_obten_id_tipo_depto(tipo_d);
    -- ESTADO POR DEFECTO
    estado_id := fn_obten_id_estado_depto('Cargado');
    depto_id := seq_departamento.nextval;

    -- INGRESAR DEPARTAMENTO
    insert into departamento(id_departamento,rol,dormitorio,banios,descripcion,superficie,valor_diario,id_tipo,id_estado)
        values(depto_id,rol_d,dormitorios_d,banios_d,descripcion_d,superficie_d,valor_diario_d,tipo_id,estado_id);    
    
    -- INGRESAR DIRECCION
    insert into direccion(id_direccion,id_departamento,numrut,id_comuna,calle,numero,depto)
        values(seq_direccion.nextval,depto_id,null,comuna_id,calle_d,numero_d,depto_d);

    -- RETORNA EL ID DEL DEPARTAMENTO
    saved := depto_id;
    commit;

exception when others then
    saved := 0;
    rollback;
end;

-- PRUEBA SP
declare
    saved number;
begin
    sp_agregar_depto('023-458',3,2,'Descripcion de prueba Y',90,70000,'NORmal','La reina','Santa anita','223','22',saved);
    
    dbms_output.put_line('ID DEPTO: '||saved);
    if saved > 0 then
        dbms_output.put_line('true');
    else
        dbms_output.put_line('false');
    end if;
end;