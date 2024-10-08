-- CLEANING DATA FROM A TABLE: ALWAYS CREATE A DUPLICATE 

-- SET sql_safe_updates=0; TURN OFF SAFE MODE
-- SET sql_safe_updates=1;TURN ON SAFE MODE
SELECT * FROM customer_sweepstakes_solo;

ALTER TABLE customer_sweepstakes_solo RENAME COLUMN `ï»¿sweepstake_id` TO `sweepstake_id`;

-- 1. REMOVE DUPLICATES

SELECT CUSTOMER_ID, COUNT(CUSTOMER_ID)
FROM CUSTOMER_SWEEPSTAKES_SOLO
GROUP BY CUSTOMER_ID
HAVING COUNT(CUSTOMER_ID)>1;  -- WE WANT TO FILTER WHO'S ON THE LIST MORE THAN 1 TIME 

DELETE FROM CUSTOMER_SWEEPSTAKES_SOLO
WHERE SWEEPSTAKE_ID IN (
SELECT SWEEPSTAKE_ID
FROM (
SELECT SWEEPSTAKE_ID, 
ROW_NUMBER() OVER(PARTITION BY CUSTOMER_ID ORDER BY CUSTOMER_ID) AS ROW_N
FROM CUSTOMER_SWEEPSTAKES_SOLO) AS TABLE_ROW
WHERE ROW_N > 1); -- CREATE A SUBQ. TO FILTER ONLY THE DUPLICATES, AFTER THIS, IT WILL DELETE THE DUPLICATE ROWS FROM SWEEPSTAKE_ID

-- 2. STANDARDIZING DATA: PHONE
SELECT * FROM CUSTOMER_SWEEPSTAKES_SOLO;

SELECT PHONE 
FROM CUSTOMER_SWEEPSTAKES_solo; -- REMOVE SPECIAL CHARACTERS WITH ONE STATEMENT

SELECT PHONE, REGEXP_REPLACE (PHONE, '[()-/+]','') -- WE'RE REPLACING ANY CHARACTER THAT'S IN THE BRACKET WITH NO SPACE
FROM CUSTOMER_SWEEPSTAKES_SOLO;

UPDATE CUSTOMER_SWEEPSTAKES_SOLO
SET PHONE = REGEXP_REPLACE (PHONE, '[()-/+]',''); 

SELECT PHONE, substring(PHONE, 1, 3), substring(PHONE, 4, 3) , substring(PHONE, 7, 4)  -- FORMAT BY DIVING WITH SUBSTRING
FROM CUSTOMER_SWEEPSTAKES_solo;

SELECT PHONE, CONCAT(substring(PHONE, 1, 3),'-', substring(PHONE, 4, 3) ,'-', substring(PHONE, 7, 4)) -- CONCAT WILL ADD '-' BETWEEN THE DIGITS
FROM CUSTOMER_SWEEPSTAKES_SOLO
WHERE PHONE <> ''; -- ADD THIS STATEMENT TO NOT ADD '-' ON THE ROWS THAT DON'T HAVE PHONE NUMBER

UPDATE CUSTOMER_SWEEPSTAKES_SOLO
SET PHONE = CONCAT(substring(PHONE, 1, 3),'-', substring(PHONE, 4, 3) ,'-', substring(PHONE, 7, 4))
WHERE PHONE <> '';

-- 2.1 STANDARDIZE DATA: BIRTH_DATE

SELECT * FROM CUSTOMER_SWEEPSTAKES_SOLO;
SELECT BIRTH_DATE FROM CUSTOMER_SWEEPSTAKES_SOLO;

SELECT BIRTH_DATE, str_to_date(BIRTH_DATE, '%m/%d/%Y'), -- FILTER THE PHONE #s ACCORDING TO THE DATE SET 
str_to_date(BIRTH_DATE, '%Y/%d/%m') 
FROM CUSTOMER_SWEEPSTAKES_SOLO; 

SELECT BIRTH_DATE,
IF( str_to_date(BIRTH_DATE, '%m/%d/%Y') IS NOT NULL, str_to_date(BIRTH_DATE, '%m/%d/%Y'),
 str_to_date(BIRTH_DATE, '%Y/%d/%m')), -- IF THE DATE IS NOT NULL, THEN WE CHANGE TO m/d/Y BUT IF IT'S NULL, THEN IT CHANGES TO Y/m/d
 str_to_date(BIRTH_DATE, '%m/%d/%Y'),
str_to_date(BIRTH_DATE, '%Y/%d/%m')
FROM CUSTOMER_SWEEPSTAKES_SOLO;

UPDATE CUSTOMER_SWEEPSTAKES_SOLO
SET BIRTH_DATE = IF( str_to_date(BIRTH_DATE, '%m/%d/%Y') IS NOT NULL, str_to_date(BIRTH_DATE, '%m/%d/%Y'),
 str_to_date(BIRTH_DATE, '%Y/%d/%m'));
 
-- DIFFERENT WAY: CASE STATEMENT
UPDATE CUSTOMER_SWEEPSTAKES_SOLO
SET BIRTH_DATE = CASE 
WHEN str_to_date(BIRTH_DATE, '%m/%d/%Y') IS NOT NULL THEN str_to_date(BIRTH_DATE, '%m/%d/%Y')
WHEN str_to_date(BIRTH_DATE, '%m/%d/%Y') IS NULL THEN  str_to_date(BIRTH_DATE, '%Y/%d/%m')
END;

-- DIFFERENT WAY: 
SELECT * FROM CUSTOMER_SWEEPSTAKES_SOLO;

SELECT BIRTH_DATE, CONCAT(SUBSTRING(BIRTH_DATE, 9,2), '/',SUBSTRING(BIRTH_DATE, 6,2),'/', SUBSTRING(BIRTH_DATE, 1,4))
FROM CUSTOMER_SWEEPSTAKES_SOLO;

UPDATE CUSTOMER_SWEEPSTAKES_SOLO
SET BIRTH_DATE = CONCAT(SUBSTRING(BIRTH_DATE, 9,2), '/',SUBSTRING(BIRTH_DATE, 6,2),'/', SUBSTRING(BIRTH_DATE, 1,4))
WHERE SWEEPSTAKE_ID IN (9,11);

UPDATE CUSTOMER_SWEEPSTAKES_SOLO
SET BIRTH_DATE = str_to_date(BIRTH_DATE, '%m/%d/%Y');

-- 2.2 STANDARDIZE: `Are you over 18?`

SELECT * FROM CUSTOMER_SWEEPSTAKES_SOLO;

SELECT `Are you over 18?`,
CASE 
WHEN `Are you over 18?` = 'YES' THEN 'Y'
WHEN `Are you over 18?` = 'NO' THEN 'N'
ELSE `Are you over 18?`
END
FROM CUSTOMER_SWEEPSTAKES_SOLO;

UPDATE CUSTOMER_SWEEPSTAKES_SOLO
SET `Are you over 18?` = 
CASE 
WHEN `Are you over 18?` = 'YES' THEN 'Y'
WHEN `Are you over 18?` = 'NO' THEN 'N'
ELSE `Are you over 18?`
END;

SELECT BIRTH_DATE, `Are you over 18?`
FROM CUSTOMER_SWEEPSTAKES_SOLO
WHERE (YEAR(now()) - 18) > YEAR(BIRTH_DATE);

UPDATE CUSTOMER_SWEEPSTAKES_SOLO
SET `Are you over 18?` = 'Y'
WHERE (YEAR(now()) - 18) > YEAR(BIRTH_DATE);

SELECT * FROM CUSTOMER_SWEEPSTAKES_SOLO;
SELECT COUNT(SWEEPSTAKE_ID),COUNT(PHONE) 
FROM CUSTOMER_SWEEPSTAKES_SOLO;

UPDATE CUSTOMER_SWEEPSTAKES_SOLO
SET PHONE = NULL 
WHERE PHONE = '';

UPDATE CUSTOMER_SWEEPSTAKES_SOLO
SET INCOME = NULL 
WHERE INCOME = '';

SELECT * FROM CUSTOMER_SWEEPSTAKES_SOLO;



