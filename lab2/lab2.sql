/*Exercitiul 1*/
/*Gasiti titlurile tuturor filmelor regizate de Steven Spielberg.*/
select title from Movie
where director = 'Steven Spielberg';


/*Exercitiul 2*/
/*Gasiti toti anii care au un film care a primit un rating de 4 sau 5, si
sortati-i in ordine crescatoare.*/
select distinct Movie.year from Movie
join Rating on Movie.mID = Rating.mId
where Rating.stars = 4 or Rating.stars = 5
order by Movie.year;


/*Exercitiul 3*/
/*Gasiti titlurile tuturor filmelor care nu au rating.*/
select title from Movie
where mID not in (
	select mID from Rating
);


/*Exercitiul 4*/
/*Unii revieweri nu au furnizat o data a review-ului lor.  Gasiti numele
tuturor reviewer-urilor care au ratinguri asociate cu o valoare NULL
pentru data.*/
select Reviewer.name from Reviewer
join Rating on Reviewer.rID = Rating.rID
where Rating.ratingDate is NULL
order by Reviewer.name;


/*Exercitiul 5*/
/*Scrieti un query care intoarce ca rezultat rating-urile intr-o forma
citibila:  numele reviewer-ului, titlul filmului, stars, ratingDate.  De
asemenea, sortati rezultatul, mai intai dupa numele reviewer-ului, apoi
dupa titlul filmului, iar apoi dupa numarul de stele.*/
select Reviewer.name, Movie.title, Rating.stars, Rating.ratingDate
from Rating
join Reviewer on Rating.rID = Reviewer.rID
join Movie on Rating.mID = Movie.mID
order by Reviewer.name, Movie.title, Rating.stars;


/*Exercitiul 6*/
/*Pentru toate cazurile in care acelasi reviewer a notat un film de doua
ori si i-a dat un rating mai mare a doua oara, returnati numele
reviewer-ului si titlul filmului.*/
select distinct Reviewer.name, Movie.title
from Rating
join Reviewer on Rating.rID = Reviewer.rID
join Movie on Rating.mID = Movie.mID
where Rating.rID in (
	select Rating1.rID
	from Rating as Rating1
	join Rating as Rating2 on Rating1.rID = Rating2.rID and Rating1.mID = Rating2.mID
	where Rating1.stars < Rating2.stars and Rating1.ratingDate < Rating2.ratingDate
) and Rating.mID in (
	select Rating1.mID
	from Rating as Rating1
	join Rating as Rating2 on Rating1.rID = Rating2.rID and Rating1.mID = Rating2.mID
	where Rating1.stars < Rating2.stars and Rating1.ratingDate < Rating2.ratingDate
);


/*Exercitiul 7*/
/*Pentru fiecare film care are cel putin un rating, gasiti cel mai mare
numar de stele pe care l-a primit filmul. Returnati titlul filmului si
numarul de stele.  Sortati dupa titlul filmului.*/
select distinct Movie.title, (
	select max(Rating.stars)
    from Rating
    where Rating.mID = Movie.mID
) as maximumRatingStars
from Rating
join Movie on Rating.mID = Movie.mID
order by Movie.title;


/*Exercitiul 8*/
/*Pentru fiecare film, returnati titlul si 'rating spread', adica diferenta
dintre cel mai mare si cel mai mic rating al filmului.  Sortati dupa acest 
'rating spread' de la cel mai mare spre cel mai mic, apoi dupa titlul filmului.*/
select distinct Movie.title, (
	(select max(Rating.stars)
    from Rating
    where Rating.mID = Movie.mID) - 
    (select min(Rating.stars)
    from Rating
    where Rating.mID = Movie.mID)
) as ratingSpread
from Rating
join Movie on Rating.mID = Movie.mID
order by ratingSpread desc, Movie.title;


/*Exercitiul 9*/
/*Gasiti diferenta dintre media rating-urilor filmelor lansate inainte de
1980 si media rating-urilor filmelor lansate dupa 1980.  Asigurati-va ca
veti calcula media rating-ului pentru fiecare film, apoi media acestor
medii pentru filmele de dinainte de 1980 si pentru filmele dupa.  Nu
calculati doar media totala nainte si dupa 1980.*/
select round(avg(table1.medianRatingStars), 10) - round(avg(table2.medianRatingStars), 10) as medianDifference
from (
	select distinct Movie.title, (
		select round(avg(Rating.stars), 10)
		from Rating
		where Movie.mID = Rating.mID
		group by Movie.title
	) as medianRatingStars
	from Rating
	join Movie on Rating.mID = Movie.mID
	where Movie.year < 1980
) as table1, (
	select distinct Movie.title, (
		select round(avg(Rating.stars), 10)
		from Rating
		where Movie.mID = Rating.mID
		group by Movie.title
	) as medianRatingStars
	from Rating
	join Movie on Rating.mID = Movie.mID
	where Movie.year >= 1980
) as table2;