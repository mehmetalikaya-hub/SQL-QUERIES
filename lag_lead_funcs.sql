--1
SELECT RegionID,RegionDescription,
LEAD(RegionDescription) OVER(ORDER BY RegionID)
from Region;

--2
SELECT OrderDate,Freight,
LEAD(Freight) OVER(ORDER BY OrderDate)
FROM Orders

--3
SELECT P.ProductID,
O.ShippedDate,
OD.Quantity,
LEAD(P.UnitsOnOrder) OVER(ORDER BY O.ShippedDate) SÝPARÝS_ADET
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
INNER JOIN Orders O ON OD.OrderID = O.OrderID
WHERE O.ShippedDate IS NOT NULL;


--4
SELECT O.OrderDate,
SUM(OD.Quantity * OD.UnitPrice) AS BUGUNKÜ_GELÝR,
LEAD(SUM(OD.Quantity * OD.UnitPrice)) OVER(ORDER BY O.OrderDate) SONRAKÝ_GÜN_GELÝR,
SUM(OD.Quantity * OD.UnitPrice)-LEAD(SUM(OD.Quantity * OD.UnitPrice)) OVER(ORDER BY O.OrderDate) AS GELÝR_FARK
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderDate

--5
SELECT O.OrderDate,
SUM(OD.Quantity * OD.UnitPrice) AS BUGUNKÜ_GELÝR,
LEAD(SUM(OD.Quantity * OD.UnitPrice),7) OVER(ORDER BY O.OrderDate) AS BÝR_HAFTA_SONRAKÝ_GÜN_GELÝR,
SUM(OD.Quantity * OD.UnitPrice)- LEAD(SUM(OD.Quantity * OD.UnitPrice),7) OVER(ORDER BY O.OrderDate) AS GELÝR_FARK
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderDate

--6
SELECT O.OrderDate,
SUM(OD.Quantity * OD.UnitPrice) AS BUGUNKÜ_GELÝR,
LEAD(SUM(OD.Quantity * OD.UnitPrice),7,0) OVER(ORDER BY O.OrderDate) AS BÝR_HAFTA_SONRAKÝ_GÜN_GELÝR,
SUM(OD.Quantity * OD.UnitPrice)- LEAD(SUM(OD.Quantity * OD.UnitPrice),7,0) OVER(ORDER BY O.OrderDate) AS GELÝR_FARK
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderDate

--7
SELECT RegionID,RegionDescription,
LAG(RegionDescription) OVER(ORDER BY RegionID)
from Region;

--8
SELECT P.ProductID,
O.ShippedDate,
OD.Quantity,
LAG(P.UnitsOnOrder,3) OVER(ORDER BY O.ShippedDate) ÜÇ_GÜN_ÖNCEKÝ_SÝPARÝS_ADET
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
INNER JOIN Orders O ON OD.OrderID = O.OrderID
WHERE O.ShippedDate IS NOT NULL;

--9
SELECT P.ProductID,
O.ShippedDate,
OD.Quantity,
LAG(P.UnitsOnOrder,3,-1) OVER(ORDER BY O.ShippedDate) ÜÇ_GÜN_ÖNCEKÝ_SÝPARÝS_ADET
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
INNER JOIN Orders O ON OD.OrderID = O.OrderID
WHERE O.ShippedDate IS NOT NULL;

--10
SELECT
OrderID,
CustomerID,
FIRST_VALUE(Freight) OVER(ORDER BY OrderDate) AS ILK_DEGER
FROM
Orders
WHERE ShipVia = 1;

--11
SELECT
OrderID,
CustomerID,
FIRST_VALUE(Freight) OVER(ORDER BY Freight) AS EN_AZ_AGIRLIK
FROM
Orders
WHERE ShipVia = 1;

--12
SELECT
OrderID,
CustomerID,
ShipCity,
OrderDate,
LAST_VALUE(OrderDate) OVER(ORDER BY OrderDate) AS SON_SIPARIS_TARIHI
FROM Orders

--13

SELECT
OrderID,
CustomerID,
ShipCity,
OrderDate,
LAST_VALUE(OrderDate) OVER(
ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS EN_SON_SIPARIS_TARIHI
FROM Orders

--14

SELECT OD.UnitPrice,
OD.Quantity,
LAST_VALUE(OD.Quantity) OVER(ORDER BY O.OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) EN_SON_ALINAN_ADET
FROM 
[Order Details] OD
JOIN Orders O ON OD.OrderID = O.OrderID


--15

WITH GELIR_TABLO
AS
(
SELECT
O.OrderDate,
SUM((OD.Quantity * OD.UnitPrice) * (1-OD.Discount)) AS NET_GELIR
FROM Orders O
JOIN 
[Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderDate
)
SELECT TOP 1
LAST_VALUE(NET_GELIR) OVER(ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS EN_YUKSEK_GELIR,
FIRST_VALUE(NET_GELIR) OVER(ORDER BY OrderDate ) AS EN_DUSUK_GELIR
FROM 
GELIR_TABLO


 

