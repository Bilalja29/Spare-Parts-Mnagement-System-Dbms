# Spare Parts Management System Database

A comprehensive **Database Management System (DBMS)** for managing a spare parts shop. This system handles inventory management, supplier relationships, customer transactions, purchase orders, and sales operations for an automotive spare parts retail business.

---

## 📋 Table of Contents
- [Overview](#overview)
- [Database Schema](#database-schema)
- [Features](#features)
- [Installation](#installation)
- [Sample Data](#sample-data)
- [Usage Examples](#usage-examples)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Future Enhancements](#future-enhancements)

---

## 🎯 Overview

This DBMS is designed for automotive spare parts shops to:
- **Manage Inventory** - Track stock levels and reorder points
- **Handle Suppliers** - Maintain supplier information and payment status
- **Track Customers** - Manage customer types and credit limits
- **Process Orders** - Record both purchases from suppliers and sales to customers
- **Monitor Finances** - Track payments and outstanding balances

**Technology Stack:**
- Database: MySQL 5.7+
- Language: SQL
- Default Database: `spare_parts_shop`

---

## 🗄️ Database Schema

### 1. **CATEGORY** Table
Stores product categories classified by vehicle type.

| Column | Type | Constraints |
|--------|------|-----------|
| category_id | INT | PRIMARY KEY |
| category_name | VARCHAR(50) | NOT NULL, UNIQUE |
| vehicle_type | VARCHAR(30) | NOT NULL |

**Sample Data:**
```
Motorcycle - Engine Parts
Motorcycle - Electrical Parts
Car - Brake System
General - Filters
Motorcycle - Body & Frame
```

---

### 2. **PRODUCT** Table
Manages spare parts inventory with pricing and stock levels.

| Column | Type | Constraints |
|--------|------|-----------|
| product_id | INT | PRIMARY KEY |
| part_name | VARCHAR(100) | NOT NULL |
| part_number | VARCHAR(30) | NOT NULL, UNIQUE |
| category_id | INT | NOT NULL, FK → CATEGORY |
| unit_price | DECIMAL(10,2) | NOT NULL |
| cost_price | DECIMAL(10,2) | NOT NULL |
| qty_in_stock | INT | DEFAULT 0 |
| reorder_level | INT | DEFAULT 5 |

**Example Products:**
- Piston Ring Set (CD70) - PKR 850
- Clutch Plate Set - PKR 1,200
- CDI Unit - PKR 1,800
- Spark Plug NGK - PKR 250
- Oil Filter (Universal) - PKR 350

---

### 3. **SUPPLIER** Table
Supplier information and contact details.

| Column | Type | Constraints |
|--------|------|-----------|
| supplier_id | INT | PRIMARY KEY |
| supplier_name | VARCHAR(100) | NOT NULL |
| contact_person | VARCHAR(80) | Optional |
| phone | VARCHAR(15) | NOT NULL, UNIQUE |
| city | VARCHAR(50) | DEFAULT 'Rawalpindi' |
| balance_due | DECIMAL(12,2) | DEFAULT 0 |

**Sample Suppliers:**
- Al-Madina Traders (Rawalpindi)
- Punjab Auto Parts (Lahore)
- Pak Motor Accessories (Rawalpindi)

---

### 4. **CUSTOMER** Table
Customer records with credit management.

| Column | Type | Constraints |
|--------|------|-----------|
| customer_id | INT | PRIMARY KEY |
| customer_name | VARCHAR(100) | NOT NULL |
| phone | VARCHAR(15) | Optional |
| customer_type | VARCHAR(10) | DEFAULT 'CASH' (CASH/CREDIT) |
| credit_limit | DECIMAL(12,2) | DEFAULT 0 |
| outstanding_balance | DECIMAL(12,2) | DEFAULT 0 |

**Customer Types:**
- **CASH** - Pay immediately
- **CREDIT** - Has credit limit and outstanding balance

---

### 5. **PURCHASE_ORDER** Table
Purchase orders placed with suppliers.

| Column | Type | Constraints |
|--------|------|-----------|
| po_id | INT | PRIMARY KEY |
| supplier_id | INT | NOT NULL, FK → SUPPLIER |
| po_date | DATE | DEFAULT CURRENT_DATE |
| total_amount | DECIMAL(12,2) | DEFAULT 0 |
| amount_paid | DECIMAL(12,2) | DEFAULT 0 |
| payment_status | VARCHAR(15) | DEFAULT 'PENDING' |

**Payment Status Values:** PENDING, PARTIAL, PAID

---

### 6. **PURCHASE_ITEM** Table
Line items for each purchase order.

| Column | Type | Constraints |
|--------|------|-----------|
| po_item_id | INT | PRIMARY KEY |
| po_id | INT | NOT NULL, FK → PURCHASE_ORDER |
| product_id | INT | NOT NULL, FK → PRODUCT |
| quantity | INT | NOT NULL |
| unit_cost | DECIMAL(10,2) | NOT NULL |
| subtotal | DECIMAL(12,2) | **AUTO-CALCULATED** |

**Note:** Subtotal is computed as `quantity * unit_cost` and stored automatically.

---

### 7. **SALE_ORDER** Table
Sales transactions to customers.

| Column | Type | Constraints |
|--------|------|-----------|
| sale_id | INT | PRIMARY KEY |
| customer_id | INT | NOT NULL, FK → CUSTOMER |
| sale_date | DATE | DEFAULT CURRENT_DATE |
| total_amount | DECIMAL(12,2) | DEFAULT 0 |
| amount_paid | DECIMAL(12,2) | DEFAULT 0 |
| payment_mode | VARCHAR(15) | DEFAULT 'CASH' |

**Payment Modes:** CASH, CREDIT, CHEQUE, ONLINE

---

### 8. **SALE_ITEM** Table
Line items for each sale order.

| Column | Type | Constraints |
|--------|------|-----------|
| sale_item_id | INT | PRIMARY KEY |
| sale_id | INT | NOT NULL, FK → SALE_ORDER |
| product_id | INT | NOT NULL, FK → PRODUCT |
| quantity | INT | NOT NULL |
| unit_price | DECIMAL(10,2) | NOT NULL |
| subtotal | DECIMAL(12,2) | **AUTO-CALCULATED** |

---

## ✨ Features

✅ **Inventory Management**
- Track stock quantities and reorder levels
- Monitor profit margins (cost vs. selling price)

✅ **Multi-Supplier Management**
- Store supplier contact information
- Track outstanding supplier balances

✅ **Customer Relationship Management**
- Support both cash and credit customers
- Track credit limits and outstanding balances

✅ **Purchase Order System**
- Create and track purchase orders
- Monitor payment status (PENDING, PARTIAL, PAID)

✅ **Sales Order System**
- Process customer sales
- Support multiple payment modes

✅ **Referential Integrity**
- Foreign keys enforce data consistency
- Cascading operations for data safety

✅ **Auto-Calculated Fields**
- Subtotals automatically computed
- Reduces manual data entry errors

---

## 🚀 Installation

### Prerequisites
- **MySQL Server** 5.7 or higher
- **SQL Client** (MySQL Workbench, DBeaver, PHPMyAdmin, or command line)
- Basic SQL knowledge

### Steps

1. **Download the SQL file**
   - Save `Project dbms.sql` to your computer

2. **Open your SQL Client**
   - MySQL Workbench, DBeaver, or MySQL command line

3. **Run the Script**
   ```bash
   mysql -u root -p < "Project dbms.sql"
   ```
   
   Or copy and paste the entire file content into your SQL client and execute.

4. **Verify Installation**
   ```sql
   USE spare_parts_shop;
   SHOW TABLES;
   DESCRIBE CATEGORY;
   ```

5. **Check Sample Data**
   ```sql
   SELECT * FROM CATEGORY;
   SELECT * FROM PRODUCT;
   SELECT * FROM SUPPLIER;
   SELECT * FROM CUSTOMER;
   ```

---

## 📊 Sample Data

The database comes pre-loaded with sample data:

**8 Products** including:
- Piston Ring Sets, Clutch Plates, CDI Units
- Spark Plugs, Brake Discs, Oil Filters, Air Filters, Chain Sprockets

**3 Suppliers** from major Pakistani auto parts dealers

**4 Sample Customers** including workshops and mechanics

**1 Purchase Order** with items already processed

**1 Sale Order** to a customer

---

## 💡 Usage Examples

### View All Products in Stock
```sql
SELECT product_id, part_name, qty_in_stock, unit_price 
FROM PRODUCT 
WHERE qty_in_stock > 0 
ORDER BY part_name;
```

### Low Stock Alert (Below Reorder Level)
```sql
SELECT product_id, part_name, qty_in_stock, reorder_level 
FROM PRODUCT 
WHERE qty_in_stock <= reorder_level 
ORDER BY qty_in_stock ASC;
```

### Customer Credit Summary
```sql
SELECT customer_name, customer_type, credit_limit, outstanding_balance 
FROM CUSTOMER 
WHERE customer_type = 'CREDIT' 
ORDER BY outstanding_balance DESC;
```

### Get Purchase Order Details
```sql
SELECT po.po_id, po.po_date, s.supplier_name, po.total_amount, po.payment_status
FROM PURCHASE_ORDER po
JOIN SUPPLIER s ON po.supplier_id = s.supplier_id;
```

### Get Sale Order Details
```sql
SELECT so.sale_id, so.sale_date, c.customer_name, so.total_amount, so.payment_mode
FROM SALE_ORDER so
JOIN CUSTOMER c ON so.customer_id = c.customer_id;
```

### Get Profit Analysis
```sql
SELECT 
    product_id, 
    part_name, 
    cost_price, 
    unit_price, 
    (unit_price - cost_price) AS profit_per_unit,
    qty_in_stock
FROM PRODUCT 
ORDER BY profit_per_unit DESC;
```

### Supplier Outstanding Balance
```sql
SELECT supplier_name, phone, city, balance_due
FROM SUPPLIER 
WHERE balance_due > 0 
ORDER BY balance_due DESC;
```

---

## 🔄 Entity Relationship Diagram

```
CATEGORY
   ↑
   │
PRODUCT ←────┐
   ↑         │
   │      PURCHASE_ITEM ← PURCHASE_ORDER → SUPPLIER
   │         │
   └─────────┴─ SALE_ITEM ← SALE_ORDER → CUSTOMER
```

### Key Relationships:
- CATEGORY → PRODUCT (One-to-Many)
- PRODUCT → PURCHASE_ITEM (One-to-Many)
- PRODUCT → SALE_ITEM (One-to-Many)
- SUPPLIER → PURCHASE_ORDER (One-to-Many)
- PURCHASE_ORDER → PURCHASE_ITEM (One-to-Many)
- CUSTOMER → SALE_ORDER (One-to-Many)
- SALE_ORDER → SALE_ITEM (One-to-Many)

---

## 🔮 Future Enhancements

🔄 **Planned Features:**
- Stored procedures for complex operations
- Database views for reporting
- Triggers for automatic stock updates
- User authentication and roles
- Transaction logging and audit trails
- Backup and recovery procedures
- Advanced reporting and analytics
- Dashboard for real-time inventory status
- Automated low-stock email notifications
- Invoice generation system
- Return/refund management

---

## 📝 Notes

- All prices are in Pakistani Rupees (PKR)
- Default city for suppliers is Rawalpinski
- Subtotals in order items are auto-calculated
- Dates default to current system date
- Phone numbers should be stored as VARCHAR for flexibility

---

## 👤 Author
**Bilal**

## 📅 Date Created
May 11, 2026

## 📜 License
Educational Project

---

## 📧 Support
For questions or issues regarding this database system, please refer to the code comments or contact the project author.

---

**Last Updated:** May 11, 2026
