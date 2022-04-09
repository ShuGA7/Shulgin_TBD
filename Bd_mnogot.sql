/*1.Вывести все имена и фамилии студентов, и название хобби, которыми занимается этот студент.*/
SELECT st.name, st.surname, hb.name
FROM student st, hobbies hb, student_hobby sh
WHERE sh.n_z = st.n_z AND sh.hobby_id = hb.id;
/*2.Вывести информацию о студенте, занимающимся хобби самое продолжительное время.*/
SELECT st.name, st.surname, sh.started_at
FROM student st, student_hobby sh
WHERE st.n_z = sh.n_z AND sh.finished_at IS NULL
ORDER BY sh.started_at
LIMIT 1

/*6 Найти средний балл в каждой группе, учитывая только баллы студентов, которые имеют хотя бы одно действующее хобби.*/
SELECT DISTINCT st.n_group, avg(st.score)::numeric(3,2)
FROM student st
INNER JOIN(SELECT DISTINCT sh.id
FROM student_hobby sh, hobbies hb
WHERE sh.hobby_id = hb.id AND sh.finished_at IS null) tt
ON tt.id = st.n_z
GROUP BY st.n_group

/*7 Найти название, риск, длительность в месяцах самого продолжительного хобби из действующих, указав номер зачетки студента.*/
SELECT hb.name, hb.risk, -1 * (to_char(tt.dlit, 'YYYY')::numeric(5,0) * 12 + to_char(tt.dlit, 'MM')::numeric(5,0)) + (to_char(now(), 'YYYY')::numeric(5,0) * 12 + to_char(now(),'MM')::numeric(5,0))
FROM hobbies hb
INNER JOIN(
SELECT sh.hobby_id, min(sh.started_at) as dlit, sh.id
FROM student_hobby sh
GROUP BY sh.id, sh.hobby_id
HAVING sh.id = 3
LIMIT 1) tt
ON tt.hobby_id = hb.id

/*8 Найти все хобби, которыми увлекаются студенты, имеющие максимальный балл.*/
SELECT hb.name
FROM student st
INNER JOIN student_hobby sh on sh.n_z = st.n_z
INNER JOIN hobbies hb on hb.id = sh.hobby_id
WHERE st.score = (SELECT max(st.score)
FROM student st)
/*9 Найти все действующие хобби, которыми увлекаются троечники 2-го курса.*/
SELECT hb.name
FROM hobbies hb
INNER JOIN student_hobby sh on sh.hobby_id = hb.id AND sh.finished_at IS NULL
INNER JOIN student st on st.n_z = sh.n_z
WHERE SUBSTRING(st.n_group::varchar, 1,1) = '2' AND st.score >= 3 AND st.score < 4
