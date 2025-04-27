-- https://www.sql-practice.com/

-- Hard problems from the Hospital problem set.

/*
Each admission costs $50 for patients without insurance, and $10 for patients with insurance. 
All patients with an even patient_id have insurance.
Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. 
Add up the admission_total cost for each has_insurance group.
*/

/*
This problem:
I want to use has_insurance for calculations but it's in itself a calculated column.
For this I need to use a Common Table Expression (CTE). 
*/

-- My Solution:

WITH Insurance_cte AS (     
SELECT
CASE
WHEN patient_id%2 = 0 THEN 'YES'
ELSE 'NO'
END AS has_insurance,
(SELECT 
 COUNT(CASE WHEN patient_id%2 = 0 THEN 1 END)
 FROM admissions) AS count_yes,
(SELECT 
 COUNT(CASE WHEN patient_id%2 = 1 THEN 1 END)
 FROM admissions) AS count_no  
FROM admissions)

SELECT 
has_insurance, 
CASE 
WHEN has_insurance = 'NO' THEN 50 * count_no
ELSE 10 * count_yes
END AS cost_after_insurance
FROM Insurance_cte
GROUP BY has_insurance;

-- Alternative solution from ChatGPT, saved for learning purposes. It's better than mine:

WITH Insurance_cte AS (
  SELECT
    CASE
      WHEN patient_id % 2 = 0 THEN 'YES'
      ELSE 'NO'
    END AS has_insurance,
    COUNT(*) AS count_group
  FROM admissions
  GROUP BY
    CASE
      WHEN patient_id % 2 = 0 THEN 'YES'
      ELSE 'NO'
    END
)

SELECT 
  has_insurance,
  CASE 
    WHEN has_insurance = 'NO' THEN 50 * count_group
    ELSE 10 * count_group
  END AS cost_after_insurance
FROM Insurance_cte;
