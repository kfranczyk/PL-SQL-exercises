/*
Utworzyć w bazie danych tabelę o nazwie StudExamDates. Tabela powinna 
zawierać informacje o studentach oraz datach zdanych egzaminów z 
poszczególnych przedmiotów. 

W tabeli utworzyć cztery kolumny. Trzy kolumny będą opisywać studenta 
(identyfikator, imię i nazwisko). Czwarta - przedmiot (nazwa przedmiotu) 
oraz datę zdanego egzaminu z tego przedmiotu. 

Dane dotyczące przedmiotu i daty egzaminu należy umieścić w kolumnie będącej
 kolekcją typu tabela zagnieżdżona. Wprowadzić dane do tabeli StudExamDates
  na podstawie danych zgromadzonych w tabelach Egzaminy, Studenci i Przedmioty.
   Następnie wyświetlić dane znajdujące się w tabeli StudExamDates. 
*/

create or replace type zdane_egzaminy_typ as object(
    nazwa_przedmiotu varchar2(100),
    data_zdania_egzaminu DATE
);
create or replace type zdane_egzaminy is table of zdane_egzaminy_typ;

create table StudExamDates(
    id_studenta VARCHAR2(7),
    imie_studenta varchar2(15),
    nazwisko_studenta varchar2(25),
    egzaminy_studenta zdane_egzaminy
)nested table egzaminy_studenta STORE AS zdane_egzaminy_studenta;

DECLARE 
    kolekcja zdane_egzaminy := zdane_egzaminy(); 
	i NUMBER := 1; 
    cursor c1 is select DISTINCT s.id_student,  s.imie, s.nazwisko 
                from studenci s inner join EGZAMINY e 
                on e.id_student = s.id_student; 
	cursor c2(id_student_var VARCHAR2) is select p.nazwa_przedmiot, e.data_egzamin 
				from EGZAMINY e inner join PRZEDMIOTY p 
        		on e.id_przedmiot = p.id_przedmiot 
        		where UPPER(e.zdal) like 'T' and e.id_student like id_student_var;
BEGIN 
	for vc1 in c1 loop 
    	i:=1; 
		for vc2 in c2(vc1.id_student) loop 
    		kolekcja.extend();  
        	kolekcja(i) := zdane_egzaminy_typ(vc2.nazwa_przedmiot, vc2.data_egzamin);  
        	i := i + 1;  
    	end loop;  
 
        INSERT INTO StudExamDates VALUES ( vc1.id_student, vc1.imie, vc1.nazwisko, kolekcja); 
		kolekcja.Delete(); 
    end loop;  
END;

select sed.ID_STUDENTA,sed.IMIE_STUDENTA,sed.NAZWISKO_STUDENTA, es.*  from StudExamDates sed , table(sed.egzaminy_studenta) es
