/* Computing profit in naira 
Profit is 0.1% of confirmed amount  and 100kobo = 1 naira
There profit = 0.1 / 100/ 100 = 0.00001
*/
WITH profits AS
(
SELECT owner_id, COUNT(savings_id) total_transactions,
       ROUND(AVG(0.00001 * confirmed_amount),2) profit 
  FROM savings_savingsaccount 
 WHERE transaction_status = 'success'
 GROUP BY owner_id
)
SELECT u.id customer_id, CONCAT(u.first_name, ' ',  u.last_name) "name",
       FLOOR(DATEDIFF(CURDATE(), u.date_joined) / 30) tenure_months,
       pr.total_transactions,
       ROUND((pr.total_transactions /
              FLOOR(DATEDIFF(CURDATE(), u.date_joined) / 30)
              ) * 12 * pr.profit,
             2
            )  estimated_clv
 FROM users_customuser u
 JOIN profits pr ON pr.owner_id = u.id
ORDER BY estimated_clv DESC;
