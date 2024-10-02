SELECT *
FROM  us_household_income;

SELECT *
FROM us_household_statistics;
  
 ALTER TABLE us_household_statistics RENAME COLUMN `ï»¿id` TO `ID`;
 
-- CHECK FOR DUPLICATES: 
SELECT ID, COUNT(ID)
FROM us_household_statistics
GROUP BY ID
HAVING COUNT(ID)>1;

SELECT *
FROM (
SELECT ROW_ID, ID,
ROW_NUMBER() OVER(PARTITION BY ID ORDER BY ID) row_n
FROM us_household_income) as duplicate
WHERE row_n > 1 ;

DELETE FROM us_household_income
WHERE ROW_ID IN (SELECT ROW_ID
FROM (
	SELECT ROW_ID, ID, 
	ROW_NUMBER() OVER(PARTITION BY ID ORDER BY ID) row_n
FROM us_household_income) as duplicate
WHERE row_n > 1;

SELECT DISTINCT STATE_NAME
FROM us_household_income
GROUP BY STATE_NAME
ORDER BY 1;

UPDATE us_household_income 
SET STATE_NAME = 'Georgia'
WHERE STATE_NAME ='georia';

UPDATE us_household_income 
SET STATE_NAME = 'Alabama'
WHERE STATE_NAME ='alabama';

SELECT DISTINCT state_ab
FROM us_household_income
GROUP BY state_ab
ORDER BY 1;

SELECT *
from us_household_income
WHERE COUNTY = 'Autauga County'
ORDER BY 1;

UPDATE us_household_income
SET PLACE = 'Autaugaville'
WHERE COUNTY = 'Autauga County'
AND CITY = 'Vinemont' ;

SELECT type, COUNT(TYPE)
FROM us_household_income
GROUP BY TYPE
ORDER BY 1;

UPDATE us_household_income
SET TYPE = 'Borough'
WHERE TYPE = 'Boroughs';

--  EXPLORATOTY DATA ANALYSIS:  
-- Q. We would like to know how much AWater per state 
SELECT *
FROM us_household_income;

SELECT *
FROM us_household_statistics;
 
SELECT State_name, SUM(ALand), SUM(AWater) -- DO A SUM OF ALAND PER STATE
FROM us_household_income
GROUP BY State_Name
ORDER BY 3 DESC -- TEXAS & CALIFORNIA ARE THE BIGGEST STATE & MICHIGAN HAS THE BIGGEST AWATER 
LIMIT 10;

-- JOINING BOTH TABLES: 
SELECT *
FROM us_household_income u
JOIN us_household_statistics uss
ON u.id = uss.id
WHERE MEAN <> 0  ;  -- WE'RE GOING TO FILTER THE ROWS THAT DON'T HAVE ANY INFORMATION

SELECT U.State_Name, County, TYPE, `Primary`, MEAN, MEDIAN
FROM us_household_income u
JOIN us_household_statistics uss
ON u.id = uss.id
WHERE MEAN <> 0;

-- CHECKING THE AVG ON MEAN & MEDIAN 
SELECT U.State_Name, ROUND(AVG(MEAN),1), ROUND(AVG(MEDIAN),1) 
FROM us_household_income u
JOIN us_household_statistics uss
ON u.id = uss.id
WHERE MEAN <> 0
GROUP BY U.State_Name
ORDER BY 2 DESC -- AVG HOUSEHOLD INCOME (LOWEST & MAX)  
LIMIT 5;

-- CHECKING ON TYPE
SELECT TYPE, COUNT(TYPE), ROUND(AVG(MEAN),1), ROUND(AVG(MEDIAN),1) 
FROM us_household_income u
JOIN us_household_statistics uss
ON u.id = uss.id
WHERE MEAN <> 0
GROUP BY TYPE
HAVING COUNT(TYPE)> 100 -- FILTER TO THE HIGHEST VOLUME FOR THIS DATA
ORDER BY 4 DESC ;

-- WHICH STATE HAS COMMUNITY 
SELECT * FROM us_household_income
WHERE TYPE = 'COMMUNITY';

-- WHICH CITY HAS THE HIGHEST INCOME 
SELECT u.State_name, city, ROUND(AVG(MEAN),1), ROUND(AVG(MEDIAN),1) 
FROM us_household_income u
JOIN us_household_statistics uss
ON u.id = uss.id
WHERE MEAN <> 0 
GROUP BY city, u.State_name
ORDER BY ROUND(AVG(MEAN),1) DESC ;

