CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    product VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO orders (user_id, product, amount) VALUES
(123, 'Laptop', 999.99),
(123, 'Mouse', 29.99),
(456, 'Keyboard', 79.99),
(456, 'Monitor', 299.99),
(789, 'Headphones', 149.99),
(789, 'Webcam', 89.99);