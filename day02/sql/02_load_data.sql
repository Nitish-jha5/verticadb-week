-- Initial target data
INSERT INTO customer_target
    (customer_id, customer_name, city)
VALUES
    (1, 'Alice', 'Hyderabad'),
    (2, 'Bob', 'Mumbai'),
    (3, 'Carol', 'Delhi');

-- Incremental batch arriving in staging
INSERT INTO customer_stage
    (customer_id, customer_name, city)
VALUES
    (2, 'Bob', 'Pune'),
    (3, 'Carol', 'Bengaluru'),
    (4, 'David', 'Chennai'),
    (5, 'Eva', 'Kolkata');
