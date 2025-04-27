-- https://www.sql-practice.com/

-- Hard problems from the Hospital problem set.

/* 
For each day, display the total amount of admissions on that day.
Display the amount changed from the previous date.
*/


WITH admission_count AS (
    SELECT
        admission_date,
        COUNT(*) AS admission_day
    FROM admissions
    GROUP BY admission_date
)

SELECT
    admission_date,
    admission_day,
    admission_day - LAG(admission_day) OVER (ORDER BY admission_date) AS admission_count_change
FROM admission_count;

/* My comment:
We need to LAG a calculated column 'admission_day'. This is a CTE problem as I can't
create a calculated column and then use it for more calculations in the same SELECT.

The part to remember in this problem was that I can select admission_date without refering
the admissions table because it was referenced in my CTE.
*/
