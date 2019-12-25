
# Trnsactions in first 16 weeks at Kroger Stores
SELECT day, week_no, COUNT(distinct household_key) as 'Number of Distinct Households', 
COUNT(distinct basket_id) as 'Number of Distinct Baskets', SUM(sales_value) as 'Total Sales Value'
FROM journey_transaction_data
WHERE week_no < 16
GROUP BY day, week_no

LIMIT 10000;

