---CREATE DATABASE IF NOT EXISTS WINDOWS_DB in sql
SELECT Name from sys.databases where name = 'WINDOWS_DB'
SELECT * from sys.databases --name_column in db name


IF NOT EXISTS(SELECT Name from sys.databases where name = 'WINDOWS_DB' )
BEGIN
    CREATE DATABASE WINDOWS_DB
END
ELSE
BEGIN
    PRINT 'Database already exist'
END

SELECT Name from sys.databases

------table creation

Use WINDOWS_DB

CREATE TABLE Employees (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    PhoneNumber VARCHAR(15),
    City VARCHAR(50)
);

INSERT INTO Employees VALUES
(1, 'Anna', 'Smith', '123-456-7890', 'Austin'),
(2, 'Bob', 'Johnson', '234-567-8901', 'Boston'),
(3, 'Charlie', 'Brown', '345-678-9012', 'Chicago'),
(4, 'David', 'Lee', '456-789-0123', 'Denver'),
(5, 'Eva', 'Green', '567-890-1234', 'Austin'),
(6, 'Frank_lin', 'White', '678-901-2345', 'Seattle'),
(7, 'Grace', 'Taylor', '789-012-3456', 'Dallas'),
(8, 'Hannah', 'Davis', '890-123-4567', 'Boston');

--------------------Practice questions-------------------------------------------
---Find employees whose FirstName ends with the letter 'a'.
select * from Employees

SELECT * FROM Employees WHERE FirstName LIKE '%A'

--Retrieve employees with a FirstName that has exactly 5 characters.
SELECT * FROM Employees WHERE FirstName LIKE '_____'

---Find employees whose LastName contains the substring 'son' anywhere.
SELECT * FROM Employees WHERE LastName LIKE '%son%'

---Identify employees with PhoneNumber values formatted as 'XXX-XXX-XXXX'
EXEC sp_help 'Employees';

INSERT INTO Employees VALUES
(9, 'Rach', 'Smith', '123-456-7890ghf', 'Austin')

SELECT * FROM Employees
SELECT * FROM Employees WHERE PhoneNumber LIKE '___-___-____' and PhoneNumber NOT LIKE '%[a-zA-Z]%'

---Find employees from cities starting with 'A', 'B', or 'C'
SELECT * FROM Employees WHERE City LIKE '[A-Ca-c]%'
SELECT * FROM Employees WHERE City LIKE 'A%' or City LIKE 'B%' OR City LIKE 'C%'

--Retrieve employees whose FirstName has 'a' as the third character
SELECT * FROM Employees WHERE FirstName LIKE '__A%'

--Find employees with a City that does not start with 'S', 'J', or 'D'.
SELECT * FROM Employees
SELECT * FROM Employees WHERE City LIKE '[^SJD]%'

SELECT * FROM Employees WHERE City NOT LIKE '[SJD]%'


--TEST
SELECT * FROM Employees WHERE City LIKE '[SJD]%'

---Identify employees with FirstName containing special characters (e.g., underscores)
SELECT * FROM Employees WHERE FirstName LIKE '%[:;}{/\~`$_!*&|@.#]%'
SELECT * FROM Employees WHERE FirstName LIKE '%[^A-Za-z]%'

---wildcard: {},!,% (how??)

--Find employees with PhoneNumber values where the area code starts with '2' and ends with '4'.
SELECT * FROM Employees WHERE PhoneNumber LIKE '2_4%'

--Retrieve employees from cities where the second letter is 'o' (e.g., Boston).
SELECT * FROM Employees WHERE City LIKE '_o%'

----HARD
--Find employees with FirstName values that have two vowels (means shaem -> ae).
SELECT * FROM Employees 
SELECT * FROM Employees  where FirstName like '%[aeiou][aeiou]%'

--COLLATE SQL_Latin1_General_CP1_CS_AS; -> for case sensitive search
SELECT * FROM Employees  where FirstName like '%[aeiou][aeiou]%' COLLATE SQL_Latin1_General_CP1_CS_AS;


---this will not work
SELECT * FROM Employees
WHERE FirstName LIKE '%[^aeiou][^aeiou]%' COLLATE SQL_Latin1_General_CP1_CS_AS;

--Identify employees where PhoneNumber has no hyphens (e.g., 1234567890).
SELECT * FROM Employees

insert into Employees VALUES(10,'Steve','Cooper','1234567890','California')

SELECT * FROM Employees where PhoneNumber not LIKE '%-%'

--Retrieve employees with LastName values that start with 'Sm' but are not 'Smith'.
SELECT * FROM Employees
WHERE LastName LIKE 'Sm%' AND LastName <> 'Smith';

--Find employees with FirstName values that are palindromes (e.g., 'Eve')
SELECT * FROM Employees
WHERE FirstName = REVERSE(FirstName);

---Identify employees from firstname with names containing exactly two 's' characters
INSERT INTO Employees VALUES
(10, 'Rachstrs', 'Smith', '123-456-7890ghf', 'Austin')

SELECT * FROM Employees
where LEN(FirstName) - LEN(REPLACE(LOWER(FirstName),'s','')) = 2
