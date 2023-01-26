USE SoftUni

GO


SELECT * 
  FROM Employees

 -- Problem 1

   SELECT 
  TOP 5 e.EmployeeID,
		e.JobTitle,
		e.AddressID,
		a.AddressText
     FROM Employees
	   AS e
LEFT JOIN Addresses 
	   AS a 
	   ON e.AddressID = a.AddressID
 ORDER BY AddressID

 -- Problem 5

   SELECT 
 TOP 3    e.EmployeeID,
          e.FirstName 
     FROM Employees 
       AS e
LEFT JOIN EmployeesProjects 
       AS ep 
	   ON e.EmployeeID = ep.EmployeeID
    WHERE ep.ProjectID IS NULL
 ORDER BY EmployeeID


 -- Problem 7

  SELECT 
 TOP 5   e.EmployeeID,
	     e.FirstName,
		 p.[Name]
		 AS [ProjectName]
    FROM Employees 
      AS e
JOIN    EmployeesProjects AS ep 
	  ON e.EmployeeID = ep.EmployeeID
JOIN    Projects AS p 
      ON ep.ProjectID = p.ProjectID
   WHERE p.[StartDate] > '08-13-2002' AND p.[EndDate] IS NULL
ORDER BY e.EmployeeID



-- Problem 9
	 
    SELECT e.EmployeeID,
		   e.FirstName,
		   e.ManagerID,
		   m.[FirstName]
		   AS [ManagerName]
      FROM Employees
        AS e
INNER JOIN Employees
        AS m 
		ON e.ManagerID = m.EmployeeID
     WHERE e.ManagerID in (3, 7)
  ORDER BY m.EmployeeID



GO 

USE Geography

go
  -- Problem 12

   SELECT 
		  c.CountryName,
		  m.MountainRange,
		  p.PeakName,
		  p.Elevation
	 FROM Countries
	   AS c
LEFT JOIN MountainsCountries
	   AS mc
	   ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains 
	   AS m
	   ON mc.MountainId = m.Id
LEFT JOIN Peaks
	   AS p 
	   ON p.MountainId = m.Id
    WHERE c.CountryName = 'Bulgaria' AND 
	      p.Elevation > 2835
 ORDER BY Elevation DESC
   


  -- Problem 13

  SELECT CountryCode,
	     COUNT(MountainId)  
   	  AS [MountainRange]  
    FROM MountainsCountries
   WHERE CountryCode IN (
						  SELECT CountryCode
							FROM Countries
						   WHERE CountryName IN ('United States', 'Russia', 'Bulgaria')
	                    )
GROUP BY [CountryCode]


 --Problem 15

SELECT ContinentCode,
	   CurrencyCode,
	   CurrencyUsage
  FROM 
	  (
		SELECT *,
		       DENSE_RANK() OVER (PARTITION BY [ContinentCode] ORDER BY [CurrencyUsage] DESC)
		    AS CurrencyRank
		  FROM 
			 (
				SELECT ContinentCode,
					   CurrencyCode,
					   COUNT(*) 
					AS CurrencyUsage
				  FROM Countries
			  GROUP BY ContinentCode, CurrencyCode
				HAVING COUNT(*) > 1
			 )
	       AS CurrencyUsageSubquery
	  )
	AS CurrencyRankingSubquery
 WHERE CurrencyRank = 1


 -- Problem 17


   SELECT 
  TOP 5
		  c.CountryName,
		  MAX(p.Elevation)
		  AS [HighestPeakElevetion],
		  MAX(r.[Length])
		  AS [LongestRiverLength]
	 FROM Countries
	   AS c
LEFT JOIN CountriesRivers 
       AS cr 
	   ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers 
	   AS r 
	   ON cr.RiverId = r.Id 
LEFT JOIN MountainsCountries 
       AS mc 
	   ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains
       AS m 
	   ON mc.MountainId = m.Id 
LEFT JOIN Peaks
       AS p
	   ON p.MountainId = m.Id
GROUP BY c.CountryName
ORDER BY [HighestPeakElevetion] DESC,
         [LongestRiverLength]DESC,
		 CountryName


-- Problem 18

	SELECT  
   TOP 5	       
		    CountryName,
			ISNULL(PeakName, '(no highest peak)')
			AS [Highest Peak Name],
			ISNULL(Elevation, 0)
			AS [Highest Peak Elevation],
			ISNULL (MountainRange, '(no mountain)')
			AS [Mountain]   
		FROM (
				SELECT c.CountryName,
						p.PeakName,
						p.Elevation,
						m.MountainRange,
						DENSE_RANK() OVER(PARTITION BY [c].[CountryName] ORDER BY [p].[Elevation] DESC)
					AS [PeakRank]
					FROM Countries
					AS c
			LEFT JOIN MountainsCountries 
					AS mc 
					ON mc.CountryCode = c.CountryCode
			LEFT JOIN Mountains 
					AS m 
					ON mc.MountainId = m.Id
			LEFT JOIN Peaks 
					AS p
					ON p.MountainId = m.Id
			)
      AS PeakRankingSubquery
ORDER BY CountryName,
		 [Highest Peak Elevation]

 -- Problem 19