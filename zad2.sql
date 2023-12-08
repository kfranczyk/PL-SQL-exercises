/*
Utworzyć kolekcję typu tablica zagnieżdżona i nazwać ją NT_Studenci
 Kolekcja powinna zawierać elementy opisujące datę ostatniego
  egzaminu poszczególnych studentów. Zainicjować wartości elementów 
  kolekcji na podstawie danych z tabel Studenci i Egzaminy. Do opisu 
  studenta należy użyć jego identyfikatora, nazwiska i imienia. Zapewnić,
   by elementy kolekcji uporządkowane były wg daty egzaminu, od najstarszej
    do najnowszej (tzn. pierwszy element kolekcji zawiera studenta, który 
    zdawał najwcześniej egzamin). Po zainicjowaniu kolekcji, wyświetlić 
    wartości znajdujące się w poszczególnych jej elementach.

*/

/* czyli asc daty */


DECLARE
    type nt_studenci_type is record(
        id_studenta varchar2(7),
        nazwisko_studenta varchar2(25),
        imie_studenta varchar2(15),
        data_ost_egzam DATE
    );
    type nt_studenci is table of nt_studenci_type;

    cursor c1 is select s.id_student, s.nazwisko, s.imie 
                from studenci s;

    kolekcja nt_studenci := nt_studenci();
    data_egz DATE;
    i NUMBER := 1;
BEGIN
    for vc1 in c1 LOOP
        data_egz := null;

        select DATA_EGZAMIN into data_egz from EGZAMINY
            WHERE ID_STUDENT = vc1.id_student
            order by 1 ASC
            fetch first 1 rows only;

        if data_egz IS NOT NULL then
            kolekcja.extend();
            kolekcja(i) := nt_studenci_type(vc1.ID_STUDENT, vc1.NAZWISKO, vc1.IMIE, data_egz);
            i := i+1;
        end if;
    end loop;

    for j in 1..kolekcja.count() LOOP
        DBMS_OUTPUT.PUT_LINE( kolekcja(j).id_studenta || ' ' || kolekcja(j).nazwisko_studenta || ' ' || kolekcja(j).imie_studenta || ' ' || kolekcja(j).data_ost_egzam );
    end loop;

END;