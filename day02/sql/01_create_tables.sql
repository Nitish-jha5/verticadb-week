CREATE TABLE customer_target (
    customer_id INT,
    customer_name VARCHAR(100),
    city VARCHAR(100)
)
SEGMENTED BY HASH(customer_id) ALL NODES;

CREATE TABLE customer_stage (
    customer_id INT,
    customer_name VARCHAR(100),
    city VARCHAR(100)
)
SEGMENTED BY HASH(customer_id) ALL NODES;
