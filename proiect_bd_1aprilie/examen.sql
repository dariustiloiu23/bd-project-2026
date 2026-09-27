CREATE or replace VIEW Vizualizare_Rezultate_Cumulate AS
SELECT 
    c.id_candidat,
    c.nume_complet,
    l.id_lucrare,
    SUM(e.nota_acordata) AS rezultat_cumulat
FROM CANDIDAT c
JOIN LUCRARE l ON c.id_candidat = l.id_candidat
JOIN EVALUARE e ON l.id_lucrare = e.id_lucrare
GROUP BY 
    c.id_candidat,
    c.nume_complet,
    l.id_lucrare;

select * from Vizualizare_Rezultate_Cumulate;