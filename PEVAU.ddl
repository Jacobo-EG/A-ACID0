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
    materia_codigo      INTEGER NOT NULL,
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
    descripción      VARCHAR2(500),
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
    materia_codigo INTEGER NOT NULL
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
    materia_codigo      INTEGER NOT NULL
);

ALTER TABLE "Examen-Materia"
    ADD CONSTRAINT "Examen-Materia_PK" PRIMARY KEY ( examen_fechayhora,
                                                     examen_aula_codigo,
                                                     examen_aula_codigo1,
                                                     materia_codigo );

CREATE TABLE materia (
    codigo INTEGER NOT NULL,
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
    materia_codigo INTEGER
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
