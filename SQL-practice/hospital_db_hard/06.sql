-- https://www.sql-practice.com/

-- Hard problems from the Hospital problem set.

/*
Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name
*/ 

-- SELECT prov.province_name FROM patients p looks a bit weird but I have to start with the main table, which is p.

SELECT
prov.province_name
FROM patients p
JOIN province_names prov 
ON p.province_id = prov.province_id
GROUP BY prov.province_name
HAVING 
COUNT(CASE WHEN p.gender = 'M' THEN 1 END) > 
COUNT(CASE WHEN p.gender = 'F' THEN 1 END);
