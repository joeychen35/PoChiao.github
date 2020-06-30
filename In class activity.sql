USE db_countries;
select * from `international-football-results-from-1872-to-2017`;
describe intl_football;

DROP TABLE IF EXISTS intl;
CREATE TEMPORARY TABLE intl
	SELECT * , STR_TO_DATE(date,'%Y-%m-%d') as date_correct
    FROM `international-football-results-from-1872-to-2017`;

DESCRIBE intl;
select * from intl;


SELECT date_correct,DAYOFWEEK(date_correct) FROM intl;
SELECT CURDATE() as today, date_correct as day_game FROM intl;

SELECT CURDATE() as today, 
      date_correct as day_game ,
      DATEDIFF(CURDATE(), date_correct)	as days_between		FROM intl;


### Q1 Prob distribution of games by day of the week by country?
SELECT home_team, date_correct,DAYOFWEEK(date_correct) AS A FROM intl;


### Q2 How long is the largiest time window between two games played by italy as vistor without scoring more that two goals?
SELECT CURDATE() as today, 
      date_correct as day_game ,
      DATEDIFF(CURDATE(), date_correct)	as days_between,
      away_team,
      away_score
      FROM intl 
      WHERE away_team = 'italy' AND away_score < 2
      ORDER BY days_between DESC;
### Q3 What is the most effective team in the world playing local?
SELECT * FROM 
	(SELECT count(*) AS home_game_won, home_team FROM intl WHERE home_score > away_score GROUP BY home_team) AS A
	INNER JOIN
	(SELECT count(*) AS home_game_played, home_team FROM intl GROUP BY home_team) AS B
    WHERE A.home_team = B.home_team;

### Q4 How many goals per day did every country in the world scored since the second world war?

SELECT country,
SUM(home_score) AS goal_score_home, 
SUM(away_score) AS goal_score_away, 
(SUM(home_score)+SUM(away_score)) AS total_score, 
((SUM(home_score)+SUM(away_score)/COUNT(*))) AS score_per_day, 
COUNT(*) 
FROM intl 
WHERE date > '1945-09-02' GROUP BY country;

