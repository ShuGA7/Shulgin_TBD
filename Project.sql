/*1. Администратор. Регистрация пользователя (т.е. нет возможности
зарегистрировать самостоятельно, учётную запись создаёт администратор)
2. Пользователь. Авторизация
3. Пользователь. Выставление приоритетов (т.е. пользователь может
указать, что приоритет для него ночные смены, например)
4. Администратор. Составление расписание на неделю (надо
продумать как хранить данные, т.е. суть в том, что в БД должно быть
понятно, что конкретный сотрудник работает, например с 8 до 17 в
такой-то день)
5. Пользователь. Просьба о переносе смены (суть в том, что можно
поместить просьбу о переносе и кто-то другой может обменять свою смену
на эту)
6. Пользователь. Просмотр своего расписания
7. Администратор. Просмотр всего назначенного расписания с
пагинацией, сортировкой по дате, поиску по фамилии
8. Администратор. Блокировка пользователя (не полное удаление!
Нужно оставить всю историю в базе, просто пользователь не может больше
авторизовываться)
9. Пользователь. Уведомление, что не выходит по состоянию здоровья
10. Администратор. Размещение заявки о необходимости замены
(сотрудник не выходит по состоянию здоровья) с возможностью увеличения
оплаты в N раз
11. Пользователь. Подтверждение заявки на замену (должна быть
проверка, что у него нет работы в данное время)*/

/*Создание таблиц*/
CREATE TABLE worker (
    id SERIAL PRIMARY KEY,
    name varchar(255) NOT NULL,
    surname varchar(255)
);
CREATE TABLE stat (
    id SERIAL PRIMARY KEY,
    worker_id INT REFERENCES worker(id),
    name varchar(255) NOT NULL,
    surname varchar(255),
    day varchar(255) NOT NULL,
    date date,
    type varchar(255),
    prior varchar(255),
    ill varchar(255),
    newdate date,
    newtime varchar(255),
    applic varchar (255),
    applictrue varchar (255)
);
CREATE TABLE login (
    id SERIAL PRIMARY KEY,
    worker_id INT REFERENCES worker(id),
    username varchar(255) NOT NULL,
    password varchar(16) NOT NULL,
    block varchar(255)
);
CREATE TABLE shift (
    id SERIAL PRIMARY KEY,
    type varchar(255) NOT NULL,
    shiftstart time,
    shiftend time
);
CREATE TABLE timetable (
    id SERIAL PRIMARY KEY,
    worker_id INT REFERENCES worker(id),
    day varchar(255) NOT NULL,
    date date,
    shift_id INT REFERENCES shift(id)
);


/*Заполнение*/
INSERT INTO worker (name, surname)
VALUES ('Иван', 'Петров'),
('Василий', 'Кузнецов'),
('Петр', 'Карпов'),
('Николай', 'Резник'),
('Иван', 'Попов'),
('Даниил', 'Сартаков'),
('Сергей', 'Волков'),
('Александр', 'Негодяев');

INSERT INTO shift (type, shiftstart, shiftend)
VALUES ('Дневная', '07:00:00', '13:00:00'),
('Ночная', '23:00:00', '07:00:00');

INSERT INTO timetable (worker_id, day, date, shift_id)
VALUES (1, 'Понедельник', '2022-05-16', 1),
(1, 'Среда', '2022-05-18', 1),
(1, 'Четверг', '2022-05-19', 2),
(1, 'Пятница', '2022-05-20', 2),
(2, 'Понедельник', '2022-05-16', 1),
(2, 'Среда', '2022-05-18', 1),
(2, 'Четверг', '2022-05-19', 1),
(2, 'Пятница', '2022-05-20', 1),
(3, 'Понедельник', '2022-05-16', 1),
(3, 'Среда', '2022-05-18', 1),
(3, 'Четверг', '2022-05-19', 1),
(3, 'Пятница', '2022-05-20', 1),
(4, 'Понедельник', '2022-05-16', 1),
(4, 'Вторник', '2022-05-17', 2),
(4, 'Среда', '2022-05-18', 2),
(4, 'Четверг', '2022-05-19', 2),
(4, 'Пятница', '2022-05-20', 1),
(5, 'Понедельник', '2022-05-16', 1),
(5, 'Вторник', '2022-05-17', 1),
(5, 'Среда', '2022-05-18', 1),
(5, 'Четверг', '2022-05-19', 1),
(5, 'Пятница', '2022-05-20', 1),
(6, 'Понедельник', '2022-05-16', 2),
(6, 'Вторник', '2022-05-17', 2),
(6, 'Среда', '2022-05-18', 2),
(6, 'Четверг', '2022-05-19', 2),
(6, 'Пятница', '2022-05-20', 1),
(7, 'Понедельник', '2022-05-16', 1),
(7, 'Вторник', '2022-05-17', 1),
(7, 'Среда', '2022-05-18', 2),
(7, 'Четверг', '2022-05-19', 1),
(7, 'Пятница', '2022-05-20', 1),
(8, 'Понедельник', '2022-05-16', 2),
(8, 'Вторник', '2022-05-17', 1),
(8, 'Среда', '2022-05-18', 2),
(8, 'Четверг', '2022-05-19', 1),
(8, 'Пятница', '2022-05-20', 2);

INSERT INTO login (worker_id, username, password, block)
VALUES (1, 'Иван', '1234' ,'no'),
(2, 'Василий', '1234', 'no'),
(3, 'Петр', '1234', 'no'),
(4, 'Николай', '1234', 'no'),
(5, 'Иван', '1234', 'no'),
(6, 'Даниил', '1234', 'no'),
(7, 'Сергей', '1234', 'no'),
(8, 'Александр', '1234', 'no');


/*Регистрация*/
INSERT INTO worker (name, surname)
VALUES ('Денис', 'Сапогов');
INSERT INTO login (worker_id, username, password)
VALUES (9, 'Денис', '1234');


/*Сортировка*/
SELECT * FROM timetable
ORDER BY date DESC

SELECT w.id, w.name, w.surname, s.id, s.shiftstart, s.shiftend, t.date, t.day
FROM worker w, shift s, timetable t
WHERE t.worker_id = w.id AND t.shift_id = s.id AND w.surname = 'Кузнецов';

/*Просмотр расписания пользователем*/
SELECT w.name, w.surname, t.date, t.day, s.shiftstart, s.shiftend
FROM worker w, shift s, timetable t, login l
WHERE t.worker_id = w.id AND t.shift_id = s.id AND w.name = 'Василий' AND l.id = t.worker_id;

/*Приоритетная смена*/
INSERT INTO stat (worker_id, name, surname, day, date, type, prior)
VALUES (8, 'Александр', 'Негодяев', 'Понедельник', '2022-05-16', 'Дневная', 'Ночная сменя');

UPDATE pref
SET p = 'Дневная сменя' where surname = 'Негодяев';

/*Авторизация*/
SELECT w.name, w.surname, t.date, t.day, s.shiftstart, s.shiftend
FROM worker w, shift s, timetable t, login l
WHERE t.worker_id = w.id AND t.shift_id = s.id AND w.name = 'Василий' AND l.id = t.worker_id;

/*Уведомление о болезни*/
INSERT INTO stat (worker_id, name, surname, day, date, type, ill)
VALUES (8, 'Александр', 'Негодяев', 'Вторник', '2022-05-17', 'Дневная', 'Отсутствие по болезни');

/*Просьба о переносе*/
INSERT INTO stat (worker_id, name, surname, day, date, type, newdate, newtime)
VALUES (8, 'Александр', 'Негодяев', 'Вторник', '2022-05-17', 'Дневная', '2022-05-18', 'Дневная');

/*Заявка на замену*/
UPDATE stat set applic = 'Необходима замена, оплата 1.9 за смену' WHERE stat.ill is NOT NULL

/*Заявка принята*/
UPDATE stat set applictrue = 'Заявка принята. id 1' WHERE stat.applic is NOT NULL

/*Утверждение*/
INSERT INTO timetable (worker_id, day, date, shift_id)
VALUES (1, 'Вторник', '2022-05-17', 1)

DELETE FROM timetable where worker_id = 8 and shift_id = 2;

INSERT INTO timetable (worker_id, day, date, shift_id)
VALUES (8, 'Вторник', '2022-05-18', 1)

/*Блокировка*/
UPDATE login set block = 'yes' where worker_id = 7;
