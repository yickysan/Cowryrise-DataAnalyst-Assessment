WITH
/* Retrieving all users with a funded savings plan */
savings_users AS
(
SELECT u.id, COUNT(p.id) savings_count
  FROM plans_plan p 
  JOIN users_customuser u ON u.id = p.owner_id
 WHERE p.is_regular_savings = 1 AND p.amount > 0
 GROUP BY u.id
),
/* Retrieving all users with a funded investment plan */
investment_users AS
(
SELECT u.id, COUNT(p.id) investment_count
  FROM plans_plan p 
  JOIN users_customuser u ON u.id = p.owner_id
 WHERE p.is_a_fund = 1 AND p.amount > 0
 GROUP BY u.id
)
SELECT CONCAT(u.first_name, ' ', u.last_name) "name",
       su.savings_count, iu.investment_count,
       COUNT(*) total_deposits
  FROM users_customuser u
  JOIN savings_savingsaccount s ON s.owner_id = u.id
  JOIN investment_users iu ON iu.id = u.id
  JOIN savings_users su ON su.id = u.id
 GROUP BY CONCAT(u.first_name, ' ', u.last_name), su.savings_count, iu.investment_count
 ORDER BY total_deposits DESC;
 



 

   

