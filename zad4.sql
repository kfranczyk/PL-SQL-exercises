/*
Który egzaminator przeprowadził więcej niż 50 egzaminów w tym samym 
ośrodku w jednym roku? Zadanie należy rozwiązać przy użyciu techniki 
wyjątków (jeśli to konieczne, można dodatkowo zastosować kursory). W 
odpowiedzi proszę umieścić pełne dane o ośrodku (identyfikator, nazwa), 
informację o roku (w formacie YYYY), pełne dane egzaminatora (identyfikator,
 nazwisko, imię) oraz liczbę egzaminów.

Zadanie należy wykonać, wykorzystując technikę wyjątków.
*/

DECLARE
    more_than_50_exc EXCEPTION;
    cursor c1 is select ID_OSRODEK, NAZWA_OSRODEK from OSRODKI;

    cursor c2(id_osr_var NUMBER) is select eg.ID_EGZAMINATOR, eg.IMIE, eg.NAZWISKO, extract(year from e.DATA_EGZAMIN) rok, count(ID_EGZAMIN) liczb_egzam
                from EGZAMINATORZY eg INNER JOIN EGZAMINY e
                ON eg.ID_EGZAMINATOR = e.ID_EGZAMINATOR
                WHERE id_osr_var = e.ID_OSRODEK
                GROUP BY eg.ID_EGZAMINATOR, eg.IMIE, eg.NAZWISKO, extract(year from e.DATA_EGZAMIN)
                order by liczb_egzam DESC;
    vc2 c2%ROWTYPE;
BEGIN
    for vc1 in c1 LOOP
        IF c2%ISOPEN THEN
            LOOP
                BEGIN
                    FETCH c2 into vc2;
                    exit when c2%NOTFOUND;
                    if vc2.liczb_egzam > 50 then 
                        RAISE more_than_50_exc;
                    end if;
                    
                    EXCEPTION 
                        WHEN more_than_50_exc THEN
                            DBMS_OUTPUT.PUT_LINE('OŚRODEK: '|| vc1.ID_OSRODEK || ' ' || vc1.NAZWA_OSRODEK || ' ROK: ' || vc2.rok || ' ' || 'EGZAMINATOR: ' || ' ' || vc2.ID_EGZAMINATOR || ' ' ||vc2.imie || ' ' || vc2.nazwisko || ' ' || vc2.liczb_egzam);
                END;
            end loop;
            close c2;
        end if;
    end loop;
END;