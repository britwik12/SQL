
# Identifying Distinct Brands at Kroger Store
SELECT commodity, count(DISTINCT upc) as 'Number of Distinct upc', count(DISTINCT brand) as 'Number of Distinct brand'
FROM carbo_product_lookup
GROUP by commodity
ORDER by 2 DESC;

# Brands selling Pasta and Pasta Sauce
SELECT T1.brand, number_of_pasta, number_of_sauce
FROM
(SELECT brand, COUNT(upc) AS number_of_pasta
FROM carbo_product_lookup
WHERE commodity = 'pasta'
GROUP BY brand) AS T1

INNER JOIN 

(SELECT brand, COUNT(upc) AS number_of_sauce
FROM carbo_product_lookup
WHERE commodity = 'pasta sauce'
GROUP BY brand) AS T2

ON T1.brand = T2.brand;

# Units and Dollar Sales for Top 25 Pasta UPC's
SELECT Z1.upc as 'UPC', SUM(units) AS 'Total Units', SUM(dollar_sales) as 'Total Dollar Sales'
FROM

(SELECT upc, units, dollar_sales
FROM carbo_transactions) AS Z1
JOIN
(SELECT upc
FROM carbo_product_lookup
WHERE commodity = 'pasta') AS Z2

ON Z1.upc = Z2.upc
GROUP BY Z1.upc
ORDER BY 3 DESC
LIMIT 25;

# Sales, Units Sold and Average Price for Top 26 Pasta Brands
SELECT brand, SUM(units) as 'Total Units', SUM(dollar_sales)as 'Total Dollar Sales', SUM(dollar_sales)/SUM(units) as 'Average Price per Unit'
FROM

(SELECT brand, upc
FROM carbo_product_lookup
WHERE commodity = 'pasta') AS F1
JOIN
(SELECT upc, units, dollar_sales
FROM carbo_transactions) AS F2

ON F1.upc = F2.upc
GROUP BY brand
ORDER BY 3 DESC
LIMIT 26;

# Brands with Pasta but do not sell Pasta Sauce
SELECT k.*
FROM
(SELECT brand as 'Brand', SUM(units) as 'Number of Units' ,SUM(dollar_sales) as Total_Sales ,SUM(dollar_sales)/SUM(units) as 'Average'
FROM carbo_transactions c
JOIN carbo_product_lookup d
ON c.upc = d.upc
WHERE commodity = 'pasta'
GROUP by brand) as k

WHERE brand IN
(SELECT a.brand
FROM 
(SELECT brand
FROM carbo_product_lookup
WHERE commodity = 'pasta'
GROUP BY brand) AS a

LEFT JOIN 

(SELECT brand
FROM carbo_product_lookup
WHERE commodity = 'pasta sauce'
GROUP BY brand) AS b

ON a.brand = b.brand
WHERE b.brand IS NULL)
GROUP BY brand
ORDER BY Total_Sales DESC


# Number of Distinct Stores for each Pasta UPC, Most sales sold in fewer than 100 stores
SELECT y.upc as UPC, y.product_description AS 'Product Description', Sales, store_num as 'Number of Stores'
FROM 
(SELECT upc, product_description, commodity
FROM carbo_product_lookup
WHERE commodity = 'pasta') as y
INNER JOIN
(SELECT upc as UPC, COUNT(DISTINCT store) as store_num, SUM(dollar_sales) as Sales
FROM carbo_transactions
GROUP BY upc) AS z
ON y.upc = z.upc
WHERE store_num < 100
ORDER BY 3 DESC
LIMIT 1;

# Kroger Data Analysis for Expansion of Stores
SELECT y.upc as UPC, Sales, store_num as 'Number of Stores', Sales/store_num as'Average Sales per Store in Dollars',y.brand AS 'Brand'
FROM 
(SELECT upc, commodity, brand
FROM carbo_product_lookup
WHERE commodity = 'pasta') AS y
INNER JOIN
(SELECT upc as UPC, COUNT(DISTINCT store) as store_num, SUM(dollar_sales) as Sales
FROM carbo_transactions
GROUP BY upc) AS z
ON y.upc = z.upc
WHERE store_num > 10
GROUP by brand
ORDER BY 4 DESC;
