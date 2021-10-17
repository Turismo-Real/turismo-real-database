-- SP OBTEN DEPARTAMENTOS
create or replace procedure sp_obten_deptos(deptos out sys_refcursor)
is begin
    open deptos for
        select
            id_departamento, rol, dormitorio, banios, descripcion,
            superficie, valor_diario, tipo_departamento, estado,
            region, comuna, calle, numero, depto
        from departamento join direccion using(id_departamento)
        join comuna using(id_comuna)
        join region using(id_region)
        join tipo_departamento using(id_tipo)
        join estado_depto using(id_estado)
        order by id_departamento;
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    c_deptos ref_cur;
    id_departamento turismo_real.departamento.id_departamento%type;
    rol turismo_real.departamento.rol%type;
    dormitorio turismo_real.departamento.dormitorio%type;
    banios turismo_real.departamento.banios%type;
    descripcion turismo_real.departamento.descripcion%type;
    superficie turismo_real.departamento.superficie%type;
    valor_diario turismo_real.departamento.valor_diario%type;
    tipo_departamento turismo_real.tipo_departamento.tipo_departamento%type;
    estado turismo_real.estado_depto.estado%type;
    region turismo_real.region.region%type;
    comuna turismo_real.comuna.comuna%type;
    calle turismo_real.direccion.calle%type;
    numero turismo_real.direccion.numero%type;
    depto turismo_real.direccion.depto%type;
begin
    sp_obten_deptos(c_deptos);
    
    loop fetch c_deptos into id_departamento,rol,dormitorio,banios,descripcion,
        superficie,valor_diario,tipo_departamento,estado,region,comuna,calle,
        numero,depto;
        exit when c_deptos%notfound;
        
        dbms_output.put_line('ID: '||id_departamento);
        dbms_output.put_line('ROL: '||rol);
        dbms_output.put_line('Dormitorios: '||dormitorio);
        dbms_output.put_line('Baños: '||banios);
        dbms_output.put_line('Descripción: '||descripcion);
        dbms_output.put_line('Superficie (m2): '||superficie);
        dbms_output.put_line('Valor diario: '||valor_diario);
        dbms_output.put_line('Tipo: '||tipo_departamento);
        dbms_output.put_line('Estado: '||estado);
        dbms_output.put_line('Región: '||region);
        dbms_output.put_line('Comuna: '||comuna);
        dbms_output.put_line('Calle: '||calle);
        dbms_output.put_line('Número: '||numero);
        dbms_output.put_line('N° Departamento: '||depto);
        dbms_output.put_line('-----------------------------');
        dbms_output.put_line('');
    end loop;
    close c_deptos;
end;