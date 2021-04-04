/*Ex 1*/
insert into Reviewer(rID, name) values (209, 'Roger Ebert');
SELECT * FROM Reviewer ORDER BY rID, name;

/*Ex 2*/
insert into Rating
SELECT (SELECT rID FROM Reviewer WHERE Reviewer.name = 'James Cameron'), mID, 5, NULL FROM Movie;
SELECT * FROM Rating WHERE stars = 5 ORDER BY rID, mID;

/*Ex 3*/
UPDATE Movie 
SET Movie.year = Movie.year + 25
WHERE Movie.mID IN (
	SELECT mID 
	FROM Rating
    GROUP BY Rating.mID
	HAVING AVG(stars)>= 4
);
SELECT * FROM Movie ORDER BY mID;

/*Ex 4*/
DROP TABLE IF EXISTS TEMP;
CREATE TABLE TEMP
	SELECT Rating.mID, Rating.rID
	FROM Rating
    JOIN Movie ON Rating.mID = Movie.mID
	WHERE (Movie.year < 1970 or Movie.year > 2000) AND Rating.stars < 4;
DELETE FROM Rating
WHERE mID IN (SELECT mID FROM TEMP) AND rID IN (SELECT rID FROM TEMP);
DROP TABLE IF EXISTS TEMP;
SELECT R.rID, R.mID, R.stars, M.title, M.year from
Rating R JOIN Movie M ON (R.mID = M.mID) ORDER BY R.rID, R.mID;

/*Ex 5*/
SELECT A.name, A.grade , B.name, B.grade, C.name, C.grade FROM Highschooler AS A
JOIN Likes ON A.ID = Likes.ID1
JOIN Highschooler AS B ON Likes.ID2 = B.ID
JOIN Likes AS lk1 ON lk1.ID1 = B.ID AND lk1.ID2 != A.ID
JOIN Highschooler AS C ON lk1.ID2 = C.ID;

/*Ex 6*/
SELECT hs.name, hs.grade
FROM (
	SELECT DISTINCT Highschooler.ID, Highschooler.name, Highschooler.grade
	FROM Highschooler
	JOIN Friend ON Highschooler.ID = Friend.ID1
	JOIN Highschooler AS hs1 ON Friend.ID2 = hs1.ID
	WHERE Highschooler.grade != hs1.grade
) AS hs
WHERE hs.ID not IN (
	SELECT DISTINCT Highschooler.ID
	FROM Highschooler
	JOIN Friend ON Highschooler.ID = Friend.ID1
	JOIN Highschooler AS hs1 ON Friend.ID2 = hs1.ID
	WHERE Highschooler.grade = hs1.grade
);

/*Ex 7*/
SELECT ROUND(AVG(A.numberOfFriends),1) FROM (SELECT Highschooler.ID, COUNT(Highschooler.ID) AS numberOfFriends FROM Highschooler
JOIN Friend ON Friend.ID1 = Highschooler.ID GROUP BY ID) AS A;

/*Ex 8*/
SELECT COUNT(ID)
FROM ((
		SELECT hs1.ID
		FROM Highschooler
		JOIN Friend AS fr1 ON Highschooler.ID = fr1.ID1
		JOIN Highschooler AS hs1 ON fr1.ID2 = hs1.ID
		WHERE Highschooler.name = 'Cassandra'
    ) UNION (
		SELECT hs2.ID
		FROM Highschooler
		JOIN Friend AS fr1 ON Highschooler.ID = fr1.ID1
		JOIN Highschooler AS hs1 ON fr1.ID2 = hs1.ID
		JOIN Friend AS fr2 ON hs1.ID = fr2.ID1
		JOIN Highschooler AS hs2 ON fr2.ID2 = hs2.ID AND hs2.name != 'Cassandra'
		WHERE Highschooler.name = 'Cassandra'
)) AS Friends;

/*Ex 9*/
SELECT Highschooler.name, Highschooler.grade FROM Highschooler
JOIN (SELECT Highschooler.ID, COUNT(Highschooler.ID) AS numberOfFriends FROM Highschooler
JOIN Friend ON Friend.ID1 = Highschooler.ID GROUP BY ID) AS A ON A.ID = Highschooler.ID WHERE A.numberOfFriends =
(SELECT MAX(A.numberOfFriends) AS maxNumberOfFriends FROM (SELECT Highschooler.ID, COUNT(Highschooler.ID) AS numberOfFriends FROM Highschooler
JOIN Friend ON Friend.ID1 = Highschooler.ID GROUP BY ID) AS A) ORDER BY Highschooler.name;
