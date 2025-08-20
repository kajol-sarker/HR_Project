CREATE DATABASE hr;

USE hr;

-- STOREDPROCEDURED
delimiter //
CREATE PROCEDURE dimensiontable()
BEGIN
        DROP TABLE IF EXISTS dim_employee;
        --  dim_employee
		CREATE TABLE dim_employee(
				employee_id INT PRIMARY KEY,
				employee_name VARCHAR(100) NOT NULL,
				age INT
				);
				
		INSERT INTO dim_employee(employee_id,employee_name,age)
		SELECT DISTINCT Employee_Id,Employee_name,Age
		FROM hr_analysis;


		--  dim_job
        DROP TABLE IF EXISTS dim_job;
		CREATE TABLE dim_job(
				job_id INT AUTO_INCREMENT PRIMARY KEY,
				job_role VARCHAR(100) NOT NULL
				);
				

		INSERT INTO dim_job(job_role)
		SELECT DISTINCT JobRole
		FROM hr_analysis;


		--  dim_department
        DROP TABLE IF EXISTS dim_department;
		CREATE TABLE dim_department(
				department_id INT AUTO_INCREMENT PRIMARY KEY,
				department_name VARCHAR(100) NOT NULL
				);
				

		INSERT INTO dim_department(department_name)
		SELECT DISTINCT Department
		FROM hr_analysis;


		--  dim_gender
        DROP TABLE IF EXISTS dim_gender;
		CREATE TABLE dim_gender(
				gender_id INT AUTO_INCREMENT PRIMARY KEY,
				gender  VARCHAR(100) NOT NULL
				);
				
		INSERT INTO dim_gender(gender)
		SELECT DISTINCT Gender
		FROM hr_analysis;



		--  dim_MaritalStatus
       DROP TABLE IF EXISTS dim_MaritalStatus;
		CREATE TABLE dim_MaritalStatus(
				Marital_Status_id INT AUTO_INCREMENT PRIMARY KEY,
				Marital_Status  VARCHAR(100) NOT NULL
				);
				

		INSERT INTO dim_MaritalStatus(Marital_Status)
		SELECT DISTINCT MaritalStatus
		FROM hr_analysis;

END //

delimiter ;

CALL dimensiontable();


-- fact table
delimiter //
CREATE PROCEDURE factTable()
BEGIN
			DROP TABLE IF EXISTS fact_employee;

			create table fact_employee(
			fact_id INT AUTO_INCREMENT PRIMARY KEY,
			employee_id INT,
			job_id INT,
			department_id INT,
			gender_id INT,
			Marital_Status_id INT,
			Attrition VARCHAR(20),
			Daily_Rate INT,
			Hourly_Rate INT,
			Monthly_Income INT,
			Monthly_Rate INT,
			Num_Companies_Worked INT,
			Percent_Salary_Hike INT,
			Total_Working_Years INT,
			Years_At_Company INT
			);
            
            
            INSERT INTO fact_employee(employee_id,job_id,department_id,gender_id,Marital_Status_id,Attrition,
                                       Daily_Rate,Hourly_Rate,Monthly_Income,Monthly_Rate,Num_Companies_Worked,
                                       Percent_Salary_Hike,Total_Working_Years,Years_At_Company
                                       )
                                       
	-- REMOVE DUPLICATES . CTE use
              WITH duplicatedata AS(
              SELECT *,
                     ROW_NUMBER() OVER (PARTITION BY Employee_Id, Employee_name, Age, Attrition, BusinessTravel, 
                     DailyRate, Department, Education, EducationField, Gender, HourlyRate, JobLevel, JobRole, 
                     MaritalStatus, MonthlyIncome, MonthlyRate, NumCompaniesWorked, OverTime, PercentSalaryHike, 
                     PerformanceRating, StockOptionLevel, TotalWorkingYears, TrainingTimesLastYear, YearsAtCompany, 
                     YearsInCurrentRole ORDER BY MonthlyIncome) AS rn
			  FROM hr_analysis
              ),
              -- CREATE ANOTHER CTE.
              filterdata AS (
                  SELECT * FROM duplicatedata
                  WHERE rn = 1)
                  
			SELECT 
                 e.employee_id,
				 j.job_id,
                 d.department_id,
                 g.gender_id,
                 m.Marital_Status_id,
                 h.Attrition,
				 h.DailyRate,
                 h.HourlyRate,
                 h.MonthlyIncome,
                 h.MonthlyRate,
                 h.NumCompaniesWorked,
                 h.PercentSalaryHike,
                 h.TotalWorkingYears,
                 h.YearsAtCompany
			FROM hr_analysis AS h                 -- Flat
            JOIN dim_employee AS e ON h.Employee_name = e.Employee_name
            JOIN dim_job as j ON h.JobRole = j.job_role
            JOIN dim_department AS d ON h.Department = d.department_name
            JOIN dim_gender AS g ON h.Gender =  g.gender
			JOIN dim_maritalstatus AS m ON h.MaritalStatus = m.Marital_Status;
end //

delimiter ;

call factTable();




-- Q1: Show all employees with their job roles.
SELECT
      e.employee_name,
      j.job_role
FROM dim_employee AS e
JOIN fact_employee AS f ON e.employee_id = f.employee_id
JOIN dim_job AS j ON f.job_id = j.job_id;


-- Q2. Show all employees with their job role and department.
SELECT
      e.employee_name,
      j.job_role,
      d.department_name
FROM dim_employee AS e
JOIN fact_employee AS f ON e.employee_id = f.employee_id
JOIN dim_job AS j ON f.job_id = j.job_id
JOIN dim_department AS d ON f.department_id = d.department_id;


-- Q3: Count number of employees in each department.
SELECT 
      d.department_name,
      COUNT(e.employee_id) AS total_employees
FROM dim_employee AS e
JOIN fact_employee AS f ON e.employee_id = f.employee_id
JOIN dim_department AS d ON f.department_id = d.department_id
GROUP BY d.department_name;


-- Q4: Count employees per department using CTE.
WITH departmentcount AS (
SELECT 
      d.department_name,
      COUNT(e.employee_id) AS total_employees
  FROM dim_employee AS e
  JOIN fact_employee AS f ON e.employee_id = f.employee_id
  JOIN dim_department AS d ON f.department_id = d.department_id
  GROUP BY d.department_name
 )
SELECT * FROM departmentcount
ORDER BY total_employees DESC;


-- Q5. Highest and lowest monthly income per department.
SELECT
      d.department_name,
      MAX(f.Monthly_Income) AS Highest,
      MIN(f.Monthly_Income) AS lowest
FROM dim_employee AS e
JOIN fact_employee AS f ON e.employee_id = f.employee_id
JOIN dim_department AS d ON f.department_id = d.department_id
GROUP BY d.department_name;


-- Q6: Find top 5 employees with highest monthly income.
select e.employee_name,
       f.Monthly_Income,
       j.job_role,
       d.department_name
FROM dim_employee AS e
JOIN fact_employee AS f ON e.employee_id = f.employee_id
JOIN dim_job AS j ON f.job_id = j.job_id
JOIN dim_department AS d ON f.department_id = d.department_id
ORDER BY f.Monthly_Income DESC
LIMIT 5;


-- Q7: Show average monthly income by department.
SELECT 
      d.department_name,
      AVG(f.Monthly_Income) AS avg_income
FROM dim_department AS d 
JOIN fact_employee AS f ON d.department_id = f.department_id
GROUP BY d.department_name;



-- Q8: List employees who have more than 5 years of total working experience.
SELECT 
      e.employee_name,
      f.Total_Working_Years,
      j.job_role
FROM dim_employee AS e
JOIN fact_employee AS f ON e.employee_id = f.employee_id
JOIN dim_job AS j ON f.job_id = j.job_id
WHERE f.Total_Working_Years > 5;


-- Q9: Show all employees with monthly income > 10000 using CTE.
WITH highincome AS (
     SELECT e.employee_name,
			f.Monthly_Income
     FROM dim_employee AS e
     JOIN fact_employee AS f ON e.employee_id = f.employee_id
)
SELECT * FROM highincome
WHERE Monthly_Income> 10000;



-- Q10: Rank employees by monthly income within each department.
select 
      e.employee_name,
      d.department_name,
	  f.Monthly_Income,
      RANK() OVER(PARTITION BY d.department_name ORDER BY f.Monthly_Income DESC) AS income_rank
FROM dim_employee AS e
JOIN fact_employee AS f ON e.employee_id = f.employee_id
JOIN dim_department AS d ON f.department_id = d.department_id;



-- Q11: Show top 3 earners in each department using row number.
WITH rankedemployee AS (
SELECT e.employee_name,
       d.department_name,
	   f.Monthly_Income,
       ROW_NUMBER() OVER(PARTITION BY d.department_name ORDER BY f.Monthly_Income DESC) AS rn
FROM dim_employee AS e
JOIN fact_employee AS f ON e.employee_id = f.employee_id
JOIN dim_department AS d ON f.department_id = d.department_id
)
SELECT * FROM rankedemployee
WHERE rn <= 3;



-- Q12: Show top 3 earners in each department using rank.
WITH rankedemployee AS (
SELECT e.employee_name,
       d.department_name,
	   f.Monthly_Income,
       RANK() OVER (PARTITION BY d.department_name ORDER BY f.Monthly_Income DESC) AS rn
FROM dim_employee AS e
JOIN fact_employee AS f ON e.employee_id = f.employee_id
JOIN dim_department AS d ON f.department_id = d.department_id
)
SELECT * FROM rankedemployee
WHERE rn <= 3;


-- Q13: Show total and average monthly income by job role.
SELECT j.job_role,
       SUM(f.Monthly_Income) AS total_income,
       AVG(f.Monthly_Income) AS avg_income
FROM dim_job AS j
JOIN fact_employee AS f ON j.job_id = f.job_id
GROUP BY j.job_role;



-- Q14: Count employees in each labeled age group (e.g., <30, 30-40, >40)
SELECT
     CASE
         WHEN age<30 THEN 'Junior'
         WHEN age BETWEEN 30 AND 40 THEN 'Mid_level'
         ELSE 'Senior'
	END AS employees_level,
    count(employee_id) AS Num_employees
FROM dim_employee
GROUP BY employees_level
ORDER BY Num_employees DESC;






	