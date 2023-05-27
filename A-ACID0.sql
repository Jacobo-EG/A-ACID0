-- Desde system creamos los tablespaces y le damos a pevau los permisos necesarios 
create tablespace TS_PEVAU datafile 'TSPEVAU.dbf' size 50M autoextend ON;
create tablespace TS_INDICES datafile 'TSINDICES.dbf' size 50M autoextend ON;

create user PEVAU identified by "febrero2023" default tablespace TS_PEVAU
quota unlimited on TS_PEVAU;
grant connect, create table, create view, create materialized view,
create procedure, create trigger, create sequence to PEVAU;
alter user PEVAU quota unlimited on TS_INDICES;
grant read, write on directory directorio_ext to PEVAU;

-- Podemos comprobarlo con las siguientes instrucciones
SELECT * FROM DBA_TABLESPACES;
SELECT * FROM dba_data_files WHERE tablespace_name = 'TS_PEVAU' OR tablespace_name = 'TS_INDICES';

-- Desde pevau creamos el esquema de la base de datos
-- Generado por Oracle SQL Developer Data Modeler 22.2.0.165.1149
--   en:        2023-02-18 18:14:18 CET
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE ane (
    dni        VARCHAR2(9 CHAR) NOT NULL,
    descabezar CHAR(1),
    aulaaparte CHAR(1)
);

ALTER TABLE ane ADD CONSTRAINT ane_pk PRIMARY KEY ( dni );

CREATE TABLE asistencia (
    asiste              CHAR(1),
    entrega             CHAR(1),
    estudiante_dni      VARCHAR2(9 CHAR) NOT NULL,
    materia_codigo      VARCHAR2(10 CHAR) NOT NULL,
    examen_fechayhora   DATE NOT NULL,
    examen_aula_codigo  INTEGER NOT NULL,
    examen_aula_codigo1 INTEGER NOT NULL
);

ALTER TABLE asistencia
    ADD CONSTRAINT asistencia_pk PRIMARY KEY ( estudiante_dni,
                                               materia_codigo,
                                               examen_fechayhora,
                                               examen_aula_codigo,
                                               examen_aula_codigo1 );

CREATE TABLE aula (
    codigo           INTEGER NOT NULL,
    capacidad        INTEGER NOT NULL,
    capacidad_examen INTEGER NOT NULL,
    descripci�n      VARCHAR2(500),
    sede_codigo      INTEGER NOT NULL
);

ALTER TABLE aula ADD CONSTRAINT aula_pk PRIMARY KEY ( codigo,
                                                      sede_codigo );

CREATE TABLE centro (
    codigo      INTEGER NOT NULL,
    nombre      VARCHAR2(500 CHAR) NOT NULL,
    direccion   VARCHAR2(500 CHAR),
    poblacion   VARCHAR2(500 CHAR),
    sede_codigo INTEGER NOT NULL
);

ALTER TABLE centro ADD CONSTRAINT centro_pk PRIMARY KEY ( codigo );

CREATE TABLE estudiante (
    dni           VARCHAR2(9 CHAR) NOT NULL,
    nombre        VARCHAR2(500 CHAR) NOT NULL,
    apellidos     VARCHAR2(500 CHAR) NOT NULL,
    telefono      VARCHAR2(9 CHAR) NOT NULL,
    correoe       VARCHAR2(500 CHAR),
    centro_codigo INTEGER NOT NULL
);

ALTER TABLE estudiante ADD CONSTRAINT estudiante_pk PRIMARY KEY ( dni );

CREATE TABLE "Estudiante-Materia" (
    estudiante_dni VARCHAR2(9 CHAR) NOT NULL,
    materia_codigo VARCHAR2(10 CHAR) NOT NULL
);

ALTER TABLE "Estudiante-Materia" ADD CONSTRAINT "Estudiante-Materia_PK" PRIMARY KEY ( estudiante_dni,
                                                                                      materia_codigo );

CREATE TABLE examen (
    fechayhora   DATE NOT NULL,
    aula_codigo  INTEGER NOT NULL,
    aula_codigo1 INTEGER NOT NULL,
    vocal_dni    VARCHAR2(9 CHAR) NOT NULL
);

ALTER TABLE examen
    ADD CONSTRAINT examen_pk PRIMARY KEY ( fechayhora,
                                           aula_codigo,
                                           aula_codigo1 );

CREATE TABLE "Examen-Materia" (
    examen_fechayhora   DATE NOT NULL,
    examen_aula_codigo  INTEGER NOT NULL,
    examen_aula_codigo1 INTEGER NOT NULL,
    materia_codigo      VARCHAR2(10 CHAR) NOT NULL
);

ALTER TABLE "Examen-Materia"
    ADD CONSTRAINT "Examen-Materia_PK" PRIMARY KEY ( examen_fechayhora,
                                                     examen_aula_codigo,
                                                     examen_aula_codigo1,
                                                     materia_codigo );

CREATE TABLE materia (
    codigo VARCHAR2(10 CHAR) NOT NULL,
    nombre VARCHAR2(500 CHAR) NOT NULL
);

ALTER TABLE materia ADD CONSTRAINT materia_pk PRIMARY KEY ( codigo );

CREATE TABLE sede (
    codigo     INTEGER NOT NULL,
    nombre     VARCHAR2(500 CHAR) NOT NULL,
    tipo       VARCHAR2(500 CHAR),
    vocal_dni  VARCHAR2(9 CHAR) NOT NULL,
    vocal_dni2 VARCHAR2(9 CHAR) NOT NULL
);

CREATE UNIQUE INDEX sede__idx ON
    sede (
        vocal_dni
    ASC );

CREATE UNIQUE INDEX sede__idxv1 ON
    sede (
        vocal_dni2
    ASC );

ALTER TABLE sede ADD CONSTRAINT sede_pk PRIMARY KEY ( codigo );

CREATE TABLE vocal (
    dni            VARCHAR2(9 CHAR) NOT NULL,
    nombre         VARCHAR2(500 CHAR) NOT NULL,
    apellidos      VARCHAR2(500 CHAR) NOT NULL,
    tipo           VARCHAR2(500),
    cargo          VARCHAR2(500 CHAR),
    materia_codigo VARCHAR2(10 CHAR)
);

ALTER TABLE vocal ADD CONSTRAINT vocal_pk PRIMARY KEY ( dni );

CREATE TABLE "Vocal-Examen-Vocales" (
    vocal_dni           VARCHAR2(9 CHAR) NOT NULL,
    examen_fechayhora   DATE NOT NULL,
    examen_aula_codigo  INTEGER NOT NULL,
    examen_aula_codigo1 INTEGER NOT NULL
);

ALTER TABLE "Vocal-Examen-Vocales"
    ADD CONSTRAINT "Vocal-Examen-Vocales_PK" PRIMARY KEY ( vocal_dni,
                                                           examen_fechayhora,
                                                           examen_aula_codigo,
                                                           examen_aula_codigo1 );

ALTER TABLE ane
    ADD CONSTRAINT ane_estudiante_fk FOREIGN KEY ( dni )
        REFERENCES estudiante ( dni );

ALTER TABLE asistencia
    ADD CONSTRAINT asistencia_estudiante_fk FOREIGN KEY ( estudiante_dni )
        REFERENCES estudiante ( dni );

ALTER TABLE asistencia
    ADD CONSTRAINT asistencia_examen_fk FOREIGN KEY ( examen_fechayhora,
                                                      examen_aula_codigo,
                                                      examen_aula_codigo1 )
        REFERENCES examen ( fechayhora,
                            aula_codigo,
                            aula_codigo1 );

ALTER TABLE asistencia
    ADD CONSTRAINT asistencia_materia_fk FOREIGN KEY ( materia_codigo )
        REFERENCES materia ( codigo );

ALTER TABLE aula
    ADD CONSTRAINT aula_sede_fk FOREIGN KEY ( sede_codigo )
        REFERENCES sede ( codigo );

ALTER TABLE centro
    ADD CONSTRAINT centro_sede_fk FOREIGN KEY ( sede_codigo )
        REFERENCES sede ( codigo );

ALTER TABLE "Estudiante-Materia"
    ADD CONSTRAINT estmat_estudiante_fk FOREIGN KEY ( estudiante_dni )
        REFERENCES estudiante ( dni );

ALTER TABLE "Estudiante-Materia"
    ADD CONSTRAINT estmat_materia_fk FOREIGN KEY ( materia_codigo )
        REFERENCES materia ( codigo );

ALTER TABLE estudiante
    ADD CONSTRAINT estudiante_centro_fk FOREIGN KEY ( centro_codigo )
        REFERENCES centro ( codigo );

ALTER TABLE examen
    ADD CONSTRAINT examen_aula_fk FOREIGN KEY ( aula_codigo,
                                                aula_codigo1 )
        REFERENCES aula ( codigo,
                          sede_codigo );

ALTER TABLE examen
    ADD CONSTRAINT examen_vocal_fk FOREIGN KEY ( vocal_dni )
        REFERENCES vocal ( dni );

ALTER TABLE "Examen-Materia"
    ADD CONSTRAINT "Examen-Materia_EXAMEN_FK" FOREIGN KEY ( examen_fechayhora,
                                                            examen_aula_codigo,
                                                            examen_aula_codigo1 )
        REFERENCES examen ( fechayhora,
                            aula_codigo,
                            aula_codigo1 );

ALTER TABLE "Examen-Materia"
    ADD CONSTRAINT "Examen-Materia_MATERIA_FK" FOREIGN KEY ( materia_codigo )
        REFERENCES materia ( codigo );

ALTER TABLE sede
    ADD CONSTRAINT sede_vocal_fk FOREIGN KEY ( vocal_dni )
        REFERENCES vocal ( dni );

ALTER TABLE sede
    ADD CONSTRAINT sede_vocal_fkv2 FOREIGN KEY ( vocal_dni2 )
        REFERENCES vocal ( dni );

ALTER TABLE vocal
    ADD CONSTRAINT vocal_materia_fk FOREIGN KEY ( materia_codigo )
        REFERENCES materia ( codigo );

ALTER TABLE "Vocal-Examen-Vocales"
    ADD CONSTRAINT "Vocal-Examen-Vocales_EXAMEN_FK" FOREIGN KEY ( examen_fechayhora,
                                                                  examen_aula_codigo,
                                                                  examen_aula_codigo1 )
        REFERENCES examen ( fechayhora,
                            aula_codigo,
                            aula_codigo1 );

ALTER TABLE "Vocal-Examen-Vocales"
    ADD CONSTRAINT "Vocal-Examen-Vocales_VOCAL_FK" FOREIGN KEY ( vocal_dni )
        REFERENCES vocal ( dni );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            12
-- CREATE INDEX                             2
-- ALTER TABLE                             30
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

-- Desde System ejecutamos para mover los �ndices del tablespace
-- TS_PEVAU al tablespace TS_INDICES, despu�s de ejecutarlo
-- comprobamos que efectivamente se han movido de sitio

SELECT * FROM dba_indexes WHERE tablespace_name = 'TS_PEVAU';

SELECT * FROM dba_indexes WHERE tablespace_name = 'TS_INDICES';

SELECT 'ALTER INDEX PEVAU."' || INDEX_NAME || '" REBUILD TABLESPACE TS_INDICES;' FROM DBA_INDEXES WHERE tablespace_name = 'TS_PEVAU';

ALTER INDEX PEVAU."ANE_PK" REBUILD TABLESPACE TS_INDICES;
ALTER INDEX PEVAU."ASISTENCIA_PK" REBUILD TABLESPACE TS_INDICES;
ALTER INDEX PEVAU."AULA_PK" REBUILD TABLESPACE TS_INDICES;
ALTER INDEX PEVAU."CENTRO_PK" REBUILD TABLESPACE TS_INDICES;
ALTER INDEX PEVAU."ESTUDIANTE_PK" REBUILD TABLESPACE TS_INDICES;
ALTER INDEX PEVAU."Estudiante-Materia_PK" REBUILD TABLESPACE TS_INDICES;
ALTER INDEX PEVAU."EXAMEN_PK" REBUILD TABLESPACE TS_INDICES;
ALTER INDEX PEVAU."Examen-Materia_PK" REBUILD TABLESPACE TS_INDICES;
ALTER INDEX PEVAU."MATERIA_PK" REBUILD TABLESPACE TS_INDICES;
ALTER INDEX PEVAU."SEDE__IDX" REBUILD TABLESPACE TS_INDICES;
ALTER INDEX PEVAU."SEDE__IDXV1" REBUILD TABLESPACE TS_INDICES;
ALTER INDEX PEVAU."SEDE_PK" REBUILD TABLESPACE TS_INDICES;
ALTER INDEX PEVAU."VOCAL_PK" REBUILD TABLESPACE TS_INDICES;
ALTER INDEX PEVAU."Vocal-Examen-Vocales_PK" REBUILD TABLESPACE TS_INDICES;

-- Importamos los datos como nos dicen en la pr�ctica grupal 1

-- Vamos a crear la tabla externa para ello ponemos en el directorio el csv
-- y desde system ejecutamos
create or replace directory directorio_ext as 'C:\Users\app\alumnos\admin\orcl\dpdump';

grant read, write on directory directorio_ext to PEVAU;

-- Desde PEVAU creamos la tabla externa

    create table estudiantes_ext
     (centro VARCHAR2(100),
      nombre VARCHAR2(100),
      apellido1 VARCHAR2(50),
      apellido2 VARCHAR2(50),
      dni VARCHAR2(20),
      telefono VARCHAR2(20),
      detalle VARCHAR2(4000))
    ORGANIZATION EXTERNAL (
     TYPE ORACLE_LOADER
 DEFAULT DIRECTORY directorio_ext
 ACCESS PARAMETERS (
 RECORDS DELIMITED BY NEWLINE
 CHARACTERSET UTF8
 FIELDS TERMINATED BY ';'
 OPTIONALLY ENCLOSED BY '"'
 MISSING FIELD VALUES ARE NULL
 (centro, nombre, apellido1, apellido2, dni, telefono, detalle)
 )
 LOCATION ('datos-estudiantes-pevau.csv')
 );
 
 -- Comprobamos que los datos est�n en la tabla 
  select * from estudiantes_ext;
  
-- Observamos que aparece la primera fila con datos que no nos interesan.
-- Las tablas externas son de solo lectura y no se pueden modificar directamente.
-- No podemos modificar o insertar directamente una tabla externa, por lo que si queremos ver la tabla correctamente tendremos que crear una vista y consultar sobre ella.

CREATE OR REPLACE VIEW estudiantes_ext_v AS SELECT * FROM estudiantes_ext
    WHERE centro != 'CENTRO' AND nombre != 'Nombre' AND apellido1 != 'Apellido1' 
    AND apellido2 != 'Apellido2' AND dni != 'DNI/NIF' AND telefono != 'TELEFONO' AND detalle != 'DETALLE_MATERIAS';


SELECT * FROM estudiantes_ext_v;
-- Ahora vemos los datos correctamente.
  
create or replace view v_estudiantes as
SELECT dni, nombre, apellido1 ||' '||apellido2 apellidos,
 telefono,
 substr(nombre,1,1)||apellido1||substr(dni,6,3) ||'@uncorreo.es' correo,
 centro, detalle
FROM estudiantes_ext
 where dni is not null AND dni != 'DNI/NIF';
-- A�ado dni != 'DNI/NIF porque la tabla aparece la primera fila con datos que no deben aparecer.
SELECT * from v_estudiantes; -- vemos todos los datos de la vista

-- Ejecutamos la siguiente instruccion y vemos que se ejecuta correctamente 
select DISTINCT centro from v_estudiantes;

-- Creamos los siguientes indices

CREATE INDEX idx_estudiante_upper_apellidos ON pevau.estudiante (upper(apellidos)) TABLESPACE TS_INDICES;
CREATE INDEX idx_tlf ON pevau.estudiante (telefono) TABLESPACE TS_INDICES;
CREATE INDEX idx_estudiante_upper_nombre ON pevau.estudiante (upper(nombre)) TABLESPACE TS_INDICES;
CREATE INDEX idx_estudiante_correoe ON pevau.estudiante (correoe) TABLESPACE TS_INDICES;
CREATE BITMAP INDEX idx_estud_centro_code ON pevau.estudiante (centro_codigo) TABLESPACE TS_INDICES;

-- Desde System damos permiso a pevau para crear una vista materializada
GRANT CREATE MATERIALIZED VIEW TO pevau;

-- Ahora desde PEVAU creamos la vista materializada
CREATE MATERIALIZED VIEW vm_estudiantes REFRESH FORCE START WITH SYSDATE NEXT TRUNC(SYSDATE + 1) AS SELECT * FROM ESTUDIANTE;

-- Desde System damos permiso a pevau para crear sinonimos
GRANT CREATE PUBLIC SYNONYM TO PEVAU;

-- Creamos el sinonimo desde PEVAU
CREATE PUBLIC SYNONYM s_estudiantes FOR vm_estudiantes;

-- Damos permisos desde System a PEVAU
GRANT CREATE SEQUENCE TO PEVAU;
GRANT CREATE TRIGGER TO PEVAU;

-- Desde System creamos la secuencia, el trigger y modificamos la tabla centro
CREATE SEQUENCE seq_centros;

create or replace trigger tr_centros
before insert on centro for each row
begin
if :new.codigo is null then
:new.codigo := SEQ_CENTROS.NEXTVAL;
end if;
END tr_centros;
/
alter table centro modify sede_codigo null; 

insert into centro (nombre) values ('Ejemplo');
select * from Centro;
rollback; -- para borrarlo

insert into centro (nombre) select distinct centro from v_estudiantes;
select * from centro;
COMMIT;

-- Ejecutamos lo siguiente desde pevau
alter table pevau.estudiante modify telefono VARCHAR2(11); --Nos salto error al ejecutar el insert asi que tuvimos que arreglarlo

insert into estudiante
SELECT
dni, v.nombre, apellidos,telefono, correo, c.codigo
-- Si hay campos adicionales en la tabla estudiantes, ponerlos a null
FROM v_estudiantes v full join centro c on v.centro = c.nombre;

-- Comprobamos que los estudiantes se han insertado bien
select * from estudiante;

-- Vamos a pasar ahora a la parte de encriptar 
-- Desde system ejecutamos 
ALTER SYSTEM SET "WALLET_ROOT"= 'C:\Users\app\alumnos\Oracle_instalacion\wallet' scope=SPFILE;
ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=FILE" scope=both;

-- Desde PEVAU ejecutamos
alter table vocal modify (APELLIDOS ENCRYPT);
alter table vocal modify (nombre encrypt);
alter table materia modify (nombre encrypt);

-- Comprobamos desde pevau
select * from user_encrypted_columns;

-- Vamos a implementar todas las vistas y politicas necesarias para que cada usuario solo pueda
-- ver o modificar sus datos, desde pevau ejecutamos
alter table estudiante add user_name varchar2(100);

create or replace function vpd_function(p_schema varchar2, p_obj varchar2)

  Return varchar2

is

  usuario VARCHAR2(100);

Begin

  usuario := SYS_CONTEXT('userenv', 'SESSION_USER');

  return 'UPPER(user_name) = ''' || usuario || '''';

End;
/

select * from estudiante;

create or replace view v_estudiante_datos_pol as select * from estudiante;

select * from v_estudiante_datos_pol;

-- Desde system aplicamos la politica y le damos permisos a pevau para 
-- crear roles, vamos a crear el rol estudiante
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'PEVAU',
        object_name => 'v_estudiante_datos_pol',
        policy_name => 'pol_datos_estudiante',
        function_schema => 'PEVAU',
        policy_function => 'vpd_function'
    );
END;
/

grant create role to pevau;
grant connect to pevau with admin option;

-- Desde pevau creamos el rol y le damos los permisos
CREATE ROLE r_estudiante;
GRANT CONNECT TO r_estudiante;
GRANT SELECT ON v_estudiante_datos_pol TO r_estudiante;

-- Desde system nos creamos dos usuarios estudiantes 
-- modificamos la tabla estudiantes para poner como user_name 
-- su usuario de oracle y probamos que podamos acceder a los datos
CREATE USER estudiante1 identified by password;
GRANT r_estudiante TO estudiante1;
CREATE USER estudiante2 identified by password;
GRANT r_estudiante TO estudiante2;

-- Desde pevau vamos a crear la siguiente vista para que los estudiantes
-- puedan obtener su asignaci�n y vamos a darle permisos 
-- al rol estudiante para verlo
CREATE OR REPLACE VIEW V_ASIGNACION_ESTUDIANTE AS
SELECT ESTUDIANTE_DNI, MATERIA_CODIGO, EXAMEN_AULA_CODIGO, EXAMEN_AULA_CODIGO1, EXAMEN_FECHAYHORA FROM asistencia
WHERE ESTUDIANTE_DNI IN (SELECT DNI FROM ESTUDIANTE WHERE upper(USER_NAME) = SYS_CONTEXT('USERENV','SESSION_USER'));

grant select on v_asignacion_estudiante to r_estudiante;
-- Probamos que la vista funciona metiendo un aula, un examen,y luego
-- datos en la tabla asistencia
-- Vamos a hacer ahora lo mismo con vigilante de aula
-- Modificamos la tabla vocal para a�adir un user_name en la tabla, luego desde pevau
alter table vocal add user_name varchar2(100);

CREATE OR REPLACE VIEW v_asignacion_vigilante AS
SELECT * FROM "Vocal-Examen-Vocales"
WHERE VOCAL_DNI = (SELECT DNI FROM VOCAL WHERE upper(USER_NAME) = SYS_CONTEXT('USERENV', 'SESSION_USER'));

CREATE ROLE r_vigilante_aula;
grant connect to r_vigilante_aula;
GRANT SELECT ON v_asignacion_vigilante TO r_vigilante_aula;

-- Desde System creamos los usuarios vigilante1 y vigilante2
CREATE USER vigilante1 IDENTIFIED BY password;
CREATE USER vigilante2 IDENTIFIED BY password;

-- Desde pevau le damos el rol
GRANT r_vigilante_aula TO vigilante1;
GRANT r_vigilante_aula TO vigilante2;

-- Insertamos datos en la tabla vocal-examen-vocales
-- y probamos que todo funciona como deber�a
-- Vamos a hacer ahora responsable de aula
-- desde pevau creamos el rol y le damos permiso para ver la vista
-- r_vigilante_aula
CREATE ROLE r_responsable_aula;
GRANT CONNECT TO r_responsable_aula;
GRANT SELECT ON v_asignacion_vigilante TO r_responsable_aula;
-- Vamos a hacer ahora la parte de actualizar el numero de 
-- alumnos haciendo el examen, luego probaremos todo
-- creandonos 2 usuarios como antes
ALTER TABLE EXAMEN ADD num_alumnos NUMBER;
-- Vamos a crear una vista para que el responsable de aula pueda ver
-- los datos del examen que va a vigilar y vamos a crear
-- un trigger para que cada vez que se inserte en la vista
-- lo haga en la tabla examen
CREATE OR REPLACE VIEW v_examen_responsable AS
SELECT * FROM EXAMEN
WHERE VOCAL_DNI = (SELECT DNI FROM VOCAL WHERE upper(USER_NAME) = SYS_CONTEXT('USERENV', 'SESSION_USER'));
GRANT SELECT ON v_examen_responsable TO r_responsable_aula;

grant update(num_alumnos) on v_examen_responsable to r_responsable_aula;

create or replace trigger tr_num_alum
instead of update on v_examen_responsable for each row
begin 
    --if sysdate = :old.fechayhora then
    update pevau.examen set num_alumnos = :new.num_alumnos 
    where fechayhora = :old.fechayhora and aula_codigo = :old.aula_codigo and aula_codigo1 = :old.aula_codigo1;
    --end if;
end tr_num_alum;
/

-- Desde System creamos los usuarios vigilante1 y vigilante2
CREATE USER responsable1 IDENTIFIED BY password;
CREATE USER responsable2 IDENTIFIED BY password;

-- Desde pevau le damos el rol
GRANT r_responsable_aula TO responsable1;
GRANT r_responsable_aula TO responsable2;

-- Insertamos datos en la tabla vocal-examen-vocales
-- y probamos que todo funciona como deber�a







-- Vamos a crear los procedimientos que nos piden
-- empezamos por pr_inserta_materias y pr_matricula_estudiantes
-- los crearemos desde pevau

CREATE OR REPLACE PROCEDURE PR_INSERTA_MATERIAS (
    PESTDNI VARCHAR2,
    PDETALLE_MATERIAS VARCHAR2
) AS
    V_CODIGO_MATERIA VARCHAR2(200);  -- Variable para almacenar el c�digo de la materia
    V_DETALLE_MATERIAS VARCHAR2(4000) := PDETALLE_MATERIAS || ',';  -- Variable para almacenar la lista de materias
BEGIN
    -- Recorremos la lista de materias separadas por comas
    LOOP
        -- Buscamos el primer elemento de la lista de materias
        EXIT WHEN NVL(V_DETALLE_MATERIAS, 'X') = 'X';  -- Salimos del bucle cuando no hay m�s elementos en la lista
        V_CODIGO_MATERIA := TRIM(SUBSTR(V_DETALLE_MATERIAS, 1, INSTR(V_DETALLE_MATERIAS, ',')-1));  -- Extraemos el primer elemento de la lista
        V_DETALLE_MATERIAS := SUBSTR(V_DETALLE_MATERIAS, INSTR(V_DETALLE_MATERIAS, ',')+1);  -- Eliminamos el primer elemento de la lista

        -- Insertamos el registro en la tabla Estudiante-Materia
        INSERT INTO "Estudiante-Materia" (
            ESTUDIANTE_DNI,
            MATERIA_CODIGO
        )
        VALUES (
            PESTDNI,
            (SELECT CODIGO FROM MATERIA WHERE NOMBRE = V_CODIGO_MATERIA)  -- Obtenemos el c�digo de la materia a partir del nombre
        );
    END LOOP;
    COMMIT;
END;
/


CREATE OR REPLACE PROCEDURE PR_MATRICULA_ESTUDIANTES AS
  v_dni_estudiante VARCHAR2(9);
  v_detalle_materias VARCHAR2(4000);
BEGIN
  FOR r IN (SELECT DNI, DETALLE FROM V_ESTUDIANTES) LOOP
    v_dni_estudiante := r.DNI;
    v_detalle_materias := r.DETALLE;
    PR_INSERTA_MATERIAS(v_dni_estudiante, v_detalle_materias);
  END LOOP;
  COMMIT;
END;
/ 

-- Lo probamos para ver que funciona bien y vemos que se han a�adido los datos
-- a estudiante-materia
execute pr_matricula_estudiantes;

-- Vamos a hacer ahora los procedimientos pr_rellena_aulas,
-- pr_borra_aula_sede y pr_borra_aulas


CREATE OR REPLACE PROCEDURE PR_RELLENA_AULAS (PNUMAULAS NUMBER, PCAPACIDAD NUMBER) AS
BEGIN
  FOR s IN (SELECT CODIGO FROM SEDE) LOOP -- recorremos todas las sedes
    FOR i IN 1..PNUMAULAS LOOP  -- generamos tantas aulas por sede como se indique en el par�metro PNUMAULAS
      INSERT INTO Aula (CODIGO, CAPACIDAD, CAPACIDAD_EXAMEN, DESCRIPCI�N, SEDE_CODIGO)  -- insertamos la nueva aula en la tabla Aula
      VALUES (s.CODIGO || i, PCAPACIDAD, PCAPACIDAD/2, 'Aula ' || i || ' de la sede ' || s.CODIGO, s.CODIGO);
    END LOOP;
  END LOOP;
  COMMIT;
END; 
/ 

execute pr_rellena_aulas(2,10);

CREATE OR REPLACE PROCEDURE PR_BORRA_AULA_SEDE (PCODIGOSEDE IN SEDE.CODIGO%TYPE) AS
BEGIN
  DELETE FROM AULA WHERE SEDE_CODIGO = PCODIGOSEDE;
  COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE PR_BORRA_AULAS AS
BEGIN
  FOR r IN (SELECT CODIGO FROM SEDE) LOOP
    PR_BORRA_AULA_SEDE(r.CODIGO);
  END LOOP;
  COMMIT;
END;
/

execute pr_borra_aulas;

-- Ahora vamos a realizar el paquete pkg_usuarios pero primero desde system
-- le damos permisos a pevau para crear usuarios
grant create user to pevau;

-- Continuamos desde pevau
CREATE OR REPLACE PACKAGE PKG_USUARIOS AS
    PROCEDURE PR_CREA_ESTUDIANTE(p_dni IN varchar2, p_username OUT VARCHAR2, p_password OUT VARCHAR2);
    PROCEDURE PR_CREA_VOCAL(p_dni IN varchar2, p_username OUT VARCHAR2, p_password OUT VARCHAR2);
END PKG_USUARIOS;
/

create or replace PACKAGE BODY PKG_USUARIOS AS
    PROCEDURE PR_CREA_ESTUDIANTE(p_dni IN VARCHAR2, p_username OUT VARCHAR2, p_password OUT VARCHAR2) IS
    BEGIN
        p_username := 'ESTUDIANTE_' || p_dni;
        p_password := 'PASS_' || DBMS_RANDOM.STRING('P', 10); -- la P indica que se pueden usar caracteres imprimibles
        EXECUTE IMMEDIATE 'CREATE USER "' || p_username || '" IDENTIFIED BY "' || p_password || '"';
        EXECUTE IMMEDIATE 'GRANT r_estudiante TO ' || p_username;
        EXECUTE IMMEDIATE 'UPDATE ESTUDIANTE SET USER_NAME = ''' || p_username || ''' WHERE DNI = ''' || p_dni || '''';
        COMMIT;
    END PR_CREA_ESTUDIANTE;

    PROCEDURE PR_CREA_VOCAL(p_dni IN VARCHAR2, p_username OUT VARCHAR2, p_password OUT VARCHAR2) IS
    BEGIN
        p_username := 'VOCAL_' || p_dni;
        p_password := 'PASS_' || DBMS_RANDOM.STRING('P', 10); -- la P indica que se pueden usar caracteres imprimibles
        EXECUTE IMMEDIATE 'CREATE USER "' || p_username || '" IDENTIFIED BY "' || p_password || '"';
        EXECUTE IMMEDIATE 'GRANT r_vigilante_aula TO ' || p_username;
        EXECUTE IMMEDIATE 'UPDATE VOCAL SET USER_NAME = ''' || p_username || ''' WHERE DNI = ''' || p_dni || '''';
        COMMIT;
    END PR_CREA_VOCAL;
END PKG_USUARIOS;
/

-- Ahora vamos a realizar el paquete pk_asigna
CREATE OR REPLACE PACKAGE PK_ASIGNA AS
  FUNCTION F_PLAZAS(PSEDE IN VARCHAR2) RETURN NUMBER;
  PROCEDURE PR_ASIGNA_SEDE;
END PK_ASIGNA;
/

create or replace PACKAGE BODY PK_ASIGNA AS 
    FUNCTION F_PLAZAS(PSEDE IN VARCHAR2) RETURN NUMBER AS
    v_capacidad number;
    v_num_estudiantes number;
    BEGIN
    SELECT SUM(CAPACIDAD_EXAMEN) into v_capacidad from aula where sede_codigo = psede;

    select count(*) into v_num_estudiantes from estudiante e join centro c on (e.centro_codigo = c.codigo) 
    where c.sede_codigo = psede;

    return v_capacidad - v_num_estudiantes;
    END F_PLAZAS;

PROCEDURE PR_ASIGNA_SEDE AS 
    NO_HAY_SEDE EXCEPTION;
    CENTRO_SEDE BOOLEAN;
BEGIN
    FOR INSTITUTO IN(SELECT CODIGO, NOMBRE FROM SEDE WHERE TIPO='INSTITUTO') LOOP
        UPDATE CENTRO SET SEDE_CODIGO = INSTITUTO.CODIGO WHERE (UPPER(NOMBRE) = UPPER(INSTITUTO.NOMBRE));
    END LOOP;

    FOR CENTROfor IN (SELECT CENTR.CODIGO CODIGO, CENTR.NOMBRE NOMBRE, F_NUM_ALUMNOS(CENTR.CODIGO) ALUMNOS, SED.TIPO
    TIPO_CENTRO FROM CENTRO CENTR LEFT JOIN SEDE SED ON (UPPER(CENTR.NOMBRE) = UPPER(SED.NOMBRE)) 
    ORDER BY ALUMNOS DESC) LOOP

    IF(CENTROfor.TIPO_CENTRO IS NULL) THEN
        CENTRO_SEDE := FALSE;
        FOR SEDE_CON_PLAZAS IN (SELECT CODIGO, NOMBRE, TIPO, F_PLAZAS(CODIGO) PLAZAS_LIBRES FROM SEDE ORDER BY PLAZAS_LIBRES DESC) LOOP
            IF(SEDE_CON_PLAZAS.PLAZAS_LIBRES >= CENTROfor.ALUMNOS) THEN
                UPDATE CENTRO SET SEDE_CODIGO = SEDE_CON_PLAZAS.CODIGO WHERE CODIGO = CENTROfor.CODIGO;
                CENTRO_SEDE := TRUE;
            END IF;
            EXIT WHEN CENTRO_SEDE = TRUE;
        END LOOP;

        IF(CENTRO_SEDE = FALSE) THEN RAISE NO_HAY_SEDE;
        END IF;
    END IF;
    END LOOP;

    EXCEPTION WHEN NO_HAY_SEDE THEN RAISE_APPLICATION_ERROR(-20001, 'No quedan sedes para albergar al centro');
    COMMIT;
END PR_ASIGNA_SEDE;
END PK_ASIGNA;
/

-- Creamos el trigger tr_borra_aula y lo probamos
CREATE OR REPLACE TRIGGER TR_BORRA_AULA
    BEFORE DELETE ON AULA
    FOR EACH ROW
DECLARE
    v_count NUMBER := 0;
    v_count2 NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_count FROM Examen WHERE AULA_CODIGO = :OLD.CODIGO AND AULA_CODIGO1 = :OLD.SEDE_CODIGO AND FECHAYHORA < SYSDATE;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se puede borrar el aula porque ya se ha realizado un examen en ella.');
    END IF;

    SELECT COUNT(*) INTO v_count2 FROM Examen WHERE AULA_CODIGO = :OLD.CODIGO AND AULA_CODIGO1 = :OLD.SEDE_CODIGO  AND FECHAYHORA BETWEEN SYSDATE AND SYSDATE + 2;
    IF v_count2 > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'No se puede borrar el aula porque hay un examen planificado en las pr�ximas 48 horas.');
    END IF;

    DELETE FROM Examen WHERE AULA_CODIGO = :OLD.CODIGO AND AULA_CODIGO1 = :OLD.SEDE_CODIGO;
END TR_BORRA_AULA;
/

-- Creamos las vistas que nos pide el ejercicio 1 de la practica grupal 3

CREATE VIEW V_OCUPACION_ASIGNADA AS 
SELECT S.CODIGO, S.NOMBRE, E.AULA_CODIGO, E.FECHAYHORA AS EXAMEN_FECHAYHORA,COUNT(A.ESTUDIANTE_DNI) AS NUMERO_ESTUDIANTES_ASIGNADOS
FROM SEDE S 
JOIN EXAMEN E ON S.CODIGO = E.AULA_CODIGO1 
JOIN ASISTENCIA A ON E.FECHAYHORA = A.EXAMEN_FECHAYHORA AND E.AULA_CODIGO = A.EXAMEN_AULA_CODIGO AND E.AULA_CODIGO1 = A.EXAMEN_AULA_CODIGO1
GROUP BY S.CODIGO, S.NOMBRE, E.AULA_CODIGO, E.FECHAYHORA;

SELECT * FROM V_OCUPACION_ASIGNADA;

CREATE VIEW V_OCUPACION AS 
SELECT S.CODIGO, S.NOMBRE, E.AULA_CODIGO, E.FECHAYHORA, COUNT(A.ESTUDIANTE_DNI) AS NUMERO_ESTUDIANTES_ASISTENTES
FROM SEDE S 
JOIN EXAMEN E ON S.CODIGO = E.AULA_CODIGO1 
JOIN ASISTENCIA A ON E.FECHAYHORA = A.EXAMEN_FECHAYHORA AND E.AULA_CODIGO = A.EXAMEN_AULA_CODIGO AND E.AULA_CODIGO1 = A.EXAMEN_AULA_CODIGO1 AND A.ASISTE = 'Y'
GROUP BY S.CODIGO, S.NOMBRE, E.AULA_CODIGO, E.FECHAYHORA;

select * from v_ocupacion;

CREATE VIEW V_VIGILANTES AS 
SELECT S.codigo, S.nombre, E.aula_codigo, E.fechayhora, COUNT(V.VOCAL_DNI) AS numero_vigilantes
FROM sede S 
INNER JOIN examen E ON S.codigo = E.aula_codigo1 
INNER JOIN "Vocal-Examen-Vocales" V ON E.fechayhora = V.EXAMEN_FECHAYHORA AND E.aula_codigo = V.EXAMEN_AULA_CODIGO AND E.aula_codigo1 = V.EXAMEN_AULA_CODIGO1
GROUP BY S.codigo, S.nombre, E.aula_codigo, E.fechayhora;

select * from v_vigilantes;

-- Vamos a hacer ahora el paquete pk_ocupacion


CREATE OR REPLACE PACKAGE PK_OCUPACION AS
    FUNCTION OCUPACION_MAXIMA(codigo_sede IN VARCHAR2, codigo_aula IN VARCHAR2) RETURN NUMBER;
    FUNCTION OCUPACION_OK RETURN BOOLEAN;
    FUNCTION VOCAL_DUPLICADO(vocal_id IN VOCAL.DNI%TYPE) RETURN BOOLEAN;
    FUNCTION VOCALES_DUPLICADOS RETURN BOOLEAN;
    FUNCTION VOCAL_RATIO(ratio IN NUMBER) RETURN BOOLEAN;
END PK_OCUPACION;
/

create or replace PACKAGE BODY PK_OCUPACION AS

    FUNCTION OCUPACION_MAXIMA(codigo_sede IN VARCHAR2, codigo_aula IN VARCHAR2) RETURN NUMBER IS
        max_ocupacion NUMBER := 0;
        ocupacion_actual NUMBER := 0;
    BEGIN
        FOR examen IN (SELECT e.FECHAYHORA FROM Examen e WHERE e.AULA_CODIGO = codigo_aula AND e.AULA_CODIGO1 = codigo_sede) LOOP
            SELECT COUNT(*) INTO ocupacion_actual FROM Asistencia a WHERE a.EXAMEN_AULA_CODIGO = codigo_aula AND a.EXAMEN_AULA_CODIGO1 = codigo_sede AND a.EXAMEN_FECHAYHORA = examen.FECHAYHORA;
            SELECT COUNT(*) + ocupacion_actual INTO ocupacion_actual FROM "Vocal-Examen-Vocales" vex WHERE vex.EXAMEN_AULA_CODIGO = codigo_aula AND vex.EXAMEN_AULA_CODIGO1 = codigo_sede AND vex.EXAMEN_FECHAYHORA = examen.FECHAYHORA;
            IF ocupacion_actual > max_ocupacion THEN
                max_ocupacion := ocupacion_actual;
            END IF;
        END LOOP;
    RETURN max_ocupacion;
    END OCUPACION_MAXIMA;
 
    FUNCTION OCUPACION_OK RETURN BOOLEAN IS
        v_examen_ok BOOLEAN := TRUE;
        ocupacion_actual NUMBER := 0;
        BEGIN
            FOR examen IN (SELECT e.FECHAYHORA, e.Aula_Codigo1, e.Aula_Codigo, a.CAPACIDAD, a.CAPACIDAD_EXAMEN FROM Examen e JOIN Aula a ON e.AULA_CODIGO = a.CODIGO AND e.AULA_CODIGO1 = a.SEDE_CODIGO WHERE e.FECHAYHORA > SYSDATE) LOOP
                SELECT COUNT(*) INTO ocupacion_actual FROM Asistencia a WHERE a.EXAMEN_AULA_CODIGO = examen.AULA_CODIGO AND a.EXAMEN_AULA_CODIGO1 = examen.AULA_CODIGO1 AND a.EXAMEN_FECHAYHORA = examen.FECHAYHORA;
                IF ocupacion_actual > examen.CAPACIDAD_EXAMEN THEN
                    v_examen_ok := FALSE;
                    EXIT; -- salgo del bucle si hay demasiados alumnos para hacer el examen en el aula
                END IF;
                SELECT COUNT(*) + ocupacion_actual INTO ocupacion_actual FROM "Vocal-Examen-Vocales" vex WHERE vex.EXAMEN_AULA_CODIGO = examen.AULA_CODIGO AND vex.EXAMEN_AULA_CODIGO1 = examen.AULA_CODIGO1 AND vex.EXAMEN_FECHAYHORA = examen.FECHAYHORA;
                IF ocupacion_actual > examen.CAPACIDAD THEN
                    v_examen_ok := FALSE;
                    EXIT; -- salgo del bucle si hay demasiados alumnos + vocales en el aula
                END IF;
            END LOOP;
        RETURN v_examen_ok;
    END OCUPACION_OK;
    
    FUNCTION VOCAL_DUPLICADO(vocal_id IN VOCAL.DNI%TYPE) RETURN BOOLEAN IS
        v_vocal_duplicado BOOLEAN := FALSE;
        v_count NUMBER := 0;
        BEGIN
            SELECT COUNT(*) INTO v_count
            FROM (
                SELECT e.FECHAYHORA
                FROM Examen e
                JOIN "Vocal-Examen-Vocales" vex ON e.AULA_CODIGO = vex.EXAMEN_AULA_CODIGO AND e.AULA_CODIGO1 = vex.EXAMEN_AULA_CODIGO1 AND e.FECHAYHORA = vex.EXAMEN_FECHAYHORA
                WHERE vex.VOCAL_DNI = vocal_id
                GROUP BY e.FECHAYHORA
                HAVING COUNT(*) > 1 --solo se contar�n las franjas horarias en las que el vocal est� asignado a m�s de un examen
            );
            
            IF v_count > 0 THEN -- si hay algun vocal asignado a mas de una franja horaria de distintos examenes
                v_vocal_duplicado := TRUE;
            END IF;
    RETURN v_vocal_duplicado;
    END VOCAL_DUPLICADO;

    FUNCTION VOCALES_DUPLICADOS RETURN BOOLEAN IS
        v_duplicado BOOLEAN := FALSE;
    BEGIN
        FOR vocal IN (SELECT DNI FROM vocal) LOOP
            v_duplicado := pk_ocupacion.vocal_duplicado(vocal.dni);
            IF v_duplicado THEN
                EXIT;
            END IF;
        END LOOP;
    RETURN v_duplicado;
    END VOCALES_DUPLICADOS;


    FUNCTION VOCAL_RATIO(ratio IN NUMBER) RETURN BOOLEAN IS
        v_ratio_ok BOOLEAN := TRUE;
        v_count_alumnos NUMBER := 0;
        v_count_vocales NUMBER := 0;
    BEGIN
        FOR examen IN (SELECT FECHAYHORA, AULA_CODIGO, AULA_CODIGO1 FROM Examen WHERE FECHAYHORA > SYSDATE) LOOP
            SELECT COUNT(*) INTO v_count_alumnos FROM Asistencia WHERE EXAMEN_FECHAYHORA = examen.FECHAYHORA AND EXAMEN_AULA_CODIGO = examen.AULA_CODIGO AND EXAMEN_AULA_CODIGO1 = examen.AULA_CODIGO1;
            SELECT COUNT(*) INTO v_count_vocales FROM "Vocal-Examen-Vocales" WHERE EXAMEN_FECHAYHORA = examen.FECHAYHORA AND EXAMEN_AULA_CODIGO = examen.AULA_CODIGO AND EXAMEN_AULA_CODIGO1 = examen.AULA_CODIGO1;
            IF v_count_vocales = 0 OR v_count_alumnos / v_count_vocales > ratio THEN
                v_ratio_ok := FALSE;
                EXIT;
            END IF;
        END LOOP;
    RETURN v_ratio_ok;
    END VOCAL_RATIO;
END PK_OCUPACION;
/

-- Probamos la funcionalidad de los metodos
-- que devuelven bool con el siguiente procedimiento de prueba
set serveroutput on;
create or replace PROCEDURE PR_prueba_ocupacion_ok AS
    v_prueba DATE;
BEGIN
  if pk_ocupacion.vocal_ratio(2) then
    select sysdate into v_prueba from dual;
    dbms_output.put_line(v_prueba);
    END IF;
    --dbms_output.put_line('hola');
END;
/

execute pr_prueba_ocupacion_ok;

-- Vamos a crear ahora el rol personal de servicio
CREATE ROLE r_personal_servicio;

GRANT UPDATE (VOCAL_DNI) ON SEDE TO r_personal_servicio;

CREATE OR REPLACE VIEW v_num_alum_examen_aula AS
SELECT EXAMEN_AULA_CODIGO1 AS EXAMEN_SEDE_CODIGO, EXAMEN_AULA_CODIGO, EXAMEN_FECHAYHORA, COUNT(*) AS TOTAL_ALUMNOS
FROM asistencia
GROUP BY EXAMEN_AULA_CODIGO1, EXAMEN_AULA_CODIGO, EXAMEN_FECHAYHORA;

GRANT SELECT ON v_num_alum_examen_aula TO r_personal_servicio;

CREATE OR REPLACE VIEW v_pers_servicio_asignacion AS
SELECT ESTUDIANTE_DNI, EXAMEN_AULA_CODIGO, EXAMEN_AULA_CODIGO1 AS EXAMEN_SEDE_CODIGO, EXAMEN_FECHAYHORA
FROM asistencia;

GRANT SELECT ON v_pers_servicio_asignacion TO r_personal_servicio;

CREATE USER personal_servicio IDENTIFIED BY password;

GRANT r_personal_servicio TO personal_servicio;
GRANT connect to r_personal_servicio;

-- Vamos a crear ahora el rol vocal responsable de sede 
create role r_responsable_sede;

CREATE OR REPLACE VIEW v_aula_sede AS
SELECT SEDE_CODIGO, CODIGO, CAPACIDAD, CAPACIDAD_EXAMEN, DESCRIPCI�N FROM AULA
WHERE SEDE_CODIGO = (SELECT CODIGO FROM SEDE WHERE VOCAL_DNI = (SELECT DNI FROM VOCAL WHERE upper(USER_NAME) = SYS_CONTEXT('USERENV', 'SESSION_USER')));

GRANT SELECT, INSERT, UPDATE, DELETE ON v_aula_sede to r_responsable_sede;

CREATE OR REPLACE TRIGGER tr_v_aula_sede
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_aula_sede FOR EACH ROW
BEGIN
IF INSERTING THEN
INSERT into aula(codigo, capacidad, capacidad_examen, descripci�n, sede_codigo)
values (:new.codigo, :new.capacidad, :new.capacidad_examen, :new.descripci�n, :new.sede_codigo);
ELSIF DELETING THEN
DELETE FROM aula WHERE codigo = :old.codigo AND sede_codigo = :old.sede_codigo;
ELSE
UPDATE aula set codigo = :new.codigo, capacidad = :new.capacidad, capacidad_examen = :new.capacidad_examen,
descripci�n = :new.descripci�n, sede_codigo = :new.sede_codigo;
END IF;
END tr_v_aula_sede;
/


CREATE OR REPLACE VIEW v_examen_sede AS
SELECT FECHAYHORA, AULA_CODIGO, AULA_CODIGO1, VOCAL_DNI, NUM_ALUMNOS FROM EXAMEN --vocal_dni es el responsable del examen, no de la sede
WHERE AULA_CODIGO1 = (SELECT CODIGO FROM SEDE WHERE VOCAL_DNI = (SELECT DNI FROM VOCAL WHERE upper(USER_NAME) = SYS_CONTEXT('USERENV', 'SESSION_USER')));

GRANT SELECT, INSERT, UPDATE, DELETE ON v_examen_sede to r_responsable_sede;

CREATE OR REPLACE TRIGGER tr_v_examen_sede
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_examen_sede FOR EACH ROW
BEGIN
IF INSERTING THEN
INSERT into EXAMEN(FECHAYHORA, AULA_CODIGO, AULA_CODIGO1, VOCAL_DNI, NUM_ALUMNOS)
values (:new.FECHAYHORA, :new.AULA_CODIGO, :new.AULA_CODIGO1, :new.VOCAL_DNI, :new.NUM_ALUMNOS);
ELSIF DELETING THEN
DELETE FROM EXAMEN WHERE FECHAYHORA = :old.FECHAYHORA AND AULA_CODIGO = :old.AULA_CODIGO AND AULA_CODIGO1 = :old.AULA_CODIGO1;
ELSE
UPDATE EXAMEN set FECHAYHORA = :new.FECHAYHORA, AULA_CODIGO = :new.AULA_CODIGO, AULA_CODIGO1 = :new.AULA_CODIGO1,
VOCAL_DNI = :new.VOCAL_DNI, NUM_ALUMNOS = :new.NUM_ALUMNOS;
END IF;
END tr_v_examen_sede;
/


CREATE OR REPLACE VIEW v_asistencia_sede AS
SELECT ASISTE, ENTREGA, ESTUDIANTE_DNI, MATERIA_CODIGO, EXAMEN_FECHAYHORA, EXAMEN_AULA_CODIGO, EXAMEN_AULA_CODIGO1 FROM ASISTENCIA
WHERE EXAMEN_AULA_CODIGO1 = (SELECT CODIGO FROM SEDE WHERE VOCAL_DNI = (SELECT DNI FROM VOCAL WHERE upper(USER_NAME) = SYS_CONTEXT('USERENV', 'SESSION_USER')));

GRANT SELECT, INSERT, UPDATE, DELETE ON v_asistencia_sede to r_responsable_sede;

CREATE OR REPLACE TRIGGER tr_v_asistencia_sede
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_asistencia_sede FOR EACH ROW
BEGIN
IF INSERTING THEN
INSERT into ASISTENCIA(ASISTE, ENTREGA, ESTUDIANTE_DNI, MATERIA_CODIGO, EXAMEN_FECHAYHORA, EXAMEN_AULA_CODIGO, EXAMEN_AULA_CODIGO1)
values (:new.ASISTE, :new.ENTREGA, :new.ESTUDIANTE_DNI, :new.MATERIA_CODIGO, :new.EXAMEN_FECHAYHORA, :new.EXAMEN_AULA_CODIGO, :new.EXAMEN_AULA_CODIGO1);
ELSIF DELETING THEN
DELETE FROM ASISTENCIA WHERE ESTUDIANTE_DNI = :old.ESTUDIANTE_DNI AND MATERIA_CODIGO = :old.MATERIA_CODIGO AND EXAMEN_FECHAYHORA = :old.EXAMEN_FECHAYHORA
AND EXAMEN_AULA_CODIGO = :old.EXAMEN_AULA_CODIGO AND EXAMEN_AULA_CODIGO1 = :old.EXAMEN_AULA_CODIGO1;
ELSE
UPDATE ASISTENCIA set ASISTE = :new.ASISTE, EXAMEN_AULA_CODIGO = :new.EXAMEN_AULA_CODIGO, EXAMEN_AULA_CODIGO1 = :new.EXAMEN_AULA_CODIGO1,
ESTUDIANTE_DNI = :new.ESTUDIANTE_DNI, ENTREGA = :new.ENTREGA, MATERIA_CODIGO = :new.MATERIA_CODIGO, EXAMEN_FECHAYHORA = :new.EXAMEN_FECHAYHORA;
END IF;
END tr_v_asistencia_sede;
/


CREATE OR REPLACE VIEW v_asignacion_sede AS
SELECT VOCAL_DNI, EXAMEN_FECHAYHORA, EXAMEN_AULA_CODIGO, EXAMEN_AULA_CODIGO1 FROM "Vocal-Examen-Vocales"
WHERE EXAMEN_AULA_CODIGO1 = (SELECT CODIGO FROM SEDE WHERE VOCAL_DNI = (SELECT DNI FROM VOCAL WHERE upper(USER_NAME) = SYS_CONTEXT('USERENV', 'SESSION_USER')));


GRANT SELECT, INSERT, UPDATE, DELETE ON v_asignacion_sede TO r_responsable_sede;


CREATE OR REPLACE TRIGGER tr_v_asignacion_sede
INSTEAD OF INSERT OR DELETE OR UPDATE ON v_asignacion_sede FOR EACH ROW
BEGIN
IF INSERTING THEN
INSERT into "Vocal-Examen-Vocales"(VOCAL_DNI, EXAMEN_FECHAYHORA, EXAMEN_AULA_CODIGO, EXAMEN_AULA_CODIGO1)
values (:new.VOCAL_DNI,:new.EXAMEN_FECHAYHORA, :new.EXAMEN_AULA_CODIGO, :new.EXAMEN_AULA_CODIGO1);
ELSIF DELETING THEN
DELETE FROM "Vocal-Examen-Vocales" WHERE VOCAL_DNI = :old.VOCAL_DNI AND EXAMEN_FECHAYHORA = :old.EXAMEN_FECHAYHORA
AND EXAMEN_AULA_CODIGO = :old.EXAMEN_AULA_CODIGO AND EXAMEN_AULA_CODIGO1 = :old.EXAMEN_AULA_CODIGO1;
ELSE
UPDATE "Vocal-Examen-Vocales" set EXAMEN_AULA_CODIGO = :new.EXAMEN_AULA_CODIGO, EXAMEN_AULA_CODIGO1 = :new.EXAMEN_AULA_CODIGO1,
VOCAL_DNI = :new.VOCAL_DNI, EXAMEN_FECHAYHORA = :new.EXAMEN_FECHAYHORA;
END IF;
END tr_v_asignacion_sede;
/

-- Creamos un usuario para hacer las pruebas
CREATE USER responsable_sede IDENTIFIED BY password;

GRANT r_responsable_sede TO responsable_sede;
GRANT connect to r_responsable_sede;






