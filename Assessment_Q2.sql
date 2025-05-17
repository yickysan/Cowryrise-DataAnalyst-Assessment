WITH 
/* Computing the number of transactions per month for each user */
monthly_transactions AS
(
SELECT u.id, 
       CONCAT(MONTHNAME(s.transaction_date), '-', YEAR(s.transaction_date)) month_year,
       COUNT(s.savings_id) transaction_count
  FROM savings_savingsaccount s
  JOIN users_customuser u ON u.id = s.owner_id
  GROUP BY u.id, month_year
),
/* Computing the average number of transactions performed monthly per user */
users_monthly_average AS 
(
SELECT id, AVG(transaction_count) user_avg
FROM monthly_transactions
GROUP BY id
)
/* Categorising users and computing the average monthly transactions for each category */
SELECT CASE WHEN user_avg >= 10 THEN 'High Frequency'
            WHEN user_avg > 3 AND user_avg < 10 THEN 'Medium Frequency'
            ELSE 'Low Frequency' END frequency_category,
        COUNT(id) customer_count,
        ROUND(AVG(user_avg),1) avg_transactions_per_month
  FROM users_monthly_average
 GROUP BY frequency_category;