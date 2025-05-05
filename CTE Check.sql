---CTE
Select * from sys.databases

CREATE DATABASE cte_db

USE cte_db

CREATE TABLE Employees (
    EmpID INT,
    Name VARCHAR(50),
    Salary INT
);

INSERT INTO Employees VALUES
(1, 'Alice', 60000),
(2, 'Bob', 75000),
(3, 'Charlie', 50000),
(4, 'Diana', 90000),
(5, 'Ethan', 75000);

select * from Employees

--Ques: Second Highest Salary

SELECT *, DENSE_RANK() OVER(Order By Salary Desc) as 'rnk2'
, RANK() OVER(Order By Salary Desc) as 'rnk1'
, ROW_NUMBER() OVER(Order By Salary Desc) as 'rnk2'
from Employees

---subqueries
select distinct a.Salary From (SELECT *, DENSE_RANK() OVER(Order By Salary Desc) as 'rnk2'
from Employees ) as a where a.rnk2 =2

--CTE
WITH second_hig as (SELECT *, DENSE_RANK() OVER(Order By Salary Desc) as 'rnk2'
from Employees) 
select distinct salary from second_hig where rnk2 = 2

CREATE TABLE Sales (
    SaleID INT,
    SaleDate DATE,
    Amount DECIMAL(10,2)
);

INSERT INTO Sales VALUES
(1, '2024-01-01', 100),
(2, '2024-01-03', 150),
(3, '2024-01-05', 200),
(4, '2024-01-10', 300),
(5, '2024-01-15', 250);

INSERT INTO Sales VALUES
(6, '2024-01-01', 100),
(7, '2024-01-03', 150),
(8, '2024-01-15', 250);

----Show each sale with a running total based on SaleDate
select * from Sales
select SaleDate, SUM(Amount) from Sales GROUP BY ROLLUP(SaleDate)

----Get the top 2 highest orders per customer using CTE 
CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    OrderAmount DECIMAL(10,2)
);

INSERT INTO Orders VALUES
(1, 101, 300),
(2, 101, 500),
(3, 101, 100),
(4, 102, 200),
(5, 102, 150),
(6, 103, 700),
(7, 103, 300),
(8, 103, 100);

select * from (select *, 
DENSE_RANK() OVER(PARTITION BY CustomerID Order BY OrderAmount Desc) as rnk1 
from Orders) as a where a.rnk1 = 2

--find customers who spent over $5000 in the last 6 month
CREATE TABLE Orders1 (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    Amount DECIMAL(10,2)
);

INSERT INTO Orders1 VALUES
(1, 101, '2024-10-01', 3000),
(2, 101, '2024-12-15', 2500),
(3, 102, '2024-12-01', 1000),
(4, 103, '2025-01-05', 6000),
(5, 104, '2024-11-20', 4500);

--SELECT * FROM Orders1

with six_m as (SELECT *, DATEDIFF(MONTH, OrderDate, GETDATE()) as day_df from Orders1),
     cuts_t as (SELECT * FROM six_m WHERE day_df BETWEEN 0 and 6 ), 
     sum_amt as (Select CustomerID, SUM(Amount) AS AMT from cuts_t GROUP BY CustomerID )
SELECT * FROM sum_amt WHERE AMT > 5000;

---ties
INSERT INTO Employees VALUEs(6,'Rach', 75000);

SELECT compatibility_level
FROM sys.databases
WHERE name = 'cte_db';

SELECT *
FROM Employees
ORDER BY Salary DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS 
 WITH TIES;

;SELECT *
FROM Employees
ORDER BY Salary DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS WITH TIES;

;SELECT *
FROM Employees
ORDER BY Salary DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY WITH TIES;

SELECT * FROM Employees
ORDER BY Salary DESC
OFFSET 0 ROWS 
FETCH NEXT 3 ROWS WITH TIES;

SELECT * FROM Employees

SELECT *, Salary - (EmpID*100) FROM Employees
SELECT *, Salary + (EmpID*100) FROM Employees
SELECT *, Salary / (EmpID*100) FROM Employees
SELECT *, Salary % (EmpID*100) FROM Employees
SELECT *, POWER(Salary, 0.5) FROM Employees




