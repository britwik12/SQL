
# Market Basket Analysis for Milk and Soft Drinks at Kroger Stores (controlling different basket size)
SELECT count(*) as Total, sum(MILK) as Milk, sum(SoftDrinks) as SoftDrinks, sum(Milk*SoftDrinks) as
		Combined, sum(Milk*SoftDrinks)*count(*)/(sum(Milk)*sum(SoftDrinks)) as lift 
	FROM 
	(SELECT sum(sales_value) as sales, basket_id, 
    max(case when commodity_desc = 'FLUID MILK PRODUCTS' then 1 else 0 end) Milk,          
    max(case when commodity_desc = 'SOFT DRINKS' then 1 else 0 end) SoftDrinks, 
    max(case when sub_commodity_desc = 'GASOLINE-REG UNLEADED' then 1 else 0 end) Gas 
    FROM journey_transaction_data jt   
    JOIN journey_product jp  
    ON jt.product_id=jp.product_id 
    GROUP BY basket_id
    HAVING Gas = 0) as wut
 
	WHERE sales >= 80; #Change the dollar sales in the 'WHERE' statement to control for basket size 

