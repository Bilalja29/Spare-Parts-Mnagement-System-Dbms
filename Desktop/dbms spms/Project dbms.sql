CREATE DATABASE IF NOT EXISTS spare_parts_shop;

USE spare_parts_shop;

 -- CATEGORY TABLE
 
CREATE TABLE CATEGORY (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    vehicle_type VARCHAR(30) NOT NULL
);

 -- PRODUCT TABLE
 
CREATE TABLE PRODUCT (
    product_id INT PRIMARY KEY,
    part_name VARCHAR(100) NOT NULL,
    part_number VARCHAR(30) NOT NULL UNIQUE,
    category_id INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    cost_price DECIMAL(10,2) NOT NULL,
    qty_in_stock INT DEFAULT 0,
    reorder_level INT DEFAULT 5,

    CONSTRAINT fk_product_category
    FOREIGN KEY (category_id)
    REFERENCES CATEGORY(category_id)
);

 -- SUPPLIER TABLE
 
CREATE TABLE SUPPLIER (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(80),
    phone VARCHAR(15) UNIQUE NOT NULL,
    city VARCHAR(50) DEFAULT 'Rawalpindi',
    balance_due DECIMAL(12,2) DEFAULT 0
);

 -- CUSTOMER TABLE
 
CREATE TABLE CUSTOMER (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    customer_type VARCHAR(10) DEFAULT 'CASH',
    credit_limit DECIMAL(12,2) DEFAULT 0,
    outstanding_balance DECIMAL(12,2) DEFAULT 0
);

 -- PURCHASE_ORDER TABLE
 
CREATE TABLE PURCHASE_ORDER (
    po_id INT PRIMARY KEY,
    supplier_id INT NOT NULL,
    po_date DATE DEFAULT (CURRENT_DATE),
    total_amount DECIMAL(12,2) DEFAULT 0,
    amount_paid DECIMAL(12,2) DEFAULT 0,
    payment_status VARCHAR(15) DEFAULT 'PENDING',

    FOREIGN KEY (supplier_id)
    REFERENCES SUPPLIER(supplier_id)
);

 -- PURCHASE_ITEM TABLE
 
CREATE TABLE PURCHASE_ITEM (
    po_item_id INT PRIMARY KEY,
    po_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,

    subtotal DECIMAL(12,2)
    GENERATED ALWAYS AS (quantity * unit_cost) STORED,

    FOREIGN KEY (po_id)
    REFERENCES PURCHASE_ORDER(po_id),

    FOREIGN KEY (product_id)
    REFERENCES PRODUCT(product_id)
);

 -- SALE_ORDER TABLE
 
CREATE TABLE SALE_ORDER (
    sale_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    sale_date DATE DEFAULT (CURRENT_DATE),
    total_amount DECIMAL(12,2) DEFAULT 0,
    amount_paid DECIMAL(12,2) DEFAULT 0,
    payment_mode VARCHAR(15) DEFAULT 'CASH',

    FOREIGN KEY (customer_id)
    REFERENCES CUSTOMER(customer_id)
);

 -- SALE_ITEM TABLE
 
CREATE TABLE SALE_ITEM (
    sale_item_id INT PRIMARY KEY,
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    subtotal DECIMAL(12,2)
    GENERATED ALWAYS AS (quantity * unit_price) STORED,

    FOREIGN KEY (sale_id)
    REFERENCES SALE_ORDER(sale_id),

    FOREIGN KEY (product_id)
    REFERENCES PRODUCT(product_id)
);

 -- INSERT CATEGORY DATA
 
INSERT INTO CATEGORY VALUES
(1,'Engine Parts','Motorcycle'),
(2,'Electrical Parts','Motorcycle'),
(3,'Brake System','Car'),
(4,'Filters','General'),
(5,'Body & Frame','Motorcycle');

 -- INSERT PRODUCT DATA
 
INSERT INTO PRODUCT VALUES
(101,'Piston Ring Set','PRG-CD70-001',1,850,550,30,5),
(102,'Clutch Plate Set','CPS-CD70-002',1,1200,800,20,4),
(103,'CDI Unit','CDI-CG125-001',2,1800,1100,15,3),
(104,'Spark Plug NGK','SPK-NGK-B6HS',2,250,140,80,10),
(105,'Brake Disc Pad','BDP-ALTO-003',3,950,600,25,5),
(106,'Oil Filter','OLF-UNIV-001',4,350,200,60,8),
(107,'Air Filter','ARF-CD70-001',4,420,260,45,6),
(108,'Chain Sprocket','CHS-CD70-001',5,680,420,3,5);

 -- INSERT SUPPLIER DATA
 
INSERT INTO SUPPLIER VALUES
(1,'Al-Madina Traders','Zia Ur Rehman','0300-1234567','Rawalpindi',0),
(2,'Punjab Auto Parts','Khalid Mehmood','0321-9876543','Lahore',0),
(3,'Pak Motor Accessories','Tariq Hussain','0333-5555555','Rawalpindi',0);

 -- INSERT CUSTOMER DATA
 
INSERT INTO CUSTOMER VALUES
(1,'Walk-In Customer','','CASH',0,0),
(2,'Usman Workshop','0311-1111111','CREDIT',50000,12000),
(3,'Tariq Garage','0322-2222222','CREDIT',30000,5000),
(4,'Bilal Mechanics','0333-3333333','CASH',0,0);

 -- INSERT PURCHASE ORDER
 
INSERT INTO PURCHASE_ORDER VALUES
(1001,1,'2026-03-01',0,0,'PENDING');

 -- INSERT PURCHASE ITEMS
 
INSERT INTO PURCHASE_ITEM
(po_item_id,po_id,product_id,quantity,unit_cost)
VALUES
(1,1001,101,20,550),
(2,1001,104,50,140);

 -- UPDATE PURCHASE TOTAL
 
UPDATE PURCHASE_ORDER
SET total_amount =
(
    SELECT SUM(quantity * unit_cost)
    FROM PURCHASE_ITEM
    WHERE po_id = 1001
)
WHERE po_id = 1001;

 -- INSERT SALE ORDER
 
INSERT INTO SALE_ORDER VALUES
(2001,2,'2026-03-05',0,0,'CREDIT');

 -- INSERT SALE ITEMS
 
INSERT INTO SALE_ITEM
(sale_item_id,sale_id,product_id,quantity,unit_price)
VALUES
(1,2001,101,5,850),
(2,2001,104,10,250);

 -- UPDATE SALE TOTAL
 
UPDATE SALE_ORDER
SET total_amount =
(
    SELECT SUM(quantity * unit_price)
    FROM SALE_ITEM
    WHERE sale_id = 2001
)
WHERE sale_id = 2001;

 -- VIEW
 
CREATE VIEW VW_STOCK_STATUS AS
SELECT
    p.product_id,
    p.part_name,
    p.part_number,
    c.category_name,
    c.vehicle_type,
    p.qty_in_stock,
    p.reorder_level,

    CASE
        WHEN p.qty_in_stock = 0 THEN 'OUT OF STOCK'
        WHEN p.qty_in_stock <= p.reorder_level THEN 'LOW STOCK'
        ELSE 'OK'
    END AS stock_status

FROM PRODUCT p
JOIN CATEGORY c
ON p.category_id = c.category_id;

 -- TEST QUERIES
 
SELECT * FROM CATEGORY;

SELECT * FROM PRODUCT;

SELECT * FROM CUSTOMER;

SELECT * FROM SALE_ORDER;

SELECT * FROM SALE_ITEM;

SELECT * FROM VW_STOCK_STATUS;

 -- JOIN QUERY
 
SELECT
    p.part_name,
    c.category_name,
    p.unit_price

FROM PRODUCT p
JOIN CATEGORY c
ON p.category_id = c.category_id;

 -- SALES REPORT QUERY
 
SELECT
    so.sale_id,
    c.customer_name,
    p.part_name,
    si.quantity,
    si.unit_price,
    si.subtotal

FROM SALE_ORDER so

JOIN CUSTOMER c
ON so.customer_id = c.customer_id

JOIN SALE_ITEM si
ON so.sale_id = si.sale_id

JOIN PRODUCT p
ON si.product_id = p.product_id;

 -- LOW STOCK QUERY
 
SELECT *
FROM VW_STOCK_STATUS
WHERE stock_status = 'LOW STOCK';

 -- AGGREGATION QUERY
 
SELECT
    SUM(total_amount) AS total_sales
FROM SALE_ORDER;

 -- BEST SELLING PRODUCTS
 
SELECT
    p.part_name,
    SUM(si.quantity) AS total_sold

FROM SALE_ITEM si
JOIN PRODUCT p
ON si.product_id = p.product_id

GROUP BY p.part_name
ORDER BY total_sold DESC;

 -- ADVANCED NESTED QUERIES
 
 -- QUERY
-- Products With Above Average Price
 
SELECT
    product_id,
    part_name,
    unit_price

FROM PRODUCT

WHERE unit_price >
(
    SELECT AVG(unit_price)
    FROM PRODUCT
);

 -- QUERY
-- Customers Who Never Purchased
 
SELECT
    customer_id,
    customer_name

FROM CUSTOMER

WHERE customer_id NOT IN
(
    SELECT customer_id
    FROM SALE_ORDER
);

 -- QUERY
-- Products Never Sold
 
SELECT
    p.product_id,
    p.part_name,
    p.qty_in_stock

FROM PRODUCT p

WHERE NOT EXISTS
(
    SELECT *
    FROM SALE_ITEM s
    WHERE s.product_id = p.product_id
);

 -- QUERY
-- Customers Having Outstanding Balance
-- Greater Than Average Outstanding
 
SELECT
    customer_name,
    outstanding_balance

FROM CUSTOMER

WHERE outstanding_balance >
(
    SELECT AVG(outstanding_balance)
    FROM CUSTOMER
);

 -- QUERY
-- Most Expensive Product
 
SELECT
    part_name,
    unit_price

FROM PRODUCT

WHERE unit_price =
(
    SELECT MAX(unit_price)
    FROM PRODUCT
);