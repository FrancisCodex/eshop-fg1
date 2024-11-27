-- User Authentication and Authorization
-- Manages user roles, registration, login, and access control

-- Create roles table
CREATE TABLE IF NOT EXISTS roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    CHECK (role_name IN ('Buyer', 'Seller', 'Admin'))
);

-- Create users table 
CREATE TABLE IF NOT EXISTS users (
    user_id CHAR(36) PRIMARY KEY DEFAULT (UUID()), -- UUID for user IDs
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE, 
    contacts VARCHAR(15) UNIQUE NOT NULL, 
    email VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, -- Store hashed passwords
    reg_date DATE DEFAULT CURRENT_DATE,
    role_id INT,
    is_verified BOOLEAN DEFAULT FALSE, -- Verification status
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE SET NULL
);


-- Create user_tokens table
CREATE TABLE IF NOT EXISTS user_tokens (
    token_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id CHAR(36),
    token VARCHAR(255) NOT NULL, 
    token_type VARCHAR(20) NOT NULL, -- 'JWT' for login tokens or 'EMAIL_VERIFICATION'
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, 
    expires_at TIMESTAMP NOT NULL, 
    CHECK (token_type IN ('JWT', 'EMAIL_VERIFICATION')),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Product Catalog and Attributes for Clothing Store
-- Manages product organization, categories, and attributes specific to clothing

-- Create product_category table
CREATE TABLE IF NOT EXISTS product_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category_id INT,
    image_url VARCHAR(255),
    size VARCHAR(10), -- Nullable: e.g., S, M, L, XL
    color VARCHAR(30), -- Nullable: e.g., Red, Blue
    material VARCHAR(50), -- Nullable: e.g., Cotton, Polyester
    date_added DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (category_id) REFERENCES product_category(category_id) ON DELETE SET NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create product_inventory table
CREATE TABLE IF NOT EXISTS product_inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity >= 0),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Cart table for managing shopping items
CREATE TABLE IF NOT EXISTS cart (
    cart_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36),
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    is_selected_for_checkout BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Create shipping_address table
CREATE TABLE IF NOT EXISTS shipping_address (
    address_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36),
    street_address VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Orders table for tracking orders
CREATE TABLE IF NOT EXISTS orders (
    order_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36),
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    address_id CHAR(36),
    total_amount DECIMAL(10, 2) NOT NULL,
    order_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    CHECK (order_status IN ('Pending', 'Processing', 'Shipped', 'Completed', 'Cancelled')),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (address_id) REFERENCES shipping_address(address_id) ON DELETE SET NULL
);

-- Checkout table for managing order-cart relationships
-- Relationships:
--   1. Links to orders table (order_id): Tracks which items are part of an order
--   2. Links to cart table (cart_id): References the original cart items selected for checkout
--   3. Enables partial checkout: Only selected cart items become part of an order
--   4. Maintains history: Cart items can be referenced even after checkout
CREATE TABLE IF NOT EXISTS checkout (
    checkout_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    order_id CHAR(36),
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Create payment table
CREATE TABLE IF NOT EXISTS payment (
    payment_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    order_id CHAR(36),
    payment_date DATE DEFAULT CURRENT_DATE,
    payment_method VARCHAR(20),
    payment_status VARCHAR(20) DEFAULT 'Pending',
    encrypted_payment_details BLOB, -- Store encrypted payment information
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- Insert dummy data into roles
INSERT INTO roles (role_name) VALUES 
('Buyer'),
('Seller'),
('Admin');

-- Insert dummy data into users
INSERT INTO users (first_name, last_name, contacts, email, password, date_of_birth, role_id) VALUES
('John', 'Doe', '09123456789', 'john.doe@example.com', 'hashed_password_1', '1980-01-01', (SELECT role_id FROM roles WHERE role_name = 'Buyer')),
('Jane', 'Smith', '09234567890', 'jane.smith@example.com', 'hashed_password_2', '1990-05-15', (SELECT role_id FROM roles WHERE role_name = 'Seller')),
('Alice', 'Johnson', '09345678901', 'alice.johnson@example.com', 'hashed_password_3', '1985-07-22', (SELECT role_id FROM roles WHERE role_name = 'Admin')),
('Bob', 'Brown', '09456789012', 'bob.brown@example.com', 'hashed_password_4', '2000-09-30', (SELECT role_id FROM roles WHERE role_name = 'Buyer')),
('Carol', 'Davis', '09567890123', 'carol.davis@example.com', 'hashed_password_5', '1995-03-11', (SELECT role_id FROM roles WHERE role_name = 'Seller')),
('Dave', 'Wilson', '09678901234', 'dave.wilson@example.com', 'hashed_password_6', '1992-06-18', (SELECT role_id FROM roles WHERE role_name = 'Admin')),
('Eve', 'Taylor', '09789012345', 'eve.taylor@example.com', 'hashed_password_7', '1988-12-25', (SELECT role_id FROM roles WHERE role_name = 'Buyer')),
('Frank', 'Anderson', '09890123456', 'frank.anderson@example.com', 'hashed_password_8', '1975-10-01', (SELECT role_id FROM roles WHERE role_name = 'Seller')),
('Grace', 'Thomas', '09901234567', 'grace.thomas@example.com', 'hashed_password_9', '2001-02-14', (SELECT role_id FROM roles WHERE role_name = 'Admin')),
('Hank', 'Moore', '09012345678', 'hank.moore@example.com', 'hashed_password_10', '1998-11-03', (SELECT role_id FROM roles WHERE role_name = 'Buyer'));

-- Insert dummy data into product_category
INSERT INTO product_category (category_name) VALUES
('Shirts'),
('Pants'),
('Jackets'),
('Shoes'),
('Accessories');

-- Insert dummy data into products (only sellers can create products)
INSERT INTO products (user_id, product_name, description, price, category_id, image_url, size, color, material) VALUES
((SELECT user_id FROM users WHERE email = 'jane.smith@example.com'), 'Casual Shirt', 'A comfortable casual shirt.', 29.99, 
 (SELECT category_id FROM product_category WHERE category_name = 'Shirts'), 'url_to_image_1', 'M', 'Blue', 'Cotton'),
((SELECT user_id FROM users WHERE email = 'jane.smith@example.com'), 'Denim Jeans', 'Classic blue denim jeans', 45.99, 
 (SELECT category_id FROM product_category WHERE category_name = 'Pants'), 'url_to_image_2', '32', 'Blue', 'Denim'),
((SELECT user_id FROM users WHERE email = 'carol.davis@example.com'), 'Leather Jacket', 'Stylish leather jacket', 99.99, 
 (SELECT category_id FROM product_category WHERE category_name = 'Jackets'), 'url_to_image_3', 'L', 'Black', 'Leather'),
((SELECT user_id FROM users WHERE email = 'carol.davis@example.com'), 'Winter Boots', 'Warm winter boots', 79.99, 
 (SELECT category_id FROM product_category WHERE category_name = 'Shoes'), 'url_to_image_4', '9', 'Brown', 'Leather'),
((SELECT user_id FROM users WHERE email = 'frank.anderson@example.com'), 'Sports Watch', 'Digital sports watch', 34.99, 
 (SELECT category_id FROM product_category WHERE category_name = 'Accessories'), 'url_to_image_5', NULL, 'Black', 'Plastic'),
((SELECT user_id FROM users WHERE email = 'frank.anderson@example.com'), 'Running Shoes', 'Lightweight running shoes', 59.99, 
 (SELECT category_id FROM product_category WHERE category_name = 'Shoes'), 'url_to_image_6', '10', 'Red', 'Synthetic'),
((SELECT user_id FROM users WHERE email = 'jane.smith@example.com'), 'Wool Scarf', 'Warm winter scarf', 24.99, 
 (SELECT category_id FROM product_category WHERE category_name = 'Accessories'), 'url_to_image_7', NULL, 'Gray', 'Wool'),
((SELECT user_id FROM users WHERE email = 'carol.davis@example.com'), 'Summer Dress', 'Floral summer dress', 49.99, 
 (SELECT category_id FROM product_category WHERE category_name = 'Shirts'), 'url_to_image_8', 'M', 'Floral', 'Cotton'),
((SELECT user_id FROM users WHERE email = 'frank.anderson@example.com'), 'Leather Belt', 'Classic leather belt', 29.99, 
 (SELECT category_id FROM product_category WHERE category_name = 'Accessories'), 'url_to_image_9', 'M', 'Brown', 'Leather'),
((SELECT user_id FROM users WHERE email = 'jane.smith@example.com'), 'Sunglasses', 'UV protection sunglasses', 39.99, 
 (SELECT category_id FROM product_category WHERE category_name = 'Accessories'), 'url_to_image_10', NULL, 'Black', 'Plastic');

-- Insert dummy data into product_inventory (matching the new products)
INSERT INTO product_inventory (product_id, quantity) VALUES
((SELECT product_id FROM products WHERE product_name = 'Casual Shirt'), 100),
((SELECT product_id FROM products WHERE product_name = 'Denim Jeans'), 75),
((SELECT product_id FROM products WHERE product_name = 'Leather Jacket'), 50),
((SELECT product_id FROM products WHERE product_name = 'Winter Boots'), 60),
((SELECT product_id FROM products WHERE product_name = 'Sports Watch'), 120),
((SELECT product_id FROM products WHERE product_name = 'Running Shoes'), 80),
((SELECT product_id FROM products WHERE product_name = 'Wool Scarf'), 150),
((SELECT product_id FROM products WHERE product_name = 'Summer Dress'), 90),
((SELECT product_id FROM products WHERE product_name = 'Leather Belt'), 200),
((SELECT product_id FROM products WHERE product_name = 'Sunglasses'), 100);

-- Insert dummy data into cart (only buyers can have cart items)
INSERT INTO cart (user_id, product_id, quantity, is_selected_for_checkout) VALUES
-- John Doe's cart (Buyer)
((SELECT user_id FROM users WHERE email = 'john.doe@example.com'),
 (SELECT product_id FROM products WHERE product_name = 'Casual Shirt'), 2, TRUE),
((SELECT user_id FROM users WHERE email = 'john.doe@example.com'),
 (SELECT product_id FROM products WHERE product_name = 'Leather Jacket'), 1, TRUE),
-- Bob Brown's cart (Buyer)
((SELECT user_id FROM users WHERE email = 'bob.brown@example.com'),
 (SELECT product_id FROM products WHERE product_name = 'Running Shoes'), 1, TRUE),
((SELECT user_id FROM users WHERE email = 'bob.brown@example.com'),
 (SELECT product_id FROM products WHERE product_name = 'Sports Watch'), 1, FALSE),
-- Eve Taylor's cart (Buyer)
((SELECT user_id FROM users WHERE email = 'eve.taylor@example.com'),
 (SELECT product_id FROM products WHERE product_name = 'Summer Dress'), 1, TRUE),
((SELECT user_id FROM users WHERE email = 'eve.taylor@example.com'),
 (SELECT product_id FROM products WHERE product_name = 'Sunglasses'), 1, TRUE);

-- Insert dummy data into shipping_address
INSERT INTO shipping_address (user_id, street_address, city, state, postal_code, country) VALUES
((SELECT user_id FROM users WHERE email = 'john.doe@example.com'), '123 Main St', 'Anytown', 'Anystate', '12345', 'USA'),
((SELECT user_id FROM users WHERE email = 'jane.smith@example.com'), '456 Elm St', 'Anytown', 'Anystate', '12345', 'USA'),
((SELECT user_id FROM users WHERE email = 'alice.johnson@example.com'), '789 Oak St', 'Anytown', 'Anystate', '12345', 'USA'),
((SELECT user_id FROM users WHERE email = 'bob.brown@example.com'), '101 Maple St', 'Anytown', 'Anystate', '12345', 'USA'),
((SELECT user_id FROM users WHERE email = 'carol.davis@example.com'), '202 Birch St', 'Anytown', 'Anystate', '12345', 'USA'),
((SELECT user_id FROM users WHERE email = 'dave.wilson@example.com'), '303 Cedar St', 'Anytown', 'Anystate', '12345', 'USA'),
((SELECT user_id FROM users WHERE email = 'eve.taylor@example.com'), '404 Pine St', 'Anytown', 'Anystate', '12345', 'USA'),
((SELECT user_id FROM users WHERE email = 'frank.anderson@example.com'), '505 Spruce St', 'Anytown', 'Anystate', '12345', 'USA'),
((SELECT user_id FROM users WHERE email = 'grace.thomas@example.com'), '606 Fir St', 'Anytown', 'Anystate', '12345', 'USA'),
((SELECT user_id FROM users WHERE email = 'hank.moore@example.com'), '707 Walnut St', 'Anytown', 'Anystate', '12345', 'USA');

-- Insert orders data (only for items marked for checkout)
INSERT INTO orders (user_id, total_amount, address_id) VALUES
-- John Doe's order (only selected items)
((SELECT user_id FROM users WHERE email = 'john.doe@example.com'),
 159.97,  -- (Casual Shirt 29.99 * 2) + (Leather Jacket 99.99)
 (SELECT address_id FROM shipping_address WHERE user_id = 
  (SELECT user_id FROM users WHERE email = 'john.doe@example.com'))),

-- Jane Smith's order (only selected items)
((SELECT user_id FROM users WHERE email = 'jane.smith@example.com'),
 49.99,   -- Running Shoes only
 (SELECT address_id FROM shipping_address WHERE user_id = 
  (SELECT user_id FROM users WHERE email = 'jane.smith@example.com')));

-- Insert checkout data (linking orders to products)
INSERT INTO checkout (order_id, product_id, quantity) VALUES
-- John Doe's checkout items
((SELECT order_id FROM orders WHERE user_id = 
  (SELECT user_id FROM users WHERE email = 'john.doe@example.com') LIMIT 1),
 (SELECT product_id FROM products WHERE product_name = 'Casual Shirt'),
 2),

((SELECT order_id FROM orders WHERE user_id = 
  (SELECT user_id FROM users WHERE email = 'john.doe@example.com') LIMIT 1),
 (SELECT product_id FROM products WHERE product_name = 'Leather Jacket'),
 1),

-- Jane Smith's checkout items
((SELECT order_id FROM orders WHERE user_id = 
  (SELECT user_id FROM users WHERE email = 'jane.smith@example.com') LIMIT 1),
 (SELECT product_id FROM products WHERE product_name = 'Running Shoes'),
 1);

-- Insert payment data
INSERT INTO payment (order_id, payment_method, payment_status, encrypted_payment_details) VALUES
((SELECT order_id FROM orders WHERE user_id = 
  (SELECT user_id FROM users WHERE email = 'john.doe@example.com') LIMIT 1),
 'Credit Card', 'Completed', 'encrypted_details_1'),
((SELECT order_id FROM orders WHERE user_id = 
  (SELECT user_id FROM users WHERE email = 'jane.smith@example.com') LIMIT 1),
 'PayPal', 'Completed', 'encrypted_details_2');
