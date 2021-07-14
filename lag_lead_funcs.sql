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
LEAD(P.UnitsOnOrder) OVER(ORDER BY O.ShippedDate) S�PAR�S_ADET
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
INNER JOIN Orders O ON OD.OrderID = O.OrderID
WHERE O.ShippedDate IS NOT NULL;


--4
SELECT O.OrderDate,
SUM(OD.Quantity * OD.UnitPrice) AS BUGUNK�_GEL�R,
LEAD(SUM(OD.Quantity * OD.UnitPrice)) OVER(ORDER BY O.OrderDate) SONRAK�_G�N_GEL�R,
SUM(OD.Quantity * OD.UnitPrice)-LEAD(SUM(OD.Quantity * OD.UnitPrice)) OVER(ORDER BY O.OrderDate) AS GEL�R_FARK
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderDate

--5
SELECT O.OrderDate,
SUM(OD.Quantity * OD.UnitPrice) AS BUGUNK�_GEL�R,
LEAD(SUM(OD.Quantity * OD.UnitPrice),7) OVER(ORDER BY O.OrderDate) AS B�R_HAFTA_SONRAK�_G�N_GEL�R,
SUM(OD.Quantity * OD.UnitPrice)- LEAD(SUM(OD.Quantity * OD.UnitPrice),7) OVER(ORDER BY O.OrderDate) AS GEL�R_FARK
FROM Orders O
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY O.OrderDate

--6
SELECT O.OrderDate,
SUM(OD.Quantity * OD.UnitPrice) AS BUGUNK�_GEL�R,
LEAD(SUM(OD.Quantity * OD.UnitPrice),7,0) OVER(ORDER BY O.OrderDate) AS B�R_HAFTA_SONRAK�_G�N_GEL�R,
SUM(OD.Quantity * OD.UnitPrice)- LEAD(SUM(OD.Quantity * OD.UnitPrice),7,0) OVER(ORDER BY O.OrderDate) AS GEL�R_FARK
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
LAG(P.UnitsOnOrder,3) OVER(ORDER BY O.ShippedDate) ��_G�N_�NCEK�_S�PAR�S_ADET
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
INNER JOIN Orders O ON OD.OrderID = O.OrderID
WHERE O.ShippedDate IS NOT NULL;

--9
SELECT P.ProductID,
O.ShippedDate,
OD.Quantity,
LAG(P.UnitsOnOrder,3,-1) OVER(ORDER BY O.ShippedDate) ��_G�N_�NCEK�_S�PAR�S_ADET
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
INNER JOIN Orders O ON OD.OrderID = O.OrderID
WHERE O.ShippedDate IS NOT NULL;

--