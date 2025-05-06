IF NOT EXISTS (select name from sys.databases where name = 'EXISTS_db')
        BEGIN
            CREATE DATABASE EXISTS_db
        END
ELSE
        BEGIN
            PRINT 'Already exists'
        END

USE EXISTS_db
-- Dummy Data Setup
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2)
);

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    Budget DECIMAL(12,2),
    StartDate DATE,
    EndDate DATE
);

CREATE TABLE ProjectAssignments (
    AssignmentID INT PRIMARY KEY,
    EmployeeID INT,
    ProjectID INT,
    Role VARCHAR(50),
    JoinDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

INSERT INTO Employees VALUES 
(1, 'Alice Chen', 'Engineering', '2020-03-15', 85000),
(2, 'Bob Wilson', 'Marketing', '2019-07-22', 72000),
(3, 'Carol Davis', 'Engineering', '2021-01-10', 78000),
(4, 'Dave Brown', 'Sales', '2018-11-05', 68000),
(5, 'Eve Johnson', 'Engineering', '2022-06-30', 90000);

INSERT INTO Projects VALUES
(101, 'Phoenix', 250000, '2023-01-01', '2023-12-31'),
(102, 'Orion', 180000, '2023-03-15', '2023-09-30'),
(103, 'Pegasus', 320000, '2023-02-01', '2024-06-30'),
(104, 'Apollo', 150000, '2023-04-01', '2023-08-31');

INSERT INTO ProjectAssignments VALUES
(1001, 1, 101, 'Lead Developer', '2023-01-01'),
(1002, 2, 102, 'Marketing Lead', '2023-03-20'),
(1003, 3, 101, 'Developer', '2023-01-15'),
(1004, 1, 103, 'Architect', '2023-02-01'),
(1005, 4, 104, 'Sales Consultant', '2023-04-05'),
(1006, 5, 101, 'QA Engineer', '2023-01-10'),
(1007, 3, 103, 'Developer', '2023-02-15');

---data explorer

SELECT * FROM INFORMATION_SCHEMA.TABLES
SELECT * FROM sys.TABLES

select * from Employees
select * from Projects
select * from ProjectAssignments;

---Medium 
----Find employees who are assigned to at least one project with a budget over $200,000
--Option 1
select * from Employees;

with Emp_project as (select a.*,b.AssignmentID, b.ProjectID,c.Budget  from  Employees as a 
                    left join ProjectAssignments as b on a.EmployeeID = b.EmployeeID
                    left join Projects as c on b.ProjectID = c.ProjectID),
     emp_summary as (select Name,count(distinct ProjectID) as 'proj_cnt',MAX(Budget) 'max_budget' from Emp_project group by Name  )
select name from emp_summary where max_budget > 200000 AND proj_cnt >= 1 ;

--Option2
--This gives you atleast one project assigned
SELECT * FROM Employees AS A where EXISTS 
                                    (SELECT * FROM ProjectAssignments AS B 
                                    WHERE A.EmployeeID = B.EmployeeID)
--Value is greater than 200000
SELECT NAME FROM Employees AS A where EXISTS 
                                    (SELECT * FROM ProjectAssignments AS B 
                                    WHERE A.EmployeeID = B.EmployeeID and EXISTS (SELECT * FROM Projects AS C 
                                    WHERE B.ProjectID = C.ProjectID AND Budget > 200000)
                                    )
----Identify projects where no engineering employees are assigned
--any project where employee is assigned
SELECT *  FROM Projects as a 
                where exists (select * from ProjectAssignments as b
                where a.ProjectID = b.ProjectID)

--remove all the project where there is any engineer
--doing this will only remove the project where enginerr is employeed but it will not remove the project entire as 
--it could be that one project as sales manager & engineer as well
--so this entry will remove engineer entry & not the sales

SELECT *  FROM Projects as a 
                where exists (select * from ProjectAssignments as b
                where a.ProjectID = b.ProjectID
                and b.Role NOT LIKE '%engineer%'
                )

 ---101 AS ENGINEER (SO WE WE LINK THE TABLE TO ITSELF)
 -- ENGINEER LINKED TO ITSELF, TO  LEAD ARCHITECT, ARCHITECT -> SO WHEN WE SET WHERE LIKE ENGINEER WE JUSTPICK THESE ROWS
 --THESE ROWS IMPLES ROW 1, ROW3, ROW 9 -> NOT EXISTS WILL TAKE OPPOSITE IMPLIES WHEREVER CONDITION MET OTHER THAN THAT
--IT'S NOT LIKE IT'S ACTUAL JOINING 
select * from ProjectAssignments as b where not exists 
(select * from ProjectAssignments as c 
where b.ProjectID = c.ProjectID and c.Role LIKE '%engineer%'
)

SELECT A.ProjectName, a.ProjectID  FROM Projects as A
                where exists ( select * from ProjectAssignments as b 
                where A.ProjectID = B.ProjectID AND not exists 
                (select * from ProjectAssignments as c 
                where b.ProjectID = c.ProjectID and c.Role LIKE '%engineer%'
                )
 )

 ----Find employees who joined the company before 2021 but haven't been assigned to any projects starting in 2023
 SELECT * FROM Employees AS A WHERE EXISTS (SELECT * FROM Employees AS B
                                        WHERE A.EmployeeID = B.EmployeeID
                                        AND YEAR(HireDate) < 2021
                                            )
SELECT * FROM ProjectAssignments
 SELECT * FROM Employees AS A WHERE EXISTS (SELECT * FROM Employees AS B
                                        WHERE A.EmployeeID = B.EmployeeID
                                        AND YEAR(HireDate) < 2021
                                            )

---Find employees assigned to all projects with budgets exceeding $200,000
with proj as (select ProjectID from Projects WHERE Budget > 200000), 
     proj_assign as (select * from ProjectAssignments where ProjectID in (select ProjectID from proj) ),
     proj_ass_cnt as (select EmployeeID,count(distinct AssignmentID) as 'dist_cnt' from proj_assign group by EmployeeID),
     emp_id as (select EmployeeID from proj_ass_cnt where dist_cnt = (select COUNT(distinct ProjectID) as cnt from proj) )
SELECT Name from Employees where EmployeeID in (select EmployeeID from emp_id);

--Identify employees who have worked on at least one project in every department they belong to
select [a].[EmployeeID],
[a].[Name],
[a].[Department],
[a].[HireDate],
[a].[Salary], b.AssignmentID,b.Role from Employees as a left join ProjectAssignments as B
on a.EmployeeID = b.EmployeeID
where Role LIKE CONCAT('%',Department,'%') or (Department like '%engineer%' and role like '%engineer%');

---Find projects where every assigned employee has a salary above the department average
with department_avg as (Select Department, Avg(Salary) as 'avg' from Employees group by Department),
     emp_comparison as (select a.*, b.avg from employees as a left join department_avg as b on a.Department = b.Department where a.Salary >= b.avg),
     total_emp_proj as  (select ProjectID,COUNT(distinct EmployeeID) as 'total_emp_per_proj' from ProjectAssignments group by ProjectID),
     total_emp_proj_sal as  (select ProjectID,COUNT(distinct EmployeeID) as 'Condn_emp_per_proj' from ProjectAssignments where EmployeeID in (select distinct EmployeeID from emp_comparison) group by ProjectID),
     join_tbl as (select a.*,b.Condn_emp_per_proj from total_emp_proj as a left join total_emp_proj_sal as b on a.ProjectID = b.ProjectID ),
     finl_tbl as (select projectname from Projects as a where exists (SELECT * from join_tbl as b where a.ProjectId = B.ProjectID  and total_emp_per_proj = Condn_emp_per_proj))

SELECT * from finl_tbl;

with department_avg as (Select Department, Avg(Salary) as 'avg' from Employees group by Department),
     emp_comparison as (select a.*, b.avg from employees as a left join department_avg as b on a.Department = b.Department where a.Salary > b.avg),
     total_emp_proj as  (select ProjectID,COUNT(distinct EmployeeID) as 'total_emp_per_proj' from ProjectAssignments group by ProjectID),
     total_emp_proj_sal as  (select ProjectID,COUNT(distinct EmployeeID) as 'Condn_emp_per_proj' from ProjectAssignments AS A where EXISTS (select 1 from emp_comparison  AS B WHERE A.EmployeeID = B.EmployeeID) group by ProjectID)

SELECT * from total_emp_proj_sal  ;

---Find employees who have been continuously assigned to projects without any gaps longer than 3 months
select A.Name from Employees as A
INNER  join 
(select a.*,b.JoinDate, LEAD(JoinDate) OVER(PARTITION BY a.EmployeeID Order by JoinDate) as 'cons_dates'  
from Employees as a 
left join ProjectAssignments as b 
ON a.EmployeeID = b.EmployeeID
) as B
ON A.EmployeeID = B.EmployeeID
AND DATEDIFF(MONTH, JoinDate, cons_dates) <= 3
