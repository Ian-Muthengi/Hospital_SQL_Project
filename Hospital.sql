-- creating database
create database hospital;

-- selecting the database
use hospital;

-- creating table 1
create table patients
(patient_id INT PRIMARY KEY,
first_name VARCHAR(30),
last_name VARCHAR(30),
gender CHAR(1),
birth_date DATE,
city VARCHAR(30),
province_id CHAR(2),
allergies VARCHAR(80),
height DECIMAL(3,0),
weight DECIMAL(4,0));

-- ADDING FOREING KEYS
ALTER TABLE patients
ADD CONSTRAINT fk_province_id_1 
FOREIGN KEY (province_id) REFERENCES province_name(province_id);

-- deleting data without deleting the column heads
truncate table patients;

-- deleting the whole table
drop table patients;

-- LOADING DATA INTO TABLE 1
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\patients.csv"
INTO TABLE patients
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@patient_id, @first_name, @last_name, @gender, @birth_date, @city, province_id, @allergies,
@height, @weight)
SET
patient_id = @patient_id,
first_name = NULLIF(@first_name, ''),
last_name = NULLIF(@last_name, ''),
gender = NULLIF(@gender, ''),
birth_date = NULLIF(@birth_date, ''),
city = NULLIF(@city, ''),
province_id = NULLIF(@province_id, ''),
allergies = NULLIF(@allergies, ''),
height = NULLIF(@height, ''),
weight = NULLIF(@weight '');

-- creating table 2
create table doctors
(doctor_id INT PRIMARY KEY,
first_name VARCHAR(30),
last_name VARCHAR(30),
speciality VARCHAR(25));

-- LOADING DATA INTO TABLE 2
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\doctors.csv"
INTO TABLE doctors
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@doctor_id, @first_name, @last_name, @speciality)
SET
doctor_id = @doctor_id,
first_name = NULLIF(@first_name, ''),
last_name = NULLIF(@last_name, ''),
speciality = NULLIF(@speciality, '');

-- creating table 3
create table admissions
(patient_id INT,
admission_date DATE,
discharge_date DATE,
diagnosis VARCHAR(50),
attending_doctor_id INT,
FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
FOREIGN KEY (attending_doctor_id) REFERENCES doctors(doctor_id));

-- LOADING DATA INTO TABLE 3
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\admissions.csv"
INTO TABLE admissions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@patient_id, @admission_date, @discharge_date, @diagnosis, @attending_doctor_id)
SET
patient_id = NULLIF(@patient_id, ''),
admission_date = NULLIF(@admission_date, ''),
discharge_date = NULLIF(@discharge_date, ''),
diagnosis = NULLIF(@diagnosis, ''),
attending_doctor_id = NULLIF(@attending_doctor_id '');

-- creating table 4
create table province_names
(province_id CHAR(2) PRIMARY KEY,
province_name VARCHAR(30));

-- LOADING DATA INTO TABLE 4
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\province_names.csv"
INTO TABLE province_names
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@province_id, @province_name)
SET
province_id = @province_id,
province_name = NULLIF(@province_name, '');

 -- first name, last name, and gender of patients whose gender is 'M'
SELECT first_name, last_name, gender
FROM patients
WHERE gender = 'M';

-- first name, last name, and the full province name of each patient
SELECT first_name, last_name, province_name
FROM patients
JOIN province_names ON province_names.province_id = patients.province_id;

-- patients with a birth_date with 2010 as the birth year
SELECT COUNT(*) AS total_patients
FROM patients
WHERE YEAR(birth_date) = 2010;

-- first name and last name of patients who does not have allergies
SELECT first_name, last_name
FROM patients
WHERE allergies IS NULL;

-- first name of patients that start with the letter 'C'
SELECT first_name
FROM patients
WHERE first_name LIKE 'C%';

-- first name and last name concatinated into one column to show their full name
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM patients;

-- the first_name, last_name, and height of the patient with the greatest height.
SELECT first_name, last_name, MAX(height) AS height
FROM patients;

-- columns for patients who have one of the following patient_ids: 1,45,534,879,1000
SELECT *
FROM patients
WHERE patient_id IN (1, 45, 534, 879, 1000);

-- total number of admissions
SELECT COUNT(*) AS total_admissions
FROM admissions;

-- columns from admissions where the patient was admitted and discharged on the same day.
SELECT *
FROM admissions
WHERE admission_date = discharge_date;

-- patient id and the total number of admissions for patient_id 579.
SELECT patient_id, COUNT(*) AS total_admissions
FROM admissions
WHERE patient_id = 579;

-- unique cities that are in province_id 'NS'
SELECT DISTINCT(city) AS unique_cities
FROM patients
WHERE province_id = 'NS';

-- first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70
SELECT first_name, last_name, birth_date
FROM patients
WHERE height > 160 AND weight > 70;

--  patient`s first_name, last_name, and allergies where allergies are not null and are from the city of 'Hamilton'
SELECT first_name, last_name, allergies
FROM patients
WHERE city = 'Hamilton'
and allergies is not null;

-- unique birth years from patients and order them by ascending
SELECT DISTINCT YEAR(birth_date) AS birth_year
FROM patients
ORDER BY birth_year;

-- first names from the patients table which only occurs once in the list
SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(first_name) = 1;

-- patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE 's____%s';

-- patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'
SELECT patients.patient_id, first_name, last_name
FROM patients
JOIN admissions ON admissions.patient_id = patients.patient_id
WHERE diagnosis = 'Dementia';

-- every patient's first_name.Ordered by the length of each name and then by alphabetically
SELECT first_name
FROM patients
order by
  len(first_name), first_name;

-- total number of male patients and the total number of female patients in the patients table and display the two results in the same row
SELECT SUM(Gender = 'M') as male_count, SUM(Gender = 'F') AS female_count
FROM patients;

-- first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name
SELECT first_name, last_name, allergies
FROM patients
WHERE
  allergies IN ('Penicillin', 'Morphine')
ORDER BY  allergies, first_name, last_name;

-- patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis
SELECT patient_id, diagnosis
FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1;

-- first name, last name and role of every person that is either patient or doctor
SELECT first_name, last_name, 'Patient' as role FROM patients
union all
SELECT first_name, last_name, 'Doctor' from doctors;

-- patient's first_name, last_name, and birth_date who were born in the 1970s decade, Sorting the list starting from the earliest birth_date.
SELECT first_name, last_name, birth_date
FROM patients
WHERE
YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;

-- patient's full name in a single column. Their last_name in all upper case will appear first, then first_name in all lower case letters. last_name and first_name are separated with a comma. list orderd by the first_name in decending order
SELECT CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS new_name_format
FROM patients
ORDER BY first_name DESC;

-- province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000
SELECT province_id, SUM(height) AS sum_height
FROM patients
GROUP BY province_id
HAVING sum_height >= 7000;

-- difference between the largest weight and smallest weight for patients with the last name 'Maroni'
SELECT (MAX(weight) - MIN(weight)) AS weight_delta
FROM patients
WHERE last_name = 'Maroni';

-- days of the month (1-31) and how many admission_dates occurred on that day. Sorted by the day with most admissions to least admissions
SELECT DAY(admission_date) AS day_number, COUNT(*) AS number_of_admissions
FROM admissions
GROUP BY day_number
ORDER BY number_of_admissions DESC;

-- columns for patient_id 542's most recent admission_date
SELECT *
FROM admissions
WHERE patient_id = 542
GROUP BY patient_id
HAVING admission_date = MAX(admission_date);

/* patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19
2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters */
SELECT patient_id, attending_doctor_id, diagnosis
FROM admissions
WHERE (attending_doctor_id IN (1, 5, 19)
    AND patient_id % 2 != 0)
  OR (attending_doctor_id LIKE '%2%'
    AND len(patient_id) = 3);

-- first_name, last_name, and the total number of admissions attended for each doctor
SELECT first_name, last_name, count(*) as admissions_total
from admissions a
join doctors ph on ph.doctor_id = a.attending_doctor_id
group by attending_doctor_id;

-- doctor`s id, full name, and the first and last admission date they attended.
select doctor_id, first_name || ' ' || last_name as full_name,
min(admission_date) as first_admission_date, max(admission_date) as last_admission_date
from admissions a
join doctors ph on a.attending_doctor_id = ph.doctor_id
group by doctor_id;

-- total number of patients for each province. Ordered by descending
SELECT province_name, COUNT(*) as patient_count
FROM patients pa
join province_names pr on pr.province_id = pa.province_id
group by pr.province_id
order by patient_count desc;

-- patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
SELECT CONCAT(patients.first_name, ' ', patients.last_name) as patient_name, diagnosis,
  CONCAT(doctors.first_name,' ',doctors.last_name) as doctor_name
FROM patients
JOIN admissions ON admissions.patient_id = patients.patient_id
JOIN doctors ON doctors.doctor_id = admissions.attending_doctor_id;

-- first name, last name and number of duplicate patients based on their first name and last name
select first_name, last_name, count(*) as num_of_duplicates
from patients
group by first_name, last_name
having count(*) > 1;

/*patient's full name, height in the units feet rounded to 1 decimal,weight in the unit pounds rounded to 0 decimals,
birth_date, gender non abbreviated.
CM Converted to feet by dividing by 30.48.
KG Converted to pounds by multiplying by 2.205.*/
select concat(first_name, ' ', last_name) AS 'patient_name', 
ROUND(height / 30.48, 1) as 'height "Feet"', 
ROUND(weight * 2.205, 0) AS 'weight "Pounds"', birth_date,
CASE 
  WHEN gender = 'M' THEN 'MALE' 
  ELSE 'FEMALE' 
END AS 'gender_type'
from patients;

-- patient_id does not exist in any admissions.patient_id rows
SELECT patients.patient_id, first_name, last_name
FROM patients
  LEFT JOIN admissions ON patients.patient_id = admissions.patient_id
WHERE admissions.patient_id is NULL;

-- patients grouped into weight groups, total number of patients in each weight group, Ordered by the weight group in decending order
SELECT COUNT(*) AS patients_in_group, FLOOR(weight / 10) * 10 AS weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;

/* patient_id, weight, height, isObese from the patients table 
IsObese is display  as a boolean 0 or 1.
Obese is defined as weight(kg)/(height(m)2) >= 30.
weight is in units kg.
height is in units cm.*/
SELECT patient_id, weight, height, 
  (CASE 
      WHEN weight/(POWER(height/100.0,2)) >= 30 THEN 1
      ELSE 0 END) AS isObese
FROM patients;

--  patient_id, first_name, last_name, and attending doctor's specialty. patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa' is displayed
SELECT p.patient_id, p.first_name AS patient_first_name, p.last_name AS patient_last_name,
  ph.specialty AS attending_doctor_specialty
FROM patients p
  JOIN admissions a ON a.patient_id = p.patient_id
  JOIN doctors ph ON ph.doctor_id = a.attending_doctor_id
WHERE ph.first_name = 'Lisa' and a.diagnosis = 'Epilepsy';

/*patient_id and temp_password. The password is in the following order:
1. patient_id
2. the numerical length of patient's last_name
3. year of patient's birth_date*/
SELECT  DISTINCT P.patient_id,
  CONCAT( P.patient_id, LEN(last_name), YEAR(birth_date)) AS temp_password
FROM patients P
JOIN admissions A ON A.patient_id = P.patient_id;

/*Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.
Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.*/
select 'No' as has_insurance, count(*) * 50 as cost
from admissions where patient_id % 2 = 1 group by has_insurance
union
select 'Yes' as has_insurance, count(*) * 10 as cost
from admissions where patient_id % 2 = 0 group by has_insurance;

-- provinces that has more patients identified as 'M' than 'F'
SELECT pr.province_name
FROM patients AS pa
JOIN province_names AS pr ON pa.province_id = pr.province_id
GROUP BY pr.province_name
HAVING SUM(gender = 'M') > SUM(gender = 'F');

/* First_name contains an 'r' after the first two letters.
Identifies their gender as 'F'
Born in February, May, or December
weight would be between 60kg and 80kg
patient_id is an odd number
They are from the city 'Kingston'*/
SELECT *
FROM patients
WHERE first_name LIKE '__r%'
  AND gender = 'F'
  AND MONTH(birth_date) IN (2, 5, 12)
  AND weight BETWEEN 60 AND 80
  AND patient_id % 2 = 1
  AND city = 'Kingston';

-- percentage of patients that have 'M' as their gender rounded off nearest hundreth number and in percent form
SELECT CONCAT(ROUND((SELECT COUNT(*)
     FROM patients
     WHERE gender = 'M') / CAST(COUNT(*) as float), 4) * 100, '%') as percent_of_male_patients
FROM patients;

-- total number of admissions on a day and the amount change  from the previous date.
SELECT admission_date, count(admission_date) as admission_day,
 count(admission_date) - LAG(count(admission_date)) OVER(ORDER BY admission_date) AS admission_count_change 
FROM admissions
group by admission_date;

-- province names sorted in ascending order in and the province 'Ontario' is always on top.
select province_name
from province_names
order by
(case when province_name = 'Ontario' then 0 else 1 end),
  province_name;
  
   -- total amount of admissions each doctor has started each year. Showing the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.
  SELECT d.doctor_id as doctor_id, CONCAT(d.first_name,' ', d.last_name) as doctor_name,
  d.specialty, YEAR(a.admission_date) as selected_year, COUNT(*) as total_admissions
FROM doctors as d
  LEFT JOIN admissions as a ON d.doctor_id = a.attending_doctor_id
GROUP BY doctor_name, selected_year
ORDER BY doctor_id, selected_year;

-- deleting database
drop database hospital;