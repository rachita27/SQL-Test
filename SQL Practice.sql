--CREATE DATABASE NEW_DB_SQL
SELECT name 
FROM sys.databases

SELECT * 
FROM sys.databases

CREATE DATABASE  tempdb

CREATE DATABASE IF NOT EXISTS tempdb

CREATE DATABASE if not exists master

USE msdb

DROP DATABASE NEW_DB_SQL;
--SHOW DATABASES

/*SELECT TOP (1000) [optname]
      ,[value]
      ,[major_version]
      ,[minor_version]
      ,[revision]
      ,[install_failures]
  FROM [master].[dbo].[MSreplication_options]*/


  use NEW_DB_SQL

CREATE TABLE Customer(
   CustomerID INT PRIMARY KEY,
   CustomerName VARCHAR(50),
   LastName VARCHAR(50),
   Country VARCHAR(50),
   Age INT CHECK (Age >= 0 AND Age <= 99),
   Phone VARCHAR(10)
);

SELECT * FROM Customer

CREATE TABLE Customer1(
   CustomerID INT PRIMARY KEY,
   CustomerName VARCHAR(50),
   LastName VARCHAR(50),
   Country VARCHAR(50),
   Age INT CHECK (Age >= 0 AND Age <= 99),
   Phone VARCHAR(10) CHECK (Phone NOT LIKE '%[^0-9]%')
);

SELECT * FROM Customer1

INSERT INTO Customer (CustomerID, CustomerName, LastName, Country, Age, Phone)
VALUES (1, 'Shubham', 'Thakur', 'India','23','xxxxxxxxxx'),
       (2, 'Aman ', 'Chopra', 'Australia','21','xxxxxxxxxx'),
       (3, 'Naveen', 'Tulasi', 'Sri lanka','24','xxxxxxxxxx'),
       (4, 'Aditya', 'Arpan', 'Austria','21','xxxxxxxxxx'),
       (5, 'Nishant. Salchichas S.A.', 'Jain', 'Spain','22','xxxxxxxxxx');

INSERT INTO Customer1 (CustomerID, CustomerName, LastName, Country, Age, Phone)
VALUES (1, 'Shubham', 'Thakur', 'India','23','9999882233'),
       (2, 'Aman ', 'Chopra', 'Australia','21','9999006677');

SELECT * FROM Customer1

INSERT INTO Customer1 (CustomerID, CustomerName, LastName, Country, Age, Phone)
VALUES (1, 'Shubham', 'Thakur', 'India','23','99998822331');

SELECT CustomerID, CustomerName
 INTO SubTable FROM customer;

---constraints
drop table if exists Customer1a
CREATE TABLE Customer1a(
   CustomerID INT PRIMARY KEY,
   CustomerName VARCHAR(50) not null default('missing'),
   LastName VARCHAR(50),
   Country VARCHAR(50),
   Age INT CHECK (Age >= 0 AND Age <= 99),
   Phone VARCHAR(10) CHECK (Phone NOT LIKE '%[^0-9]%')
);

INSERT INTO Customer1a (CustomerID, LastName, Country, Age, Phone)
VALUES (1, 'Thakur', 'India','23','9999882233')

SELECT * FROM Customer1a

------
SELECT * FROM Customer

SELECT * FROM Customer WHERE Age BETWEEN 21 AND 23
SELECT * FROM Customer WHERE Age >= 23
SELECT * FROM Customer WHERE CustomerName LIKE '%s%'

SELECT * FROM Customer WHERE CustomerName LIKE 's%' --(starts with s)
SELECT * FROM Customer WHERE CustomerName LIKE '%a' -- ends with a
SELECT * FROM Customer WHERE CustomerName LIKE '__a%' --(third letter a)

---delete
drop table GFG_Employees
CREATE TABLE GFG_Employees (
   id INT PRIMARY KEY,
   name VARCHAR (20) ,
   email VARCHAR (25),
   department VARCHAR(20)
);
INSERT INTO GFG_Employees (id, name, email, department) VALUES 
(1, 'Jessie', 'jessie23@gmail.com', 'Development'),
(2, 'Praveen', 'praveen_dagger@yahoo.com', 'HR'),
(3, 'Bisa', 'dragonBall@gmail.com', 'Sales'),
(4, 'Rithvik', 'msvv@hotmail.com', 'IT'),
(5, 'Suraj', 'srjsunny@gmail.com', 'Quality Assurance'),
(6, 'Om', 'OmShukla@yahoo.com', 'IT'),
(7, 'Naruto', 'uzumaki@konoha.com', 'Development');
Select * From GFG_Employees

DELETE FROM GFG_Employees WHERE NAME = 'Rithvik'; 
Select * From GFG_Employees 

DELETE FROM GFG_EMPLOyees;

BEGIN TRANSACTION;
DELETE FROM GFG_Employees WHERE NAME = 'Rithvik';
-- If needed, you can rollback the deletion
ROLLBACK;
Select * From GFG_Employees 

---Rollback
drop table GFG_Employees
CREATE TABLE GFG_Employees (
   id INT PRIMARY KEY,
   name VARCHAR (20) ,
   email VARCHAR (25),
   department VARCHAR(20)
);
INSERT INTO GFG_Employees (id, name, email, department) VALUES 
(1, 'Jessie', 'jessie23@gmail.com', 'Development'),
(2, 'Praveen', 'praveen_dagger@yahoo.com', 'HR'),
(3, 'Bisa', 'dragonBall@gmail.com', 'Sales'),
(4, 'Rithvik', 'msvv@hotmail.com', 'IT'),
(5, 'Suraj', 'srjsunny@gmail.com', 'Quality Assurance'),
(6, 'Om', 'OmShukla@yahoo.com', 'IT'),
(7, 'Naruto', 'uzumaki@konoha.com', 'Development');
Select * From GFG_Employees 

BEGIN TRANSACTION;
DELETE FROM GFG_EMPLOyees;

Select * From GFG_Employees


BEGIN TRANSACTION;
DELETE FROM GFG_EMPLOyees;
-- If needed, you can rollback the deletion
ROLLBACK;
Select * From GFG_Employees

EXEC sp_help 'GFG_Employees';

SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'GFG_Employees'

----Updates
select * from Customer
select * into Customer_copy from Customer

UPDATE Customer
set CustomerName = 'Nishant'
where CustomerName = 'Nishant. Salchichas S.A.'

select * from Customer_copy where CustomerID = 5
select * from Customer where CustomerID = 5

----Alter
--Alter Table name
EXEC sp_rename 'Customercopy', 'Customercops'

select * from Customercops

--Change cOLUMN NAME
EXEC sp_rename 'Customercops.CustomerID', 'Customer_IDs', 'COLUMN';
select * from Customercops

--adding a column
ALTER TABLE Customercops
ADD new_col VARCHAR DEFAULT('2')
select * from Customercops

--modify data type
ALTER TABLE Customercops
ALTER COLUMN Phone VARCHAR(15)

--Delete column
select * from Customer
ALTER TABLE Customer
DROP COLUMN Phone

select * from Customer

---TRUNCATE TABLE Student_details;
select * into Customercops1 from Customercops
TRUNCATE TABLE Customercops1;

SELECT * from Customercops1

----DUPLICATE TABLE WITHOUT VALUES
SELECT * from Customercops

SELECT * INTO Customer_cop_no from Customercops where 1>2
SELECT * from Customer_cop_no
SELECT * from Customercops

SELECT * INTO #Customer_cop_no from Customercops 
SELECT * INTO ##Customer_cop_no from Customercops 

----not operator
SELECT * from ##Customer_cop_no
where age NOT between 21 and 23

SELECT * from ##Customer_cop_no
where CustomerName not like 's%'

SELECT * from ##Customer_cop_no
where CustomerName is NULL
SELECT * from ##Customer_cop_no
where not CustomerName is NULL

---Ties
