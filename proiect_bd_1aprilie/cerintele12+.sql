
-- Cerinta 12: 5 Cereri SQL Complexe

-- Cererea 1
-- Bifeaza cerintele: 
-- c) grupări de date, funcții grup, filtrare la nivel de grupuri cu subcereri nesincronizate în HAVING
-- Enunț: Să se afișeze denumirea unităților de învățământ și numărul de candidați înscriși, dar doar pentru unitățile care au un număr de candidați mai mare sau egal cu media candidaților per școală.

SELECT u.denumire, COUNT(c.id_candidat) AS numar_candidati
FROM unitate_invatamant u
JOIN candidat c ON u.id_unitate = c.id_unitate
GROUP BY u.denumire
HAVING COUNT(c.id_candidat) >= (
    SELECT AVG(COUNT(id_candidat))
    FROM candidat
    GROUP BY id_unitate
)
ORDER BY numar_candidati DESC;


-- Cererea 2
-- Bifeaza cerintele:
-- a) subcereri sincronizate în care intervin cel puțin 3 tabele
-- Enunț: Să se afișeze numele candidaților care au obținut cel puțin o notă strict mai mare decât nota medie obținută de toți candidații din aceeași unitate de învățământ a lor, la aceeași sesiune de examen.

SELECT DISTINCT c.nume_complet
FROM candidat c
JOIN lucrare l ON c.id_candidat = l.id_candidat
JOIN evaluare e ON l.id_lucrare = e.id_lucrare
WHERE e.nota_acordata > (
    SELECT AVG(e2.nota_acordata)
    FROM evaluare e2
    JOIN lucrare l2 ON e2.id_lucrare = l2.id_lucrare
    JOIN candidat c2 ON l2.id_candidat = c2.id_candidat
    WHERE c2.id_unitate = c.id_unitate   
      AND l2.id_sesiune = l.id_sesiune   
);


-- Cererea 3
-- Bifeaza cerintele:
-- b) subcereri nesincronizate în clauza FROM
-- f) utilizarea a cel puțin 1 bloc de cerere (clauza WITH)
-- Enunț: Folosind clauza WITH și o subcerere în FROM, să se afișeze capacitatea fiecărei săli și capacitatea medie a tuturor sălilor, pentru sălile care au capacitatea peste medie.

WITH StatisticiSali AS (
    SELECT id_sala, denumire_sala, capacitate
    FROM sala
)
SELECT s.denumire_sala, s.capacitate, medii.capacitate_medie
FROM StatisticiSali s,
     (SELECT AVG(capacitate) AS capacitate_medie FROM sala) medii
WHERE s.capacitate > medii.capacitate_medie;


-- Cererea 4
-- Bifeaza cerintele:
-- d) ordonari și utilizarea funcțiilor NVL și DECODE în cadrul aceleiași cereri
-- Enunț: Să se afișeze școlile, ID-ul școlii părinte (dacă nu au, se afișează 'Unitate Principala') și o etichetă (DECODE) pentru județul de care aparțin (1='Bucuresti', 2='Cluj', restul 'Alt judet'). Se va ordona alfabetic.

SELECT denumire,
       NVL(TO_CHAR(id_unitate_parinte), 'Unitate Principala') AS status_subordonare,
       DECODE(id_judet, 1, 'Bucuresti', 2, 'Cluj', 'Alt judet') AS regiune
FROM unitate_invatamant
ORDER BY denumire ASC;


-- Cererea 5
-- Bifeaza cerintele:
-- e) 2 funcții pe șiruri de caractere, 2 funcții pe date calendaristice, o expresie CASE
-- Enunț: Pentru fiecare sesiune, afișați un cod generat din primele 3 litere ale disciplinei (majuscule) concatenate cu anul, câte luni au trecut de la probă, și o etichetă CASE pentru sezon (vară/toamnă).

SELECT 
    UPPER(SUBSTR(d.denumire_disciplina, 1, 3)) || '-' || TO_CHAR(s.data_examen, 'YYYY') AS cod_sesiune,
    ROUND(MONTHS_BETWEEN(SYSDATE, s.data_examen)) AS luni_trecute_de_la_examen,
    EXTRACT(MONTH FROM s.data_examen) AS luna_calendaristica,
    CASE
        WHEN EXTRACT(MONTH FROM s.data_examen) IN (6, 7) THEN 'Sesiune de Vara'
        WHEN EXTRACT(MONTH FROM s.data_examen) IN (8, 9) THEN 'Sesiune de Toamna'
        ELSE 'Alte sesiuni'
    END AS tip_sesiune
FROM sesiune s
JOIN disciplina d ON s.id_disciplina = d.id_disciplina;



-- Cerinta 13: 3 Operații de actualizare/stergere cu subcereri

-- 1. UPDATE cu subcerere
-- Enunt: Se marește capacitatea cu 5 locuri pentru toate sălile din centrele de examen aflate în București.

UPDATE sala
SET capacitate = capacitate + 5
WHERE id_centru IN (
    SELECT c.id_centru
    FROM centru_examen c
    JOIN judet j ON c.id_judet = j.id_judet
    WHERE j.nume_judet = 'Bucuresti'
);

-- 2. UPDATE cu subcerere
-- Enunt: Se adaugă un bonus de 0.50 puncte (fără a depăși nota 10) la evaluările lucrărilor scrise de candidații de la 'Colegiul National Sf. Sava'.

UPDATE evaluare
SET nota_acordata = LEAST(nota_acordata + 0.50, 10)
WHERE id_lucrare IN (
    SELECT l.id_lucrare
    FROM lucrare l
    JOIN candidat c ON l.id_candidat = c.id_candidat
    JOIN unitate_invatamant u ON c.id_unitate = u.id_unitate
    WHERE u.denumire = 'Colegiul National Sf. Sava'
);

-- 3. DELETE cu subcerere
-- Enunt: Se sterg evaluările acordate de profesorii stagiari ('Debutant') la disciplina 'Matematica', din motive de reevaluare.

DELETE FROM evaluare
WHERE id_profesor IN (SELECT id_profesor FROM profesor WHERE grad_didactic = 'Debutant')
  AND id_lucrare IN (
      SELECT l.id_lucrare
      FROM lucrare l
      JOIN sesiune s ON l.id_sesiune = s.id_sesiune
      JOIN disciplina d ON s.id_disciplina = d.id_disciplina
      WHERE d.denumire_disciplina = 'Matematica'
  );

COMMIT;




-- Cerinta 14: Vizualizare complexa si operatii LMD

-- 1. Crearea vizualizării complexe (conține un JOIN)
-- Enunt: Sa se creeze o vizualizare care expune detaliile candidaților impreuna cu denumirea școlii de proveniență și județul.

CREATE OR REPLACE VIEW V_CANDIDATI_SCOLI AS
SELECT c.id_candidat,
       c.nume_complet,
       c.cnp,
       c.id_unitate,
       u.denumire AS nume_scoala,
       u.id_judet
FROM candidat c
JOIN unitate_invatamant u ON c.id_unitate = u.id_unitate;


-- 2. Operație LMD Permisa
-- Enunț: Modificăm numele unui candidat prin intermediul vizualizării.
-- Acest UPDATE este permis pt ca modifica exclusiv un atribut dintr-un 'key-preserved table' (tabelul baza CANDIDAT) în cadrul vizualizării.

UPDATE V_CANDIDATI_SCOLI
SET nume_complet = 'Avram Mihai-Alexandru'
WHERE id_candidat = 80;

-- (Va afisa: 1 row updated)


-- 3. Operație LMD Nepermisă
-- Enunt: Încercăm să inserăm o linie nouă prin vizualizarea complexă.
-- Această operație va genera o eroare, deoarece vizualizarea implică mai multe tabele (un JOIN), iar Oracle nu știe cum să impartă datele inserate între tabelul CANDIDAT și UNITATE_INVATAMANT.

INSERT INTO V_CANDIDATI_SCOLI (id_candidat, nume_complet, cnp, id_unitate, nume_scoala, id_judet)
VALUES (99, 'Test Elev', '5060708123456', 50, 'Colegiul Fals', 1);







-- Cerinta 15: 3 Cereri Suplimentare (Outer-Join, Division, Top-N)

-- 1. OUTER-JOIN pe minimum 4 tabele
-- Enunt: Sa se afiseze toti candidatii inscrisi, scoala de proveniență, codul secret al lucrarii și nota obținută. 
-- Folosind LEFT OUTER JOIN, ne asigurăm că afișăm candidații chiar dacă aceștia nu au depus încă o lucrare sau nu au primit o notă.

SELECT c.nume_complet, 
       u.denumire AS scoala_provenienta, 
       l.cod_secret, 
       e.nota_acordata
FROM candidat c
LEFT OUTER JOIN unitate_invatamant u ON c.id_unitate = u.id_unitate
LEFT OUTER JOIN lucrare l ON c.id_candidat = l.id_candidat
LEFT OUTER JOIN evaluare e ON l.id_lucrare = e.id_lucrare
ORDER BY c.nume_complet;


-- 2. Operația DIVISION (Diviziune)
-- Enunt: Să se gasească numele candidaților care au susținut și au depus lucrări la ABSOLUT TOATE sesiunile de examen disponibile în sistem (rezolvare prin dublu NOT EXISTS).
--  In setul nostru curent de date de test, niciun elev nu a participat chiar la toate cele 5 probe posibile, deci rezultatul corect afisat va fi un tabel gol (ceea ce validează filtrarea corectă).

SELECT c.nume_complet
FROM candidat c
WHERE NOT EXISTS (
    SELECT 1
    FROM sesiune s
    WHERE NOT EXISTS (
        SELECT 1
        FROM lucrare l
        WHERE l.id_candidat = c.id_candidat
          AND l.id_sesiune = s.id_sesiune
    )
);


-- 3. Analiza TOP-N
-- Enunt: Să se afiseze Top 3 cele mai bune lucrări din întregul județ, incluzând numele candidatului și nota obținută, ordonate descrescător după notă.

SELECT nume_complet, nota_acordata
FROM (
    SELECT c.nume_complet, e.nota_acordata
    FROM candidat c
    JOIN lucrare l ON c.id_candidat = l.id_candidat
    JOIN evaluare e ON l.id_lucrare = e.id_lucrare
    ORDER BY e.nota_acordata DESC
)
WHERE ROWNUM <= 3;

