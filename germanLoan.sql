-- count people who have good (1) and bad (2) credit risk
SELECT CreditRisk, COUNT(CreditRisk)
FROM 'german_credit_cleaned.csv'
GROUP BY CreditRisk;

-- list of all unique purposes and the total amount of money disbursed for each of them
SELECT distinct(Purpose), CONCAT('€ ',SUM(Amount)) as TotalAmount
FROM 'german_credit_cleaned.csv'
GROUP BY Purpose; 

-- average loan amount for clients over 50 y.o.
SELECT Purpose, CONCAT('€ ', ROUND(AVG(Amount), 2)) as AvgAmount
FROM 'german_credit_cleaned.csv'
WHERE Age >=50
GROUP BY Purpose; 

-- number of clients by age group
SELECT COUNT(Age), 
	   case 
	      when Age < 25 then 'Young'
	      when Age > 55 then 'Senior'
	      else 'Adult'
	   end as AgeCategory
FROM 'german_credit_cleaned.csv'
GROUP BY AgeCategory; 

-- types of housing and percentage of "bad" loans for each type
SELECT Housing,
	   CONCAT(ROUND(
	       (SUM(case 
	               when CreditRisk = 'Bad' then 1 
	               else 0 
	            end)/COUNT(CreditRisk))*100, 2), ' %') as Presentage
FROM 'german_credit_cleaned.csv'
GROUP BY Housing; 

-- clients whose loan amount is higher than the average for all clients
WITH GeneralAvgAmount AS (
	SELECT AVG(Amount) as AvgAm
	FROM 'german_credit_cleaned.csv'
)

SELECT DISTINCT(Purpose), Amount
FROM 'german_credit_cleaned.csv'
WHERE Amount > ALL(SELECT AvgAm FROM GeneralAvgAmount); 

-- purpose with the largest average loan amount
WITH MaxAvgAmount AS (
	SELECT AVG(Amount) as AvgAm
	FROM 'german_credit_cleaned.csv'
)

SELECT DISTINCT(Purpose), CONCAT('€ ', ROUND(AVG(Amount), 2)) as HighestAmount
FROM 'german_credit_cleaned.csv'
WHERE Amount > ALL(SELECT AvgAm FROM MaxAvgAmount)
GROUP BY Purpose
ORDER BY AVG(Amount) DESC
LIMIT 3; 

