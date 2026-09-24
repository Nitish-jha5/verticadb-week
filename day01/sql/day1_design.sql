CREATE PROJECTION store.store_sales_fact_DBD_1_rep_day1_store_design /*+createtype(D)*/
(
 date_key ENCODING DELTARANGE_COMP, 
 product_key ENCODING COMMONDELTA_COMP, 
 product_version ENCODING BLOCKDICT_COMP, 
 store_key ENCODING RLE, 
 promotion_key ENCODING COMMONDELTA_COMP, 
 customer_key ENCODING ZSTD_FAST_COMP, 
 employee_key ENCODING COMMONDELTA_COMP, 
 pos_transaction_number ENCODING DELTARANGE_COMP, 
 sales_quantity ENCODING BLOCKDICT_COMP, 
 sales_dollar_amount ENCODING DELTAVAL, 
 cost_dollar_amount ENCODING DELTAVAL, 
 gross_profit_dollar_amount ENCODING DELTAVAL, 
 transaction_type ENCODING ZSTD_FAST_COMP, 
 transaction_time ENCODING GCDDELTA, 
 tender_type ENCODING ZSTD_FAST_COMP, 
 store_sales_date ENCODING DELTARANGE_COMP, 
 store_sales_datetime ENCODING ZSTD_FAST_COMP
)
AS
 SELECT date_key, 
        product_key, 
        product_version, 
        store_key, 
        promotion_key, 
        customer_key, 
        employee_key, 
        pos_transaction_number, 
        sales_quantity, 
        sales_dollar_amount, 
        cost_dollar_amount, 
        gross_profit_dollar_amount, 
        transaction_type, 
        transaction_time, 
        tender_type, 
        store_sales_date, 
        store_sales_datetime
 FROM store.store_sales_fact 
 ORDER BY store_key
UNSEGMENTED ALL NODES;



