-- https://www.sql-practice.com/

-- Hard problems from the Hospital problem set.

/*
We need a breakdown for the total amount of admissions each doctor has started each year. 
Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.
*/

WITH year_cte AS (
    SELECT 
  		attending_doctor_id, -- we need this column to join doctors d
        YEAR(admission_date) AS selected_year,
        COUNT(*) AS total_admissions
    FROM admissions
    GROUP BY attending_doctor_id, YEAR(admission_date)
)
SELECT
    d.doctor_id,
    d.specialty,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    y.selected_year,
    y.total_admissions
FROM year_cte y
JOIN doctors d
ON y.attending_doctor_id = d.doctor_id
ORDER BY y.attending_doctor_id, y.selected_year;