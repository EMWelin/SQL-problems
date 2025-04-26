-- https://www.sql-practice.com/

-- This is the Hospital problem set.

-- Table: patients

-- primary key icon	patient_id	INT
-- first_name	TEXT
-- last_name	TEXT
-- gender	CHAR(1)
-- birth_date	DATE
-- city	TEXT
-- primary key icon	province_id	CHAR(2)
-- allergies	TEXT
-- height	INT
-- weight	INT

-- Table: province_names


-- primary key icon	province_id	CHAR(2)
-- province_name	TEXT

-- Medium problems:

-- Show unique birth years from patients and order them by ascending.
-- Solution:

SELECT
DISTINCT(SUBSTR(birth_date, 1,4)) AS birth_year
FROM patients
ORDER BY birth_year ASC
;

-- Alternative solution:

SELECT
  DISTINCT YEAR(birth_date) AS birth_year 
FROM patients
ORDER BY birth_year;


-- Show unique first names from the patients table which only occurs once in the list.
 
-- For example, if two or more people are named 'John' in the first_name column then don't include their name -- in the output list. If only 1 person is named 'Leo' then include them in the output.
-- Solution:

SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1;  -- COUNT(DISTINCT will not work here).

-- Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least - 6 characters long.
-- Solution:

SELECT 
patient_id,
first_name
FROM patients
WHERE first_name LIKE 'S%' -- starts with S
AND first_name LIKE'%s' -- ends with s
AND LENGTH(first_name) >= 6
;

-- Cleaner solution: WHERE first_name LIKE 's____%s';


-- Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
-- Primary diagnosis is stored in the admissions table.

SELECT 
p.patient_id,
p.first_name,
p.last_name
FROM patients p
JOIN admissions a
ON p.patient_id = a.patient_id
WHERE a.diagnosis = 'Dementia'
;


-- Display every patient's first_name.
-- Order the list by the length of each name and then by alphabetically.


SELECT first_name
FROM patients
ORDER BY 
LENGTH(first_name),
first_name -- ASC is default
;

-- Show the total amount of male patients.. 
-- and the total amount of female patients in the patients table.
-- Display the two results in the same row.

SELECT
COUNT(CASE WHEN gender = 'M' THEN 1 END) AS male_count,
COUNT(CASE WHEN gender = 'F' THEN 1 END) AS female_count
FROM patients
;

-- Comment on the problem:
-- COUNT(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) is wrong
-- because it ends up counting the zeros as well.

-- Next problem: 

-- Show first and last name, 
-- allergies from patients which have allergies to either 
-- 'Penicillin' or 'Morphine'. 
-- Show results ordered ascending by allergies 
-- then by first_name then by last_name.

SELECT
first_name,
last_name,
allergies
FROM patients
WHERE allergies in ('Penicillin', 'Morphine')
ORDER BY allergies, 
first_name, 
last_name -- ASC is default
;

-- Show patient_id, diagnosis from admissions. 
-- Find patients admitted multiple times for the same diagnosis.

SELECT 
p.patient_id,
a.diagnosis
FROM patients p
JOIN admissions a
ON p.patient_id = a.patient_id
-- This one is interesting.
-- We crete groups of p.patient_id and a.diagnosis and checks which groups occur more than once.
GROUP BY 
p.patient_id,
a.diagnosis
HAVING COUNT(*) > 1 
;

-- Show the city and the total number of patients in the city.
-- Order from most to least patients and then by city name ascending.

SELECT 
city,
COUNT(patient_id) AS num_patients
FROM patients
GROUP BY city
ORDER BY 
num_patients DESC, 
city;

-- Table: doctors

-- primary key icon	doctor_id	INT
-- first_name	TEXT
-- last_name	TEXT
-- specialty	TEXT

-- Show first name, last name and role of every person that is either patient or doctor.
-- The roles are either "Patient" or "Doctor"

-- Interesting problem, how to do two selects from different tables
-- w/o joining.

SELECT 
first_name,
last_name,
'Patient' as role
FROM patients

UNION ALL  -- This performs a vertical stack of the two selects.

SELECT 
first_name,
last_name,
'Doctor' as role
FROM doctors;

-- Show all allergies ordered by popularity. 
-- Remove NULL values from query.

-- This is an interesting one. I need to count but I also need to do WHERE

SELECT
allergies,
COUNT(allergies) AS total_diagnosis
FROM patients
WHERE allergies IS NOT NULL
GROup BY allergies
ORDER BY total_diagnosis DESC
;


-- Show all patient's first_name, last_name, 
-- and birth_date who were born in the 1970s decade. 
-- Sort the list starting from the earliest birth_date. 

-- In 'real' SQlite: use SUBSTR(birth_day, 1, 4) and match strings.

SELECT
first_name,
last_name,
birth_date
FROM patients
WHERE YEAR(birth_date) IN (
  1970, 1971, 1972, 1973, 1974,
  1975, 1976, 1977, 1978, 1979
)
ORDER BY birth_date 
;



-- We want to display each patient's full name in a single column. 
--Their last_name in all upper letters must appear first, 
--then first_name in all lower case letters. 
--Separate the last_name and first_name with a comma. 
-- Order the list by the first_name in decending order EX: SMITH,jane

SELECT  
CONCAT(
  UPPER(last_name),
        ',',
        LOWER(first_name)
  ) AS new_name_format  
FROM patients
ORDER BY first_name DESC
;

-- Show the province_id(s), sum of height; 
-- where the total sum of its patient's height is 
-- greater than or equal to 7,000.

SELECT 
province_id,
SUM(height) AS sum_height
FROM patients
GROUP BY province_id
-- Filter groups, use HAVING. WHERE is for Rows.
HAVING sum_height >= 7000 
ORDER BY province_id

-- Show the difference between the largest weight and smallest weight 
-- for patients with the last name 'Maroni'

SELECT 
MAX(weight) - MIN(weight) AS weight_delta
FROM patients
GROUP BY last_name
HAVING last_name = 'Maroni';


-- Show all of the days of the month (1-31) and 
-- how many admission_dates occurred on that day. 
-- Sort by the day with most admissions to least admissions.

SELECT 
DAY(admission_date) AS day_number,
COUNT(admission_date) AS number_of_admissions
FROM admissions
GROUP BY day_number
ORDER BY number_of_admissions DESC;

-- Show all columns for patient_id 542's most recent admission_date.

SELECT *
FROM admissions
GROUP BY patient_id
HAVING patient_id = 542 AND admission_date = MAX(admission_date)  -- MAX can be used for Dates(!)
;

-- Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
-- 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
-- 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.

SELECT 
patient_id, 
attending_doctor_id, 
diagnosis
FROM admissions
WHERE 
(patient_id % 2 = 1 AND attending_doctor_id IN (1,5,19)) 
OR 
-- This is the tricky one. We convert the INT column to string using CAST
-- and then we can use LIKE
(CAST(attending_doctor_id AS TEXT) LIKE '%2%'
AND LENGTH(patient_id) = 3
 );

-- Show first_name, last_name, and the total number of admissions attended for each doctor.
-- Every admission has been attended by a doctor.

SELECT
d.first_name,
d.last_name,
COUNT(a.admission_date) AS admissions_total
FROM doctors d
JOIN admissions a
ON d.doctor_id = a.attending_doctor_id
GROUP BY attending_doctor_id;

-- For each doctor, display their id, full name, and the first and last admission date they attended.

SELECT
d.doctor_id,
CONCAT(d.first_name, ' ', d.last_name) AS full_name,
MIN(a.admission_date) AS fist_admission_date,
MAX(a.admission_date) AS last_admission_date
FROM doctors d
JOIN admissions a 
ON d.doctor_id = a.attending_doctor_id
GROUP BY a.attending_doctor_id;


-- Display the total amount of patients for each province. Order by descending.

-- Table: province_names

-- primary key icon	province_id	CHAR(2)
-- province_name	TEXT

SELECT 
prov.province_name,
COUNT(p.patient_id) AS patient_count
FROM patients p
JOIN province_names prov
ON p.province_id = prov.province_id
GROUP BY prov.province_name
ORDER by patient_count DESC;


/*
Table: doctors
doctor_id	INT
first_name	TEXT
last_name	TEXT
specialty	TEXT

For every admission, 
display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
*/

-- Intersting problem: JOIN of three tables.

SELECT
CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
a.diagnosis,
CONCAT(d.first_name, ' ', d.last_name) AS doctor_name
FROM patients p
JOIN admissions a
ON p.patient_id = a.patient_id
JOIN doctors d
ON a.attending_doctor_id = d.doctor_id;

/*
display the first name, last name and number of duplicate patients based on their first name and last name.
Ex: A patient with an identical name can be considered a duplicate.
*/

SELECT
first_name,
last_name,
COUNT(*) AS num_of_duplicates
FROM patients
-- Group by first and last_name
GROUP BY 
    first_name, 
    last_name
HAVING 
COUNT(*) > 1;

/*
Display patient's full name,
height in the units feet rounded to 1 decimal, weight in the unit pounds rounded to 0 decimals,
birth_date, gender non abbreviated.
Convert CM to feet by dividing by 30.48.
Convert KG to pounds by multiplying by 2.205.
*/

SELECT
CONCAT(first_name, ' ', last_name) as patient_name,
ROUND(height/30.48,1) AS height,
ROUND(weight*2.205,0) AS weight,
birth_date,
CASE 
WHEN gender = 'M' THEN 'MALE' 
ELSE 'FEMALE' 
END AS gender
FROM patients


/*
Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. 
(Their patient_id does not exist in any admissions.patient_id rows.)
*/

-- Interesting problem: "Anti-join" using LEFT JOIN.

SELECT
p.patient_id, 
p.first_name, 
p.last_name
FROM patients p
-- LEFT JOIN: keep all records from left table.
LEFT JOIN admissions a 
ON p.patient_id = a.patient_id
WHERE a.patient_id IS NULL;

/*
Display a single row with max_visits, min_visits, average_visits
where the maximum, minimum and average number of admissions per day is calculated. Average is rounded to 2 decimal places.
*/

-- Interesting problem: subqueing.

SELECT 
MAX(visit_count) AS max_visits,
MIN(visit_count) AS min_visits,
ROUND(
  AVG(visit_count), 2) AS average_visits
FROM
(
  SELECT
  COUNT(admission_date) AS visit_count
  FROM admissions
  GROUP BY admission_date
 );
