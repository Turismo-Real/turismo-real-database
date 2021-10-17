-- SP OBTEN PAISES
create or replace procedure sp_obten_paises(paises out sys_refcursor)
is begin
    open paises for select pais from pais;
end;

-- PRUEBA SP
declare
    type ref_cur is ref cursor;
    paises ref_cur;
    pais turismo_real.pais.pais%type;
begin
    sp_obten_paises(paises);

    loop fetch paises into pais;
        exit when paises%notfound;

        dbms_output.put_line(pais);
    end loop;
    close paises;
end;