/*Ex 1*/
SELECT title FROM Movie
WHERE director = 'Steven Spielberg';


/*Ex 2*/
SELECT DISTINCT Movie.year FROM Movie
JOIN Rating ON Movie.mID = Rating.mId
WHERE Rating.stars = 4 OR Rating.stars = 5
ORDER BY Movie.year;


/*Ex 3*/
SELECT title FROM Movie
WHERE mID not IN (
	SELECT mID FROM Rating
);


/*Ex 4*/
SELECT Reviewer.name FROM Reviewer
JOIN Rating ON Reviewer.rID = Rating.rID
WHERE Rating.ratingDate is NULL
ORDER BY Reviewer.name;


/*Ex 5*/
SELECT Reviewer.name, Movie.title, Rating.stars, Rating.ratingDate
FROM Rating
JOIN Reviewer ON Rating.rID = Reviewer.rID
JOIN Movie ON Rating.mID = Movie.mID
ORDER BY Reviewer.name, Movie.title, Rating.stars;


/*Ex 6*/
SELECT DISTINCT Reviewer.name, Movie.title
FROM Rating
JOIN Reviewer ON Rating.rID = Reviewer.rID
JOIN Movie ON Rating.mID = Movie.mID
WHERE Rating.rID IN (
	SELECT Rating1.rID
	FROM Rating AS Rating1
	JOIN Rating AS Rating2 ON Rating1.rID = Rating2.rID and Rating1.mID = Rating2.mID
	WHERE Rating1.stars < Rating2.stars and Rating1.ratingDate < Rating2.ratingDate
) and Rating.mID IN (
	SELECT Rating1.mID
	FROM Rating AS Rating1
	JOIN Rating AS Rating2 ON Rating1.rID = Rating2.rID and Rating1.mID = Rating2.mID
	WHERE Rating1.stars < Rating2.stars and Rating1.ratingDate < Rating2.ratingDate
);


/*Ex 7*/
SELECT DISTINCT Movie.title, (
	SELECT MAX(Rating.stars)
    FROM Rating
    WHERE Rating.mID = Movie.mID
) AS maximumRatingStars
FROM Rating
JOIN Movie ON Rating.mID = Movie.mID
ORDER BY Movie.title;


/*Ex 8*/
SELECT DISTINCT Movie.title, (
	(SELECT MAX(Rating.stars)
    FROM Rating
    WHERE Rating.mID = Movie.mID) - 
    (SELECT MIN(Rating.stars)
    FROM Rating
    WHERE Rating.mID = Movie.mID)
) AS ratingSpread
FROM Rating
JOIN Movie ON Rating.mID = Movie.mID
ORDER BY ratingSpread desc, Movie.title;


/*Ex 9*/
SELECT ROUND(AVG(table1.medianRatingStars), 10) - ROUND(AVG(table2.medianRatingStars), 10) AS medianDifference
FROM (
	SELECT DISTINCT Movie.title, (
		SELECT ROUND(AVG(Rating.stars), 10)
		FROM Rating
		WHERE Movie.mID = Rating.mID
		GROUP BY Movie.title
	) AS medianRatingStars
	FROM Rating
	JOIN Movie ON Rating.mID = Movie.mID
	WHERE Movie.year < 1980
) AS table1, (
	SELECT DISTINCT Movie.title, (
		SELECT ROUND(AVG(Rating.stars), 10)
		FROM Rating
		WHERE Movie.mID = Rating.mID
		GROUP BY Movie.title
	) AS medianRatingStars
	FROM Rating
	JOIN Movie ON Rating.mID = Movie.mID
	WHERE Movie.year >= 1980
) AS table2;