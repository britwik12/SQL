# Weekly Sales Analysis for Kroger store in zipcode '40502' and stores '229' & '321'
SELECT *
from carbo_store_lookup
WHERE zipcode = 40502;

SELECT week, sum(dollar_sales) as 'Weekly Dollar Sales', store
From carbo_transactions
WHERE STORE IN ('229', '321')
GROUP BY store, week;

