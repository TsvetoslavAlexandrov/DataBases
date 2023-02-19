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


 -- Problem 5

 SELECT * 
   FROM Boardgames 

