-- SP AGREGAR DEPARTAMENTO
create or replace sp_agregar_depto(
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
    estado_default := 
begin
    fn_obten_id_tipo_depto(tipo_d);


end;