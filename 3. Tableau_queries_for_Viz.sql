/*
Queries for Tableau Visualizations
*/

-- DASHBOARD 1: TOP GAMES AND REVIEWS
-- Table 1: Top selling video games with reviews 
SELECT s.name, s.platform, s.publisher, s.developer, s.games_sold, ROUND(r.critic_score, 2) AS critic_score , ROUND(r.user_score, 2) AS user_score, s.year
FROM game_sales AS s
LEFT JOIN game_reviews AS r
    ON s.id = r.id
	AND s.name = r.name
ORDER BY games_sold DESC


-- DASHBOARD 2: THE GOLDEN ERA OF VIDEO GAMES
-- Table 2: Best years for video games based on what the CRITICS think
SELECT year, ROUND(AVG(critic_score), 2) AS avg_critic_score, COUNT(*) AS num_games
FROM game_sales AS s
LEFT JOIN game_reviews AS r
    ON s.id = r.id
	AND s.name = r.name
GROUP BY year
HAVING COUNT(*) >= 5
ORDER by avg_critic_score DESC

-- Table 3: Best years for video games based on what the PLAYERS think
SELECT year, ROUND(AVG(user_score), 2) AS avg_user_score, COUNT(*) AS num_games
FROM game_sales AS s
LEFT JOIN game_reviews AS r
    ON s.id = r.id
	AND s.name = r.name
GROUP BY year
HAVING COUNT(*) >= 5
ORDER by avg_user_score DESC

-- Table 4: Years that both players and critics loved
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

-- Table 5: Best selling years 
SELECT year, SUM(games_sold)*1000000 AS units_sold
FROM game_sales AS s
LEFT JOIN game_reviews AS r
    ON s.id = r.id
	AND s.name = r.name
GROUP BY year
ORDER by units_sold DESC

-- Table 6: Best selling years broke down by platform
SELECT year, platform, ROUND(SUM(games_sold)*1000000, 1) AS units_sold
FROM game_sales AS s
LEFT JOIN game_reviews AS r
    ON s.id = r.id
	AND s.name = r.name
GROUP BY year, platform
ORDER by year DESC, units_sold DESC

-- DASHBOARD 3: PLATFORM ANALYSIS
-- Table 7: Sum of units sold by platform
SELECT platform, ROUND((SUM(games_sold)*1000000), 0) AS total_units
FROM game_sales
GROUP BY platform
ORDER BY total_units DESC

-- Table 8: Best-selling game for each top selling platform
WITH top_platforms AS(
SELECT TOP 10 platform, ROUND((SUM(games_sold)*1000000), 0) AS total_units, MAX(games_sold) AS best_seller
FROM game_sales AS s1
GROUP BY platform
ORDER BY total_units DESC
)
SELECT t.platform, s.name, (t.best_seller)*1000000 AS best_seller
FROM top_platforms AS t
LEFT JOIN game_sales AS s
	ON t.best_seller = s.games_sold
ORDER BY total_units DESC

-- Table 9: Now let's see how loved are our top selling platforms
SELECT TOP 10 platform, ROUND(AVG(critic_score), 2) AS avg_critic_score, ROUND(AVG(user_score), 2) AS average_user_score
FROM game_sales AS s
LEFT JOIN game_reviews AS r 
	ON s.id = r.id AND s.name = r.name
GROUP BY platform
ORDER BY (SUM(games_sold)*1000000) DESC

