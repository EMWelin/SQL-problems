-- https://www.sql-practice.com/

-- Hard problems from the Hospital problem set.

/*
Show the percent of patients that have 'M' as their gender. 
Round the answer to the nearest hundreth number and in percent form.
*/

-- sql-practice requires the answer to look like xx% hence why I use concat the add the percentage sign.

SELECT 
CONCAT(
ROUND(
SUM(CASE WHEN gender = 'M' THEN 1 END) * 1.0 / COUNT(*) * 100, 2), '%') AS percent_male_patients
FROM patients
