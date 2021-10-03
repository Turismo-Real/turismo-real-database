-- FN OBTENER ID GENERO
create or replace function fn_obten_id_genero(genero varchar) return integer
is 
    id_genero integer := 0;
begin
    select g.id_genero into id_genero
    from genero g
    where upper(g.genero) = upper(genero);

    return id_genero; 
end;

/

-- FN OBTENER ID PAIS
create or replace function fn_obten_id_pais(pais varchar) return integer
is 
    id_pais integer := 0;
begin
    select p.id_pais into id_pais
    from pais p
    where upper(p.pais) = upper(pais);

    return id_pais;
end;

/

-- FN OBTENER TIPO USUARIO
create or replace function fn_obten_id_tipo(tipo varchar) return integer
is 
    id_tipo integer := 0;
begin
    select t.id_tipo into id_tipo
    from tipo_usuario t
    where upper(t.tipo) = upper(tipo);

    return id_tipo;
end;