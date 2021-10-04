-- SP EDITAR DEPTO
create or replace procedure sp_editar_depto(
    id_d in number,
    rol_d in varchar,
    dormitorios_d in number,
    banios_d in number,
    descripcion_d in varchar,
    superficie_d in number,
    valor_diario_d in number,
    tipo_d in varchar,
    estado_d in varchar,
    updated out boolean
)
-- TODO: repair
is
    tipo_id number;
    estado_id number;
begin
    update departamento set
        rol = rol_d,
        dormitorio = dormitorios_d,
        banios = banios_d,
        descripcion = descripcion_d,
        superficie = superficie_d,
        valor_diario = valor_diario_d,
        id_tipo = tipo_id,
        id_estado = estado_id
    where id_departamento = id_d;

    updated := true;
    commit;
exception when others then
    updated := false;
end;

-- PRUEBA SP
declare
    updated boolean;
begin
    sp_editar_depto(6,'006-099',3,1,'Descripcion de prueba Y',90,75000,'DupleX','En espera',updated);

    if updated = true then
        dbms_output.put_line('true');
    else
        dbms_output.put_line('false');
    end if;
end;


