-- Step 1: Create the initial ProductDetail table (Unnormalized Form)
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(255),
    Products VARCHAR(255)
);

-- Step 2: Insert unnormalized data (6 rows)
INSERT INTO ProductDetail (OrderID, CustomerName, Products)
VALUES 
    (101, 'John Doe', 'Laptop'),
    (101, 'John Doe', 'Mouse'),
    (102, 'Jane Smith', 'Tablet'),
    (102, 'Jane Smith', 'Keyboard'),
    (102, 'Jane Smith', 'Mouse'),
    (103, 'Emily Clark', 'Phone');

-- Step 3: Create ProductDetail_1NF table (First Normal Form - 1NF)
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255)
);

-- Step 4: Transform data into 1NF by storing individual products as separate rows
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
VALUES 
    (101, 'John Doe', 'Laptop'),
    (101, 'John Doe', 'Mouse'),
    (102, 'Jane Smith', 'Tablet'),
    (102, 'Jane Smith', 'Keyboard'),
    (102, 'Jane Smith', 'Mouse'),
    (103, 'Emily Clark', 'Phone');

-- Step 5: View the 1NF table
SELECT * FROM ProductDetail_1NF;


-- 🔹 Step 6: Create OrderDetails table (Still in 1NF, adding Quantity)
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255),
    Quantity INT
);

-- 🔹 Step 7: Insert data into OrderDetails table
INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity)
VALUES 
    (101, 'John Doe', 'Laptop', 2),
    (101, 'John Doe', 'Mouse', 1),
    (102, 'Jane Smith', 'Tablet', 3),
    (102, 'Jane Smith', 'Keyboard', 1),
    (102, 'Jane Smith', 'Mouse', 2),
    (103, 'Emily Clark', 'Phone', 1),
    (103, 'Emily Clark', 'Headphones', 1);  -- New product


-- 🔹 Step 8: Create the Orders table (Removing partial dependency on OrderID)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- 🔹 Step 9: Populate the Orders table (Unique orders)
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- View the Orders table
SELECT * FROM Orders;


-- 🔹 Step 10: Create the Product table (Eliminating redundancy)
CREATE TABLE Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(255) UNIQUE
);

-- 🔹 Step 11: Populate the Product table with distinct products
INSERT INTO Product (ProductName)
SELECT DISTINCT Product FROM OrderDetails;

-- View the Product table
SELECT * FROM Product;


-- 🔹 Step 12: Create OrderItems table (Associates Orders with Products)
CREATE TABLE OrderItems (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- 🔹 Step 13: Populate OrderItems table (Using ProductID instead of ProductName)
INSERT INTO OrderItems (OrderID, ProductID, Quantity)
SELECT 
    od.OrderID, 
    p.ProductID, 
    od.Quantity
FROM OrderDetails od
JOIN Product p ON od.Product = p.ProductName;

-- 🔹 Step 14: View the final 2NF tables
SELECT * FROM Orders;
SELECT * FROM Product;
SELECT * FROM OrderItems;
