USE SoftUni

GO

--DEMO
GO

CREATE FUNCTION udf_GetSalaryLevel(@Salary MONEY)
RETURNS NVARCHAR(10) AS
BEGIN
DECLARE @salaryLevel VARCHAR(10) ='Average';
-- SET @salaryLevel = 'Average';
     IF (@Salary < 30000)
	 BEGIN
	   SET @salaryLevel = 'Low';
	 END;
	 ELSE IF (@Salary > 50000)
	 BEGIN
	   SET @salaryLevel = 'High';
	 END;
	 RETURN @salaryLevel;
END;

GO

SELECT *,
       [dbo].[udf_GetSalaryLevel](Salary)
    AS [SalaryLevel]      
  FROM [Employees]



  --Problem 1
  GO

  CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
		        AS
             BEGIN
					SELECT FirstName,
					       LastName
					  FROM Employees
					 WHERE Salary > 35000
			   END

GO

EXEC usp_GetEmployeesSalaryAbove35000



-- Problem 2

GO

CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber(@salary DECIMAL(18,4))
              AS
		   BEGIN
					SELECT FirstName,
					       LastName
		              FROM Employees
					 WHERE Salary >= @salary
		     END

			 
GO

EXEC dbo.usp_GetEmployeesSalaryAboveNumber 100000.23


-- Problem 3

GO

CREATE PROCEDURE usp_GetTownsStartingWith (@townLetter VARCHAR(50))
			  AS
		   BEGIN
				DECLARE @townLetterLength INT = LEN(@townLetter)
				SELECT [Name]
				  FROM Towns
				WHERE LEFT([Name], @townLetterLength) = @townLetter
            END

GO

EXEC usp_GetTownsStartingWith 'c'


-- Problem 4
GO

CREATE PROCEDURE usp_GetEmployeesFromTown (@townName VARCHAR(50))
              AS
		SELECT FirstName,
			   LastName
		  FROM Employees 
			AS e
		  JOIN Addresses 
			AS a
			ON e.AddressID = a.AddressID
		  JOIN Towns 
			AS t
			ON a.TownID = t.TownID
         WHERE t.[Name] = @townName


GO


EXEC usp_GetEmployeesFromTown 'Sofia'

GO


GO



-- Problem 5


CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
RETURNS VARCHAR (10)
		     AS 
				BEGIN
				DECLARE @salaryLevel VARCHAR(10) ='Average';
				-- SET @salaryLevel = 'Average';
					 IF (@Salary < 30000)
					 BEGIN
					   SET @salaryLevel = 'Low';
					 END;
					 ELSE IF (@Salary > 50000)
					 BEGIN
					   SET @salaryLevel = 'High';
					 END;
					 RETURN @salaryLevel;
				END;

GO


SELECT [dbo].[udf_GetSalaryLevel](23333) 
    


GO


-- Problem 6


GO

CREATE PROCEDURE usp_EmployeesBySalaryLevel (@levelOfSalary VARCHAR(8))
              AS
           BEGIN
					SELECT FirstName,
						   LastName
					  FROM Employees
					  WHERE [dbo].[udf_GetSalaryLevel](Salary) = @levelOfSalary
					  
		     END

EXEC usp_EmployeesBySalaryLevel 'High'


GO

-- Problem 7

CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50))
    RETURNS BIT
             AS
          BEGIN
                    DECLARE @wordIndex INT = 1;
					WHILE (@wordIndex <= LEN(@word))
					BEGIN
							IF (CHARINDEX(SUBSTRING(@word, @wordIndex, 1), @setOfLetters)) = 0
						 BEGIN
								RETURN 0;
						   END
						   SET @wordIndex += 1;
					  END

				      RETURN 1;
            END
 
GO

SELECT [dbo].[ufn_IsWordComprised]('oistmiahf', 'halves')


-- Problem 8

GO

CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT)
              AS
		   BEGIN
					-- We need to store all id's of the Employees that are going to be removed
                    DECLARE @employeesToDelete TABLE ([Id] INT);            
                    INSERT INTO @employeesToDelete
                                SELECT [EmployeeID] 
                                  FROM [Employees]
                                 WHERE [DepartmentID] = @departmentId
 
                    -- Employees which we are going to remove can be working on some
                    -- projects. So we need to remove them from working on this projects.
                    DELETE
                      FROM [EmployeesProjects]
                     WHERE [EmployeeID] IN (
                                                SELECT * 
                                                  FROM @employeesToDelete
                                           )
 
                    -- Employees which we are going to remove can be Managers of some Departments
                    -- So we need to set ManagerID to NULL of all Departments with futurely deleted Managers
                    -- First we need to alter column ManagerID
                     ALTER TABLE [Departments]
                    ALTER COLUMN [ManagerID] INT
                    
                    UPDATE [Departments]
                       SET [ManagerID] = NULL
                     WHERE [ManagerID] IN (
                                                SELECT *
                                                  FROM @employeesToDelete
                                          )
 
                    -- Employees which we are going to remove can be Managers of another Employees
                    -- So we need to set ManagerID to NULL of all Employees with futurely deleted Managers
                    UPDATE [Employees]
                       SET [ManagerID] = NULL
                     WHERE [ManagerID] IN (
                                                SELECT *
                                                  FROM @employeesToDelete
                                          )
 
                    -- Since we removed all references to the employees we want to remove
                    -- We can safely remove them
                    DELETE
                      FROM [Employees]
                     WHERE [DepartmentID] = @departmentId
 
                     DELETE 
                       FROM [Departments]
                      WHERE [DepartmentID] = @departmentId
 
                      SELECT COUNT(*)
                        FROM [Employees]
                       WHERE [DepartmentID] = @departmentId
		     END

GO

EXEC [dbo].[usp_DeleteEmployeesFromDepartment] 7

GO

-- Problem 9


USE Bank

GO



CREATE PROCEDURE usp_GetHoldersFullName 
              AS 
		   BEGIN
					SELECT CONCAT(FirstName, ' ', LastName)
					    AS [FullName]
					  FROM AccountHolders
		     END


EXEC usp_GetHoldersFullName



-- Problem 10

GO


CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan @higherBalance INT
              AS
		   BEGIN 
					    SELECT FirstName,
						       LastName
						  FROM AccountHolders
							AS ah
					INNER JOIN Accounts
							AS a
							ON ah.Id = a.AccountHolderId
					     WHERE Balance > @higherBalance
					  ORDER BY FirstName, LastName
			 END


GO

EXEC dbo.usp_GetHoldersWithBalanceHigherThan 7000



-- Problem 11

GO

CREATE FUNCTION ufn_CalculateFutureValue(@SUM DECIMAL(18, 4), @yearlyInterestRate FLOAT, @numberOfYears INT)
RETURNS DECIMAL(18, 4) 
AS
BEGIN
    RETURN @SUM * POWER((1 + @yearlyInterestRate / 1), @numberOfYears)
END
 
GO

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)


--Problem 12 

GO

CREATE PROCEDURE usp_CalculateFutureValueForAccount (@AccountId INT, @InterestRate FLOAT)
              AS
		   BEGIN
				SELECT a.Id
					AS [Account Id],
					   ah.FirstName
					AS [First Name],
					   ah.LastName
					AS [LastName],
					   a.Balance
					AS [Current Balance],
					   dbo.ufn_CalculateFutureValue(Balance, @InterestRate, 5)
					AS [Balance in 5 years]
				  FROM AccountHolders
					AS ah
			INNER JOIN Accounts
					AS a
					on ah.Id = a.AccountHolderId
				 WHERE a.id= @AccountId
		     END

GO

EXEC usp_CalculateFutureValueForAccount 1, 0.1




USE Diablo


GO


-- Problem 13


CREATE FUNCTION ufn_CashInUsersGames(@gameName NVARCHAR(50))
  RETURNS TABLE
             AS
         RETURN
                (
                    SELECT SUM([Cash])
                        AS [SumCash]
                      FROM (
                                SELECT [g].[Name],
                                       [ug].[Cash],
                                       ROW_NUMBER() OVER(ORDER BY [ug].[Cash] DESC)
                                    AS [RowNumber]
                                  FROM [UsersGames]
                                    AS [ug]
                            INNER JOIN [Games]
                                    AS [g]
                                    ON [ug].[GameId] = [g].[Id]
                                 WHERE [g].[Name] = @gameName
                           ) 
                        AS [RankingSubQuery]
                     WHERE [RowNumber] % 2 <> 0
                )
 
GO
	
        
