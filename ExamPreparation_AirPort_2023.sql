CREATE DATABASE AirPort

USE AirPort

GO

CREATE TABLE Passengers
(
	Id INT PRIMARY KEY IDENTITY,
	FullName VARCHAR(100) UNIQUE NOT NULL,
	Email VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Pilots
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) UNIQUE NOT NULL,
	LastName VARCHAR(30) UNIQUE NOT NULL,
	Age TINYINT CHECK(Age >= 21 AND Age <= 62) NOT NULL,
	Rating FLOAT CHECK(Rating >= 0.0 AND Rating <= 10.0) 
)

CREATE TABLE AircraftTypes
(
	Id INT PRIMARY KEY IDENTITY,
	TypeName VARCHAR(30) UNIQUE NOT NULL
)

CREATE TABLE Aircraft
(
	Id INT PRIMARY KEY IDENTITY,
	Manufacturer VARCHAR(25) NOT NULL,
	Model VARCHAR(30) NOT NULL,
	[Year] INT NOT NULL,
	FlightHours INT,
	Condition CHAR NOT NULL,
	TypeId INT FOREIGN KEY REFERENCES AircraftTypes (Id) NOT NULL
)

CREATE TABLE PilotsAircraft
(
	AircraftId INT FOREIGN KEY REFERENCES Aircraft (Id) NOT NULL,
	PilotId INT FOREIGN KEY REFERENCES Pilots (Id) NOT NULL,
	PRIMARY KEY (AircraftId, PilotId)
)

CREATE TABLE Airports
(
	Id INT PRIMARY KEY IDENTITY,
	AirportName VARCHAR(70) UNIQUE NOT NULL,
	Country VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE FlightDestinations
(
	Id INT PRIMARY KEY IDENTITY,
	AirportId INT FOREIGN KEY REFERENCES Airports (Id) NOT NULL,
	[Start] DATETIME NOT NULL,
	AircraftId INT FOREIGN KEY REFERENCES Aircraft (Id) NOT NULL,
	PassengerId INT FOREIGN KEY REFERENCES Passengers (Id) NOT NULL,
	TicketPrice DECIMAL(18,2) DEFAULT 15 NOT NULL
)



-- Problem 2

INSERT INTO Passengers
SELECT CONCAT(FirstName, ' ', LastName), 
	   CONCAT(FirstName, LastName, '@gmail.com') 
  FROM Pilots WHERE Id >= 5 AND Id <= 15

-- Problem 3

UPDATE Aircraft SET Condition = 'A'
WHERE (Condition = 'B' OR Condition = 'C') 
      AND (FlightHours IS NULL OR FlightHours <= 100) 
	  AND [Year] >= 2013;

-- Problem 4

DELETE FROM Passengers 
      WHERE LEN(FullName) <= 10;


-- Problem 5


	SELECT Manufacturer,
		   Model,
		   FlightHours,
		   Condition
	  FROM Aircraft
  ORDER BY FlightHours DESC

-- Problem 6


SELECT FirstName,
	   LastName,
	   Manufacturer,
	   Model,
	   FlightHours
  FROM Pilots
    AS p
  JOIN PilotsAircraft 
    AS pac
	ON pac.PilotId = p.Id
  JOIN Aircraft
    AS ac
	ON ac.Id = pac.AircraftId
 WHERE FlightHours IS NOT NULL AND 
       FlightHours < 304
ORDER BY FlightHours DESC,
		 FirstName 

-- Problem 7


SELECT 
   TOP (20)
       fd.Id
    AS DestinationId,
	   [Start],
	   FullName,
	   AirportName,
	   TicketPrice
  FROM FlightDestinations
    AS fd
  JOIN Passengers
    AS p
	ON fd.PassengerId = p.Id
  JOIN Airports 
    AS a
	ON fd.AirportId = a.Id
WHERE DATEPART(DAY, fd.[Start]) % 2 = 0		 
ORDER BY TicketPrice DESC,
	     AirportName


-- Problem 8

SELECT a.Id 
    AS AircraftId,
	   Manufacturer,
	   FlightHours,
	   COUNT(fd.Id)
	AS FlightDestinationsCount,
	   ROUND(AVG(fd.TicketPrice), 2)
	AS AvgPrice
  FROM Aircraft 
    AS a
  JOIN FlightDestinations
    AS fd
	ON a.Id = fd.AircraftId
GROUP BY a.Id,AircraftId,Manufacturer,FlightHours
HAVING COUNT(fd.Id) >= 2
ORDER BY FlightDestinationsCount DESC,
		 AircraftId


-- Problem 9

SELECT *
  FROM (
SELECT FullName,
       COUNT(a.Id)
	AS CountOfAircraft,
	   SUM(fd.TicketPrice)
    AS TotalPayed
  FROM Passengers
    AS p
  JOIN FlightDestinations
    AS fd
	ON p.Id = fd.PassengerId
  JOIN Aircraft
    AS a
    ON fd.AircraftId = a.Id
WHERE SUBSTRING(FullName, 2, 1) = 'a'
GROUP BY FullName
      ) AS subquery
WHERE CountOfAircraft > 1

-- Problem 10

SELECT AirportName, 
	   [Start]
	AS [DateTime],
	   TicketPrice,
	   FullName, 
	   Manufacturer,
	   Model
  FROM FlightDestinations
    AS fd
  JOIN AirCraft 
    AS a
	ON fd.AircraftId = a.Id
  JOIN Passengers 
    AS p
	ON fd.PassengerId = p.Id
  JOIN Airports 
    AS ap
	ON fd.AirportId = ap.Id	
WHERE CAST(fd.[Start] AS TIME) BETWEEN '06:00' AND '20:00'
      AND TicketPrice > 2500
ORDER BY Model

-- Problem 11
GO

CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50)) 
RETURNS INT AS 
BEGIN 
     
	DECLARE @passengerCount INT;
	SET @passengerCount = 
	( 
	 SELECT
		    COUNT(fd.Id)
	   FROM Passengers
		 AS p
	   JOIN FlightDestinations
		 AS fd
		 ON p.Id = fd.PassengerId
	  WHERE p.Email = @email
   GROUP BY p.Id
    );
	IF @passengerCount IS NULL 
	   SET @passengerCount = 0

   RETURN @passengerCount
END;

GO
SELECT dbo.udf_FlightDestinationsByEmail('MerisShale@gmail.com')
SELECT dbo.udf_FlightDestinationsByEmail('Montacute@gmail.com')
SELECT dbo.udf_FlightDestinationsByEmail('MerisShale@gmail.com')
GO


GO

CREATE PROCEDURE usp_SearchByAirportName @airportName VARCHAR(70)
AS 
BEGIN
	SELECT AirportName,
	       FullName,
      CASE 
	      WHEN TicketPrice > 0 AND TicketPrice <= 400  THEN 'Low'
		  WHEN TicketPrice >= 401 AND TicketPrice <= 1500 THEN 'Medium'
		  WHEN TicketPrice >= 1501 THEN 'High'
		  END
	    AS LevelOfTickerPrice,
		   ac.Manufacturer,
		   ac.Condition,
		   TypeName 
	  FROM Airports
	    AS a
INNER JOIN FlightDestinations 
        AS fd
		ON a.Id = fd.AirportId
INNER JOIN Passengers
		AS p 
		ON fd.PassengerId = p.Id
INNER JOIN Aircraft
        AS ac
		ON fd.AircraftId = ac.Id
INNER JOIN AircraftTypes 
        AS [at]
		ON ac.TypeId = [at].Id
WHERE a.AirportName = @airportName
ORDER BY ac.Manufacturer, p.FullName
END;

GO


EXEC usp_SearchByAirportName 'Sir Seretse Khama International Airport'

GO

