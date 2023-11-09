/*
List countries that saw a difference of
more than 10°C between their highest and
lowest temperatures in the first eight months of 2013.
*/
SELECT country FROM temperatures_by_country
WHERE dt BETWEEN '2013-01-01' AND '2013-08-31'
GROUP BY country
HAVING (MAX(avg_temp)-MIN(avg_temp))>10;

