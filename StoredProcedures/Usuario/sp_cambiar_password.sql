-- SP CAMBIAR PASSWORD
create or replace procedure sp_cambiar_password(
    usuario_id in number,
    current_password in varchar,
    new_password in varchar,
    updated out number
) is 
    id_u turismo_real.usuario.id_usuario%type;
    pass turismo_real.usuario.password%type;
begin
    -- comprobar existencia de usuario
    select id_usuario into id_u
    from usuario
    where id_usuario = usuario_id;
    
    -- comprobar contraseña actual
    select password into pass
    from usuario
    where id_usuario = usuario_id;
    
    if current_password = pass then
        -- cambiar contraseña
        update usuario
            set password = new_password
        where id_usuario = id_u;
        commit;
        updated := 1; -- CONTRASEÑA ACTUALIZADA
    else
        updated := -2; -- CONTRASEÑA NO COINCIDE CON LA ACTUAL
    end if;
exception
    when no_data_found then updated := -1; -- NO EXISTE USUARIO
    when others then updated := 0; -- ERROR AL ACTUALIZAR
end;

-- PRUEBA SP
declare
    usuario_id turismo_real.usuario.id_usuario%type;
    current_pass turismo_real.usuario.password%type;
    new_pass turismo_real.usuario.password%type;
    updated number;
begin
    usuario_id := 3;
    current_pass := 'a60b85d409a01d46023f90741e01b79543a3cb1ba048eaefbe5d7a63638043bf';
    new_pass := 'AAAAAAA';
    sp_cambiar_password(usuario_id, current_pass, new_pass, updated);

    if updated > 0 then
        dbms_output.put_line('Contraseña actualizada.');
    elsif updated = -1 then
        dbms_output.put_line('No existe el usuario con id '||usuario_id);
    elsif updated = -2 then
        dbms_output.put_line('Contraseña no coincide con la actual.');
    else
        dbms_output.put_line('Error al actualizar contraseña.');
    end if;
end;