-- https://www.sql-practice.com/

-- Hard problems from the Hospital problem set.

/* 
We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
- First_name contains an 'r' after the first two letters.
- Identifies their gender as 'F'
- Born in February, May, or December
- Their weight would be between 60kg and 80kg
- Their patient_id is an odd number
- They are from the city 'Kingston'
*/ 

-- My comment: misclassified problem. Should probably be considered Medium.


SELECT * 
FROM patients
WHERE
MONTH(birth_date) IN (2, 5, 12) 
AND first_name LIKE "__r%" 
AND patient_id%2 = 1 
AND CITY = 'Kingston' 
AND gender = 'F'
AND weight Between 60 AND 80;
