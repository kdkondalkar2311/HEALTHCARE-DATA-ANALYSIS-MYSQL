SELECT * FROM healthcare;
-- Q1 The names in the system are messy (mixed case). Standardize all names to Uppercase and remove extra spaces?.
SELECT UPPER(TRIM(Name)) AS Cleaned_Name FROM Healthcare;

-- Q2 Calculate how many days each patient stayed in the hospital?
SELECT name, DATEDIFF(AdmissionDate,DischargeDate) as day_stay from healthcare;

-- Q3 Find patients who were billed more than the average billing amount?
select avg(BillingAmount) FROM HEALTHCARE;
SELECT NAME, BillingAmount from healthcare 
WHERE BillingAmount > (select avg(BillingAmount) FROM HEALTHCARE);

-- Q4 Create a column 'Age_Group': Under 30 as 'Young', 30-60 as 'Adult', 60+ as 'Senior'?
SELECT NAME, AGE,
CASE 
	WHEN AGE<30 THEN "YOUNG"
    WHEN AGE BETWEEN 30 AND 60 THEN "ADULT"
    ELSE "OLD" END AS AGE_GROUP
FROM HEALTHCARE;

-- Q5 Which insurance provider has the highest total billing?
SELECT insurance, SUM(BillingAmount) AS total_revenue
 from healthcare
 group by insurance
 order by total_revenue DESC;
 
 -- Q6 Count how many unique patients each doctor has handled?
 SELECT DOCTOR, COUNT(distinct Name) as patient_count
 from healthcare
 group by doctor;
 
 -- Q7 What percentage of admissions are 'Emergency'?
 SELECT AdmissionType, 
COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HEALTHCARE) as percentage 
 from healthcare
 where AdmissionType="emergency" 
GROUP BY admissiontype;

-- Q8 List patients with 'Abnormal' test results who were admitted as 'Urgent'?
SELECT NAME , ADMISSIONTYPE,TESTRESULTS 
FROM HEALTHCARE 
WHERE AdmissionType="URGENT" AND TestResults="ABNORMAL";

-- Q9 Which month had the highest number of admissions?
SELECT MONTH(ADMISSIONDATE), COUNT(*) AS ADMISSION
FROM healthcare
GROUP BY MONTH(ADMISSIONDATE)
ORDER BY ADMISSION DESC 
LIMIT 1; --> 726

-- Q10 Find the most commonly prescribed medication for 'Obesity'?
SELECT MEDICATION, COUNT(*) AS FREQUENCY
FROM HEALTHCARE 
WHERE HEALTH_CONDITION ="OBESITY"
ORDER BY FREQUENCY DESC; --> IBUPROFEN

-- Q11 Create a View for the Finance team showing only Name, Insurance, and Billing?
 CREATE VIEW Finance_View AS
SELECT Name, Insurance, BillingAmount FROM Healthcare;

-- 	Q12 If Room Number is missing, show it as '999'?
SELECT Name, COALESCE(RoomNumber, 999) FROM Healthcare;

-- Q13 Use a Window Function to rank patients by billing amount?
SELECT NAME, BILLINGAMOUNT, 
RANK() OVER(ORDER BY BILLINGAMOUNT DESC) AS BILLING_RANK
FROM HEALTHCARE;

-- Q14 Which hospital has the lowest average billing (most affordable)?
SELECT HOSPITAL, AVG(BILLINGAMOUNT) AS AVG_BILL
FROM HEALTHCARE 
GROUP BY HOSPITAL
ORDER BY AVG_BILL ASC;

-- Q15 Find all doctors whose names start with 'S'?
SELECT distinct doctor FROM healthcare
WHERE DOCTOR LIKE "S%";

-- 	Q16 Use a CTE to find patients who stayed longer than 7 days and were treated for 'Cancer'?
WITH LongStays AS (
    SELECT Name, HEALTH_Condition, DATEDIFF(DischargeDate,  AdmissionDate) as Duration
    FROM Healthcare
)
SELECT * FROM LongStays WHERE Duration > 7 AND HEALTH_Condition = 'Cancer';

-- Q17 Standardize 'B-' to 'B Negative' in the Blood Type column?
SET SQL_SAFE_UPDATES = 0;
UPDATE HEALTHCARE SET BLOODTYPE="B NEGATIVE" 
WHERE BLOODTYPE ="B-";

-- Q18 Find the total billing for 'Male' patients with 'Diabetes'.
SELECT SUM(BILLINGAMOUNT) FROM healthcare
WHERE GENDER="MALE" AND HEALTH_CONDITION="DIABETES";

-- Q19 Find any records where the Discharge Date is before the Admission Date (Error Checking).
SELECT * FROM HEALTHCARE 
WHERE DischargeDate < admissiondate;

-- Q20 Create a procedure where I can type a Doctor's name and see all their patients.
call getdocpatients("abc");
SELECT * FROM HEALTHCARE  where doctor ="abc";


