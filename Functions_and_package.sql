-- FN OBTENER ID GENERO
create or replace function fn_obten_id_genero(genero_in in varchar)
return number is 
    idgenero number := 0;
begin
    select g.id_genero into idgenero
    from genero g
    where upper(g.genero) = upper(genero_in);

    return idgenero; 

exception
    when no_data_found then return 0;
end;

/

-- FN OBTENER ID PAIS
create or replace function fn_obten_id_pais(nombre_pais varchar)
return number is 
    pais_id integer := 0;
begin
    select p.id_pais into pais_id
    from pais p
    where upper(p.pais) = upper(nombre_pais);

    return pais_id;
exception
    when no_data_found then return 0;
end;

/

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