/*finding which location has more rich customers*/
SELECT 
    Geography, 
    COUNT(*) AS Total_Customers,
    AVG(Balance) AS Average_Balance
FROM 
    Churn_Modeling
GROUP BY 
    Geography;
/* ## The "High-Value German Retention" List*/
/*We want to find customers in Germany who have a Balance > 100,000 and a Credit Score > 600, but are flagged as Exited (1)*/
SELECT 
    Surname, 
    CreditScore, 
    Balance, 
    Geography
FROM Churn_Modeling
WHERE Geography = 'Germany' 
  AND Balance > 100000 
  AND CreditScore > 600
  AND Exited = 1
ORDER BY Balance DESC;
/* Finding which country has highest churned count */
SELECT 
    Geography, 
    COUNT(*) AS Churned_Count, 
    AVG(Age) AS Avg_Age
FROM Churn_Modeling
WHERE Exited = 1
GROUP BY Geography;
/*Germany has the highest churned_count but France has also almost same numbers, and same goes for average avg both countries have approximately same avg age* therefore
we will not find churned rate to see if germany and france really has same amount of churned count */
SELECT 
    Geography, 
    COUNT(*) AS Total_Customers,
    SUM(Exited) AS Total_Churned,
    ROUND(AVG(Exited) * 100, 2) AS Churn_Percentage
FROM Churn_Modeling
GROUP BY Geography
ORDER BY Churn_Percentage DESC;
/* Germany almost 32.5 % whereas Spain and France are at 16 % */
/* Deep Dive into Germany region */
SELECT 
    Age, 
    IsActiveMember, 
    NumOfProducts, 
    AVG(Balance) AS Avg_Balance,
    COUNT(*) AS Total
FROM Churn_Modeling
WHERE Geography = 'Germany' AND Exited = 1
GROUP BY Age
ORDER BY Total DESC
LIMIT 10;
/* salary might give me some insights as once person reaches X amount of salary they are moving to other banks for better service; */
SELECT 
    CASE 
        WHEN EstimatedSalary < 50000 THEN 'Low (0-50k)'
        WHEN EstimatedSalary BETWEEN 50000 AND 100000 THEN 'Medium (50k-100k)'
        WHEN EstimatedSalary BETWEEN 100000 AND 150000 THEN 'High (100k-150k)'
        ELSE 'Very High (150k+)'
    END AS Salary_Bracket,
    COUNT(*) AS Total_Customers,
    SUM(Exited) AS Churned_Count,
    ROUND(AVG(Exited) * 100, 2) AS Churn_Rate
FROM  Churn_Modeling
GROUP BY Salary_Bracket
ORDER BY Churn_Rate DESC;
/* there is an increase in churn rate as the salary bracket increase */
/*
Now that we know the "Wealthy" are leaving, we need to find the Lever. There are usually two main reasons:

    Poor Engagement: They have the money, but they aren't using the bank's digital tools (IsActiveMember).

    Product Misalignment: They have high balances but only one product (e.g., just a Savings Account, no Credit Card or Wealth Management */
SELECT 
    IsActiveMember, 
    ROUND(AVG(Exited) * 100, 2) AS Churn_Rate
FROM Churn_Modeling
WHERE EstimatedSalary > 150000
GROUP BY IsActiveMember;
/* The Goal: Find out if having more products (Credit Cards, Home Loans, Insurance) makes a customer stay.*/
SELECT 
    NumOfProducts, 
    COUNT(*) AS Total_Customers,
    ROUND(AVG(Exited) * 100, 2) AS Churn_Rate
FROM Churn_Modeling
GROUP BY NumOfProducts
ORDER BY NumOfProducts;
/* having 3 or more products increases churn rate exponentially to almost 85-95 % so i think 2 is the sweet spot */
