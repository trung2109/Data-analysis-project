SELECT * FROM AIRLINES

SELECT Airline, COUNT(Airline) AS Flight  FROM AIRLINES
GROUP BY Airline
ORDER BY COUNT(Airline) DESC

SELECT Airline, Flight, ROUND(CAST(AVG AS FLOAT)/Flight,2) AS Recommended_rate FROM (SELECT A.Airline, Recommended, AVG, Flight FROM (SELECT Airline, Recommended, COUNT(Recommended) AS AVG FROM AIRLINES
GROUP BY Recommended, Airline) A
JOIN (SELECT Airline, COUNT(Airline) AS Flight FROM AIRLINES
GROUP BY Airline) B
ON A.Airline = B.Airline) C
WHERE Recommended = 'yes'
ORDER BY Flight DESC
-- HIGH AMOUNT: Qatar Airways, Turkish Airways (>1000)
-- LOW AMOUNT:  EVA Air, All Nippon Airways, Japan Airlines, Korean Air(<300)
-- Những hãng có Tỉ lệ Recommended cao nhất: Qatar Airways, All Nippon Airways, 
-- 2 Hãng hàng không phổ biến nhất có tình trạng tỉ lệ Recommended ngược nhau, khi Qatar Airways khá cao thì Turkish Airways có tỉ lệ Recommended thấp nhất

WITH RAW_DATA AS( SELECT Airline, Flight, ROUND(CAST(AVG AS FLOAT)/Flight,2) AS Recommended_rate FROM (SELECT A.Airline, Recommended, AVG, Flight FROM (SELECT Airline, Recommended, COUNT(Recommended) AS AVG FROM AIRLINES
GROUP BY Recommended, Airline) A
JOIN (SELECT Airline, COUNT(Airline) AS Flight FROM AIRLINES
GROUP BY Airline) B
ON A.Airline = B.Airline) C
WHERE Recommended = 'yes')
SELECT Market_share, ROUND(AVG(Recommended_rate),2) AS AVG FROM (
SELECT Airline, Recommended_rate, 
CASE
WHEN Flight >= 1000 THEN 'high'
WHEN Flight <= 200 THEN 'low'
ELSE 'medium'
END AS Market_share
FROM RAW_DATA) A
GROUP BY Market_share
-- Các hãng hàng không có thị phần thấp sẽ được khách hàng recommend nhiều hơn, tỉ lệ này giảm giần khi đến các nhóm hãng có thị phần lớn hơn
-- Qatar Airways tuy có thị phần lớn nhưng tỉ lệ recommended vẫn rất cao

SELECT A.Airline, Class, ROUND(CAST(Flight AS FLOAT)/TFlight,2) AS Rate FROM (SELECT Airline, Class, COUNT(Class) As Flight FROM AIRLINES 
GROUP BY Airline, Class)A
JOIN 
(SELECT Airline, Count(Airline) AS TFlight FROM AIRLINES 
GROUP BY Airline) B
ON A.Airline = B.Airline
ORDER BY Rate DESC

-- Mạnh về Economy Class: Turkish Airlines, Korean Air, Emirates, Air France
-- Mạnh về Business Class: Qatar Airways
-- Mạnh về First Class: Emirates, All Nippon Airways
-- Mạnh về Premium Economy: EVA Air

SELECT Class, A.Type_of_Traveller , ROUND(CAST(Flight AS FLOAT)/TFlight,2) AS Rate FROM (SELECT Type_of_Traveller, Class, COUNT(Class) As Flight FROM AIRLINES 
GROUP BY Type_of_Traveller, Class)A
JOIN 
(SELECT Type_of_Traveller, Count(Type_of_Traveller) AS TFlight FROM AIRLINES 
GROUP BY Type_of_Traveller) B
ON A.Type_of_Traveller = B.Type_of_Traveller
ORDER BY Class

-- Business Class: Business
-- Economy Class: Family Leisure
-- First Class: Solo Leisure
-- Premium Economy: Couple Leisure