/*1.Выведите на экран номера групп и количество студентов, обучающихся в них*/

SELECT n_group, COUNT(*)
FROM student
GROUP BY n_group


/* 2.Выведите на экран для каждой группы максимальный средний балл*/

SELECT n_group, MAX(score)
FROM student
GROUP BY n_group

/* 3 . Подсчитать количество студентов с каждой фамилией */

SELECT surname, COUNT(surname)
FROM student
GROUP BY surname

/* 4 . Подсчитать студентов, которые родились в каждом году (adress - столбец с годом рождения)*/

SELECT adress, count(adress)
FROM student
GROUP BY adress

/* 7  Для каждой группы подсчитать средний балл, вывести на экран только те номера групп и их средний балл, в которых он менее или равен 3.5. Отсортировать по от меньшего среднего балла к большему.*/

SELECT  n_group,AVG(score) 
FROM student
GROUP BY n_group
HAVING AVG(score)>= 3.5
ORDER BY AVG(score) ASC
/* У меня нет меньше 3.5 в таблице, поэтому я сделал больше*/

/* 8.Для каждой группы в одном запросе вывести количество студентов, максимальный балл в группе, средний балл в группе, минимальный балл в группе*/
SELECT  n_group, COUNT(name),MAX(score),AVG(score),MIN(score)
FROM student
GROUP BY n_group

/* 9.Вывести студента/ов, который/ые имеют наибольший балл в заданной группе*/

SELECT  name, MAX(score),n_group
FROM student
WHERE n_group = 2221
GROUP BY n_group,name
HAVING MAX(score) >= 4
/* 10.Аналогично 9 заданию, но вывести в одном запросе для каждой группы студента с максимальным баллом */

SELECT distinct n_group, name ,MAX(score)
FROM student
WHERE score = (SELECT MAX(score)  from student)
GROUP BY n_group,name




