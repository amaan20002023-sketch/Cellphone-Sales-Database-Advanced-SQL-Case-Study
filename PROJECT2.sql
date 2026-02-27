--SQL Advance Case Study

--Q1--BEGIN 
/*1. List all the states in which we have customers who have bought cellphones 
from 2005 till today. */

	SELECT DISTINCT DL.STATE
	FROM FACT_TRANSACTIONS FT
	JOIN DIM_CUSTOMER DC ON FT.IDCustomer=DC.IDCustomer
	JOIN DIM_LOCATION DL ON FT.IDLocation=DL.IDLocation
	JOIN DIM_DATE DD ON FT.Date=DD.DATE
	WHERE DD.YEAR>=2005

--Q1--END

--Q2--BEGIN

--2. What state in the US is buying the most 'Samsung' cell phones?


	
	SELECT TOP 1 dl.State, SUM(ft.Quantity) AS Total_Quantity
FROM FACT_TRANSACTIONS ft
JOIN DIM_MODEL dm ON ft.IDModel = dm.IDModel
JOIN DIM_MANUFACTURER dman ON dm.IDManufacturer = dman.IDManufacturer
JOIN DIM_LOCATION dl ON ft.IDLocation = dl.IDLocation
WHERE dman.Manufacturer_Name = 'Samsung'
  AND dl.Country = 'US'
GROUP BY dl.State
ORDER BY Total_Quantity DESC;


--Q2--END

--Q3--BEGIN      
	--Show the number of transactions for each model per zip code per state.
	
	SELECT DL.ZIPCODE,
	       DL.STATE,
		   DM.MODEL_NAME,
		   COUNT(FT.IDMODEL) AS TRANSACTION_COUNT
	FROM FACT_TRANSACTIONS FT
	JOIN DIM_MODEL DM ON FT.IDModel=DM.IDModel
	JOIN DIM_LOCATION DL ON FT.IDLocation=DL.IDLocation
	GROUP BY DL.ZIPCODE,
	       DL.STATE,
		   DM.MODEL_NAME
		   ORDER BY DL.ZIPCODE,
	       DL.STATE,
		   COUNT(FT.IDMODEL) DESC
		  
--Q3--END

--Q4--BEGIN
--4. Show the cheapest cellphone (Output should contain the price also)
SELECT TOP 1
DM.MODEL_NAME,
DM.Unit_price
FROM DIM_MODEL DM
ORDER BY DM.Unit_price ASC


--Q4--END

--Q5--BEGIN
/*5. Find out the average price for each model in the top5 manufacturers in 
terms of sales quantity and order by average price. */


WITH TopManufacturers AS (
    SELECT TOP 5 dman.IDManufacturer
    FROM FACT_TRANSACTIONS ft
    JOIN DIM_MODEL dm ON ft.IDModel = dm.IDModel
    JOIN DIM_MANUFACTURER dman ON dm.IDManufacturer = dman.IDManufacturer
    GROUP BY dman.IDManufacturer
    ORDER BY SUM(ft.Quantity) DESC
),
ModelSales AS (
    SELECT 
        dm.Model_Name,
        AVG(dm.Unit_Price) AS Avg_Price
    FROM DIM_MODEL dm
    JOIN TopManufacturers tm ON dm.IDManufacturer = tm.IDManufacturer
    GROUP BY dm.Model_Name
)
SELECT Model_Name, Avg_Price
FROM ModelSales
ORDER BY Avg_Price DESC



--Q5--END

--Q6--BEGIN

/*6. List the names of the customers and the average amount spent in 2009, 
where the average is higher than 500*/ 
SELECT 
    dc.Customer_Name,
    AVG(ft.TotalPrice) AS Avg_Spent_2009
FROM FACT_TRANSACTIONS ft
JOIN DIM_CUSTOMER dc ON ft.IDCustomer = dc.IDCustomer
JOIN DIM_DATE dd ON ft.Date = dd.DATE
WHERE dd.YEAR = 2009
GROUP BY dc.Customer_Name
HAVING AVG(ft.TotalPrice) > 500
ORDER BY Avg_Spent_2009 DESC;


--Q6--END
	
--Q7--BEGIN  
	
/*	7. List if there is any model that was in the top 5 in terms of quantity, 
simultaneously in 2008, 2009 and 2010 */

WITH YearlyTop5 AS (
    SELECT 
        dd.YEAR,
        dm.IDModel,
        dm.Model_Name,
        SUM(ft.Quantity) AS Total_Quantity,
        RANK() OVER (PARTITION BY dd.YEAR ORDER BY SUM(ft.Quantity) DESC) AS RankQty
    FROM FACT_TRANSACTIONS ft
    JOIN DIM_MODEL dm ON ft.IDModel = dm.IDModel
    JOIN DIM_DATE dd ON ft.Date = dd.DATE
    WHERE dd.YEAR IN (2008, 2009, 2010)
    GROUP BY dd.YEAR, dm.IDModel, dm.Model_Name
),
Top5PerYear AS (
    SELECT IDModel, Model_Name, YEAR
    FROM YearlyTop5
    WHERE RankQty <= 5
),
ModelCount AS (
    SELECT Model_Name, COUNT(DISTINCT YEAR) AS YearsInTop5
    FROM Top5PerYear
    GROUP BY Model_Name
)
SELECT Model_Name
FROM ModelCount
WHERE YearsInTop5 = 3;


--Q7--END	
--Q8--BEGIN
/*8. Show the manufacturer with the 2nd top sales in the year of 2009 and the 
manufacturer with the 2nd top sales in the year of 2010*/

WITH RankedSales AS (
    SELECT 
        dd.YEAR,
        dman.Manufacturer_Name,
        SUM(ft.TotalPrice) AS Total_Sales,
        RANK() OVER (PARTITION BY dd.YEAR ORDER BY SUM(ft.TotalPrice) DESC) AS SalesRank
    FROM FACT_TRANSACTIONS ft
    JOIN DIM_MODEL dm ON ft.IDModel = dm.IDModel
    JOIN DIM_MANUFACTURER dman ON dm.IDManufacturer = dman.IDManufacturer
    JOIN DIM_DATE dd ON ft.Date = dd.DATE
    WHERE dd.YEAR IN (2009, 2010)
    GROUP BY dd.YEAR, dman.Manufacturer_Name
)
SELECT YEAR, Manufacturer_Name, Total_Sales
FROM RankedSales
WHERE SalesRank = 2
ORDER BY YEAR

--Q8--END
--Q9--BEGIN
	
/*9. Show the manufacturers that sold cellphones in 2010 but did not in 2009. */
SELECT DISTINCT dman.Manufacturer_Name
FROM FACT_TRANSACTIONS ft
JOIN DIM_MODEL dm ON ft.IDModel = dm.IDModel
JOIN DIM_MANUFACTURER dman ON dm.IDManufacturer = dman.IDManufacturer
JOIN DIM_DATE dd ON ft.Date = dd.DATE
WHERE dd.YEAR = 2010
  AND dman.IDManufacturer NOT IN (
    SELECT DISTINCT dm2.IDManufacturer
    FROM FACT_TRANSACTIONS ft2
    JOIN DIM_MODEL dm2 ON ft2.IDModel = dm2.IDModel
    JOIN DIM_DATE dd2 ON ft2.Date = dd2.DATE
    WHERE dd2.YEAR = 2009
  )
  --9.END


 --10.BEGAIN
 /*10. Find top 100 customers and their average spend, average quantity by each 
year. Also find the percentage of change in their spend.*/

WITH CustomerYearly AS (
    SELECT 
        dc.IDCustomer,
        dc.Customer_Name,
        dd.YEAR,
        AVG(ft.TotalPrice) AS Avg_Spend,
        AVG(ft.Quantity) AS Avg_Quantity
    FROM FACT_TRANSACTIONS ft
    JOIN DIM_CUSTOMER dc ON ft.IDCustomer = dc.IDCustomer
    JOIN DIM_DATE dd ON ft.Date = dd.DATE
    GROUP BY dc.IDCustomer, dc.Customer_Name, dd.YEAR
),
RankedCustomers AS (
    SELECT 
        IDCustomer,
        Customer_Name,
        SUM(Avg_Spend) AS Total_Avg_Spend,
        RANK() OVER (ORDER BY SUM(Avg_Spend) DESC) AS CustomerRank
    FROM CustomerYearly
    GROUP BY IDCustomer, Customer_Name
),
Top100 AS (
    SELECT IDCustomer, Customer_Name
    FROM RankedCustomers
    WHERE CustomerRank <= 100
),
FinalData AS (
    SELECT 
        cy.Customer_Name,
        cy.YEAR,
        cy.Avg_Spend,
        cy.Avg_Quantity,
        LAG(cy.Avg_Spend) OVER (PARTITION BY cy.IDCustomer ORDER BY cy.YEAR) AS Prev_Year_Spend
    FROM CustomerYearly cy
    JOIN Top100 t ON cy.IDCustomer = t.IDCustomer
)
SELECT 
    Customer_Name,
    YEAR,
    ROUND(Avg_Spend, 2) AS Avg_Spend,
    ROUND(Avg_Quantity, 2) AS Avg_Quantity,
    CASE 
        WHEN Prev_Year_Spend IS NULL THEN NULL
        ELSE ROUND(((Avg_Spend - Prev_Year_Spend) / Prev_Year_Spend) * 100, 2)
    END AS Pct_Change_Spend
FROM FinalData
ORDER BY Customer_Name, YEAR

--END














	



















	