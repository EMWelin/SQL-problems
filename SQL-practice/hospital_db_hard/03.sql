-- https://www.sql-practice.com/

-- Hard problems from the Hospital problem set.

/* 
Show patient_id, first_name, last_name, and attending doctor's specialty.
Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'

Check patients, admissions, and doctors tables for required information.

*/

-- This problem should probably have been graded 'Medium' difficulty.

SELECT 
p.patient_id,
p.first_name AS patient_first_name,
p.last_name AS patient_last_name,
d.specialty AS attending_doctor_specialty
FROm patients p
JOIN admissions a 
on p.patient_id = a.patient_id
JOIN doctors d 
ON a.attending_doctor_id = d.doctor_id
WHERE 
d.first_name = 'Lisa'
AND a.diagnosis = 'Epilepsy'
