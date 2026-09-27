-- creare secventa
CREATE SEQUENCE examen_seq START WITH 1 INCREMENT BY 1;


CREATE TABLE judet (
    id_judet NUMBER PRIMARY KEY,
    nume_judet VARCHAR2(50) NOT NULL
);

CREATE TABLE examen (
    id_examen NUMBER PRIMARY KEY,
    denumire_examen VARCHAR2(50) NOT NULL,
    an_sustinere NUMBER(4) NOT NULL
);

CREATE TABLE disciplina (
    id_disciplina NUMBER PRIMARY KEY,
    denumire_disciplina VARCHAR2(50) NOT NULL
);

CREATE TABLE profesor (
    id_profesor NUMBER PRIMARY KEY,
    nume_profesor VARCHAR2(100) NOT NULL,
    grad_didactic VARCHAR2(20)
);

-- creare tabele cu dependente (FK)
CREATE TABLE centru_examen (
    id_centru NUMBER PRIMARY KEY,
    nume_centru VARCHAR2(100) NOT NULL,
    id_judet NUMBER NOT NULL,
    CONSTRAINT fk_centru_judet FOREIGN KEY (id_judet) REFERENCES judet(id_judet)
);

CREATE TABLE unitate_invatamant (
    id_unitate NUMBER PRIMARY KEY,
    denumire VARCHAR2(100) NOT NULL,
    id_judet NUMBER NOT NULL,
    id_unitate_parinte NUMBER,
    CONSTRAINT fk_unitate_judet FOREIGN KEY (id_judet) REFERENCES judet(id_judet),
    CONSTRAINT fk_unitate_parinte FOREIGN KEY (id_unitate_parinte) REFERENCES unitate_invatamant(id_unitate)
);

CREATE TABLE candidat (
    id_candidat NUMBER PRIMARY KEY,
    nume_complet VARCHAR2(100) NOT NULL,
    cnp VARCHAR2(13) UNIQUE NOT NULL,
    id_unitate NUMBER NOT NULL,
    CONSTRAINT fk_candidat_unitate FOREIGN KEY (id_unitate) REFERENCES unitate_invatamant(id_unitate)
);

CREATE TABLE sesiune (
    id_sesiune NUMBER PRIMARY KEY,
    data_examen DATE NOT NULL,
    id_examen NUMBER NOT NULL,
    id_disciplina NUMBER NOT NULL,
    CONSTRAINT fk_sesiune_examen FOREIGN KEY (id_examen) REFERENCES examen(id_examen),
    CONSTRAINT fk_sesiune_disciplina FOREIGN KEY (id_disciplina) REFERENCES disciplina(id_disciplina)
);

CREATE TABLE sala (
    id_sala NUMBER PRIMARY KEY,
    denumire_sala VARCHAR2(50) NOT NULL,
    capacitate NUMBER(3),
    id_centru NUMBER NOT NULL,
    CONSTRAINT fk_sala_centru FOREIGN KEY (id_centru) REFERENCES centru_examen(id_centru)
);

CREATE TABLE lucrare (
    id_lucrare NUMBER PRIMARY KEY,
    cod_secret VARCHAR2(20),
    id_candidat NUMBER NOT NULL,
    id_sesiune NUMBER NOT NULL,
    CONSTRAINT fk_lucrare_candidat FOREIGN KEY (id_candidat) REFERENCES candidat(id_candidat),
    CONSTRAINT fk_lucrare_sesiune FOREIGN KEY (id_sesiune) REFERENCES sesiune(id_sesiune)
);

-- tabele asociative
CREATE TABLE repart_suprav (
    id_repartizare NUMBER PRIMARY KEY,
    id_profesor NUMBER NOT NULL,
    id_sala NUMBER NOT NULL,
    id_sesiune NUMBER NOT NULL,
    CONSTRAINT fk_repart_profesor FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    CONSTRAINT fk_repart_sala FOREIGN KEY (id_sala) REFERENCES sala(id_sala),
    CONSTRAINT fk_repart_sesiune FOREIGN KEY (id_sesiune) REFERENCES sesiune(id_sesiune)
);

CREATE TABLE evaluare (
    id_evaluare NUMBER PRIMARY KEY,
    nota_acordata NUMBER(4,2) CHECK (nota_acordata >= 1 AND nota_acordata <= 10),
    id_lucrare NUMBER NOT NULL,
    id_profesor NUMBER NOT NULL,
    CONSTRAINT fk_evaluare_lucrare FOREIGN KEY (id_lucrare) REFERENCES lucrare(id_lucrare),
    CONSTRAINT fk_evaluare_profesor FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor)
);


