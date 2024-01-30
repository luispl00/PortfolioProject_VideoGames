-- THE GOLDEN ERA OF VIDEO GAMES

/* Analysis of the years available in our data set to answer the question: 
When was the golden age of video games?

Skills needed: Filtering with having, CTEs, Joins, Aggregate functions, Complex Joins (CTEs with DB tables), Set operations
*/

SELECT *
FROM game_sales
	
SELECT *
FROM game_reviews

-- Let's begin by looking at some of the top selling video games of all time
SELECT TOP 10 *
FROM game_sales
ORDER BY games_sold DESC

/*
The best-selling video games were released between 1985 to 2017! That's quite a range
We'll have to use data from the reviews table to gain more insight on the best years for video games.
*/


-- One big shortcoming is that there is not any reviews data for some of the games on the game_sales table.
SELECT COUNT(*) AS NoReviews_Count
FROM game_sales AS s
LEFT JOIN game_reviews AS r
    ON s.id = r.id AND s.name = r.name
WHERE (critic_score IS NULL AND user_score IS NULL)

/*
It looks like almost half of the games on the game_sales table don't have any reviews data. 
That's a big percentage, we can continue our exploration, but the missing reviews data is a good thing 
to keep in mind as we move on to evaluating results from more sophisticated queries.
*/


-- There are lots of ways to measure the best years for video games! Let's start with what the critics think.
SELECT TOP 10 year, ROUND(AVG(critic_score), 2) AS avg_critic_score
FROM game_sales AS s
LEFT JOIN game_reviews AS r
    ON s.id = r.id
	AND s.name = r.name
WHERE critic_score IS NOT NULL
GROUP BY year
ORDER by avg_critic_score DESC
	
/*
The range of great years according to critic reviews goes from 1982 until 2020.
We are no closer to finding the golden age of video games!
Some of those avg_critic_score values look like suspiciously round numbers for averages. 
The value for 1982, 1994 and 1992 looks especially suspicious. 
Maybe there weren't a lot of video games in our dataset that were released in certain years.
*/


-- Based on the previuos query, let's see how many games we have per year
SELECT TOP 10 year, ROUND(AVG(critic_score), 2) AS avg_critic_score, COUNT(*) AS num_games
FROM game_sales AS s
LEFT JOIN game_reviews AS r
    ON s.id = r.id
	AND s.name = r.name
WHERE critic_score IS NOT NULL
GROUP BY year
ORDER by avg_critic_score DESC

/* 
Now it's more clear for us. There are years that have just 1 record (where critic_score is not null), 
that's why we have round numbers on the averegar_critic_score.
*/


-- Let's filter our query with just years that have 5 or more records in their group.
SELECT year, ROUND(AVG(critic_score), 2) AS avg_critic_score, COUNT(*) AS num_games
FROM game_sales AS s
LEFT JOIN game_reviews AS r
    ON s.id = r.id
	AND s.name = r.name
GROUP BY year
HAVING COUNT(*) >= 5
ORDER by avg_critic_score DESC

/* 
The num_games column convinces us that our new list of the critics' top games reflects years that had quite a few well-reviewed games
rather than just one or two hits. But which years dropped off the list due to having four or fewer reviewed games?
Let's identify them so that someday we can track down more game reviews for those years and determine whether they might rightfully 
be considered as excellent years for video game releases.
*/



-- Using a Set Operation to identify those games that were dropped off.
WITH top_critic_years AS(
SELECT year, ROUND(AVG(critic_score), 2) AS avg_critic_score, COUNT(*) AS num_games
FROM game_sales AS s
LEFT JOIN game_reviews AS r
    ON s.id = r.id
	AND s.name = r.name
WHERE critic_score IS NOT NULL
GROUP BY year
),
top_critic_years_refined AS(
SELECT year, ROUND(AVG(critic_score), 2) AS avg_critic_score, COUNT(*) AS num_games
FROM game_sales AS s
LEFT JOIN game_reviews AS r
    ON s.id = r.id
	AND s.name = r.name
WHERE critic_score IS NOT NULL
GROUP BY year
HAVING COUNT(*) >= 5
)

SELECT year, avg_critic_score, num_games
FROM top_critic_years
EXCEPT
SELECT year, avg_critic_score, num_games
FROM top_critic_years_refined

/*
Now we can see which years were taken out of consideration due to not enough records in their group.
We have to move on, Based on our work in previous task above, it looks like the early 1990s might merit 
consideration as the golden age of video games based on critic_score alone
*/


-- Let's move on to looking at the opinions of another important group of people: players. 
SELECT TOP 10 year, ROUND(AVG(user_score), 2) AS avg_user_score, COUNT(*) AS num_games
FROM game_sales AS s
LEFT JOIN game_reviews AS r
    ON s.id = r.id
	AND s.name = r.name
GROUP BY year
HAVING COUNT(*) >= 5
ORDER by avg_user_score DESC

/*
We've got a list of the top ten years according to both critic reviews and user reviews.
*/


-- Let's find out which years were loved by critics and players
WITH top_critic_years AS
(
SELECT TOP 10 year, ROUND(AVG(critic_score), 2) AS avg_critic_score, COUNT(*) AS num_games
FROM game_sales AS s
LEFT JOIN game_reviews AS r
    ON s.id = r.id
	AND s.name = r.name
GROUP BY year
HAVING COUNT(*) >= 5
ORDER by avg_critic_score DESC
),
top_user_years AS
(
SELECT TOP 10 year, ROUND(AVG(user_score), 2) AS avg_user_score, COUNT(*) AS num_games
FROM game_sales AS s
LEFT JOIN game_reviews AS r
    ON s.id = r.id
	AND s.name = r.name
GROUP BY year
HAVING COUNT(*) >= 5
ORDER by avg_user_score DESC
)

SELECT *
FROM top_critic_years AS c
INNER JOIN top_user_years AS u
ON c.year = u.year

/*
4 years have in common user and critics.
*/
