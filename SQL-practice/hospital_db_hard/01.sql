-- https://www.sql-practice.com/

-- Hard problems from the Hospital problem set.

/*
Show all of the patients grouped into weight groups.
Show the total amount of patients in each weight group.
Order the list by the weight group decending.

For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
*/


SELECT
COUNT(*) AS patients_in_group,
-- FLOOR(x / 10) * 10 rounds x to the nearest ten down. 
-- Example: (Floor(142 / 10) ) * 10 = 140
FLOOR(weight / 10) * 10 AS weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;

