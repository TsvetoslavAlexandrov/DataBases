USE [Softuni]

GO

--5
SELECT [FirstName], 
	   [MiddleName], 
	   [LastName]	   
  FROM [Employees]

--6	
SELECT CONCAT ([FirstName],'.',[LastName], '@', 'softuni.bg')	
	AS [Full Email Address]
  FROM [Employees]

--7

SELECT DISTINCT [Salary] 
		   FROM [Employees]



--8
SELECT * FROM [Employees]
WHERE [JobTitle] = 'Sales Representative'


--9
SELECT [FirstName],
	   [LastName], 
	   [JobTitle]
  FROM [Employees]
 WHERE [Salary] BETWEEN 20000 AND 30000


--10
SELECT CONCAT_WS (' ',[FirstName],[MiddleName],[LastName])
	AS [FullName]
  FROM [Employees]
 WHERE [Salary] = 25000 OR [Salary] = 12500 OR [Salary] = 14000 OR [Salary] = 23600


--11

SELECT [FirstName], 
	   [LastName]
  FROM [Employees]
  WHERE [ManagerID] IS NULL
	   

--12

SELECT [FirstName], 
	   [LastName],
	   [Salary]
  FROM [Employees]
  WHERE [Salary] > 50000 
ORDER BY [Salary] DESC




--13
  Select 
TOP (5)  [FirstName],
	     [LastName]
    FROM [Employees]
ORDER BY [Salary]  DESC
 

--14

SELECT [FirstName],
	   [LastName]
  FROM [Departments]
  WHERE [DepartmentID] != 4



--15

SELECT *
  FROM [Employees]
ORDER BY [Salary] DESC,
		 [FirstName],
		 [LastName] DESC,
		 [MiddleName]


--16






--17
GO

CREATE VIEW [V_EmployeeNameJobTitle3]
		AS
		   (
			SELECT CONCAT ([FirstName],  ' sd', [MiddleName], ' ', [LastName])
			    AS [Full Name],
				   [JobTitle]
			  FROM [Employees]

		   )

GO

SELECT [Full Name] FROM [V_EmployeeNameJobTitle]



--18








--19

SELECT 
TOP (10) *
	FROM [Projects]
ORDER BY [StartDate],
[Name]



--20






--21

SELECT *
  FROM [Employees]



SELECT [DepartmentID]
  FROM [Departments]
WHERE [Name] IN ('Engineering', 'Tool Design', 'Marketing', 'Information Services')

UPDATE [Employees]
   SET [Salary] += 0.12 * [Salary]
WHERE [DepartmentID] IN (1, 2 ,4 ,11)

SELECT [Salary]
  FROM [Employees]
 

USE [SoftUni]



--22






--23






--24
USE [Geography]
GO



SELECT [CountryName],
       [CountryCode],
	   CASE [CurrencyCode]
	   WHEN 'EUR' THEN 'Euro'
	   ELSE 'Not Euro'
	   END
	   AS[Currency]
  FROM [Countries] 
ORDER BY [CountryName] 


--25







