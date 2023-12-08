/*
Dla każdego egzaminatora wskazać tych studentów, których egzaminował on
 w ciągu ostatnich trzech dni swojego egzaminowania. Jeżeli dany egzaminator
  nie przeprowadził żadnego egzaminu, proszę wyświetlić komunikat "Brak 
  egzaminów". W odpowiedzi należy umieścić dane identyfikujące egzaminatora 
  (identyfikator, nazwisko, imię), dzień egzaminowania 
  (w formacie DD-MM-YYYY) i egzaminowanych studentów (identyfikator,
   nazwisko, imię). Zadanie proszę wykonać z użyciem kursora. 
*/

DECLARE 
    cursor c1 is select ID_EGZAMINATOR, imie, NAZWISKO from EGZAMINATORZY;

    cursor c2(id_egzaminatora_var VARCHAR2) is select DISTINCT DATA_EGZAMIN from EGZAMINY
                                where ID_EGZAMINATOR = id_egzaminatora_var
                                ORDER BY 1 DESC
                                FETCH FIRST 3 ROWS ONLY;
    cursor c3(id_egzaminatora_var VARCHAR2, data_egzaminu_var DATE) is
                select DISTINCT s.id_student, s.nazwisko, s.imie 
                from studenci s inner join EGZAMINY e
                on e.id_student = s.id_student
                where e.DATA_EGZAMIN = data_egzaminu_var and e.ID_EGZAMINATOR = id_egzaminatora_var;

    dat_egz_temp DATE;
BEGIN
    for vc1 in c1 loop

        OPEN c2(vc1.id_egzaminator);
        IF c2%ISOPEN THEN
            for i IN 1..3 LOOP
                FETCH c2 into dat_egz_temp;
                if c2%NOTFOUND then 
                    DBMS_OUTPUT.PUT_LINE('dany egzaminator nie przeprowadził żadnego egzaminu');
                else 
                    for vc3 in c3(vc1.id_egzaminator, dat_egz_temp) loop
                        dbms_output.put_line('EGZAMINATOR: ' || ' ' || vc1.ID_EGZAMINATOR || ' ' ||vc1.imie || ' ' || vc1.nazwisko || ' ' || dat_egz_temp || ' STUDENT: ' || vc3.id_student || ' ' || vc3.imie || ' ' || vc3.nazwisko);
                    end loop;
                end if;
                exit when c2%NOTFOUND;
            end loop;
            close c2;
        end if;

    end loop;
END;