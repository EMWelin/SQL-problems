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



-- Show first name, last name, and gender of patients whose gender is 'M'
-- Solution:

SELECT 
first_name, 
last_name, 
gender
FROM patients
WHERE
gender = 'M'


-- Show first name and last name of patients who does not have allergies. (null)
-- Solution:

SELECT 
first_name, 
last_name
FROM patients
WHERE
allergies is NULL

-- Show first name of patients that start with the letter 'C'
-- Solution:

SELECT 
first_name
FROM patients
WHERE first_name like 'C%'   
;

-- Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
-- Solution:

UPDATE patients
SET allergies = COALESCE(allergies, 'NKA') 
WHERE allergies IS NULL;


-- Show first name and last name concatinated into one column to show their full name.
-- Solution:

SELECT 
CONCAT(first_name, " ", last_name)
AS full_name
FROM patients

-- Show first name, last name, and the full province name of each patient.
-- Example: 'Ontario' instead of 'ON'
-- Solution:

SELECT 
p.first_name,
p.last_name,
prov.province_name
FROM patients p
JOIN province_names prov
on p.province_id = prov.province_id

-- Show how many patients have a birth_date with 2010 as the birth year.
-- Solution:

SELECT
-- patient_id is primary key so we don't need COUNT(DISTINCT patient_id)
COUNT(patient_id) AS total_patients 
FROM patients
-- birth_date has this format: 2017-11-19
-- match on the first four characters to get year. 
WHERE SUBSTR(birth_date, 1, 4) = '2010' -- SUBSTR(string, start index, length)

-- Show the first_name, last_name, and height of the patient with the greatest height.
-- Solution:

SELECT 
first_name,
last_name,
height
FROM patients
WHERE height = (SELECT MAX(height) FROM patients)
;

-- Show all columns for patients who have one of the following patient_ids: 
-- 1,45,534,879,1000
-- Solution:

SELECT * -- This is (*) in MySQL
FROM patients
WHERE patient_id IN (1, 45, 534, 879, 1000); 


-- NEW TABLE admissions:

-- Table Info
-- primary key icon	patient_id	INT
-- admission_date	DATE
-- discharge_date	DATE
-- diagnosis	TEXT
-- primary key icon	attending_doctor_id	INT


-- Show the total number of admissions
-- Solution:

SELECT 
COUNT(patient_id) as total_admissions
FROM admissions

-- Show all the columns from admissions where the patient was admitted and discharged on the same day.
-- Solution:

SELECT *
FROM admissions
WHERE 
JULIANDAY(admission_date) - JULIANDAY(discharge_date) = 0 -- MySQL equivalent is DATEDIFF()


-- Show the patient id and the total number of admissions for patient_id 579.
-- Solution:

SELECT
patient_id, 
COUNT(DISTINCT admission_date) as total_admissions
FROM admissions
WHERE patient_id = 579
;


-- Based on the cities that our patients live in, show unique cities that are in province_id 'NS'.
-- Solution:

SELECT 
DISTINCT(city) AS unique_cities 
FROM patients
WHERE province_id = 'NS'

-- Write a query to find the first_name, last name and birth date of patients who has height greater than 160 -- and weight greater than 70
-- Solution:

SELECT
first_name,
last_name,
birth_date
FROM patients
WHERE height > 160 AND weight > 70


-- Write a query to find list of patients first_name, last_name, and allergies where allergies are not null and -- are from the city of 'Hamilton'
-- Solution:

SELECT 
first_name,
last_name,
allergies
FROM patients
where allergies  IS NOT NULL and city = 'Hamilton'