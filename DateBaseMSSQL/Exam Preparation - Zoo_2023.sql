CREATE DATABASE [Zoo]
 
GO
 
USE [Zoo]
 
GO
 
-- Problem 01
-- PRIMARY KEY -> PK, UNIQUE, NOT NULL
-- IDENTITY -> Auto-incremented Id
-- FOREIGN KEY REFERENCES [TableName]([ReferencedTablePK]) -> Relationship with a table
-- All columns except PKs are NULLABLE by default
CREATE TABLE [Owners]
             (
                [Id] INT PRIMARY KEY IDENTITY,
                [Name] VARCHAR(50) NOT NULL,
                [PhoneNumber] VARCHAR(15) NOT NULL,
                [Address] VARCHAR(50)
             )
 
CREATE TABLE [AnimalTypes]
             (
                [Id] INT PRIMARY KEY IDENTITY,
                [AnimalType] VARCHAR(30) NOT NULL
             )
 
CREATE TABLE [Cages]
             (
                [Id] INT PRIMARY KEY IDENTITY,
                [AnimalTypeId] INT FOREIGN KEY REFERENCES [AnimalTypes]([Id]) NOT NULL
             )
 
CREATE TABLE [Animals]
             (
                [Id] INT PRIMARY KEY IDENTITY,
                [Name] VARCHAR(30) NOT NULL,
                [BirthDate] DATE NOT NULL,
                [OwnerId] INT FOREIGN KEY REFERENCES [Owners]([Id]),
                [AnimalTypeId] INT FOREIGN KEY REFERENCES [AnimalTypes]([Id]) NOT NULL
             )
 
CREATE TABLE [AnimalsCages]
             (
                [CageId] INT FOREIGN KEY REFERENCES [Cages]([Id]),
                [AnimalId] INT FOREIGN KEY REFERENCES [Animals]([Id]),
                PRIMARY KEY([CageId], [AnimalId])
             )
 
CREATE TABLE [VolunteersDepartments]
             (
                [Id] INT PRIMARY KEY IDENTITY,
                [DepartmentName] VARCHAR(30) NOT NULL
             )
 
CREATE TABLE [Volunteers]
             (
                [Id] INT PRIMARY KEY IDENTITY,
                [Name] VARCHAR(50) NOT NULL,
                [PhoneNumber] VARCHAR(15) NOT NULL,
                [Address] VARCHAR(50),
                [AnimalId] INT FOREIGN KEY REFERENCES [Animals]([Id]),
                [DepartmentId] INT FOREIGN KEY REFERENCES [VolunteersDepartments]([Id]) NOT NULL
             )
 
-- Problem 02
INSERT INTO [Animals]
            ([Name], [BirthDate], [OwnerId], [AnimalTypeId])
     VALUES 
            ('Giraffe', '2018-09-21', 21, 1),
            ('Harpy Eagle', '2015-04-17', 15, 3),
            ('Hamadryas Baboon', '2017-11-02', NULL, 1),
            ('Tuatara', '2021-06-30', 2, 4)
           
INSERT INTO [Volunteers]
            ([Name], [PhoneNumber], [Address], [AnimalId], [DepartmentId])
     VALUES
            ('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
            ('Dimitur Stoev', '0877564223', NULL, 42, 4),
            ('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
            ('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
            ('Boryana Mileva', '0888112233', NULL, 31, 5)
 
-- Problem 03
UPDATE [Animals]
   SET [OwnerId] = (
                        SELECT [Id]
                          FROM [Owners]
                         WHERE [Name] = 'Kaloqn Stoqnov'
                   )
 WHERE [OwnerId] IS NULL
 
SELECT *
  FROM [Animals]
 WHERE [OwnerId] IS NULL
 
-- Problem 04
---- First we need to release the volunteers from the deleted department
DELETE
  FROM [Volunteers]
 WHERE [DepartmentId] = (
                            SELECT [Id]
                              FROM [VolunteersDepartments]
                             WHERE [DepartmentName] = 'Education program assistant'
                        )
 
---- Then we can safely delete the department
DELETE
  FROM [VolunteersDepartments]
 WHERE [DepartmentName] = 'Education program assistant'
 
-- Problem 05
  SELECT [Name],
         [PhoneNumber],
         [Address],
         [AnimalId],
         [DepartmentId]
    FROM [Volunteers]
ORDER BY [Name],
         [AnimalId],
         [DepartmentId]
 
-- Problem 06
    SELECT [a].[Name],
           [at].[AnimalType],
           FORMAT([a].[BirthDate], 'dd.MM.yyyy')
        AS [BirthDate]
      FROM [Animals]
        AS [a]
INNER JOIN [AnimalTypes]
        AS [at]
        ON [a].[AnimalTypeId] = [at].[Id]
  ORDER BY [a].[Name]
 
-- Problem 07
   SELECT
  TOP (5) [o].[Name]
       AS [Owner],
          COUNT([a].[Id])
       AS [CountOfAnimals]
     FROM [Owners]
       AS [o]
LEFT JOIN [Animals]
       AS [a]
       ON [o].[Id] = [a].[OwnerId]
 GROUP BY [o].[Name]
 ORDER BY [CountOfAnimals] DESC,
          [Owner]
 
-- Problem 08
-- I do not need owners without an animal
    SELECT CONCAT([o].[Name], '-', [a].[Name])
        AS [OwnersAnimals],
           [o].[PhoneNumber],
           [ac].[CageId]
      FROM [Owners]
        AS [o]
INNER JOIN [Animals]
        AS [a]
        ON [o].[Id] = [a].[OwnerId]
INNER JOIN [AnimalTypes]
        AS [at]
        ON [a].[AnimalTypeId] = [at].[Id]
INNER JOIN [AnimalsCages]
        AS [ac]
        ON [a].[Id] = [ac].[AnimalId]
     WHERE [at].[AnimalType] = 'Mammals'
  ORDER BY [o].[Name],
           [a].[Name] DESC
 
-- Problem 09
    SELECT [v].[Name],
           [v].[PhoneNumber],
           LTRIM(REPLACE(REPLACE([v].[Address], 'Sofia', ''), ',', ''))
        AS [Address]
      FROM [Volunteers]
        AS [v]
INNER JOIN [VolunteersDepartments]
        AS [vd]
        ON [v].[DepartmentId] = [vd].[Id]
     WHERE [vd].[DepartmentName] = 'Education program assistant' AND
           [v].[Address] LIKE '%Sofia%'
  ORDER BY [v].[Name]
 
-- Problem 10
    SELECT [a].[Name],
           DATEPART(YEAR, [a].[BirthDate])
        AS [BirthYear],
           [at].[AnimalType]
      FROM [Animals]
        AS [a]
INNER JOIN [AnimalTypes]
        AS [at]
        ON [a].[AnimalTypeId] = [at].[Id]
     WHERE [a].[OwnerId] IS NULL AND
           DATEDIFF(YEAR, [a].[BirthDate], '01/01/2022') < 5 AND
           [at].[AnimalType] <> 'Birds'
  ORDER BY [a].[Name]
           
GO
 
-- Problem 11
CREATE FUNCTION [udf_GetVolunteersCountFromADepartment] (@VolunteersDepartment VARCHAR(30))
    RETURNS INT
             AS
          BEGIN
                    DECLARE @departmentId INT;
                    SET @departmentId = (
                                            SELECT [Id]
                                              FROM [VolunteersDepartments]
                                             WHERE [DepartmentName] = @VolunteersDepartment
                                        );
 
                    DECLARE @departmentVoluntersCount INT;
                    SET @departmentVoluntersCount = (
                                                        SELECT COUNT(*)
                                                          FROM [Volunteers]
                                                         WHERE [DepartmentId] = @departmentId
                                                    );
 
                    RETURN @departmentVoluntersCount;               
            END
 
GO
 
SELECT dbo.udf_GetVolunteersCountFromADepartment ('Education program assistant')
SELECT dbo.udf_GetVolunteersCountFromADepartment ('Guest engagement')
SELECT dbo.udf_GetVolunteersCountFromADepartment ('Zoo events')
 
GO
 
-- Problem 12
CREATE PROCEDURE [usp_AnimalsWithOwnersOrNot] (@AnimalName VARCHAR(30))
              AS
           BEGIN
                       SELECT [a].[Name],
                              ISNULL([o].[Name], 'For adoption')
                           AS [OwnersName]
                         FROM [Animals]
                           AS [a]
                    LEFT JOIN [Owners]
                           AS [o]
                           ON [a].[OwnerId] = [o].[Id]
                        WHERE [a].[Name] = @AnimalName
             END
 
GO
 
EXEC usp_AnimalsWithOwnersOrNot 'Pumpkinseed Sunfish'
EXEC usp_AnimalsWithOwnersOrNot 'Hippo'
