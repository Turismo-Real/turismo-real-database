-- SP OBTEN IMAGEN DEPTO
create or replace procedure sp_obten_imagenes_depto(
    depto_id in number,
    imagenes out sys_refcursor
) is begin
    open imagenes for
        select id_imagen, nombre, formato, imagen
        from imagen
        where id_departamento = depto_id
        order by id_imagen;
end;