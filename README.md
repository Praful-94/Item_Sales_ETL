# Item_Sales_ETL


# Item Sales ETL and Analysis Project

This project demonstrates a complete **ETL (Extract, Transform, Load)** process and SQL-based analytical reporting for a Smoke Shop's item sales dataset using **MySQL Workbench**.

## Project Structure

- **Data Source:** CSV file (`Final_ItemSales.csv`)
- **Database:** MySQL
- **Tables:**
  - `Staging_ItemSales` – Raw import table
  - `Final_ItemSales` – Cleaned and structured analysis table

## ETL Workflow

### 1. Extract
The CSV file is imported into the MySQL staging table using MySQL Workbench’s data import functionality.

### 2. Transform
- Remove unwanted symbols like `$` and `%`.
- Convert string values to `DECIMAL`.
- Handle nulls and invalid financial entries.
- Normalize column names and data types.

### 3. Load
The cleaned data is inserted into the `Final_ItemSales` table with proper data types and structure.


## Database Schema

### `Final_ItemSales` (Main Table)

| Column           | Type          | Description                        |
|------------------|---------------|------------------------------------|
| id               | INT (AI)      | Primary key                        |
| CustomerName     | VARCHAR(255)  | Customer name                      |
| ItemName         | VARCHAR(255)  | Name of the item                   |
| StockCode        | VARCHAR(100)  | Unique stock code                  |
| UnitsSold        | INT           | Units sold                         |
| Category         | VARCHAR(100)  | Product category                   |
| Supplier         | VARCHAR(100)  | Supplier name                      |
| StockLevel       | INT           | Current stock available            |
| Price            | DECIMAL(10,2) | Item price                         |
| Cost             | DECIMAL(10,2) | Cost of item                       |
| Profit           | DECIMAL(10,2) | Profit per item                    |
| Margin           | DECIMAL(7,2)  | Profit margin (%)                  |
| Markup           | DECIMAL(7,2)  | Markup value (%)                   |
| Discounts        | DECIMAL(10,2) | Discount applied                   |
| Tax              | DECIMAL(10,2) | Tax applied                        |
| Total            | DECIMAL(10,2) | Total sale value                   |
| Refunded         | INT           | Units refunded                     |
| RefundedAmount   | DECIMAL(10,2) | Total refund amount                |
| Balance          | DECIMAL(10,2) | Remaining balance                  |


## SQL Analysis Queries

### Sales Analysis
- Top 10 & 15 Selling Items
- Total Revenue
- Total Profit
- Revenue by Category

### Inventory Analysis
- Items with Stock Level < 10
- Items with Stock Level > 300
- Stock Value Estimation

### Financial Insights
- Total Discounts Given
- Category-Wise Discounts
- Category-Wise Profit
- Highest Margin Items
- Margin Distribution

### Refund Analysis
- Refunded Items Summary
- Total Refund Value

### Supplier Analysis
- Supplier-wise Revenue and Profit


## Post-ETL Cleanup
```sql
DROP TABLE IF EXISTS Staging_ItemSales;
````


## ✅ How to Run

1. Open MySQL Workbench.
2. Create the database and tables using the SQL script.
3. Import the CSV file into `Staging_ItemSales`.
4. Run the transformation and insert queries.
5. Run the analysis queries for insights.


## 📚 Author

**Smoke Shop Sales Analyst Project**
Designed for SQL data transformation, business analysis, and reporting.
