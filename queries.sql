/*
List countries that saw a difference of
more than 10°C between their highest and
lowest temperatures in the first eight months of 2013.
*/
SELECT country FROM temperatures_by_country
WHERE dt BETWEEN '2013-01-01' AND '2013-08-31'
GROUP BY country
HAVING (MAX(avg_temp)-MIN(avg_temp))>10;

/*
Identify pairs of countries that had, on average,
similar temperatures (less than 1 degree difference)
in the years from 2010 to 2013.
*/
WITH
	country_avg_temps AS(
    SELECT country,
    			 AVG(avg_temp) AS country_avg_temp
    FROM temperatures_by_country
    WHERE EXTRACT(YEAR FROM dt) BETWEEN 2010 AND 2013
    GROUP BY country)
  
  SELECT t1.country AS country_1,
  			 t2.country AS country_2,
         ABS(t1.country_avg_temp - t2.country_avg_temp) AS abs_temp_diff
  FROM country_avg_temps t1
  JOIN country_avg_temps t2
		ON t1.country <> t2.country
    AND ABS(t1.country_avg_temp - t2.country_avg_temp) < 1

