# 🏥 Hospital Management Data Analysis Project

### Phase 1 : database

//sql
CREATE TABLE Healthcare (
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    BloodType VARCHAR(5),
    Condition VARCHAR(50),
    AdmissionDate DATE,
    Doctor VARCHAR(100),
    Hospital VARCHAR(100),
    Insurance VARCHAR(50),
    BillingAmount DECIMAL(15,2),
    RoomNumber INT,
    AdmissionType VARCHAR(20),
    DischargeDate DATE,
    Medication VARCHAR(50),
    TestResults VARCHAR(20)
);
sql//
______________________________________
### Phase 2: 20 Professional Interview Questions & Solutions
1. The Name Fixer (Cleaning)
Q: The names in the system are messy (mixed case). Standardize all names to Uppercase and remove extra spaces.
SQL
SELECT UPPER(TRIM(Name)) AS Cleaned_Name FROM Healthcare;
•	Explanation: TRIM removes accidental spaces, and UPPER ensures the data looks professional for reporting.

2. Patient Stay Duration
Q: Calculate how many days each patient stayed in the hospital.
SQL
SELECT Name, DATEDIFF(day, AdmissionDate, DischargeDate) AS Days_Stayed 
FROM Healthcare;
•	Explanation: DATEDIFF is the industry standard for calculating intervals between events.

3. High-Value Billing
Q: Find patients who were billed more than the average billing amount.
SQL
SELECT Name, BillingAmount FROM Healthcare 
WHERE BillingAmount > (SELECT AVG(BillingAmount) FROM Healthcare);
•	Explanation: This uses a Subquery to find the threshold first, then filters the list.

4. Conditional Reporting (CASE)
Q: Create a column 'Age_Group': Under 30 as 'Young', 30-60 as 'Adult', 60+ as 'Senior'.
SQL
SELECT Name, Age,
CASE 
    WHEN Age < 30 THEN 'Young'
    WHEN Age BETWEEN 30 AND 60 THEN 'Adult'
    ELSE 'Senior'
END AS Age_Group
FROM Healthcare;
•	Explanation: CASE statements are vital for "Bucketing" data for marketing or medical research.

5. Insurance Market Share
Q: Which insurance provider has the highest total billing?
SQL
SELECT Insurance, SUM(BillingAmount) as Total_Revenue
FROM Healthcare
GROUP BY Insurance
ORDER BY Total_Revenue DESC;

6. Doctor Load Analysis
Q: Count how many unique patients each doctor has handled.
SQL
SELECT Doctor, COUNT(DISTINCT Name) as Patient_Count
FROM Healthcare
GROUP BY Doctor;
•	Explanation: COUNT(DISTINCT) ensures we don't count the same person twice if they visited the same doctor twice.

7. Admission Type Breakdown
Q: What percentage of admissions are 'Emergency'?
SQL
SELECT AdmissionType, 
(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Healthcare)) as Percentage
FROM Healthcare
GROUP BY AdmissionType;

8. Finding Abnormal Results
Q: List patients with 'Abnormal' test results who were admitted as 'Urgent'.
SQL
SELECT Name, Condition, TestResults 
FROM Healthcare 
WHERE TestResults = 'Abnormal' AND AdmissionType = 'Urgent';

9. Monthly Admission Trends
Q: Which month had the highest number of admissions?
SQL
SELECT MONTH(AdmissionDate) as Month_Num, COUNT(*) as Admissions
FROM Healthcare
GROUP BY MONTH(AdmissionDate)
ORDER BY Admissions DESC;

10. Medication Popularity
Q: Find the most commonly prescribed medication for 'Obesity'.
SQL
SELECT Medication, COUNT(*) as Frequency
FROM Healthcare
WHERE Condition = 'Obesity'
GROUP BY Medication
ORDER BY Frequency DESC;

11. Creating a Permanent View
Q: Create a View for the Finance team showing only Name, Insurance, and Billing.
SQL
CREATE VIEW Finance_View AS
SELECT Name, Insurance, BillingAmount FROM Healthcare;

12. Handling Nulls (Safety)
Q: If Room Number is missing, show it as '999'.
SQL
SELECT Name, COALESCE(RoomNumber, 999) FROM Healthcare;

13. Top 3 Expensive Patients (Ranking)
Q: Use a Window Function to rank patients by billing amount.
SQL
SELECT Name, BillingAmount,
RANK() OVER(ORDER BY BillingAmount DESC) as Billing_Rank
FROM Healthcare;

14. Hospital Performance
Q: Which hospital has the lowest average billing (most affordable)?
SQL
SELECT Hospital, AVG(BillingAmount) as Avg_Bill
FROM Healthcare
GROUP BY Hospital
ORDER BY Avg_Bill ASC;

15. Complex Filtering (LIKE)
Q: Find all doctors whose names start with 'S'.
SQL
SELECT DISTINCT Doctor FROM Healthcare WHERE Doctor LIKE 'S%';

16. Patient Loyalty (CTE)
Q: Use a CTE to find patients who stayed longer than 7 days and were treated for 'Cancer'.
SQL
WITH LongStays AS (
    SELECT Name, Condition, DATEDIFF(day, AdmissionDate, DischargeDate) as Duration
    FROM Healthcare
)
SELECT * FROM LongStays WHERE Duration > 7 AND Condition = 'Cancer';

17. Updating Messy Data
Q: Standardize 'B-' to 'B Negative' in the Blood Type column.
SQL
UPDATE Healthcare SET BloodType = 'B Negative' WHERE BloodType = 'B-';

18. Multi-Condition Aggregation
Q: Find the total billing for 'Male' patients with 'Diabetes'.
SQL
SELECT SUM(BillingAmount) FROM Healthcare 
WHERE Gender = 'Male' AND Condition = 'Diabetes';

19. Data Validation
Q: Find any records where the Discharge Date is before the Admission Date (Error Checking).
SQL
SELECT * FROM Healthcare WHERE DischargeDate < AdmissionDate;

20. Stored Procedure for Search
Q: Create a procedure where I can type a Doctor's name and see all their patients.
SQL
CREATE PROCEDURE GetDocPatients @DocName VARCHAR(100)
AS
BEGIN
    SELECT Name, Condition, AdmissionDate FROM Healthcare WHERE Doctor = @DocName;
END;
________________________________________
