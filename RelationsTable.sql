CREATE DATABASE [EntityRelationsExcersice]

GO

USE [EntityRelationsExcersice]

GO





-- 1

CREATE TABLE [Passports]
(
	[PassportID] INT PRIMARY KEY IDENTITY(101, 1),
	[PassportNumber] VARCHAR(8) NOT NULL
)

CREATE TABLE [Persons]
(
	[PersonID] INT PRIMARY KEY IDENTITY,
	[FirstName] VARCHAR(50) NOT NULL,
	[Salary] DECIMAL(8, 2) NOT NULL,
	[PassportID] INT FOREIGN KEY REFERENCES [Passports] ([PassportID]) UNIQUE NOT NULL
)


INSERT INTO [Passports]([PassportNumber])
	VALUES
			('N34FG21B'),
			('K65LO4R7'),
			('ZE657QP2')

INSERT INTO [Persons]([FirstName], [Salary], [PassportID])
	VALUES
			('Roberto', 43300.00, 102),
			('Tom', 56100.00, 103),
			('Yana', 60200.00, 101)








--2 

CREATE TABLE [Manufacturers]
(
	[ManufacturerID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[EstablishedOn] DATETIME2
)
CREATE TABLE [Models]
(
	[ModelID] INT PRIMARY KEY IDENTITY(101,1),
	[Name] VARCHAR(50) NOT NULL,
	[ManufacturerID] INT FOREIGN KEY REFERENCES [Manufacturers] ([ManufacturerID]) UNIQUE NOT NULL
)







--3


CREATE TABLE [Studen23232ts]
(
	[StudentID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100)
)


CREATE TABLE [Exams]
(
	[ExamID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100)

)

CREATE TABLE [StudentsExams]
(
	[StudentID] INT FOREIGN KEY REFERENCES [Students] ([StudentID]) NOT NULL,
	[ExamID] INT FOREIGN KEY REFERENCES [Exams] ([ExamID]),
	PRIMARY KEY ([StudentID], [ExamID])
)







--4


CREATE TABLE [Teachers]
(
	[TeacherID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] VARCHAR(50) NOT NULL,
	[ManagerID]  INT FOREIGN KEY REFERENCES [Teachers] ([TeacherID]) NOT NULL
)





go
--5
CREATE TABLE [ItemTypes]
(
	[ItemTypeID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL 
)

CREATE TABLE [Cities]
(
	[CityID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL
)

CREATE TABLE [Items]
(
	[ItemID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL,
	[ItemTypeID] INT FOREIGN KEY REFERENCES [ItemTypes] ([ItemTypeID]) NOT NULL

)

CREATE TABLE [Customers]
(
	[CustomerID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL,
	[Birthday] DATETIME2,
	[CityID] INT FOREIGN KEY REFERENCES [Cities] ([CityID]) NOT NULL
)


CREATE TABLE [Orders]
(
	[OrderID] INT PRIMARY KEY IDENTITY,
	[CustomerID] INT FOREIGN KEY REFERENCES [Customers] ([CustomerID]) NOT NULL
)

CREATE TABLE [OrderItems]
(
	[OrderID] INT FOREIGN KEY REFERENCES [Orders]([OrderID]) NOT NULL,
	[ItemID] INT FOREIGN KEY REFERENCES [Items] ([ItemID]) NOT NULL,
	PRIMARY KEY ([OrderID], [ItemID])
)






--6


CREATE TABLE [Mayors]
(
	[MayorID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL
)

CREATE TABLE [Students]
(
	[StudentID] INT PRIMARY KEY IDENTITY,
	[StudentNumber] VARCHAR(8) NOT NULL,
	[StudentName] VARCHAR(100) NOT NULL,
	[MayorID] INT FOREIGN KEY REFERENCES [Mayors] ([MayorID]) UNIQUE NOT NULL
)

CREATE TABLE [Payments]
(
	[PaymentID] INT PRIMARY KEY IDENTITY,
	[PaymentDate] DATETIME2,
	[PaymentAmount] DECIMAL(8, 2),
	[StudentID] INT FOREIGN KEY REFERENCES [Students] ([StudentID]) UNIQUE NOT NULL
)

CREATE TABLE [Subjects]
(
	[SubjectID] INT PRIMARY KEY IDENTITY,
	[SubjectName] VARCHAR(50) NOT NULL
)

CREATE TABLE [Agenda]
(
	[StudentID] INT FOREIGN KEY REFERENCES [Students] ([StudentID]) UNIQUE NOT NULL,
	[SubjectID] INT FOREIGN KEY REFERENCES [Subjects] ([SubjectID]) UNIQUE NOT NULL,
	PRIMARY KEY ( [StudentID], [SubjectID])
)


--7