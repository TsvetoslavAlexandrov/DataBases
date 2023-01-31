USE [Gringotts]

GO


SELECT * 
  FROM [WizzardDeposits]

 -- Problem 1

SELECT COUNT(*)
    AS [Count]
  FROM [WizzardDeposits]  


-- Problem 2

SELECT [DepositGroup]
	AS [LongestMagicWand]
  FROM [WizzardDeposits]  


-- Problem 3

   SELECT [DepositGroup],
         MAX([MagicWandSize])
      AS [LongestMagicWand]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]




--Problem 4

  SELECT 
TOP (2)   [DepositGroup]
	FROM  [WizzardDeposits]
GROUP BY  [DepositGroup]	
ORDER BY AVG([MagicWandSize]) 



-- Problem 5

  SELECT [DepositGroup],
         SUM([DepositAmount])
      AS [TotalSum]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]




-- Prolem 6

  SELECT [DepositGroup],
         SUM([DepositAmount])
      AS [TotalSum]
    FROM [WizzardDeposits]
   WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]





-- Problem 7
  SELECT [DepositGroup],
         SUM([DepositAmount])
      AS [TotalSum]
    FROM [WizzardDeposits]
   WHERE [MagicWandCreator] = 'Ollivander family' 
GROUP BY [DepositGroup]
  HAVING SUM([DepositAmount]) < 150000
ORDER BY [TotalSum] DESC


--Method 2 
SELECT *
  FROM  ( 
		   SELECT [DepositGroup],
				  SUM([DepositAmount])
			   AS [TotalSum]
			 FROM [WizzardDeposits]
		    WHERE [MagicWandCreator] = 'Ollivander family' 
		 GROUP BY [DepositGroup]

        )AS [subquery]
WHERE [TotalSum] < 150000
ORDER BY [TotalSum] DESC
-- Problem 8

  SELECT [DepositGroup], 
		 [MagicWandCreator],
		 MIN([DepositCharge])
      AS [MinDepositCharge]    
	FROM [WizzardDeposits]
GROUP BY [DepositGroup], [MagicWandCreator]



-- Problem 9 

SELECT [AgeGroups], 
       COUNT(*)
	AS [WizzardCount]
  FROM (
			SELECT CASE
						   WHEN Age BETWEEN 0 AND 10
						   THEN '[0-10]'
						   WHEN Age BETWEEN 11 AND 20
						   THEN '[11-20]'
						   WHEN Age BETWEEN 21 AND 30
						   THEN '[21-30]'
						   WHEN Age BETWEEN 31 AND 40
						   THEN '[31-40]'
						   WHEN Age BETWEEN 41 AND 50
						   THEN '[41-50]'
						   WHEN Age BETWEEN 51 AND 60
						   THEN '[51-60]'
						   WHEN Age >= 61
						   THEN '[61+]'
						   ELSE 'N\A'
					   END AS AgeGroups 
				   FROM [WizzardDeposits]
	   ) AS [subquery]
GROUP BY [AgeGroups]



-- Problem 10 

SELECT SUBSTRING([FirstName], 1, 1)
	   [FirstLetter]
  FROM [WizzardDeposits]
WHERE [DepositGroup] = 'Troll Chest'
GROUP BY SUBSTRING([FirstName], 1, 1)
ORDER BY [FirstLetter]



 -- Problem 11

  SELECT [DepositGroup],
         [IsDepositExpired],
		 AVG([DepositInterest])
	  AS [AverageInterest]
	FROM [WizzardDeposits]
   WHERE [DepositStartDate] > '01/01/1985'
GROUP BY [DepositGroup], [IsDepositExpired]
ORDER BY [DepositGroup] DESC
         



-- Problem 12
 
SELECT SUM(Diffrences) 
    AS [SumDiffrence]
  FROM (
			SELECT [FirstName]
				AS [Host Wizard],
				   [DepositAmount]
				AS [Host Wizard Deposit],
				   LEAD([FirstName]) OVER (ORDER BY (Id))
				AS [Guest Wizard],
				   LEAD([DepositAmount]) OVER (ORDER BY (Id))
				AS [Guest Wizard Deposit],
				   [DepositAmount] - LEAD([DepositAmount]) OVER (ORDER BY (Id))
				AS [Diffrences]
			  FROM [WizzardDeposits]
       ) AS [DiffrenceSubquery]




GO

USE [SoftUni]

GO

-- Problem 13

  SELECT [DepartmentID],
	     SUM(Salary)
   	  AS [TotalSum]
    FROM [Employees]
GROUP BY [DepartmentID]

-- Problem 14

  SELECT [DepartmentID],
		 MIN(Salary)
   	  AS [MinimumSalary]
    FROM [Employees]
   WHERE [DepartmentID] IN (2, 5, 7) AND [HireDate] > '01/01/2000'
GROUP BY [DepartmentID]


-- Problem 15

SELECT *
  INTO [EmployeesWithSalaryOver30000]
  FROM [Employees] 
 WHERE [Salary] > 30000

DELETE 
  FROM [EmployeesWithSalaryOver30000]
 WHERE [ManagerID] = 42 

UPDATE [EmployeesWithSalaryOver30000]
   SET [Salary] += 5000
 WHERE [DepartmentID] = 1

  SELECT [DepartmentID],
	     AVG([Salary])
      AS [AverageSalary]
    FROM [EmployeesWithSalaryOver30000]
GROUP BY [DepartmentID]


-- Problem 16

  SELECT [DepartmentID],
         MAX([Salary]) 
      AS [MaxSalary]
    FROM [Employees]
GROUP BY [DepartmentID] 
  HAVING MAX([Salary]) < 30000 OR MAX([Salary])  > 70000



--Problem 17

SELECT COUNT([EmployeeID])
    AS [Count]
  FROM (
		SELECT *
		  FROM [Employees]
		 WHERE [ManagerID] IS NULL

       )AS [Subqueries]




--Problem 18

  SELECT 
  DISTINCT [DepartmentID],
           [Salary] 
        AS [ThirdHighestSalary]
      FROM (
		    SELECT [DepartmentID],
				   [Salary],
				   DENSE_RANK() OVER (PARTITION BY [DepartmentId] ORDER BY [Salary] DESC)
			    AS [SalaryRank]
			  FROM [Employees]
		   )AS [Salarysubquery]
      WHERE [SalaryRank] = 3


-- Problem 19
 SELECT 
TOP (10)[e].[FirstName],
	    [e].[LastName],
	    [e].[DepartmentID]
   FROM [Employees]
     AS [e] 
  WHERE [e].[Salary] > (
							 SELECT AVG(Salary)
							   FROM [Employees]
								 AS [subEmployees]
							  WHERE [subEmployees].[DepartmentID] = [e].[DepartmentID]
						   GROUP BY [subEmployees].[DepartmentID]
	                    )
ORDER BY [e].[DepartmentID]