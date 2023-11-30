/*
List countries that saw a difference of
more than 10°C between their highest and
lowest temperatures in the first eight months of 2013.
*/
SELECT country FROM temperatures_by_country
WHERE dt BETWEEN '2013-01-01' AND '2013-08-31'
GROUP BY country
HAVING (MAX(avg_temp)-MIN(avg_temp))>10;

/*sol*/
SELECT 
  EXTRACT(MONTH FROM russia2013.dt) AS "Month",
  russia2013.avg_temp AS Temp2013,
  russia2012.avg_temp AS Temp2012
FROM 
  temperatures_by_country AS russia2013
INNER JOIN 
  temperatures_by_country AS russia2012
ON 
  EXTRACT(MONTH FROM russia2013.dt) = EXTRACT(MONTH FROM russia2012.dt)
  AND russia2013.country = 'Russia' 
  AND russia2012.country = 'Russia'
  AND EXTRACT(YEAR FROM russia2013.dt) = 2013
  AND EXTRACT(YEAR FROM russia2012.dt) = 2012;


/*
Identify pairs of countries that had, on average,
similar temperatures (less than 1-degree difference)
in the years from 2010 to 2013.
*/
WITH country_avg_temps AS(
    SELECT country, AVG(avg_temp) AS country_avg_temp
    FROM temperatures_by_country
    WHERE EXTRACT(YEAR FROM dt) IN (2010, 2011, 2012, 2013)
    GROUP BY country
)
SELECT t1.country AS country_1, t2.country AS country_2,
ABS(t1.country_avg_temp - t2.country_avg_temp) AS abs_temp_diff
FROM country_avg_temps t1
JOIN country_avg_temps t2 ON t1.country <> t2.country
AND ABS(t1.country_avg_temp - t2.country_avg_temp) < 1

/* the earliest and latest year represented in this dataset */
SELECT min(EXTRACT(Year from dt)), 
max(EXTRACT(Year from dt)) 
FROM temperatures_by_country;

/* How many null temperatures exist and its percentage in this dataset */
SELECT
    COUNT(*) AS null_count,
    COUNT(*) * 100.0 / (SELECT COUNT(*) 
    FROM temperatures_by_country) AS null_percentage
FROM
    temperatures_by_country
WHERE
    avg_temp IS NULL;

/* How many null temperatures exist in this dataset */
SELECT COUNT(*) FROM temperatures_by_country
WHERE avg_temp IS NULL OR avg_temp_uncertainty IS NULL;

/* top 10 countries with the highest average temperature? (do not include avg_temp = NULL) */
SELECT DISTINCT country, 
AVG(avg_temp) FROM temperatures_by_country
WHERE avg_temp IS NOT NULL
GROUP BY country
ORDER BY AVG(avg_temp) DESC
LIMIT 10;

/* Between the years 2000 and 2013, 
what difference in average yearly 
temperature between Djibouti and Greenland */
with greenland as (
select extract(year from dt) as years, avg(avg_temp) as gtemp

from temperatures_by_country
where extract(year from dt) between '2000' and '2013'
   and country = 'Greenland'
group by 1),

djibouti as (
select extract(year from dt) as years, avg(avg_temp) as dtemp

from temperatures_by_country
where extract(year from dt) between '2000' and '2013'
   and country = 'Djibouti'
group by 1)


select
years, 
round((d.dtemp - gr.gtemp)::numeric, 2) as temp_difference

from greenland gr
left join djibouti d using (years)
order by 1 desc

/* Starting from the year 2000, 
what is the relative change in overall climate year-over-year in Fahrenheit.
relative change = ((x2 - x1) / x1) */
SELECT
    EXTRACT(YEAR FROM t1.dt) AS year,
    ((AVG(t2.avg_temp) - AVG(t1.avg_temp)) / AVG(t1.avg_temp)) * 100 AS relative_change
FROM
    temperatures_by_country AS t1
JOIN
    temperatures_by_country AS t2
ON
    EXTRACT(YEAR FROM t1.dt) = EXTRACT(YEAR FROM t2.dt) - 1
    AND t1.country = t2.country
WHERE
    EXTRACT(YEAR FROM t1.dt) >= 2000
GROUP BY
    EXTRACT(YEAR FROM t1.dt)
ORDER BY
    EXTRACT(YEAR FROM t1.dt);
