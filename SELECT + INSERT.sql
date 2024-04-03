-- ЗАДАНИЕ 1.
-- Добавление списка исполнителей
INSERT INTO performers_list(performer) 
VALUES
	('Maluma'), 
	('Linkin Park'), 
	('Nickelback'), 
	('The Weeknd'), 
	('Michael Jackson'), 
	('Evanescence');

-- список жанров
INSERT INTO genres_list(genre) 
VALUES('Latino'), ('Rock'), ('R&B'), ('Pop');

-- список альбомов с датой релиза 
INSERT INTO albums_list(album_title, release_date) 
VALUES
    ('All the Right Reasons', '2005'),
    ('Dark Horse', '2008'),
    ('Meteora', '2003'),
    ('Beauty Behind the Madness', '2015'),
    ('Thriller', '1982'),
    ('Invincible', '2001'),
    ('Fallen', '2003');
   
-- список ключей альбом-исполнитель:
INSERT INTO album_performer (album_id, performer_id) 
VALUES(1, 3), (2, 3), (3, 2), (4, 4), (5, 5), (6, 5), (7, 6);

-- список ключей исполнитель-жанр:
INSERT INTO performers_genres (performer_id, genre_id) 
VALUES(1, 1), (2, 2), (3, 2), (4, 3), (4, 4), (5, 2), (5, 3), (5, 4), (6, 2);

-- список ключей трек-сборник:
INSERT INTO track_collection (track_id, collection_id) 
VALUES(1, 1), (2, 1), (3, 2), (4, 1), (4, 2), (5, 1), (6, 3);

INSERT INTO track_collection (track_id, collection_id)
VALUES(3, 5), (4, 5), (5, 5);
   
-- список треков с длительностью
INSERT INTO tracks_list(track_title, duration, album_id) 
VALUES
    ('If Today was your last day', 248, 1),
    ('Animals', 187, 2),
    ('Billie Jean', 290, 5),
    ('My immortal', 275, 7),
    ('Bring Me to Life', 237, 7),
    ('You Rock My World', 339, 6);
   
-- список сборников
INSERT INTO collections_list(collection_title, release_date) 
VALUES
    ('The Best of Rock', '2009'),
    ('Top 100', '2015'),
    ('R&B Gold Collection', '2010'),
    ('Latina Party', '2018');
   
INSERT INTO collections_list(collection_title, release_date) 
VALUES ('Immortal hits', '2020');
   
   
-- ЗАДАНИЕ 2.
-- Название и продолжительность самого длительного трека:
SELECT track_title, duration
FROM tracks_list
ORDER BY duration DESC
LIMIT 1;

-- Название треков, продолжительность которых не менее 3,5 минут.
SELECT track_title, duration 
FROM tracks_list
WHERE duration >= 210; -- выбрала тип данных ingerer по предыдущему комментарию, поэтому все привела к такому виду.
-- буду думать дальше, как решить эту проблему. пока так.

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT collection_title
FROM collections_list
WHERE release_date BETWEEN '2018' AND '2020'; -- добавила сборник для выполнения пункта

-- Исполнители, чьё имя состоит из одного слова.
SELECT performer
FROM performers_list
WHERE performer NOT LIKE '% %';

-- Название треков, которые содержат слово «мой» или «my».
SELECT track_title
FROM tracks_list
WHERE LOWER(track_title) LIKE '%мой%' OR LOWER(track_title) LIKE '%my%';


-- ЗАДАНИЕ 3.
-- Количество исполнителей в каждом жанре.
SELECT g.genre, COUNT(pg.performer_id) AS performer_count
FROM genres_list g
LEFT JOIN performers_genres pg ON g.id = pg.genre_id
GROUP BY g.genre;

-- Количество треков, вошедших в альбомы 2019–2020 годов.
-- нужно добавить альбом

INSERT INTO albums_list(album_title, release_date) 
VALUES('Dawn FM', '2020');

-- добавить трек
INSERT INTO tracks_list(track_title, duration, album_id) 
VALUES('Take My Breath', 220, 8);

-- добавить трек-сборник
INSERT INTO track_collection(track_id, collection_id)
VALUES(9, 5);

-- собственно выполнение самого запроса:

SELECT COUNT(t.id) AS track_count
FROM tracks_list t
INNER JOIN albums_list a ON t.album_id = a.id
WHERE a.release_date BETWEEN '2019' AND '2021';

-- Средняя продолжительность треков по каждому альбому:
SELECT a.album_title, 
       AVG(duration) AS average_duration
FROM tracks_list t
INNER JOIN albums_list a ON t.album_id = a.id
GROUP BY a.album_title;


-- Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT p.performer
FROM performers_list p
LEFT JOIN album_performer ap ON p.id = ap.performer_id
LEFT JOIN albums_list a ON ap.album_id = a.id
WHERE EXTRACT(YEAR FROM TO_DATE(a.release_date, 'YYYY')) <> 2020 OR a.release_date IS NULL
GROUP BY p.performer;


-- Названия сборников, в которых присутствует конкретный исполнитель.
SELECT c.collection_title
FROM collections_list c
INNER JOIN track_collection tc ON c.id = tc.collection_id
INNER JOIN tracks_list t ON tc.track_id = t.id
INNER JOIN album_performer ap ON t.album_id = ap.album_id
INNER JOIN performers_list p ON ap.performer_id = p.id
WHERE p.performer = 'Michael Jackson';


















