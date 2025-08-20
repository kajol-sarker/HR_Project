# HR_Project


Project Requirements:
1.	Source Data
•	We are given a flat table named hr_analyst containing 1470 employee records.
•	The table includes various employee-related information such as demographics (age, gender, education), job details (job role, department), salary and rate information, and work history.
2.	Normalization & Data Warehouse Design
•	The flat table contains redundancy and duplicate values (e.g., job roles, departments, education fields appear multiple times).
•	To optimize query performance and reduce redundancy, the data needs to be normalized.
•	We will implement a Star Schema by creating multiple Dimension Tables and one Fact Table.
3.	Dimension Tables
•	Dimension tables will store descriptive attributes (e.g., employee info, job details, education, demographics).
•	Each dimension will have a primary key that links to the fact table.
4.	Fact Table
•	The fact table (fact_employee) will contain measurable and quantitative data (e.g., salary, rates, years of experience).
•	It will also contain foreign keys referencing the dimension tables.
5.	ETL Process
•	Extract: Source data from the flat hr_analyst table.
•	Transform: Remove duplicates using ROW_NUMBER().
•	Load: Insert clean data into Fact and Dimension tables.
6.	Objective
•	To create a clean HR Data Warehouse model.
•	To answer HR-related analytical questions using SQL queries, CTEs, and Window Functions.
Questions:
Q1: Show all employees with their job roles.
Q2. Show all employees with their job role and department.
Q3: Count number of employees in each department.
Q4: Count employees per department using CTE.
Q5. Highest and lowest monthly income per department.
Q6: Find top 5 employees with highest monthly income.
Q7: Show average monthly income by department.
Q8: List employees who have more than 5 years of total working experience.
Q9: Show all employees with monthly income > 10000 using CTE.
Q10: Rank employees by monthly income within each department.
Q11: Show top 3 earners in each department using row number.
Q12: Show top 3 earners in each department using rank.
Q13: Show total and average monthly income by job role.
Q14: Count employees in each labeled age group (e.g., <30, 30-40, >40)
