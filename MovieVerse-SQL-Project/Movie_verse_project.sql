SELECT * FROM movies;
-- SELECT * FROM ratings;
-- SELECT * FROM users;
-- SELECT * FROM genres;
-- SELECT * FROM movie_genres;
-- SELECT * FROM actors;
-- SELECT * FROM movie_actors;
-- Q1. What are the top 5 highest rated movies based on ratings?

SELECT m.title, r.rating
FROM movies AS m
JOIN ratings AS r ON m.movie_id = r.movie_id
ORDER BY r.rating DESC
LIMIT 5;

-- Q2. Which movies have been rated 9 or above by users from India?

SELECT m.title, r.rating
FROM movies AS m 
JOIN ratings AS r ON m.movie_id = r.movie_id
JOIN users AS u on r.user_id = u.user_id
WHERE r.rating >=9 AND u.country = 'India';

--  Q3. How many movies belong to each genre?

SELECT g.genre_name, COUNT(m.movie_id) AS TotalMovies
FROM genres AS g 
JOIN movie_genres as mg ON g.genre_id = mg.genre_id
JOIN movies m ON mg.movie_id = m.movie_id 
GROUP BY g.genre_name;

-- Q4. Which actor has acted in the highest number of movies?

SELECT a.name, COUNT(m.movie_id) AS TotalMovies
FROM actors AS a 
JOIN movie_actors ma ON a.actor_id = ma.actor_id
JOIN movies m ON ma.movie_id = m.movie_id
GROUP BY a.name
ORDER BY COUNT(m.movie_id) DESC
LIMIT 1;

-- Q5. Average ratings given by user?

SELECT u.name, ROUND(AVG(r.rating),2) AS AVGRating
FROM users AS u 
JOIN ratings r on u.user_id = r.user_id
GROUP BY u.name; 

-- Q6. Assign a release rank to each movie using its release year?

SELECT title , release_year, 
RANK() OVER(ORDER BY release_year) AS Release_Ranks
FROM movies;

-- Q7. Classify movies as 'Classic', 'Modern' or 'New' based on release year.

SELECT title, release_year,
     CASE 
	           WHEN release_year < 2000 THEN 'Classic'
			   WHEN release_year > 2000 AND release_year < 2020 Then 'Modern'
			   ELSE 'New'
			   END AS ERABUCKET
FROM movies;

-- Q8. Recommended Movie of the day?

SELECT m.title AS NAME,m.release_year AS YEAR,g.genre_name AS GENRE,a.name AS ACTOR,r.rating AS RATING
FROM movies AS m
JOIN movie_genres mg ON m.movie_id = mg.movie_id
JOIN genres g ON mg.genre_id = g.genre_id
JOIN movie_actors ma ON m.movie_id = ma.movie_id
JOIN actors a ON ma.actor_id = a.actor_id
JOIN ratings r ON m.movie_id = r.movie_id
ORDER BY RANDOM()
LIMIT 1;



