WITH Toplam_Urun_Kategori AS
(
SELECT C.CategoryID,
CASE 
	WHEN C.CategoryID IN (6,8) THEN 'Non-vegetarian'
	ELSE 'Vegetarian'
	END AS Kategori_Tur,
COUNT(*) AS Toplam_Urun
FROM Products P
INNER JOIN Categories C ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryID
)
SELECT Kategori_Tur,
AVG(Toplam_Urun) AS ortalama_urun
FROM Toplam_Urun_Kategori
GROUP BY Kategori_Tur


---------------

WITH Toplam_Harcama_Kontrol AS 
(
SELECT O.CustomerID,
CASE 
	WHEN SUM(OD.UnitPrice * OD.Quantity) > 20000 THEN 'High-Value'
	ELSE 'low-value'
	END AS Harcama_Kontrol
FROM Orders O
INNER JOIN [Order Details] OD ON OD.OrderID = O.OrderID
GROUP BY O.CustomerID
)
SELECT Harcama_Kontrol,
COUNT(CustomerID) AS Harcama_Analiz
FROM Toplam_Harcama_Kontrol
GROUP BY Harcama_Kontrol
-------------

WITH Toplam_Harcamalar AS 
(
SELECT O.EmployeeID,
SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount)) AS TOPLAM_HARCAMA
FROM Orders O
INNER JOIN [Order Details] OD ON OD.OrderID = O.OrderID
GROUP BY O.OrderID,O.EmployeeID
),
Ortalama_Harcamalar AS
(
SELECT  
Toplam_Harcamalar.EmployeeID,
AVG(TOPLAM_HARCAMA) AS Ortalama_Harcama
FROM
Toplam_Harcamalar
GROUP BY Toplam_Harcamalar.EmployeeID
)
SELECT
ROUND(MIN (Ortalama_Harcama),2) AS minimum_ortalama_harcama,
ROUND(MAX(Ortalama_Harcama),2) AS maksimum_ortalama_harcama
FROM Ortalama_Harcamalar



------------------------

WITH TOTAL_VALUES AS 
(
SELECT O.OrderID,
SUM(OD.UnitPrice * OD.Quantity) AS TOTAL_VALUE
FROM Orders O
INNER JOIN [Order Details] OD ON OD.OrderID = O.OrderID
WHERE O.ShipCountry = 'Italy'
GROUP BY O.OrderID
),
Average_Prices AS
(
SELECT
AVG(TOTAL_VALUE) AS AVERAGE_VALUE
FROM TOTAL_VALUES 
)
SELECT
TP.OrderID,
TP.TOTAL_VALUE,
AP.AVERAGE_VALUE
FROM TOTAL_VALUES TP,Average_Prices AP
WHERE TP.TOTAL_VALUE > AP.AVERAGE_VALUE


-------------------------
WITH Items_total_count AS 
(
SELECT
O.OrderID,
O.EmployeeID,
SUM(OD.Quantity) AS Items_Count
FROM Orders O
JOIN [Order Details] OD ON OD.OrderID = O.OrderID
WHERE O.OrderDate >= '1996-01-01' AND O.OrderDate < '2017-01-01'
GROUP BY O.OrderID,O.EmployeeID
)
SELECT
E.FirstName,
E.LastName,
AVG(Items_Count) AS Average_Item_Quantity
FROM Items_total_count AS ITC
JOIN Employees E ON E.EmployeeID = ITC.EmployeeID
GROUP BY E.FirstName,
E.LastName
ORDER BY 3 DESC


-------------------------
WITH Prica_Kategori AS 
(
SELECT
	CASE WHEN OD.UnitPrice <=20 THEN 'Ucuz'
	ELSE 'Pahalý'
END AS Fiyat_Kategori,
COUNT(OD.OrderID) AS Toplam_Siparis
FROM Orders O
INNER JOIN [Order Details] OD ON OD.OrderID = O.OrderID
GROUP BY OD.UnitPrice
)
SELECT 
PK.Fiyat_Kategori,
AVG(Toplam_Siparis) AS Ortalama_Siparis
FROM Prica_Kategori PK
GROUP BY PK.Fiyat_Kategori


SELECT 
E.EmployeeID,E.FirstName,E.LastName,
SUM(CASE WHEN O.ShipCountry IN ('Germany', 'Switzerland','Austria') THEN OD.Quantity * OD.UnitPrice ELSE 0 END) dasch_countries,
SUM(CASE WHEN O.ShipCountry NOT IN ('Germany', 'Switzerland','Austria') THEN OD.Quantity * OD.UnitPrice ELSE 0 END) other_countries
FROM Orders O 
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
INNER JOIN Employees E ON O.EmployeeID = E.EmployeeID
GROUP BY E.EmployeeID,E.FirstName,E.LastName



SELECT 
C.CustomerID,
SUM(CASE WHEN O.ShippedDate IS NOT NULL THEN 1 END) AS SENDING,
SUM(CASE WHEN O.ShippedDate IS NULL THEN 1 END) AS PENDING
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID


WITH CC AS (

SELECT O.OrderID,
CASE WHEN C.Country = 'France' THEN 'France'
ELSE 'Other'
END AS Customer_Country
FROM 
Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID
)
SELECT 
Customer_Country,
ROUND(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)),2) AS FIYAT
FROM 
CC
INNER JOIN [Order Details] OD ON CC.OrderID = OD.OrderID
GROUP BY Customer_Country
