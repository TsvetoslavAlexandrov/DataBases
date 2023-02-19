CREATE DATABASE Boardgames

USE Boardgames

CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	StreetName NVARCHAR(100) NOT NULL,
	StreetNumber INT NOT NULL,
	Town VARCHAR(30) NOT NULL,
	Country VARCHAR(50) NOT NULL,
	ZIP INT NOT NULL
)

CREATE TABLE Publishers
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) UNIQUE NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses (Id) NOT NULL,
	Website NVARCHAR(40),
	Phone NVARCHAR(20) 
)

CREATE TABLE PlayersRanges
(
	Id INT PRIMARY KEY IDENTITY,
	PlayersMin INT NOT NULL,
	PlayersMax INT NOT NULL,
)

CREATE TABLE Boardgames
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,
	YearPublished INT NOT NULL,
	Rating DECIMAL(18,2) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories (Id) NOT NULL,
	PublisherId INT FOREIGN KEY REFERENCES Publishers (Id) NOT NULL,
	PlayersRangeId INT FOREIGN KEY REFERENCES PlayersRanges (Id) NOT NULL
)

CREATE TABLE Creators
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Email NVARCHAR(30) NOT NULL
)


CREATE TABLE CreatorsBoardgames 
(
	CreatorId INT FOREIGN KEY REFERENCES Creators (Id) NOT NULL,
	BoardgameId INT FOREIGN KEY REFERENCES Boardgames (Id) NOT NULL,
	PRIMARY KEY (CreatorId, BoardgameId)
)



-- Problem 3
SELECT * FROM PlayersRanges
UPDATE PlayersRanges
SET PlayersMax = PlayersMax + 1
WHERE PlayersMin = 2 
  AND PlayersMax = 2 
  AND Id IN (
					SELECT Id 
					FROM PlayersRanges 
					WHERE PlayersMin = 2 AND PlayersMax = 2
					)

UPDATE Boardgames
   SET [Name] = [Name] + 'V2'
 WHERE YEAR(YearPublished) >= 2020


 -- Problem 4

 SELECT * FROM Addresses


 DECLARE @countriesToDelete TABLE (Id INT);
INSERT INTO @countriesToDelete (Id)
SELECT DISTINCT Id FROM Addresses 
WHERE Town LIKE 'L%';

DELETE FROM Addresses
WHERE Id IN (SELECT Id FROM Addresses WHERE Town IN (SELECT Id FROM @countriesToDelete));

DELETE FROM Addresses
WHERE Id IN (SELECT Id FROM @countriesToDelete);

 -- Problem 5

 SELECT Name,
		Rating
   FROM Boardgames 
ORDER BY YearPublished ASC,
         Name DESC


 -- Problem 6


 SELECT b.Id,
        b.Name,
		YearPublished,
		c.Name
   FROM Boardgames 
     AS b
   JOIN Categories
     AS c
	 ON b.CategoryId = c.Id
WHERE c.Name IN ('Strategy Games', 'Wargames')
ORDER BY YearPublished DESC


-- Problem 7

SELECT c.Id,
       CONCAT(FirstName, ' ', LastName)
    AS CreatorName,
	   Email
  FROM Creators 
    AS c
LEFT JOIN CreatorsBoardgames
    AS cb
	ON c.Id = cb.CreatorId
WHERE CreatorId IS NULL 
ORDER BY CreatorName ASC


-- Problem 8

SELECT TOP 5 
  b.Name, 
  b.Rating, 
  c.Name 
FROM 
  Boardgames b 
  JOIN Categories c ON b.CategoryId = c.Id 
  JOIN PlayersRanges pr ON b.PlayersRangeId = pr.Id 
WHERE 
  (b.Rating > 7.00 AND b.Name LIKE '%a%') 
  OR (b.Rating > 7.50 AND pr.PlayersMin >= 2 AND pr.PlayersMax <= 5) 
ORDER BY 
  b.Name ASC, 
  b.Rating DESC;



-- Problem 9


SELECT CONCAT(FirstName, ' ', LastName)
    AS FullName,
	   Email,
	   MAX(Rating)
    AS Rating
  FROM Creators 
    AS c
  JOIN CreatorsBoardgames
    AS cb
	ON c.Id = cb.CreatorId
  JOIN Boardgames 
    AS b
	ON cb.BoardgameId = b.Id
WHERE Email LIKE '%.com'
GROUP BY FirstName, LastName, Email
ORDER BY FullName ASC

-- Problem 10


  SELECT c.LastName,
  	     CEILING(AVG(Rating)) 
      AS AverageRating,
  	     p.Name 
   	  AS PublisherName
    FROM Creators 
  	  AS c
    JOIN CreatorsBoardgames 
  	  AS cb
  	  ON c.Id = cb.CreatorId
    JOIN Boardgames
      AS b
  	  ON cb.BoardgameId = b.Id
    JOIN Publishers
      AS p
  	  ON b.PublisherId = p.Id
WHERE  p.Name = 'Stonemaier Games'
GROUP BY LastName, p.Name
ORDER BY AVG(Rating) DESC;

-- Problem 11


GO

CREATE FUNCTION udf_CreatorWithBoardgames (@name NVARCHAR(30))
RETURNS INT
AS
BEGIN
    DECLARE @count INT;
        SET @count = (
					    SELECT COUNT(*)
							FROM Creators
							  AS c
						 JOIN CreatorsBoardgames
							  AS cb
							  ON c.Id = cb.CreatorId
						 JOIN Boardgames 
							  AS b
							  ON cb.BoardgameId = b.Id
						WHERE C.FirstName = @name
					  )
    RETURN @count;
END

GO
SELECT * FROM Creators
SELECT dbo.udf_CreatorWithBoardgames('')

GO

CREATE PROCEDURE usp_SearchByCategory @category NVARCHAR(30)
AS
BEGIN
    SELECT 
           b.Name, 
           b.YearPublished, 
           b.Rating, 
           c.Name, 
           p.Name, 
           CONCAT(pr.PlayersMin, ' people') 
		AS MinPlayers, 
           CONCAT(pr.PlayersMax, ' people') 
		AS MaxPlayers 
      FROM Boardgames 
	    AS b 
      JOIN Categories 
	    AS c 
		ON b.CategoryId = c.Id 
      JOIN Publishers 
	    AS p 
		ON b.PublisherId = p.Id 
      JOIN PlayersRanges 
	    AS pr 
		ON b.PlayersRangeId = pr.Id 
    WHERE c.Name = @category 
    ORDER BY p.Name ASC, 
             b.YearPublished DESC;
END

EXEC usp_SearchByCategory 'Wargames'



