
--  CERINTA 10: Crearea unei secvente

CREATE SEQUENCE seq_examene
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
-- FINAL CERINTA 10

--  CERINTA 11: Crearea tabelelor si inserarea datelor

-- 11.1 CREARE TABELE
CREATE TABLE JUDET (
    id_judet NUMBER(10) PRIMARY KEY,
    nume_judet VARCHAR2(50) NOT NULL
);

CREATE TABLE CENTRU_EXAMEN (
    id_centru NUMBER(10) PRIMARY KEY,
    nume_centru VARCHAR2(100) NOT NULL,
    id_judet NUMBER(10) REFERENCES JUDET(id_judet)
);

CREATE TABLE UNITATE_INVATAMANT (
    id_unitate NUMBER(10) PRIMARY KEY,
    denumire VARCHAR2(100) NOT NULL,
    id_judet NUMBER(10) REFERENCES JUDET(id_judet),
    id_unitate_parinte NUMBER(10) REFERENCES UNITATE_INVATAMANT(id_unitate)
);

CREATE TABLE CANDIDAT (
    id_candidat NUMBER(10) PRIMARY KEY,
    nume_complet VARCHAR2(100) NOT NULL,
    cnp VARCHAR2(13) UNIQUE NOT NULL,
    id_unitate NUMBER(10) REFERENCES UNITATE_INVATAMANT(id_unitate)
);

CREATE TABLE EXAMEN (
    id_examen NUMBER(10) PRIMARY KEY,
    denumire_examen VARCHAR2(50) NOT NULL,
    an_sustinere NUMBER(4) NOT NULL
);

CREATE TABLE DISCIPLINA (
    id_disciplina NUMBER(10) PRIMARY KEY,
    denumire_disciplina VARCHAR2(50) NOT NULL
);

CREATE TABLE SESIUNE (
    id_sesiune NUMBER(10) PRIMARY KEY,
    data_examen DATE NOT NULL,
    id_examen NUMBER(10) REFERENCES EXAMEN(id_examen),
    id_disciplina NUMBER(10) REFERENCES DISCIPLINA(id_disciplina)
);

CREATE TABLE SALA (
    id_sala NUMBER(10) PRIMARY KEY,
    denumire_sala VARCHAR2(50) NOT NULL,
    capacitate NUMBER(3),
    id_centru NUMBER(10) REFERENCES CENTRU_EXAMEN(id_centru)
);

CREATE TABLE PROFESOR (
    id_profesor NUMBER(10) PRIMARY KEY,
    nume_profesor VARCHAR2(100) NOT NULL,
    grad_didactic VARCHAR2(20)
);

CREATE TABLE REPART_SUPRAV (
    id_repartizare NUMBER(10) PRIMARY KEY,
    id_profesor NUMBER(10) REFERENCES PROFESOR(id_profesor),
    id_sala NUMBER(10) REFERENCES SALA(id_sala),
    id_sesiune NUMBER(10) REFERENCES SESIUNE(id_sesiune)
);

CREATE TABLE LUCRARE (
    id_lucrare NUMBER(10) PRIMARY KEY,
    cod_secret VARCHAR2(20),
    id_candidat NUMBER(10) REFERENCES CANDIDAT(id_candidat),
    id_sesiune NUMBER(10) REFERENCES SESIUNE(id_sesiune)
);

CREATE TABLE EVALUARE (
    id_evaluare NUMBER(10) PRIMARY KEY,
    nota_acordata NUMBER(4,2) CHECK (nota_acordata BETWEEN 1 AND 10),
    id_lucrare NUMBER(10) REFERENCES LUCRARE(id_lucrare),
    id_profesor NUMBER(10) REFERENCES PROFESOR(id_profesor)
);


-- 11.2 INSERARE DATE 
-- Judet: ID-uri generate de la 1 la 5
INSERT INTO JUDET VALUES (seq_examene.NEXTVAL, 'Bucuresti');
INSERT INTO JUDET VALUES (seq_examene.NEXTVAL, 'Cluj');
INSERT INTO JUDET VALUES (seq_examene.NEXTVAL, 'Timis');
INSERT INTO JUDET VALUES (seq_examene.NEXTVAL, 'Iasi');
INSERT INTO JUDET VALUES (seq_examene.NEXTVAL, 'Brasov');

-- Centru Examen: ID-uri de la 6 la 10
INSERT INTO CENTRU_EXAMEN VALUES (seq_examene.NEXTVAL, 'Centrul Zonal Bucuresti 1', 1);
INSERT INTO CENTRU_EXAMEN VALUES (seq_examene.NEXTVAL, 'Centrul Zonal Cluj 1', 2);
INSERT INTO CENTRU_EXAMEN VALUES (seq_examene.NEXTVAL, 'Centrul Zonal Timis 1', 3);
INSERT INTO CENTRU_EXAMEN VALUES (seq_examene.NEXTVAL, 'Centrul Zonal Iasi 1', 4);
INSERT INTO CENTRU_EXAMEN VALUES (seq_examene.NEXTVAL, 'Centrul Zonal Brasov 1', 5);

-- Unitate Invatamant: ID-uri de la 11 la 15
INSERT INTO UNITATE_INVATAMANT VALUES (seq_examene.NEXTVAL, 'Colegiul National Sf. Sava', 1, NULL);
INSERT INTO UNITATE_INVATAMANT VALUES (seq_examene.NEXTVAL, 'Liceul Teoretic Al. I. Cuza', 1, NULL);
INSERT INTO UNITATE_INVATAMANT VALUES (seq_examene.NEXTVAL, 'Colegiul National Emil Racovita', 2, NULL);
INSERT INTO UNITATE_INVATAMANT VALUES (seq_examene.NEXTVAL, 'Liceul Grigore Moisil', 3, NULL);
INSERT INTO UNITATE_INVATAMANT VALUES (seq_examene.NEXTVAL, 'Colegiul National Unirea', 5, NULL);

-- Candidat: ID-uri de la 16 la 20
INSERT INTO CANDIDAT VALUES (seq_examene.NEXTVAL, 'Popescu Ion', '5040101123456', 11);
INSERT INTO CANDIDAT VALUES (seq_examene.NEXTVAL, 'Ionescu Maria', '6040202123456', 11);
INSERT INTO CANDIDAT VALUES (seq_examene.NEXTVAL, 'Marin Andrei', '5050303123456', 12);
INSERT INTO CANDIDAT VALUES (seq_examene.NEXTVAL, 'Dumitru Elena', '6050404123456', 13);
INSERT INTO CANDIDAT VALUES (seq_examene.NEXTVAL, 'Stan Mihai', '5060505123456', 14);

-- Examen: ID-uri de la 21 la 25
INSERT INTO EXAMEN VALUES (seq_examene.NEXTVAL, 'Bacalaureat', 2026);
INSERT INTO EXAMEN VALUES (seq_examene.NEXTVAL, 'Evaluare Nationala', 2026);
INSERT INTO EXAMEN VALUES (seq_examene.NEXTVAL, 'Bacalaureat Toamna', 2026);
INSERT INTO EXAMEN VALUES (seq_examene.NEXTVAL, 'Simulare Bacalaureat', 2026);
INSERT INTO EXAMEN VALUES (seq_examene.NEXTVAL, 'Simulare Evaluare', 2026);

-- Disciplina: ID-uri de la 26 la 30
INSERT INTO DISCIPLINA VALUES (seq_examene.NEXTVAL, 'Limba Romana');
INSERT INTO DISCIPLINA VALUES (seq_examene.NEXTVAL, 'Matematica');
INSERT INTO DISCIPLINA VALUES (seq_examene.NEXTVAL, 'Informatica');
INSERT INTO DISCIPLINA VALUES (seq_examene.NEXTVAL, 'Fizica');
INSERT INTO DISCIPLINA VALUES (seq_examene.NEXTVAL, 'Istorie');

-- Sesiune: ID-uri de la 31 la 35
INSERT INTO SESIUNE VALUES (seq_examene.NEXTVAL, TO_DATE('2026-06-15', 'YYYY-MM-DD'), 21, 26);
INSERT INTO SESIUNE VALUES (seq_examene.NEXTVAL, TO_DATE('2026-06-17', 'YYYY-MM-DD'), 21, 27);
INSERT INTO SESIUNE VALUES (seq_examene.NEXTVAL, TO_DATE('2026-06-19', 'YYYY-MM-DD'), 21, 28);
INSERT INTO SESIUNE VALUES (seq_examene.NEXTVAL, TO_DATE('2026-08-20', 'YYYY-MM-DD'), 23, 26);
INSERT INTO SESIUNE VALUES (seq_examene.NEXTVAL, TO_DATE('2026-08-22', 'YYYY-MM-DD'), 23, 27);

-- Sala: ID-uri de la 36 la 40
INSERT INTO SALA VALUES (seq_examene.NEXTVAL, 'Amfiteatrul 1', 50, 6);
INSERT INTO SALA VALUES (seq_examene.NEXTVAL, 'Sala 101', 30, 6);
INSERT INTO SALA VALUES (seq_examene.NEXTVAL, 'Sala 102', 30, 7);
INSERT INTO SALA VALUES (seq_examene.NEXTVAL, 'Sala 201', 25, 8);
INSERT INTO SALA VALUES (seq_examene.NEXTVAL, 'Amfiteatrul 2', 60, 9);

-- Profesor: ID-uri de la 41 la 45
INSERT INTO PROFESOR VALUES (seq_examene.NEXTVAL, 'Avram Vasile', 'Grad I');
INSERT INTO PROFESOR VALUES (seq_examene.NEXTVAL, 'Radu Corina', 'Definitivat');
INSERT INTO PROFESOR VALUES (seq_examene.NEXTVAL, 'Tudor George', 'Grad II');
INSERT INTO PROFESOR VALUES (seq_examene.NEXTVAL, 'Manea Alina', 'Grad I');
INSERT INTO PROFESOR VALUES (seq_examene.NEXTVAL, 'Dinu Cristian', 'Debut');

-- Repartizare Supraveghere: ID-uri de la 46 la 55
INSERT INTO REPART_SUPRAV VALUES (seq_examene.NEXTVAL, 41, 36, 31);
INSERT INTO REPART_SUPRAV VALUES (seq_examene.NEXTVAL, 42, 36, 31);
INSERT INTO REPART_SUPRAV VALUES (seq_examene.NEXTVAL, 43, 37, 32);
INSERT INTO REPART_SUPRAV VALUES (seq_examene.NEXTVAL, 44, 38, 33);
INSERT INTO REPART_SUPRAV VALUES (seq_examene.NEXTVAL, 45, 39, 34);
INSERT INTO REPART_SUPRAV VALUES (seq_examene.NEXTVAL, 41, 36, 32);
INSERT INTO REPART_SUPRAV VALUES (seq_examene.NEXTVAL, 42, 37, 33);
INSERT INTO REPART_SUPRAV VALUES (seq_examene.NEXTVAL, 43, 38, 34);
INSERT INTO REPART_SUPRAV VALUES (seq_examene.NEXTVAL, 44, 39, 35);
INSERT INTO REPART_SUPRAV VALUES (seq_examene.NEXTVAL, 45, 40, 31);

-- Lucrare: ID-uri de la 56 la 60
INSERT INTO LUCRARE VALUES (seq_examene.NEXTVAL, 'SEC123', 16, 31);
INSERT INTO LUCRARE VALUES (seq_examene.NEXTVAL, 'SEC124', 16, 32);
INSERT INTO LUCRARE VALUES (seq_examene.NEXTVAL, 'SEC125', 17, 31);
INSERT INTO LUCRARE VALUES (seq_examene.NEXTVAL, 'SEC126', 18, 33);
INSERT INTO LUCRARE VALUES (seq_examene.NEXTVAL, 'SEC127', 19, 34);

-- Evaluare: ID-uri de la 61 la 71
INSERT INTO EVALUARE VALUES (seq_examene.NEXTVAL, 9.50, 56, 41);
INSERT INTO EVALUARE VALUES (seq_examene.NEXTVAL, 8.80, 56, 42);
INSERT INTO EVALUARE VALUES (seq_examene.NEXTVAL, 7.50, 57, 43);
INSERT INTO EVALUARE VALUES (seq_examene.NEXTVAL, 10.00, 57, 44);
INSERT INTO EVALUARE VALUES (seq_examene.NEXTVAL, 9.20, 58, 45);
INSERT INTO EVALUARE VALUES (seq_examene.NEXTVAL, 8.00, 58, 41);
INSERT INTO EVALUARE VALUES (seq_examene.NEXTVAL, 9.90, 59, 42);
INSERT INTO EVALUARE VALUES (seq_examene.NEXTVAL, 8.50, 59, 43);
INSERT INTO EVALUARE VALUES (seq_examene.NEXTVAL, 6.70, 60, 44);
INSERT INTO EVALUARE VALUES (seq_examene.NEXTVAL, 7.80, 60, 45);
INSERT INTO EVALUARE VALUES (seq_examene.NEXTVAL, 9.00, 60, 41);

-- INCEPUT CERINTA 12: Cele 5 cereri SQL complexe

-- Cererea 12.1: Subcerere sincronizata (3 tabele)
SELECT c.nume_complet, e.nota_acordata
FROM CANDIDAT c
JOIN LUCRARE l ON c.id_candidat = l.id_candidat
JOIN EVALUARE e ON l.id_lucrare = e.id_lucrare
WHERE e.nota_acordata > (
    SELECT AVG(e2.nota_acordata)
    FROM EVALUARE e2
    JOIN LUCRARE l2 ON e2.id_lucrare = l2.id_lucrare
    JOIN CANDIDAT c2 ON l2.id_candidat = c2.id_candidat
    WHERE c2.id_unitate = c.id_unitate
);

-- Cererea 12.2: Subcerere nesincronizata in clauza FROM
SELECT u.denumire, tabel_temp.nr_elevi
FROM UNITATE_INVATAMANT u
JOIN (
    SELECT id_unitate, COUNT(id_candidat) as nr_elevi
    FROM CANDIDAT
    GROUP BY id_unitate
) tabel_temp ON u.id_unitate = tabel_temp.id_unitate
WHERE tabel_temp.nr_elevi >= 2;

-- Cererea 12.3: Grupari de date, functii grup, filtrare HAVING cu subcerere
SELECT p.nume_profesor, COUNT(e.id_lucrare) as total_lucrari
FROM PROFESOR p
JOIN EVALUARE e ON p.id_profesor = e.id_profesor
GROUP BY p.nume_profesor
HAVING COUNT(e.id_lucrare) > (
    SELECT AVG(COUNT(id_lucrare))
    FROM EVALUARE
    GROUP BY id_profesor
);

-- Cererea 12.4: Ordonari si utilizarea functiilor NVL si DECODE
SELECT nume_profesor,
       NVL(DECODE(grad_didactic, 'Grad I', 'Senior', 'Grad II', 'Intermediar', 'Debut', 'Incepator'), 'Fara Grad') as status_grad
FROM PROFESOR
ORDER BY nume_profesor ASC;

-- Cererea 12.5: Functii pe siruri de caractere, date calendaristice, expresii CASE, clauza WITH
WITH Info_Sesiune AS (
    SELECT s.data_examen, d.denumire_disciplina
    FROM SESIUNE s
    JOIN DISCIPLINA d ON s.id_disciplina = d.id_disciplina
)
SELECT UPPER(denumire_disciplina) as materie,
       SUBSTR(denumire_disciplina, 1, 3) as cod,
       EXTRACT(YEAR FROM data_examen) as an,
       CASE 
          WHEN EXTRACT(MONTH FROM data_examen) IN (6, 7, 8) THEN 'Vara'
          ELSE 'Toamna/Iarna'
       END as perioada
FROM Info_Sesiune;

-- CERINTA 13: Operatii de actualizare (UPDATE) si suprimare (DELETE) 

-- 13.1 Actualizare (UPDATE 1)
UPDATE EVALUARE
SET nota_acordata = nota_acordata + 0.50
WHERE id_lucrare IN (
    SELECT l.id_lucrare FROM LUCRARE l
    JOIN CANDIDAT c ON l.id_candidat = c.id_candidat
    JOIN UNITATE_INVATAMANT u ON c.id_unitate = u.id_unitate
    WHERE u.denumire = 'Colegiul National Sf. Sava'
) AND nota_acordata <= 9.50;

-- 13.2 Actualizare (UPDATE 2)
UPDATE PROFESOR
SET grad_didactic = 'Grad I'
WHERE id_profesor IN (
    SELECT id_profesor FROM EVALUARE WHERE nota_acordata = 10
);

-- 13.3 Suprimare (DELETE)
DELETE FROM CANDIDAT
WHERE id_candidat NOT IN (
    SELECT id_candidat FROM LUCRARE
);
