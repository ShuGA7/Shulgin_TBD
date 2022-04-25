/*1.Вывести все имена и фамилии студентов, и название хобби, которыми занимается этот студент.*/
SELECT st.name, st.surname, hb.name
FROM hobbies hb, student st, student_hobby shb
WHERE shb.hobby_id = hb.id AND shb.n_z = st.n_z; 
/*2.Вывести информацию о студенте, занимающимся хобби самое продолжительное время.*/
SELECT st.name, st.surname, shb.started_at
FROM student_hobby shb, student st
WHERE shb.finished_at AND st.n_z = shb.n_z IS NULL
ORDER BY shb.started_at
/*3.Вывести имя, фамилию, номер зачетки и дату рождения для студентов, средний балл которых выше среднего, а сумма риска всех хобби, которыми он занимается в данный момент, больше 0.9.*/
SELECT DISTINCT st.score, st.name, st.surname, st.adress
FROM student st
INNER JOIN
(
SELECT SUM(hb.risk) as st.s, shb.n_z
FROM hobbies hb,
student_hobby shb
WHERE hb.id= shb.hobby_id AND shb.finished_at IS NULL
GROUP BY shb.n_z
)
ON st.n_z = st.n_z
AND st.s > 0.9
WHERE st.score >
(
SELECT AVG(score)::numeric(3,2)
FROM student
)

/*6 Найти средний балл в каждой группе, учитывая только баллы студентов, которые имеют хотя бы одно действующее хобби.*/
SELECT DISTINCT st.n_group, avg(st.score)::numeric(3,2)
FROM student st
INNER JOIN(SELECT DISTINCT shb.id
FROM student_hobby shb, hobbies hb
WHERE shb.hobby_id = hb.id AND shb.finished_at IS null) p
ON p.id = st.n_z
GROUP BY st.n_group

/*8 Найти все хобби, которыми увлекаются студенты, имеющие максимальный балл.*/
SELECT hb.name
FROM 
INNER JOIN student_hobby shb on shb.n_z = st.n_z
INNER JOIN hobbies hb on hb.id = shb.hobby_id
WHERE st.score = (SELECT max(st.score)
FROM student st)
/*9 Найти все действующие хобби, которыми увлекаются троечники 2-го курса.*/
SELECT hb.name
FROM hobbies hb
INNER JOIN student_hobby shb on shb.id = hb.id AND shb.finished_at IS NULL
INNER JOIN student st on st.n_z = sh.id
WHERE SUBSTRING(st.n_group::varchar, 1,1) = '2' AND st.score > 2 AND st.score < 4
/*12 Для каждого курса подсчитать количество различных действующих хобби на курсе.*/
SELECT count(shb.n_z), SUBSTRING(st.course::varchar, 1,1)
FROM student_hobby shb, student st
WHERE shb.finished_at IS NULL AND shb.n_z = st.n_z
GROUP BY SUBSTRING(st.course::varchar,1,1)
/*13 Вывести номер зачётки, фамилию и имя, дату рождения и номер курса для всех отличников, не имеющих хобби. Отсортировать данные по возрастанию в пределах курса по убыванию даты рождения.*/
SELECT DISTINCT st.n_z, st.name, st.surname, st.date, SUBSTRING(st.course::varchar,1,1) as course
FROM student_hobby shb, student st
WHERE st.n_z = shb.n_z AND shb.finished_at IS NULL and st.score = 5
ORDER BY course, date
/*15 Для каждого хобби вывести количество людей, которые им занимаются.*/
SELECT hb.name, en.countofhobby
FROM hobbies hb
INNER JOIN
(SELECT count(shb.n_z) as countofhobby, shb.hobby_id
FROM student_hobby shb
WHERE shb.finished_at IS NULL
GROUP BY shb.hobby_id) en
ON en.hobby_id = hb.id
/*16 Вывести ИД самого популярного хобби.*/
SELECT hb.name
FROM hobbies hb
INNER JOIN
(SELECT count(shb.n_z) as countofhobby, shb.hobby_id
FROM student_hobby shb
GROUP BY shb.hobby_id) en
ON en.hobby_id = hb.id
ORDER BY en.countofhobby DESC
LIMIT 1

