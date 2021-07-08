SELECT CustomerID,ShipVia,ShipAddress, ShippedDate,
RANK() OVER(ORDER BY ShippedDate DESC) AS SIRA
FROM Orders


SELECT ShippedDate,
DENSE_RANK() OVER(ORDER BY ShippedDate) AS SIRA
FROM Orders
WHERE ShippedDate IS NOT NULL;



SELECT O.OrderDate,
SUM(OD.Quantity* OD.UnitPrice) AS HARCAMA_TOPLAM,
DENSE_RANK() OVER (ORDER BY SUM(OD.Quantity* OD.UnitPrice) DESC) AS HARCAMA_SIRALAMA
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderDate


SELECT ShippedDate,
ROW_NUMBER() OVER(ORDER BY ShippedDate) ROW_NUM_SIRALAMA
FROM Orders
WHERE ShippedDate IS NOT NULL;


SELECT ShippedDate,
RANK() OVER (ORDER BY ShippedDate ) AS RANK_SIRA,
DENSE_RANK() OVER (ORDER BY ShippedDate) AS DENS_RANK_SIRA,
ROW_NUMBER() OVER(ORDER BY ShippedDate) AS ROW_NUM_SIRA
FROM Orders
WHERE ShippedDate IS NOT NULL;


SELECT ProductName,UnitPrice,UnitsInStock,
DENSE_RANK() OVER(ORDER BY UnitsInStock DESC) AS STOK_SIRA
FROM Products


SELECT OrderDate,ShippedDate,
ROW_NUMBER() OVER(ORDER BY OrderDate DESC, ShippedDate DESC) SIRALAMA
FROM Orders
WHERE OrderDate IS NOT NULL
AND ShippedDate IS NOT NULL;



SELECT O.OrderDate,
SUM(OD.Quantity* OD.UnitPrice) AS TOPLAM_HARCAMA,
DENSE_RANK() OVER(ORDER BY O.OrderDate DESC) SÝPARÝS_TARÝH_SIRA
FROM 
Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderDate
ORDER BY TOPLAM_HARCAMA DESC

SELECT O.OrderID,
SUM(OD.Quantity* OD.UnitPrice) AS KAZANC,
NTILE(10) OVER(ORDER BY SUM(OD.Quantity* OD.UnitPrice) DESC) KAZANC_SEGMENT
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderID


WITH SIRALAMA AS (
SELECT O.OrderID,
SUM(OD.Quantity* OD.UnitPrice) AS KAZANC,
NTILE(10) OVER(ORDER BY SUM(OD.Quantity* OD.UnitPrice) DESC) KAZANC_SEGMENT
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderID
)
SELECT * FROM SIRALAMA
WHERE KAZANC_SEGMENT = 5;


SELECT C.CategoryName,P.UnitsOnOrder,
NTILE(3) OVER(ORDER BY P.UnitsOnOrder DESC) AS TALEP_SIRA
FROM Products P
INNER JOIN Categories C ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName,P.UnitsOnOrder


WITH TALEP_SIRALAMA AS
(
SELECT C.CategoryName,P.UnitsOnOrder,
NTILE(3) OVER(ORDER BY P.UnitsOnOrder DESC) AS TALEP_SIRA
FROM Products P
INNER JOIN Categories C ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName,P.UnitsOnOrder
)
SELECT *,
CASE WHEN TALEP_SIRA = 1 THEN 'YÜKSEK TALEP' 
	WHEN TALEP_SIRA = 2 THEN 'ORTALAMA TALEP' 
	ELSE 'DÜÞÜK TALEP' END AS TALEP_DURUM
FROM TALEP_SIRALAMA


WITH SIRALA AS 
(
SELECT ProductName,C.CategoryName,P.UnitPrice,
RANK() OVER(ORDER BY UnitPrice DESC) AS FÝYAT_SIRA
FROM Products P
INNER JOIN Categories C ON P.CategoryID = C.CategoryID
WHERE ProductName IS NOT NULL
)
SELECT * FROM SIRALA 
WHERE FÝYAT_SIRA =1;