/* 1.Вывести всеми возможными способами имена и фамилии студентов, средний балл которых от 4 до 4.5*/

SELECT name,surname
FROM student WHERE score>=4 AND score<=4.5

SELECT name,surname
FROM student WHERE score=4 OR score=4.1 OR score=4.2 OR score=4.3 OR score=4.4 OR score=4.5

/*2.Знакомиться с функцией CAST. Вывести при помощи неё студентов заданного курса (использовать Like)*/

select name,surname, cast(course as varchar(5))
from student
where course LIKE '2%'

/*3.Вывести всех студентов, отсортировать по убыванию номера группы и имени от а до я*/

SELECT name,surname,n_group
FROM student ORDER BY n_group DESC,name A;

/*4.Вывести студентов, средний балл которых больше 4 и отсортировать по баллу от большего к меньшему*/

Select name, surname, score 
from student where score > 4.0 order by score desc

/*5.Вывести на экран название и риск футбола и хоккея*/

Select name, risk from hobbies 
where name = 'Плавание' or name = 'Баскетбол'

/*6.Вывести id хобби и id студента которые начали заниматься хобби между двумя заданными датами (выбрать самим) и студенты должны до сих пор заниматься хобби*/

Select id, hobby_id, started_at, finished_at
from student_hobby
where started_at between '2018-01-01' and '2019-01-01' and finished_at notnull

/*7.Вывести студентов, средний балл которых больше 4.5 и отсортировать по баллу от большего к меньшему*/

Select name, surname, score 
from student where score > 4.5 order by score desc

/*8.Из запроса №7 вывести несколькими способами на экран только 5 студентов с максимальным баллом*/

Select name, surname, score 
from student
where score = (select max(score) from student)
limit 5;

/*9.Выведите хобби и с использованием условного оператора сделайте риск словами*/

select name, 
case
when risk >=8 then 'очень высокий'
when risk >=6 AND risk <8 then 'высокий'
when risk >=4 AND risk <8 then 'средний'
when risk >=2 AND risk <4 then 'низкий'
when risk < 2 then 'очень низкий'
end
from hobbies

/*10.Вывести 3 хобби с максимальным риском*/

Select name, risk 
from hobbies order by (risk) desc limit 3




