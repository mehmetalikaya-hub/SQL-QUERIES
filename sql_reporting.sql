SELECT 
O.ShipCountry,
ROUND(SUM(CASE WHEN O.Freight <= 90 THEN OD.Quantity * OD.UnitPrice * (1-OD.Discount) ELSE 0 END)
/
SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) * 100,2) AS LOW_FREIGHT,
ROUND(SUM(CASE WHEN O.Freight > 90 THEN OD.Quantity * OD.UnitPrice * (1-OD.Discount) ELSE 0 END)
/
SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) * 100,2) AS HIGH_FREIGHT
FROM 
Orders O
JOIN [Order Details] OD ON O.OrderID = OD.OrderID 
GROUP BY O.ShipCountry

---
WITH FREIGHT1 AS (
SELECT O.ShipCountry,
SUM(CASE WHEN O.Freight <= 90 THEN OD.UnitPrice * OD.Quantity * (1-OD.Discount) ELSE 0 END) AS DIS_REVENUE,
SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS TOTAL_REVENUE_1
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.ShipCountry
),
FREIGHT2 AS 
(
SELECT O.ShipCountry,
SUM(CASE WHEN O.Freight > 90 THEN OD.UnitPrice * OD.Quantity * (1-OD.Discount) ELSE 0 END) AS DIS_REVENUE_2,
SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS TOTAL_REVENUE_2
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.ShipCountry
)
SELECT
F1.ShipCountry,
ROUND(F1.DIS_REVENUE
/
F1.TOTAL_REVENUE_1 * 100,2) AS percentage_low_freight,
ROUND(F2.DIS_REVENUE_2
/
F2.TOTAL_REVENUE_2 * 100,2) AS percentage_high_freight
FROM
FREIGHT1 F1
INNER JOIN FREIGHT2 F2 ON F1.ShipCountry = F2.ShipCountry
GROUP BY F1.ShipCountry,F1.DIS_REVENUE,F1.TOTAL_REVENUE_1,F2.DIS_REVENUE_2,F2.TOTAL_REVENUE_2

----
--TUM SHÝP_COUNTRY, EMP1 VE EMP2 NÝN BU CCOUNTRYLER ICIN YUZDELERÝ
WITH CALISAN1 AS 
(
SELECT
O.ShipCountry,
SUM(CASE WHEN O.EmployeeID = 1 THEN OD.Quantity * OD.UnitPrice ELSE 0 END) AS CALISAN_1_SATIS,
SUM(OD.Quantity * OD.UnitPrice) AS TOPLAM_SATIS_1
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.ShipCountry
),
CALISAN2 AS 
(
SELECT
O.ShipCountry,
SUM(CASE WHEN O.EmployeeID = 2 THEN OD.Quantity * OD.UnitPrice ELSE 0 END) AS CALISAN_2_SATIS,
SUM(OD.UnitPrice * OD.Quantity) AS TOPLAM_SATIS_2
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.ShipCountry
)
SELECT
C1.ShipCountry,
ROUND((C1.CALISAN_1_SATIS / C1.TOPLAM_SATIS_1) * 100, 2 )  AS CALISAN1_PERFORMANS,
ROUND(C2.CALISAN_2_SATIS / C2.TOPLAM_SATIS_2 * 100,2) AS CALISAN_2_PERFORMANS
FROM CALISAN1 AS C1
JOIN CALISAN2 C2 ON C1.ShipCountry = C2.ShipCountry
GROUP BY C1.ShipCountry,C1.CALISAN_1_SATIS,C1.TOPLAM_SATIS_1,C2.CALISAN_2_SATIS,C2.TOPLAM_SATIS_2



---------
SELECT O.ShipCountry,
ROUND(SUM(CASE WHEN O.EmployeeID = 1 THEN OD.Quantity * OD.UnitPrice ELSE 0 END)
/ 
CAST(SUM(OD.Quantity*OD.UnitPrice)AS float) * 100,2) AS EMPLOYEE1,
ROUND(SUM(CASE WHEN O.EmployeeID = 2 THEN OD.Quantity * OD.UnitPrice ELSE 0 END)
/
CAST(SUM(OD.Quantity * OD.UnitPrice)AS float) * 100,2) AS EMPLOYEE2
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.ShipCountry


------------
SELECT 
E.EmployeeID,E.FirstName,E.LastName,
SUM(CASE WHEN O.ShipCountry IN ('Germany', 'Switzerland','Austria') THEN OD.Quantity * OD.UnitPrice ELSE 0 END) dasch_countries,
SUM(CASE WHEN O.ShipCountry NOT IN ('Germany', 'Switzerland','Austria') THEN OD.Quantity * OD.UnitPrice ELSE 0 END) other_countries
FROM Orders O 
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
INNER JOIN Employees E ON O.EmployeeID = E.EmployeeID
GROUP BY E.EmployeeID,E.FirstName,E.LastName



---------
