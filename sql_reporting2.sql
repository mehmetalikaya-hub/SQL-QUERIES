--STOKTA OLMAYAN URUN YUZDEMÝZ?
SELECT
COUNT(CASE WHEN P.UnitsInStock = 0 THEN P.ProductID END) AS STOK_YOK,
COUNT(P.ProductID) AS TOPLAM_URUN,
ROUND(COUNT(CASE WHEN P.UnitsInStock = 0 THEN P.ProductID END)
/
CAST(COUNT(P.ProductID) AS float) * 100,2) AS YUZDE
FROM Products P

Siparis adeti stok adetini geçen ürün yuzdesi.
SELECT SUM(CASE WHEN UnitsInStock < UnitsOnOrder THEN 1 END) AS SIPARIS_STOK_TEHLIKE,
COUNT(P.ProductID) AS URUN,
ROUND(SUM(CASE WHEN UnitsInStock < UnitsOnOrder THEN 1 END)
/
CAST(COUNT(P.ProductID) AS float) * 100,2) AS YUZDELIK
FROM Products P

1)
SELECT O.CustomerID MUSTERI_ID,
COUNT(DISTINCT OD.OrderID) AS TEKÝL_SÝPARÝS_SAYÝSÝ,
ROUND(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)),0) AS TOPLAM_HARCAMA
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.CustomerID
ORDER BY TOPLAM_HARCAMA DESC

2)
SELECT E.FirstName,E.LastName,E.Title,
COUNT(DISTINCT O.OrderID) AS SATIS_TOPLAM,
ROUND(SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)),0) AS SATIS_TUTARI
FROM Employees E
LEFT JOIN Orders O ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE O.OrderDate BETWEEN '1996-01-01' AND '1996-12-31'
GROUP BY E.EmployeeID,E.FirstName,E.LastName,E.Title

3)
SELECT C.CategoryName AS KATEGORI,
COUNT(CASE WHEN P.UnitsInStock > 0 THEN ProductID END) AS URUN_STOK_ADET,
COUNT(CASE WHEN P.UnitsInStock = 0 THEN ProductID END) AS TUKETILEN_ADET
FROM Categories C
LEFT JOIN Products P ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName


4)

SELECT 
SUM(CASE WHEN Discount > 0 THEN UnitPrice * Quantity * (1-Discount) END) AS INDIRIMLI_FIYAT_TOPLAM,
SUM(UnitPrice * Quantity * (1-Discount)) AS TOPLAM_FIYAT,
SUM(CASE WHEN Discount >0 THEN UnitPrice * Quantity * (1-Discount) END)
/
CAST(SUM(UnitPrice * Quantity * (1-Discount)) AS decimal) * 100 AS ORAN
FROM [Order Details] OD


5)
SELECT E.FirstName,E.LastName,
COUNT(CASE WHEN C.Country = 'France' THEN O.OrderID END) AS FRANSA_SATIS,
COUNT(DISTINCT O.OrderID) AS TOPLAM_SATIS,
ROUND(COUNT(CASE WHEN C.Country = 'France' THEN O.OrderID END)
/
CAST(COUNT(O.OrderID) AS float) * 100,1) AS YUZDELIK
FROM Employees E
LEFT JOIN Orders O ON E.EmployeeID = O.EmployeeID 
LEFT JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY E.EmployeeID,E.FirstName,E.LastName
ORDER BY YUZDELIK DESC

6)
--Eylül 97 de yapýlan toplam harcamayý bul
WITH EYLUL_AY_TOPLAM AS 
(
SELECT
SUM(OD.UnitPrice* OD.Quantity) AS EYLUL_AYI_HARCAMA
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE O.OrderDate >= '1997-09-01' AND O.OrderDate < '1997-10-01'
)
SELECT C.CustomerID,
SUM(OD.Quantity * OD.UnitPrice) AS HARCAMA,
ROUND(SUM(OD.Quantity * OD.UnitPrice)
/
CAST(EYLUL_AY_TOPLAM.EYLUL_AYI_HARCAMA AS decimal) *100,2) AS EYLUL_AY_YUZDELIK
FROM EYLUL_AY_TOPLAM,Customers AS C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID 
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE O.OrderDate <= '1997-07-01' AND O.OrderDate < '1997-10-01'
GROUP BY C.CustomerID,EYLUL_AY_TOPLAM.EYLUL_AYI_HARCAMA
ORDER BY 3 DESC

7)
WITH SIPARIS_SAY AS
(
SELECT COUNT(DISTINCT OrderID) AS TOPLAM_SIPARIS
FROM 
Orders 
WHERE OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
)
SELECT E.EmployeeID,E.FirstName,E.LastName,
COUNT(O.OrderID) AS SIPARIS,
ROUND(COUNT(O.OrderID)
/
CAST(SIPARIS_SAY.TOPLAM_SIPARIS AS float) * 100,2) AS SATIS_ELEMANI_PERF_YUZDE
FROM SIPARIS_SAY,Employees AS E
INNER JOIN Orders O ON E.EmployeeID = O.EmployeeID
WHERE OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
GROUP BY E.EmployeeID,E.FirstName,E.LastName,SIPARIS_SAY.TOPLAM_SIPARIS
ORDER BY 5 DESC