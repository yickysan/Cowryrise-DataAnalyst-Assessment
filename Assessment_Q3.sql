WITH 
/* Computing the last transaction_date and 
filtering for accounts that have not transacted in over 365 days
*/
inactive_accounts AS 
(
SELECT plan_id, MAX(transaction_date) last_transaction_date 
  FROM savings_savingsaccount
 GROUP BY plan_id 
HAVING DATEDIFF(CURDATE(), last_transaction_date) > 365
)
SELECT i.plan_id, p.owner_id,
       IF(p.is_a_fund = 1, 'Investment','Savings') "type",
       i.last_transaction_date,
       DATEDIFF(CURDATE(), i.last_transaction_date) inactivity_days
  FROM plans_plan p
  JOIN inactive_accounts i ON i.plan_id = p.id
 ORDER BY inactivity_days DESC;