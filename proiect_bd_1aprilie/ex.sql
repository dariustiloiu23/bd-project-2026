select
c.nume_centru, count(s.id_sala) as nr_sali
from CENTRU_EXAMEN c
join sala s on c.ID_CENTRU=s.ID_CENTRU
group by c.ID_CENTRU, c.NUME_CENTRU
having sum(s.CAPACITATE)>100;

select 
d.DENUMIRE_DISCIPLINA, avg(e.NOTA_ACORDATA) as medie
from disciplina d
join sesiune s on d.ID_DISCIPLINA=s.ID_DISCIPLINA
join lucrare l on s.ID_SESIUNE=l.ID_SESIUNE
join evaluare e on l.ID_LUCRARE=e.ID_LUCRARE
group by  d.DENUMIRE_DISCIPLINA
having medie>8.50;

select distinct
c.NUME_COMPLET
from candidat c
where c.ID_CANDIDAT in(
    select l.id_candidat
    from lucrare l
    JOIN evaluare e ON l.ID_LUCRARE = e.ID_LUCRARE
    JOIN sesiune s ON l.ID_SESIUNE = s.ID_SESIUNE
    JOIN disciplina d ON s.ID_DISCIPLINA = d.ID_DISCIPLINA
    WHERE d.DENUMIRE_DISCIPLINA = 'Matematica' 
      AND e.NOTA_ACORDATA = 10
);

select 
to_char(DATA_EXAMEN, 'mm') as luna,
count(ID_SESIUNE) as nr_sesiuni
from sesiune 
group by to_char(DATA_EXAMEN, 'mm');

select 
c.NUME_COMPLET, e.NOTA_ACORDATA
from candidat c
join lucrare l on c.ID_CANDIDAT=l.ID_CANDIDAT
join evaluare e on e.ID_LUCRARE=l.ID_LUCRARE
where e.NOTA_ACORDATA>(select
 avg(nota_acordata)
 from evaluare
 );

--create sequence seq_centru
start with 100
INCREMENT by 1;

--insert into centru_examen (id_centru, nume_centru, id_judet) values(seq_centru.nextval, 'czt', 1);

alter table sala
add CONSTRAINT chk check(capacitate>0);

--SELECT
table_name
from user_tables
where upper(table_name) like 'E%';

--alter table sala
drop constraint chk;

--create table contestatie(
  id_contestatie number primary key,
  data_depunere date not null,
id_lucrare number not null,
nota number(4,2) check(nota>=1 and nota<=10), constraint fk_contestatie foreign key (id_lucrare) references lucrare(id_lucrare)
--);

create or replace view v_program_supraveghere as
select  p.nume_profesor
from profesor p

 


