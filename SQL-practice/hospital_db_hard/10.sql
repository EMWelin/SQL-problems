-- https://www.sql-practice.com/

-- Hard problems from the Hospital problem set.

/*
Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.
*/

-- Weird sorting trick.

SELECT province_name
FROM province_names
ORDER BY 
    CASE 
        WHEN province_name = 'Ontario' THEN 0 
        ELSE 1 
    END, 
    province_name ASC;
sion_day) OVER (ORDER BY admission_date) AS admission_count_change
FROM admission_count;