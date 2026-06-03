use scd;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    skin_type VARCHAR(50),
    age INT,
    weather_preference VARCHAR(50),
    allergies TEXT,
    full_name VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    brand_id INT,
    product_price DECIMAL(10, 2),
    product_stock INT,
    product_quantity INT,
    product_allergy TEXT,
    product_weather_suitability VARCHAR(50),
    product_skintype_preference VARCHAR(50),
    FOREIGN KEY (brand_id) REFERENCES Brands(brand_id)
);
INSERT INTO products (product_name, brand_id, product_price, product_stock, product_quantity, product_allergy, product_weather_suitability, product_skintype_preference) VALUES
('Moisturizing Cream', 1, 20.50, 100, 50, 'None', 'Cold', 'Dry'),
('Sunscreen SPF 50', 2, 15.99, 200, 150, 'None', 'Sunny', 'Normal'),
('Face Wash', 1, 10.00, 50, 30, 'None', 'Rainy', 'Combination'),
('Anti-Aging Serum', 3, 40.00, 80, 40, 'None', 'Mild', 'Normal'),
('Hydrating Mask', 4, 25.00, 150, 100, 'None', 'Hot', 'Oily'),
('Night Cream', 5, 35.00, 60, 30, 'None', 'Cold', 'Dry'),
('Cleansing Oil', 2, 18.99, 120, 90, 'None', 'Mild', 'Combination'),
('Shampoo', 3, 12.00, 300, 200, 'None', 'Hot', 'Normal'),
('Exfoliating Scrub', 4, 22.50, 90, 50, 'None', 'Rainy', 'Oily'),
('Moisturizer SPF 30', 1, 28.00, 80, 60, 'None', 'Sunny', 'Dry');

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date DATETIME,
    total_price DECIMAL(10, 2),
    order_status VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
INSERT INTO orders (user_id, order_date, total_price, order_status) VALUES
(1, '2024-11-01 10:00:00', 120.50, 'Shipped'),
(2, '2024-11-02 11:30:00', 150.00, 'Delivered'),
(3, '2024-11-03 12:45:00', 80.00, 'Pending'),
(4, '2024-11-04 09:00:00', 55.00, 'Cancelled'),
(5, '2024-11-05 14:15:00', 200.00, 'Shipped'),
(6, '2024-11-06 16:00:00', 95.00, 'Delivered'),
(7, '2024-11-07 17:20:00', 60.00, 'Pending'),
(8, '2024-11-08 13:30:00', 110.00, 'Shipped'),
(9, '2024-11-09 15:00:00', 85.00, 'Delivered'),
(10, '2024-11-10 18:10:00', 75.00, 'Pending');

CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    review TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO reviews (user_id, product_id, review) VALUES
(1, 1, 'Great moisturizing cream!'),
(2, 2, 'Perfect sunscreen for sunny days.'),
(3, 3, 'Nice gentle face wash.'),
(4, 4, 'Effective anti-aging serum, very satisfied.'),
(5, 5, 'Hydrating mask worked wonders on my skin.'),
(6, 6, 'Love this night cream, my skin feels rejuvenated.'),
(7, 7, 'Cleansing oil is very gentle on my skin.'),
(8, 8, 'Great shampoo, my hair feels refreshed.'),
(9, 9, 'Exfoliating scrub is too harsh for my skin.'),
(10, 10, 'Moisturizer SPF 30 is a great everyday product.');

CREATE TABLE favorites (
    favorite_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO favorites (user_id, product_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

CREATE TABLE wishlists (
    wishlist_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO wishlists (user_id, product_id) VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6),
(6, 7),
(7, 8),
(8, 9),
(9, 10),
(10, 1);

CREATE TABLE recently_Viewed (
    recently_viewed_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    view_date DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO recently_Viewed (user_id, view_date) VALUES
(1, '2024-11-01 10:30:00'),
(2, '2024-11-02 11:45:00'),
(3, '2024-11-03 12:00:00'),
(4, '2024-11-04 09:15:00'),
(5, '2024-11-05 14:30:00'),
(6, '2024-11-06 16:15:00'),
(7, '2024-11-07 17:30:00'),
(8, '2024-11-08 13:45:00'),
(9, '2024-11-09 15:15:00'),
(10, '2024-11-10 18:30:00');

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    product_stock INT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO inventory (product_id, product_stock) VALUES
(1, 100),
(2, 150),
(3, 50),
(4, 80),
(5, 120),
(6, 60),
(7, 200),
(8, 90),
(9, 150),
(10, 80);

CREATE TABLE customer_Services (
    customer_service_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    issue_description TEXT,
    created_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO customer_Services (user_id, issue_description, created_at) VALUES
(1, 'Problem with product delivery', '2024-11-01 10:00:00'),
(2, 'Received damaged product', '2024-11-02 11:15:00'),
(3, 'Wrong product delivered', '2024-11-03 12:30:00'),
(4, 'Refund request', '2024-11-04 09:45:00'),
(5, 'Product not matching description', '2024-11-05 14:00:00'),
(6, 'Tracking not updating', '2024-11-06 16:30:00'),
(7, 'Issue with payment processing', '2024-11-07 17:45:00'),
(8, 'Unable to cancel order', '2024-11-08 13:00:00'),
(9, 'Product out of stock', '2024-11-09 14:30:00'),
(10, 'Exchange request for wrong size', '2024-11-10 18:45:00');

CREATE TABLE order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO order_Items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(2, 2, 3),
(3, 3, 1),
(4, 4, 1),
(5, 5, 2),
(6, 6, 1),
(7, 7, 2),
(8, 8, 3),
(9, 9, 1),
(10, 10, 2);

CREATE TABLE brands (
    brand_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_name VARCHAR(100) NOT NULL
);

INSERT INTO brands (brand_name) VALUES
('Brand A'),
('Brand B'),
('Brand C'),
('Brand D'),
('Brand E');

select * from users;




CREATE TABLE cart (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    quantity INT DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
select * from favorites;
select * from cart;
select * from orders;
select * from favorites;
select * from products;
select * from users;