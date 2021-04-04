/*Ex 1*/
SELECT Highschooler.name
FROM Highschooler
JOIN Friend ON Highschooler.ID = Friend.ID1
JOIN Highschooler AS hs1 ON Friend.ID2 = hs1.ID
WHERE hs1.name = 'Gabriel'
ORDER BY Highschooler.name;


/*Ex 2*/
SELECT Highschooler.name, Highschooler.grade, hs1.name, hs1.grade
FROM Highschooler
JOIN Likes ON Highschooler.ID = Likes.ID1
JOIN Highschooler AS hs1 ON Likes.ID2 = hs1.ID
WHERE Highschooler.grade - hs1.grade >= 2;


/*Ex 3*/
SELECT DISTINCT hs1.name, hs1.grade, hs2.name, hs2.grade
FROM Highschooler AS hs1
JOIN Likes ON hs1.ID = Likes.ID1
JOIN Highschooler AS hs2 ON Likes.ID2 = hs2.ID
JOIN Likes AS lk1 ON hs2.ID = lk1.ID1 and hs1.ID = lk1.ID2
WHERE hs1.ID < hs2.ID
ORDER BY hs1.name, hs2.name;


/*Ex 4*/
SELECT Highschooler.name, Highschooler.grade
FROM Highschooler
WHERE Highschooler.ID not in (
	SELECT Likes.ID1
    FROM Likes
) and Highschooler.ID not in (
	SELECT Likes.ID2
    FROM Likes
)
ORDER BY Highschooler.grade, Highschooler.name;


/*Ex 5*/
SELECT Highschooler.name, Highschooler.grade, hs1.name, hs1.grade
FROM Highschooler
JOIN Likes ON Highschooler.ID = Likes.ID1
JOIN Highschooler AS hs1 ON Likes.ID2 = hs1.ID
WHERE hs1.ID not in (
	SELECT Likes.ID1
    FROM Likes
)
ORDER BY Highschooler.name;


/*Ex 6*/
SELECT Highschooler.name, Highschooler.grade
FROM Highschooler
WHERE Highschooler.ID not in
(
	SELECT Highschooler.ID
	FROM Highschooler
	JOIN Friend ON Highschooler.ID = Friend.ID1
	JOIN Highschooler AS hs1 ON Friend.ID2 = hs1.ID
	WHERE Highschooler.grade != hs1.grade
)
ORDER BY Highschooler.grade, Highschooler.name;


/*Ex 7*/
SELECT DISTINCT A.name, A.grade, B.name, B.grade, C.name, C.grade
FROM Highschooler AS A
JOIN Likes ON A.ID = Likes.ID1
JOIN Highschooler AS B ON Likes.ID2 = B.ID
JOIN Friend AS frd1 ON A.ID = frd1.ID1
JOIN Highschooler AS C ON frd1.ID2 = C.ID
JOIN Friend AS frd2 ON C.ID = frd2.ID1 and frd2.ID2 = B.ID
WHERE A.ID not in (
	SELECT A.ID
	FROM Highschooler AS A
	JOIN Likes ON A.ID = Likes.ID1
	JOIN Highschooler AS B ON Likes.ID2 = B.ID
	JOIN Friend ON A.ID = Friend.ID1 and B.ID = Friend.ID2
);


/*Ex 8*/
SELECT COUNT(name) - COUNT(DISTINCT name) AS difference
FROM Highschooler;


/*Ex 9*/
SELECT Highschooler.name, Highschooler.grade
FROM Highschooler
WHERE (
	SELECT COUNT(Likes.ID1)
    FROM Likes
    WHERE Likes.ID2 = Highschooler.ID
) > 1;
