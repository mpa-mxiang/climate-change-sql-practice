/*
List countries that saw a difference of
more than 10°C between their highest and
lowest temperatures in the first eight months of 2013.
*/
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
