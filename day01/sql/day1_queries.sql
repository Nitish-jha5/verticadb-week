SELECT
    YEAR(store_sales_date) AS sales_year,
    SUM(sales_dollar_amount) AS total_sales,
    SUM(gross_profit_dollar_amount) AS total_profit
FROM store.store_sales_fact
GROUP BY YEAR(store_sales_date)
ORDER BY sales_year;

SELECT
    store_key,
    SUM(sales_dollar_amount) AS total_sales,
    SUM(gross_profit_dollar_amount) AS total_profit
FROM store.store_sales_fact
WHERE store_sales_date >= DATE '2025-01-01'
  AND store_sales_date < DATE '2026-01-01'
GROUP BY store_key
ORDER BY store_key;
