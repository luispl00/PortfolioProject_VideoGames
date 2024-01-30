-- Platforms Analysis
/* 
Analysis of the platforms available in our data set to answer the question: 
Which platform has the best numbers?
*/



-- What about video game platforms? Were sales good? Let's find out which platform has the most games sold.
SELECT TOP 10 platform, ROUND((SUM(games_sold)*1000000), 0) AS total_units
FROM game_sales
GROUP BY platform
ORDER BY total_units DESC

/*
That's a lot of games sold! Now we see why kaggle says that the game industry has been growing so much.
But units sold tells us about game's quality? Let's see there's a relation between units sold and the average critic score.
*/



-- Let's see have a look to the best-seller game for each platform
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

/*
Those numbers are huge! We can see every best-seller and their respective number of sale for the top 10 platforms in sales.
*/



-- Now let's see how loved are our top selling platforms
SELECT TOP 10 platform, AVG(critic_score) AS avg_critic_score, AVG(user_score) AS average_user_score
FROM game_sales AS s
LEFT JOIN game_reviews AS r 
	ON s.id = r.id AND s.name = r.name
GROUP BY platform
ORDER BY (SUM(games_sold)*1000000) DESC

/*
We can see that our top selling platforms are very loved by their users! 
Critics have a different opinion as we can see.
*/
