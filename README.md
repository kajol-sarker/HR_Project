# HR_Project


<h1>Project Requirements:</h1>
<h3>1.Source Data</h3>><br>
•	We are given a flat table named hr_analyst containing 1470 employee records.<br>
•	The table includes various employee-related information such as demographics (age, gender, education), job details (job role, department), salary and rate information, and work history.<br>
<h3>2.Normalization & Data Warehouse Design</h3><br>
•	The flat table contains redundancy and duplicate values (e.g., job roles, departments, education fields appear multiple times).<br>
•	To optimize query performance and reduce redundancy, the data needs to be normalized.<br>
•	We will implement a Star Schema by creating multiple Dimension Tables and one Fact Table.<br>
<h3>3.Dimension Tables</h3>
•	Dimension tables will store descriptive attributes (e.g., employee info, job details, education, demographics).<br>
•	Each dimension will have a primary key that links to the fact table.
<h3>4.Fact Table</h3> 
•	The fact table (fact_employee) will contain measurable and quantitative data (e.g., salary, rates, years of experience).<br>
•	It will also contain foreign keys referencing the dimension tables.<br>
<h3>5.ETL Process</h3>
•	Extract: Source data from the flat hr_analyst table.<br>
•	Transform: Remove duplicates using ROW_NUMBER().<br>
•	Load: Insert clean data into Fact and Dimension tables.<br>
 <h3>6.Objective</h3>
•	To create a clean HR Data Warehouse model.<br>
•	To answer HR-related analytical questions using SQL queries, CTEs, and Window Functions.<br>

<h1>Questions:</h1>
Q1: Show all employees with their job roles. <br>
Q2. Show all employees with their job role and department.<br>
Q3: Count number of employees in each department.<br>
Q4: Count employees per department using CTE.<br>
Q5. Highest and lowest monthly income per department.<br>
Q6: Find top 5 employees with highest monthly income.<br>
Q7: Show average monthly income by department.<br>
Q8: List employees who have more than 5 years of total working experience.<br>
Q9: Show all employees with monthly income > 10000 using CTE.<br>
Q10: Rank employees by monthly income within each department.<br>
Q11: Show top 3 earners in each department using row number.<br>
Q12: Show top 3 earners in each department using rank.<br>
Q13: Show total and average monthly income by job role.<br>
Q14: Count employees in each labeled age group (e.g., <30, 30-40, >40)<br>
