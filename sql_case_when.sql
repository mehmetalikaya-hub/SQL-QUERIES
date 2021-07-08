
------------------------------
SELECT FROMWHO,
CASE WHEN FROMWHO = 'Galeriden' THEN 1
	WHEN FROMWHO = 'Sahibinden' THEN  0
	END AS FROMWHO
FROM WEBOFFERS


-------------------------------------
SELECT
SUM(CASE WHEN DATEPART(YEAR,YEAR_) BETWEEN 2018 AND 2019 THEN PRICE END) AS ikibin_onsekiz_ondokuz, 
SUM(CASE WHEN DATEPART(YEAR,YEAR_) BETWEEN 2016 AND 2017 THEN PRICE END) AS ikibin_onaltý_onyedi
FROM WEBOFFERS
WHERE BRAND = 'Audi'

------------------------

-----------------------------

SELECT U.USERNAME_,U.GENDER,W.KM,
CASE WHEN W.KM > 200000 THEN 'Yüksek Kilometre'
	WHEN W.KM BETWEEN 100000 AND 200000 THEN 'Normal Kilometre'
	ELSE 'Ýdeal Kilometre'
	END AS Kilometre_Analiz
FROM WEBOFFERS W
INNER JOIN USER_ U ON U.ID = W.USERID
-----------------------------

ORDER BY ÝLE yerleþtir ve tekrar anlaT.

SELECT U.USERNAME_,U.GENDER,W.KM,
CASE WHEN W.KM > 200000 THEN 'Yüksek Kilometre'
	WHEN W.KM BETWEEN 100000 AND 200000 THEN 'Normal Kilometre'
	ELSE 'Ýdeal Kilometre'
	END AS Kilometre_Analiz
FROM WEBOFFERS W
INNER JOIN USER_ U ON U.ID = W.USERID
ORDER BY 3 DESC


----------------------------------
SELECT BRAND,RAISEPRICE,
CASE
	WHEN RAISEPRICE BETWEEN 10000 AND 50000 THEN 'Baþlangýç'
	WHEN RAISEPRICE > 50000 AND RAISEPRICE <=200000 THEN 'Orta'
	WHEN RAISEPRICE > 200000 AND RAISEPRICE <=400000 THEN 'Pahalý' 
	WHEN RAISEPRICE > 400000 THEN 'Lüks'
	ELSE 'Pertli Araç'
	END AS Fiyat_Kategori
FROM WEBOFFERS

---------------------------

---------------------------

SELECT BRAND,
SUM(CASE  WHEN FROMWHO = 'Sahibinden' THEN 1 ELSE 0 END ) AS sahibinden_toplam_arac,
SUM(CASE WHEN FROMWHO = 'Galeriden' THEN 1 ELSE 0 END ) AS galeriden_toplam_arac
FROM WEBOFFERS
WHERE FROMWHO IS NOT NULL
GROUP BY BRAND
ORDER BY 1 ASC;


--------------------------------
SELECT 
SUM(CASE WHEN FUEL = 'Benzin' THEN 1 ELSE 0 END ) AS Benzinli_arac,
SUM(CASE WHEN FUEL = 'Dizel' THEN 1 ELSE 0 END ) AS Dizel_arac,
SUM(CASE WHEN FUEL = 'Benzin/LPG' THEN 1 ELSE 0 END ) AS Benzin_LPG_arac,
SUM(CASE WHEN FUEL IS NULL THEN 1 ELSE 0 END) AS Diger
FROM WEBOFFERS
WHERE COLOR IN('Beyaz','Gümüþ Gri')
-------------------------------------


-----------------------------
SELECT COUNT(*) AS TOPLAM_ARAC_SAYISI, 
COUNT(CASE
	WHEN DATEDIFF(YEAR,YEAR_,GETDATE()) >= 30  THEN 'ARAC HURDA TESVÝK ALABÝLÝR'
	END) AS HURDA_ARAC_TESVÝK_SAYISI
FROM WEBOFFERS

--------------------------------
SELECT ORIGIN,COUNT(*) AS TOPLAM_ARAC_SAYISI, 
COUNT(CASE
	WHEN DATEDIFF(YEAR,YEAR_,GETDATE()) >= 30  THEN 'ARAC HURDA TESVÝK ALABÝLÝR'
	END) AS HURDA_ARAC_SAYISI
FROM WEBOFFERS
GROUP BY ORIGIN
ORDER BY HURDA_ARAC_SAYISI DESC

---------------------------------


UPDATE WEBOFFERS 
SET ORIGIN = (CASE 
	WHEN BRAND IN('Audi','BMW','Mercedes','Volkswagen','Porsche') THEN 'Almanya'
	WHEN BRAND IN('Chevrolet','Ford') THEN 'ABD'
	WHEN BRAND IN('Citroen','Dacia','Peugeot','Renault') THEN 'Fransa'
	WHEN BRAND IN('Fiat','Jeep') THEN 'Ýtalya'
	WHEN BRAND IN('Honda','Hyundai','Toyota','Suzuki','Nissan','Mazda') THEN 'Japonya'
	WHEN BRAND = 'Kia' THEN 'Güney Kore'
	WHEN BRAND = 'Tofaþ' THEN 'Türkiye'
	WHEN BRAND = 'Volvo' THEN 'Ýsviçre'
	WHEN BRAND = 'Skoda' THEN 'Çek Cumhuriyeti'
	WHEN BRAND = 'Seat' THEN 'Ýspanya'
END)



---------------------------------


---------------------------

SELECT U.USERNAME_,
SUM(CASE WHEN SHIFTTYPE = 'Düz Vites' THEN 1 ELSE 0 END) AS duz_vites_araclar,
SUM(CASE WHEN SHIFTTYPE = 'Yarý Otomatik Vites' THEN 1 ELSE 0 END) AS yari_otomatik_araclar,
SUM(CASE WHEN SHIFTTYPE = 'Otomatik Vites' THEN 1 ELSE 0 END) AS otomatik_araclar
FROM WEBOFFERS W
LEFT JOIN USER_ U ON U.ID = W.USERID
WHERE SHIFTTYPE IS NOT NULL
GROUP BY U.USERNAME_
ORDER BY U.USERNAME_

----------------------------

SELECT BRAND,
COUNT(CASE WHEN FROMWHO = 'Sahibinden' THEN ID END) AS sahibinden_toplam,
COUNT(CASE WHEN FROMWHO = 'Galeriden' THEN ID END) AS galeriden_toplam
FROM WEBOFFERS
WHERE BRAND = 'Audi'
AND BRAND IS NOT NULL
GROUP BY BRAND

-----------------------------

SELECT BRAND,
COUNT(DISTINCT CASE WHEN FROMWHO = 'Sahibinden' THEN USERID END) AS sahibinden_toplam,
COUNT(DISTINCT CASE WHEN FROMWHO = 'Galeriden' THEN USERID END) AS galeriden_toplam
FROM WEBOFFERS
INNER JOIN USER_ U ON U.ID = WEBOFFERS.USERID
WHERE BRAND = 'Audi'
AND BRAND IS NOT NULL
GROUP BY BRAND

----------------------------

SELECT 
SUM(CASE WHEN DATEDIFF(YEAR,YEAR_,GETDATE()) = 0 THEN 1 ELSE 0 END) AS sifir_kilometre,
SUM(CASE WHEN DATEDIFF(YEAR,YEAR_,GETDATE()) BETWEEN 1 AND 10 THEN 1 ELSE 0 END) AS bir_on_yil,
SUM(CASE WHEN DATEDIFF(YEAR,YEAR_,GETDATE()) BETWEEN 11 AND 20 THEN 1 ELSE 0 END) AS on_yirmi_yil,
SUM(CASE WHEN DATEDIFF(YEAR,YEAR_,GETDATE()) BETWEEN 21 AND 30 THEN 1 ELSE 0 END) AS yirmi_otuz_yil,
SUM(CASE WHEN DATEDIFF(YEAR,YEAR_,GETDATE()) >= 31 THEN 1 ELSE 0 END) AS otuz_yýl_ustu
FROM WEBOFFERS


------------------------------------
SELECT U.USERNAME_,U.GENDER,MAX(PRICE) AS MAKSIMUM_FIYAT
FROM WEBOFFERS W
INNER JOIN USER_ U ON U.ID = W.USERID
GROUP BY W.BRAND,U.USERNAME_,U.GENDER
HAVING(MAX(CASE WHEN U.GENDER = 'E' THEN W.PRICE ELSE NULL END) > 500000
OR
MAX(CASE WHEN U.GENDER = 'K' THEN W.PRICE ELSE NULL END) > 500000)
ORDER BY MAKSIMUM_FIYAT DESC

---------------------------------


-------------------

SELECT SUM( 
CASE	
	WHEN KM = 0	THEN 1 ELSE 0
	END) AS 'SIFIR_KM_ARAC_SAYISI',
SUM(CASE 
	WHEN KM BETWEEN 50000 AND 99999
	THEN 1 ELSE 0
	END) AS '50BIN_100BIN_KM',
SUM(CASE
	WHEN KM BETWEEN 100000 AND 499999 THEN 1 ELSE 0
	END) AS '100_BIN_500BIN_KM',
SUM(CASE
WHEN KM >=500000 THEN 1 ELSE 0
END) AS '500BIN_KM_USTU'
FROM WEBOFFERS	






