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

--4. Вывести фамилию, имя, зачетку, дату рождения, название хобби и длительность в месяцах, для всех завершенных хобби Диапазон дат.
SELECT st.surname, st.name, st.n_z, st.adress, hb.name, extract(month from age(shb.finished_at, shb.started_at)) + 12 * extract(year from age(sh.finished_at, sh.started_at)) as months, sh.finished_at 
FROM student st
INNER JOIN student_hobby shb on shb.n_z = st.n_z
INNER JOIN hobbies hb on hb.id = shb.hobby_id
Where shb.finished_at IS NOT null

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
SELECT DISTINCT st.n_z, st.name, st.surname, st.adress, SUBSTRING(st.course::varchar,1,1) as course
FROM student_hobby shb, student st
WHERE st.n_z = shb.n_z AND shb.finished_at IS NULL and st.score = 5
ORDER BY course, adress
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
/*18 Вывести ИД 3х хобби с максимальным риском.*/
Select hb.id
From hobbies hb
Where hb.risk >= (
Select hb.risk
From hobbies hb
order by hb.risk desc
Limit 1 offset 2
)
/*19 Вывести 10 студентов, которые занимаются одним (или несколькими) хобби самое продолжительно время.*/
SELECT st.name, st.surname, sh.started_at
FROM student st, student_hobby sh
WHERE st.n_z = sh.n_z AND sh.finished_at IS NULL
ORDER BY sh.started_at Limit 10

/*20 Создать представление, которое выводит номер зачетки, имя и фамилию студентов, отсортированных по убыванию среднего балла.*/

CREATE OR REPLACE VIEW st_avscore AS
SELECT st.n_z, st.name, st.surname
FROM student st
ORDER BY st.score DESC

SELECT * FROM st_avscore

/*24 Представление: для каждого курса подсчитать количество студентов на курсе и количество отличников.*/

CREATE OR REPLACE VIEW st_greatnum AS
SELECT 
LEFT(st.n_group::VARCHAR,1) course, 
COUNT(st.n_z) allstudents, 
COUNT(st.n_z) FILTER (WHERE st.score >= 4.5) greatstudents
FROM student st
GROUP BY LEFT(st.n_group::VARCHAR,1) 

SELECT * FROM st_greatnum

/*27 Для каждой буквы алфавита из имени найти максимальный, средний и минимальный балл. (Т.е. среди всех студентов, чьё имя начинается на А (Алексей, Алина, Артур, Анджела) найти то, что указано в задании. Вывести на экран тех, максимальный балл которых больше 3.6*/

SELECT LEFT(st.name::VARCHAR,1), min(st.score), max(st.score), avg(st.score)
FROM student st
GROUP BY LEFT(st.name::VARCHAR,1) HAVING MAX(st.score) > 3.6

/*28 Для каждой фамилии на курсе вывести максимальный и минимальный средний балл. (Например, в университете учатся 4 Иванова (1-2-3-4). 1-2-3 учатся на 2 курсе и имеют средний балл 4.1, 4, 3.8 соответственно, а 4 Иванов учится на 3 курсе и имеет балл 4.5. На экране должно быть следующее: 2 Иванов 4.1 3.8 3 Иванов 4.5 4.5*/

SELECT  
st.surname, MIN(st.score), MAX(st.score), LEFT(st.n_group::VARCHAR,1)
FROM student st
GROUP BY LEFT(st.n_group::VARCHAR,1), st.surname