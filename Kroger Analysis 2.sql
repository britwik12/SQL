
# Kroger Visit and Sales Analysis based on Demographic Information
SELECT CASE WHEN dem.household_key then 1 else 0 END as groupid, b.*
FROM
(SELECT household_key
FROM journey_hh_demographic) dem
RIGHT JOIN
(SELECT household_key, SUM(sales_value) as 'Total', COUNT(DISTINCT basket_id) as 'Number of Trips',
MIN(day) as 'First Day', MAX(day) as 'Last Day', SUM(sales_value)/COUNT(DISTINCT basket_id) as 'Average Dollar Sales',
COUNT(DISTINCT product_id)/COUNT(DISTINCT basket_id) as 'Average Quantity per visit', (Max(day)-Min(day))/(Count(distinct basket_id)-1) as 'Average Time Between Trips'
FROM journey_transaction_data
GROUP by household_key) b

ON dem.household_key = b.household_key

