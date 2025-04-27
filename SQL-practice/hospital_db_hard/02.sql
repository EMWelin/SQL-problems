-- https://www.sql-practice.com/

-- Hard problems from the Hospital problem set.


/* 
Show patient_id, weight, height, isObese from the patients table.
Display isObese as a boolean 0 or 1.
Obese is defined as weight(kg)/(height(m)^2) >= 30.
weight is in units kg.
height is in units cm.
*/

/*
My comment:
This is an interesting problem because (height * height /10000) is logically correct but runs into numerical problems. I need to use POWER to avoid this issue.
*/ 

SELECT 
patient_id,
weight,
height,
CASE
-- cm = 10^-2 m --> 100 cm = 1 m --> a cm = a * 10^-2 * 100 cm = a * 10^-2 m 
WHEN weight / POWER(height / 100.0, 2) >= 30 THEN 1
Else 0
END AS isObese
FROM patients
;