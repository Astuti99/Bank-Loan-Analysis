--1. How does the credit score trend across different age ranges?
select 
CASE 	
	WHEN Age BETWEEN 20 AND 30 -- AGE >= 20 AND AGE<= 30
		THEN '20-30'
	WHEN AGE BETWEEN 31 AND 40 -- AGE >= 31 AND AGE <=40
		THEN '31-40'
	WHEN AGE BETWEEN 41 AND 50
		THEN '41-50'
	WHEN AGE BETWEEN 51 AND 60
		THEN '51-60'
	ELSE '> 60'
END AS GROUPS, AVG(Credit_Score) AS AVG_CREDIT_SCORE
from Bank_loan
GROUP BY (CASE 	
	WHEN Age BETWEEN 20 AND 30 -- AGE >= 20 AND AGE<= 30
		THEN '20-30'
	WHEN AGE BETWEEN 31 AND 40 -- AGE >= 31 AND AGE <=40
		THEN '31-40'
	WHEN AGE BETWEEN 41 AND 50
		THEN '41-50'
	WHEN AGE BETWEEN 51 AND 60
		THEN '51-60'
	ELSE '> 60'
END)

--2. Does education level influence loan approval?
select Education_Level, count(Loan_Status) as Approval_count
from Bank_loan
where Loan_Status = 'approved'
group by Education_Level

-- 3. Which were the highest loan amounts approved?
select max(Loan_Amount) as max_loan_amt 
from  Bank_loan
where Loan_Status = 'approved'

select top 10 *
from Bank_loan
where Loan_Status = 'approved'
order by Loan_Amount desc

-- 4. Do lower credit scores correlate with higher late payments?
select Customer_ID,Credit_Score, No_of_Delayed_Payments 
from Bank_loan
order by Credit_Score , No_of_Delayed_Payments desc

-- 5. Which customers have a high EMI burden relative to their income?
select distinct Customer_ID , round( Annual_Income/ 12, 2) as Monthly_Income,
Monthly_Installment
from Bank_loan
where Monthly_Installment > round( Annual_Income/ 12, 2)

-- 6.  Do longer loan terms lead to higher default rates?
select Loan_Term_Months, sum(Defaulted) as Default_Count 
from Bank_loan
group by Loan_Term_Months

-- 7. Is there a gender-based difference in loan default rates?

-- SUBQUERY: ordinal subquery
select Gender, sum(Defaulted)/(select sum(Defaulted) from Bank_loan )
				as Defaulters 
from Bank_loan
group by gender

-- 8. Which loan types carry the highest monthly repayment burdens?
SELECT TOP 1 Loan_Type, AVG(Monthly_Installment) AS AVG_MONTHLY_INSTALL
FROM Bank_loan
GROUP BY Loan_Type
ORDER BY AVG_MONTHLY_INSTALL DESC

-- 9. How does default rate vary across employment statuses 
--      (e.g., unemployed vs employed)?

SELECT Employment_Status, SUM(Defaulted) AS DEFAULTERS ,
SUM(Defaulted)/ (SELECT SUM(Defaulted) FROM Bank_loan)*100 AS DEFAULT_RATE
FROM Bank_loan
GROUP BY Employment_Status
