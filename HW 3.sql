USE db_countries;


###Q1###
###What countries have a total GDP per capita above the mean?
# 77 rows return
SELECT *
FROM countries_of_the_world 
WHERE GDP * Population > (SELECT AVG(GDP) FROM countries_of_the_world)* Population;

###Q2###
###How many countries are above the mean on each region in Area, GDP and another variable decided by yourself?
# 4 countries, I assume the mean is total Area, GDP and population
SELECT Region, count(*) AS num_of_countries_above_mean_GDP_area_pop
FROM countries_of_the_world 
WHERE GDP  > (SELECT AVG(GDP) FROM countries_of_the_world) AND 
	Area > (SELECT AVG(Area) FROM countries_of_the_world) AND 
	population > (SELECT AVG(population) FROM countries_of_the_world)
GROUP BY Region;

###Q3###
###How many regions have more than 65% of their countries with a GDP per capita above 6000?
# 4 regions
DROP TEMPORARY TABLE new_tbl3;
CREATE TEMPORARY TABLE new_tbl3
	SELECT B.*, A.Above_6000 FROM
		(SELECT region,COUNT(country) AS Above_6000 FROM countries_of_the_world WHERE GDP > 6000 GROUP BY region)
		AS A,
        (SELECT region,COUNT(country) AS total FROM countries_of_the_world GROUP BY region) AS B
		WHERE A.region = B.region;
SELECT *, (Above_6000/total) AS percentage_countries_6000 FROM new_tbl3 WHERE Above_6000/total >.65;

###Q4###
###List all the countries with a GDP that is less than 40% of the mean GDP per capita across all the countries.
# 88 rows return
SELECT Country
FROM countries_of_the_world 
WHERE GDP < (SELECT AVG(GDP) FROM countries_of_the_world) * 0.4;

###Q5###
###List all the countries with a GDP per capita that is between 40% and 60% the mean GDP per capita across all the countries.
# 29 rows return
SELECT Country
FROM countries_of_the_world 
WHERE GDP BETWEEN (SELECT AVG(GDP) FROM countries_of_the_world) * 0.4 AND (SELECT AVG(GDP) FROM countries_of_the_world) * 0.6;

###Q6###
###Which letter is the most popular first letter among all the countries? (i.e. what is the letter that starts the largest number of countries?)
# The letter S
SELECT COUNT(*) as countries_appears,SUBSTRING(Country,1,1) as letter
FROM countries_of_the_world 
GROUP BY SUBSTRING(Country,1,1) 
ORDER BY  countries_appears DESC;

###Q7###
###What are the countries with a coast to area ratio in the top 50? 
# 50 rows return
SELECT country, round(Coastline/Area,3) AS CA_ratio FROM countries_of_the_world ORDER BY CA_ratio DESC LIMIT 50;

###7a.From these countries, how many of them belong to the bottom 30 countries by GDP per capita?
# 4 countries 
SELECT A.Country, A.CA_ratio, B.GDP
	FROM (SELECT country, round(Coastline/Area,3) AS CA_ratio FROM countries_of_the_world ORDER BY CA_ratio DESC LIMIT 50) AS A
	INNER JOIN
	(SELECT country, GDP FROM countries_of_the_world ORDER BY GDP LIMIT 30) AS B
	ON A.Country = B.Country;
    
###7b.From these countries, how many of them belong to the top 30 countries by GDP per capita?
# 7 countries 
SELECT A.Country, A.CA_ratio, B.GDP
	FROM (SELECT country, round(Coastline/Area,3) AS CA_ratio FROM countries_of_the_world ORDER BY CA_ratio DESC LIMIT 50) AS A
	INNER JOIN
	(SELECT country, GDP FROM countries_of_the_world ORDER BY GDP DESC LIMIT 30) AS B
	ON A.Country = B.Country;

###Q8###
###Is the average Agriculture, Industry, Service distribution of the top 20 richest countries different than the one of the lowest 20?
#  YES, its different. Compare rank group 1 and 2 for answer.
CREATE TEMPORARY TABLE new_tbl4
	SELECT Country, Agriculture, Industry, Service, 
	RANK() OVER (ORDER BY GDP) rank_increasing,
	RANK() OVER (ORDER BY GDP DESC) rank_decreasing
	FROM countries_of_the_world; 
SELECT rank_group,
		round(AVG(Agriculture),3) AS 'mean_agriculture',
		round(AVG(Industry),3) AS 'mean_industry',
		round(AVG(Service),3) AS 'mean_service'
FROM(
SELECT *,
	1*(rank_decreasing<21)+
    2*(rank_increasing<21)
    AS rank_group
FROM new_tbl4) as t4
GROUP BY t4.rank_group ORDER BY rank_group;								###Compare rank group 1 and 2 for answer


###Q9###
###How much higher is the average literacy level in the 20% percentile of the richest countries relative to the poorest 20% countries?
# 38.20499999999999
SELECT count(*)*.2 FROM countries_of_the_world;  ### calculate 20% percentile and figure out 20% percentile is top 45 country and botton 45 country

CREATE TEMPORARY TABLE top_20_percentile
	SELECT literacy FROM countries_of_the_world ORDER BY GDP DESC limit 45;
CREATE TEMPORARY TABLE botton_20_percentile
	SELECT literacy FROM countries_of_the_world ORDER BY GDP limit 45;

SELECT (SELECT AVG(literacy) AS literacy_top20_percetile FROM top_20_percentile ) - 
(SELECT AVG(literacy) AS literacy_botton20_percetile  FROM botton_20_percentile) AS literacy_rich_poor_diff;


###Q10###
###From all the countries with a coast ratio at least 50% lower than the mean, which % of them stay in Africa? 
# 26.76% countries with a coast ratio at least 50% lower than the mean stays in Africa. 

SELECT Count(country) FROM countries_of_the_world WHERE round(Coastline/Area,3) < (SELECT AVG(round(Coastline/Area,3)) FROM countries_of_the_world)*.5; #count all the countries with a coast ratio at least 50% lower than the mean

DROP TEMPORARY TABLE new_tbl5;
CREATE TEMPORARY TABLE new_tbl5
	SELECT country, region, round(Coastline/Area,3) AS CA_ratio FROM countries_of_the_world
	WHERE round(Coastline/Area,3) < (SELECT AVG(round(Coastline/Area,3)) FROM countries_of_the_world)*.5 
	AND region REGEXP 'Africa';

SELECT count(country)/(SELECT Count(country) FROM countries_of_the_world WHERE round(Coastline/Area,3) < (SELECT AVG(round(Coastline/Area,3)) FROM countries_of_the_world)*.5 
)FROM new_tbl5;

###10a.How many of them start with the letter C?
# 8 countries 

SELECT * FROM new_tbl5 WHERE country REGEXP '^c';





