IF NOT EXISTS (SELECT NAME FROM sys.databases where name = 'case_when_db')
BEGIN
    create DATABASE case_when_db
END
ELSE
BEGIN
    PRINT 'ALREADY EXISTS'
END

SELECT NAME FROM sys.databases

USE case_when_db
---create table

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    JoinDate DATE,
    PerformanceRating INT
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    EmployeeID INT,
    Amount DECIMAL(10,2),
    SaleDate DATE,
    Region VARCHAR(50),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

INSERT INTO Employees VALUES 
(1, 'John Doe', 'Engineering', 75000, '2020-01-15', 8),
(2, 'Jane Smith', 'Marketing', 68000, '2019-05-22', 6),
(3, 'Alice Lee', 'Engineering', 92000, '2018-11-30', 9),
(4, 'Bob Brown', 'Sales', 55000, '2021-02-10', 5),
(5, 'Charlie Kim', 'HR', 62000, '2020-07-05', 7);

INSERT INTO Sales VALUES
(101, 4, 15000, '2023-01-10', 'West'),
(102, 4, 22000, '2023-01-25', 'East'),
(103, 2, 8000, '2023-02-05', 'North'),
(104, 1, 12000, '2023-02-18', 'South'),
(105, 3, 25000, '2023-03-01', 'West');


---Categorize employees into 'High', 'Medium', or 'Low' salary bands (e.g., >80k, 60-80k, <60k)
select * from Employees

SELECT *, case when Salary is NULL then 'missing'
               when Salary < 60000 then '<60k'
               when Salary BETWEEN 60000 AND 80000 then '60-80 K'
               ELSE '>80 K' END AS 'Salary_catg'
from Employees

---Label sales transactions as 'High Value' (≥20k), 'Medium Value' (10k-20k), or 'Low Value' (<10k)
SELECT * FROM Sales

SELECT *, case when Amount is NULL then 'missing'
               when Amount < 10000 then 'Low Value'
               when Amount BETWEEN 10000 AND 20000 then '10-20 K'
               ELSE '>20 K' END AS 'Trans_catg'
from Sales

--Classify employees based on tenure: 'Veteran' (>3 years), 'Experienced' (1-3 years), 'New Hire' (<1 year).
select * from Employees

INSERT INTO Employees VALUES 
(6, 'Rach', 'Engineering', 75000, '2024-01-15', 8),
(7, 'Ross', 'Marketing', 68000, '2025-04-22', 6)

SELECT *,DATEDIFF(YEAR, JoinDate, GETDATE())  as 'tenure_yrs'
,case when DATEDIFF(YEAR, JoinDate, GETDATE()) is NULL then 'missing'
               when DATEDIFF(YEAR, JoinDate, GETDATE()) < 1 then 'New hire'
               when DATEDIFF(YEAR, JoinDate, GETDATE()) BETWEEN 1 AND 3 then 'Experienced'
               ELSE 'Veteran' END AS 'Emp_Tenure_catg'
from Employees

--Create a performance tier: 'Top Performer' (Rating ≥8), 'Average' (5-7), 'Needs Improvement' (<5)
SELECT *
,case when PerformanceRating is NULL then 'missing'
               when PerformanceRating < 5 then 'Needs Improvement'
               when PerformanceRating BETWEEN 5 AND 7 then 'Average'
               ELSE 'Top Performer' END AS 'Rating_Tier'
from Employees

----ADVANCED LEVEL
--For each region, generate a report showing:
----Total sales
----A column labeled 'Performance' that displays 'Target Met' if sales >50k, else 'Target Missed'.

SELECT * FROM Sales;

WITH TOTAL_SAL AS (SELECT Region , SUM(Amount) as amt from Sales Group by Region  )
select *, CASE When amt is null then 'Cant Determine'
               WHEN amt > 50000 THEN 'Target Met' 
               Else 'Target Missed' END AS 'Performance'

from  TOTAL_SAL;

--Flags employees as 'Eligible for Bonus' if they're in Sales/Engineering AND have a PerformanceRating ≥7.
--Otherwise, mark as 'Not Eligible'.

Select * from Employees
Select *, CASE WHEN Department in ('Sales', 'Engineering') and PerformanceRating >= 7
                    THEN 'Eligible for Bonus' ELSE 'Not Eligible' END AS 'Bonus'

 from Employees

 ---Create a dynamic fiscal quarter label (Q1-Q4) based on SaleDate, with an additional 'Year-End' tag for December sales.
select * FROM Sales

INSERT INTO Sales VALUES
(106, 4, 15000, '2023-04-10', 'East'),
(107, 4, 15000, '2023-07-10', 'West'),
(108, 4, 15000, '2023-11-10', 'West'),
(109, 4, 15000, '2023-12-10', 'North')

select *, CASE WHEN MONTH(SaleDate) BETWEEN 1 AND 3 THEN 'Q1' 
               WHEN MONTH(SaleDate) BETWEEN 4 AND 6 THEN 'Q2' 
               WHEN MONTH(SaleDate) BETWEEN 7 AND 9 THEN 'Q3'
               WHEN MONTH(SaleDate) BETWEEN 10 AND 11 THEN 'Q4' 
               WHEN MONTH(SaleDate) = 12 THEN 'Q4-Year-End'
               else 'missing' end 'Fiscal Flag'

From Sales ;

----HARD
--Categorize sales as:
--'Platinum' if Amount ≥20k AND Region is 'West/East'
--'Gold' if Amount ≥15k Silver' for all others.

WITH TOTAL_SAL AS (SELECT Region , SUM(Amount) as amt from Sales Group by Region  )
select *, CASE When amt is null then 'Cant Determine'
               WHEN amt >= 20000  AND Region in ('West','East') THEN 'Platinum' 
               WHEN amt >= 15000 then 'Gold'
               Else 'Silver' END AS 'Sales_Cat'
from  TOTAL_SAL;

--Show department-wise average salary, with a column that:
--Displays 'Above Company Avg' if dept avg > overall avg

select * from Employees;

with Depart_avg as (select Department, avg(Salary) 'dept_avg_salary' from Employees group by Department ),
     Overall_avg as (select Avg(Salary) 'ovr_avg_salary' from Employees)

--select * from Overall_avg
select *, case when dept_avg_salary > (select ovr_avg_salary from Overall_avg )
               then 'Above Company Avg' 
               else 'Below Company Avg' end as 'salry_avg_group'
--(select ovr_avg_salary from Overall_avg ) - dept_avg_salary  as 'salary_avg_diff' 
from Depart_avg; 

--For employees hired before 2020, apply a 10% salary uplift in a new column, but:
--Cap the uplift at 8k for Engineering
--5k for all other departments.
select * from Employees;

select *,YEAR(JoinDate), Department, (Salary *0.1),Salary,
        CASE 
            WHEN YEAR(JoinDate) < 2020 and Department = 'Engineering' THEN 
                CASE when (Salary *.1) <= 8000 THEN (Salary+ (Salary *.1))
                ELSE Salary+ 8000 END 
            WHEN YEAR(JoinDate) < 2020 and Department <> 'Engineering' THEN  
                case when (Salary *.1) <= 5000 THEN Salary+ (Salary *.1)
                     ELSE Salary+ 5000 END
                
        ELSE Salary END AS 'SALARY_UPLIFT'
            from Employees;

---Create a composite flag that combines:
---'High Earner' (Salary >75k)
---'High Performer' (Rating ≥8)
---'High Sales' (if they have any sale ≥15k)

select * from Sales
select * from Employees;

with total_sales as (Select EmployeeID, SUM(Amount) as sales_t from Sales group by EmployeeID ),
     EMP_tbl as (select a.*, case when b.sales_t is null then 0 else b.sales_t end as 'sold_amt' from  Employees as a left join total_sales as b on a.EmployeeID = b.EmployeeID )

select *, case when Salary > 75000 then 'High Earner'
               when PerformanceRating >= 8 then 'High Performer'
               when sold_amt > 15000 then 'High Sales'
           else 'Average Employee'
        end as 'category'
from EMP_tbl;

--Use CASE to transform rows into columns showing:
----Total sales for each region (West, East, North, South) as separate columns.
select * from Sales

select *, case when Region = 'West' then Amount else 0 end as 'West_T' 
        , case when Region = 'East' then Amount else 0 end as 'Eastt_T' 
        , case when Region = 'North' then Amount else 0 end as 'North_T' 
        , case when Region = 'South' then Amount else 0 end as 'South_T' 

from Sales

---CASE in UPDATE Statement: Write an UPDATE that increases salary by:
--15% for PerformanceRating ≥9
--10% for Rating 7-8
--5% for Rating 5-6, 0% otherwise.

UPDATE Employees1
SET Salary = Salary * 
    CASE 
        WHEN PerformanceRating >= 9 THEN 1.15
        WHEN PerformanceRating >= 7 THEN 1.10
        WHEN PerformanceRating >= 5 THEN 1.05
        ELSE 1
    END;

--CASE in ORDER BY:
---Sort employees by:
---Department (Engineering first, then Sales, then others)
--PerformanceRating (descending)
--Salary (ascending for Ratings ≤6, descending otherwise

SELECT 
    Name,
    Department,
    PerformanceRating,
    Salary
FROM Employees
ORDER BY 
    CASE When Department = 'Engineering' THEN 1
         When Department = 'Sales' THEN 2
        ELSE 3
    END,
    PerformanceRating DESC,
    CASE WHEN PerformanceRating <= 6 THEN Salary ELSE -Salary END;

---For each employee, show: Their salary
--The department's average salary
--A column that says 'Above'/'Below

select * from Employees;

WITH DEPART_AVG AS (SELECT Department, ROUND(Avg(Salary),0) 'Dept_avg' from Employees group by Department  ),
     individual_sal as (SELECT a.*, b.Dept_avg from Employees as a left join DEPART_AVG as b on a.Department = b.Department)
select *, 
CASE WHEN Salary > Dept_avg THEN 'Above'
     ELSE 'Below' END AS 'Flg'
 from individual_sal



