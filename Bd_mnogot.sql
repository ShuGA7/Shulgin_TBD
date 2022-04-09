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
/*3.Вывести имя, фамилию, номер зачетки и дату рождения для студентов, средний балл которых выше среднего, а сумма риска всех хобби, которыми он занимается в данный момент, больше 0.9.*/
SELECT DISTINCT st.score, st.name, st.surname, st.adress
FROM student st
INNER JOIN
(
SELECT SUM(hb.risk) as st.su, sh.n_z
FROM hobbies hb,
student_hobby sh
WHERE hb.id= sh.hobby_id AND sh.finished_at IS NULL
GROUP BY sh.n_z
)
ON st.n_z = st.n_z
AND st.su > 0.9
WHERE st.score >
(
SELECT AVG(score)::numeric(3,2)
FROM student
)


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
WHERE SUBSTRING(st.course::varchar, 1,1) = '2' AND st.score >= 3 AND st.score < 4
/*10 Найти номера курсов, на которых более 50% студентов имеют более одного действующего хобби.*/
SELECT SUBSTRING(st.n_group::varchar,1,1) as course
FROM student st
INNER JOIN(SELECT SUBSTRING(st.n_group::varchar,1,1) as course, count(st.n_z) as countofstd
FROM student st
INNER JOIN(SELECT sh.n_z, count(sh.hobby_id)
FROM student_hobby sh
WHERE sh.finished_at IS NULL
GROUP BY sh.n_z
HAVING count(sh.n_z) > 1) en
ON en.n_z = st.n_z
GROUP BY SUBSTRING(st.n_group::varchar,1,1)) enend
ON SUBSTRING(st.n_group::varchar,1,1) = enend.course
INNER JOIN(SELECT SUBSTRING(st.n_group::varchar,1,1) as course, count(st.n_z) as countofstd
FROM student st
GROUP BY SUBSTRING(st.n_group::varchar,1,1)) ennext
ON SUBSTRING(st.n_group::varchar,1,1) = ennext.course
WHERE ennext.countofstd / 2 + ennext.countofstd % 2 <= enend.countofstd
GROUP BY SUBSTRING(st.n_group::varchar,1,1)
/*11Вывести номера групп, в которых не менее 60% студентов имеют балл не ниже 4.*/
SELECT DISTINCT st.n_group
FROM student st
INNER JOIN(SELECT st.n_group, count(st.n_z) as countofstd, sum(st.score)
FROM student st
WHERE st.score >= 4
GROUP BY st.n_group) tt
ON st.n_group = tt.n_group
INNER JOIN(SELECT st.n_group, count(st.n_z) as countofstd
FROM student st
GROUP BY st.n_group) en
ON st.n_group = en.n_group
WHERE en.countofstd / 100 * 60 <= en.countofstd
/*12 Для каждого курса подсчитать количество различных действующих хобби на курсе.*/
SELECT count(sh.n_z), SUBSTRING(st.course::varchar, 1,1)
FROM student_hobby sh, student st
WHERE sh.finished_at IS NULL AND sh.n_z = st.n_z
GROUP BY SUBSTRING(st.course::varchar,1,1)
/*13 Вывести номер зачётки, фамилию и имя, дату рождения и номер курса для всех отличников, не имеющих хобби. Отсортировать данные по возрастанию в пределах курса по убыванию даты рождения.*/
SELECT st.n_z, st.name, st.surname, st.adress, SUBSTRING(st.course::varchar, 1,1) as course
FROM student st
WHERE st.score = 5
EXCEPT SELECT DISTINCT en.n_z, en.name, en.surname, en.adress, SUBSTRING(en.course::varchar,1,1) as course
FROM student_hobby sh, student en
WHERE en.n_z = sh.n_z AND sh.finished_at IS NULL
ORDER BY course, adress
/*15 Для каждого хобби вывести количество людей, которые им занимаются.*/
SELECT hb.name, en.countofhobby
FROM hobbies hb
INNER JOIN
(SELECT count(sh.n_z) as countofhobby, sh.hobby_id
FROM student_hobby sh
WHERE sh.finished_at IS NULL
GROUP BY sh.hobby_id) en
ON en.hobby_id = hb.id
/*16 Вывести ИД самого популярного хобби.*/
SELECT hb.name
FROM hobbies hb
INNER JOIN
(SELECT count(sh.n_z) as countofhobby, sh.hobby_id
FROM student_hobby sh
GROUP BY sh.hobby_id) en
ON en.hobby_id = hb.id
ORDER BY en.countofhobby DESC
LIMIT 1

