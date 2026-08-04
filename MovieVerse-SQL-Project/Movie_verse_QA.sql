1. List all movies longer than 150 minutes released after 2010. 

SELECT title, release_year, duration
FROM movies
WHERE duration > 150 AND release_year > 2010;


2. Find all users from India who rated any movie after January 2025. 

SELECT DISTINCT u.user_id, u.name, u.country
FROM users u
JOIN ratings r ON u.user_id = r.user_id
WHERE u.country = 'India' AND r.rating_date > '2025-01-31';


3. Show all actors whose names start with 'A' or end with 'Khan'. 

SELECT actor_id, name
FROM actors
WHERE name LIKE 'A%' OR name LIKE '%Khan';


4. List all genres that have not been linked to any movie yet.

SELECT g.genre_name
FROM genres g
LEFT JOIN movie_genres mg ON g.genre_id = mg.genre_id
WHERE mg.movie_id IS NULL;


5. Count the number of movies per release decade (1990s, 2000s, etc). 


SELECT CONCAT((release_year / 10) * 10, 's') AS decade, COUNT(*) AS total_movies
FROM movies
GROUP BY (release_year / 10) * 10
ORDER BY decade;


6. Find the movies which have exactly two genres associated. 

SELECT m.title, COUNT(mg.genre_id) AS total_genres
FROM movies m
JOIN movie_genres mg ON m.movie_id = mg.movie_id
GROUP BY m.movie_id, m.title
HAVING COUNT(mg.genre_id) = 2;


7. Display all movies that have received a rating of exactly 9.0. 


SELECT DISTINCT m.title, r.rating
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
WHERE r.rating = 9.0;


8. List all users who have not given any ratings. 


SELECT u.user_id, u.name
FROM users u
LEFT JOIN ratings r ON u.user_id = r.user_id
WHERE r.rating_id IS NULL;


9. Get the total number of actors in the database. 

SELECT COUNT(*) as Total_Actors 
FROM actors;

10. Display the duration of the shortest movie in each genre. 


SELECT g.genre_name, MIN(m.duration) AS shortest_duration
FROM genres g
JOIN movie_genres mg ON g.genre_id = mg.genre_id
JOIN movies m ON mg.movie_id = m.movie_id
GROUP BY g.genre_name
ORDER BY g.genre_name;


11. Find all movies in which ‘Leonardo DiCaprio’ acted. 

SELECT m.title as Movies_by_Leonardo_DiCaprio
FROM movies m
JOIN movie_actors ma ON m.movie_id = ma.movie_id
JOIN actors a ON ma.actor_id = a.actor_id
WHERE a.name = 'Leonardo DiCaprio';


12. Show the title and genre of all movies rated above 9 by any user. 


SELECT DISTINCT m.title, g.genre_name
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
JOIN movie_genres mg ON m.movie_id = mg.movie_id
JOIN genres g ON mg.genre_id = g.genre_id
WHERE r.rating > 9;


13. List all users who have rated movies from the 'Action' genre. 


SELECT DISTINCT u.user_id, u.name
FROM users u
JOIN ratings r ON u.user_id = r.user_id
JOIN movies m ON r.movie_id = m.movie_id
JOIN movie_genres mg ON m.movie_id = mg.movie_id
JOIN genres g ON mg.genre_id = g.genre_id
WHERE g.genre_name = 'Action';

14. Find movies which are in both 'Drama' and 'Thriller' genres.

SELECT m.title
FROM movies m
JOIN movie_genres mg ON m.movie_id = mg.movie_id
JOIN genres g ON mg.genre_id = g.genre_id
WHERE g.genre_name IN ('Drama', 'Thriller')
GROUP BY m.movie_id, m.title
HAVING COUNT(DISTINCT g.genre_name) = 2;

15. List actors who have worked in at least one movie with Shah Rukh Khan.

SELECT DISTINCT a2.name
FROM actors a1
JOIN movie_actors ma1
ON a1.actor_id = ma1.actor_id
JOIN movie_actors ma2
ON ma1.movie_id = ma2.movie_id
JOIN actors a2
ON ma2.actor_id = a2.actor_id
WHERE a1.name = 'Shah Rukh Khan'
  AND a2.name <> 'Shah Rukh Khan';

16. Find all reviews that contain the word ‘emotional’. 

SELECT
    review
FROM ratings
WHERE review ILIKE '%emotional%';

17. List all users who gave a review starting with 'Best'. 


SELECT DISTINCT u.user_id, u.name
FROM users u
JOIN ratings r ON u.user_id = r.user_id
WHERE r.review LIKE 'Best%';


18. Find movies with the word 'Dark' in the title (case-insensitive).


SELECT title
FROM movies
WHERE title ILIKE '%Dark%';

19. Show each user’s total number of ratings and categorize them as Newbie, Active, or Pro. 

SELECT
    u.user_id,
    u.name,
    COUNT(r.rating_id) AS total_ratings,
    CASE
        WHEN COUNT(r.rating_id) = 0 THEN 'Newbie'
        WHEN COUNT(r.rating_id) BETWEEN 1 AND 5 THEN 'Active'
        ELSE 'Pro'
    END AS user_category
FROM users u
LEFT JOIN ratings r
ON u.user_id = r.user_id
GROUP BY u.user_id, u.name
ORDER BY total_ratings DESC;

20. Count how many movies each actor has appeared in. 

SELECT
    a.actor_id,
    a.name,
    COUNT(ma.movie_id) AS total_movies
FROM actors a
JOIN movie_actors ma
ON a.actor_id = ma.actor_id
GROUP BY a.actor_id, a.name
ORDER BY total_movies DESC;

21. Use RANK() to show the top 3 movies per genre based on average rating.

WITH MovieRatings AS (
    SELECT
        g.genre_name,
        m.title,
        ROUND(AVG(r.rating), 2) AS avg_rating,
        RANK() OVER (
            PARTITION BY g.genre_name
            ORDER BY AVG(r.rating) DESC
        ) AS movie_rank
    FROM movies m
    JOIN movie_genres mg
        ON m.movie_id = mg.movie_id
    JOIN genres g
        ON mg.genre_id = g.genre_id
    JOIN ratings r
        ON m.movie_id = r.movie_id
    GROUP BY g.genre_name, m.title
)

SELECT *
FROM MovieRatings
WHERE movie_rank <= 3
ORDER BY genre_name, movie_rank;

22. Show each movie’s rating along with the average rating for that genre using window functions. 
SELECT
    g.genre_name,
    m.title,
    r.rating,
    ROUND(
        AVG(r.rating) OVER(PARTITION BY g.genre_name),
        2
    ) AS genre_avg_rating
FROM movies m
JOIN movie_genres mg
    ON m.movie_id = mg.movie_id
JOIN genres g
    ON mg.genre_id = g.genre_id
JOIN ratings r
    ON m.movie_id = r.movie_id
ORDER BY g.genre_name;
SELECT
    g.genre_name,
    m.title,
    r.rating,
    ROUND(
        AVG(r.rating) OVER(PARTITION BY g.genre_name),
        2
    ) AS genre_avg_rating
FROM movies m
JOIN movie_genres mg
    ON m.movie_id = mg.movie_id
JOIN genres g
    ON mg.genre_id = g.genre_id
JOIN ratings r
    ON m.movie_id = r.movie_id
ORDER BY g.genre_name;

23. For each user, list the last movie they rated (by date). 


WITH LastRating AS (
    SELECT
        u.name,
        m.title,
        r.rating_date,
        ROW_NUMBER() OVER (
            PARTITION BY u.user_id
            ORDER BY r.rating_date DESC
        ) AS rn
    FROM users u
    JOIN ratings r
        ON u.user_id = r.user_id
    JOIN movies m
        ON r.movie_id = m.movie_id
)

SELECT
    name,
    title,
    rating_date
FROM LastRating
WHERE rn = 1;

24. Show the difference in rating each user gave compared to their previous rating using LAG(). 

SELECT
    u.name,
    r.rating_date,
    r.rating,
    LAG(r.rating) OVER (
        PARTITION BY u.user_id
        ORDER BY r.rating_date
    ) AS previous_rating,
    r.rating -
    LAG(r.rating) OVER (
        PARTITION BY u.user_id
        ORDER BY r.rating_date
    ) AS rating_difference
FROM users u
JOIN ratings r
    ON u.user_id = r.user_id
ORDER BY u.name, r.rating_date;


25. Use DENSE_RANK() to find the top-rated movies overall (no gaps in rank).


WITH MovieAverage AS (
    SELECT
        m.title,
        ROUND(AVG(r.rating),2) AS avg_rating
    FROM movies m
    JOIN ratings r
        ON m.movie_id = r.movie_id
    GROUP BY m.title
)

SELECT
    title,
    avg_rating,
    DENSE_RANK() OVER(
        ORDER BY avg_rating DESC
    ) AS movie_rank
FROM MovieAverage;


