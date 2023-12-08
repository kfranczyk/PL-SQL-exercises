/*
Dla każdego przedmiotu wskazać tych studentów, którzy 
zdawali egzamin w ostatnim dniu egzaminowania z tego przedmiotu. 
Jeśli nikt nie zdawał egzaminu z danego przedmiotu, należy wyświetlić
 odpowiedni komunikat. W rozwiązaniu zadania należy wykorzystać 
 podprogram (funkcja lub procedura) PL/SQL, który umożliwi wyznaczenie 
 daty ostatniego dnia egzaminowania z danego przedmiotu. 
*/

DECLARE 
    cursor c1 is select ID_PRZEDMIOT from PRZEDMIOTY;
    cursor c2(id_przedm_var NUMBER, data_egzam_var DATE) is select DISTINCT s.ID_STUDENT, s.IMIE, s.NAZWISKO 
                from STUDENCI s INNER JOIN EGZAMINY e
                ON e.ID_STUDENT = s.ID_STUDENT
                WHERE E.DATA_EGZAMIN = data_egzam_var and e.ID_PRZEDMIOT = id_przedm_var;

    data_var DATE;

    FUNCTION get_last_exam_day (id_przedm_var NUMBER) RETURN DATE IS
        ret_val date;
    BEGIN
        select DATA_EGZAMIN into ret_val from EGZAMINY
            where ID_PRZEDMIOT = id_przedm_var
            order by 1 desc
            FETCH FIRST 1 ROWS ONLY;
        
      RETURN ret_val;
    END get_last_exam_day;
BEGIN 
    for vc1 in c1 LOOP
        data_var := get_last_exam_day(vc1.ID_PRZEDMIOT);
        if data_var IS NOT NULL THEN 
            for vc2 in c2(vc1.ID_PRZEDMIOT ,data_var) loop
                DBMS_OUTPUT.PUT_LINE( vc2.ID_STUDENT || ' ' ||  vc2.IMIE || ' ' || vc2.NAZWISKO || ' ' || data_var || ' ' ||vc1.ID_PRZEDMIOT);
            end loop;
        else
            DBMS_OUTPUT.PUT_LINE('nikt nie zdawał egzaminu z przedmiotu o id:' || vc1.ID_PRZEDMIOT);
        end if;
    end loop;
END;


