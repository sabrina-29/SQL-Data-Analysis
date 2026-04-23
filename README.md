# SQL-Data-Analysis
SQL Analytics Project — WideWorldImporters
A comprehensive SQL analysis project based on the WideWorldImporters sample database.
This repository demonstrates advanced querying techniques for business insights, including revenue analysis, customer segmentation, product profitability, and churn detection.

📘 Table of Contents
🧬 Overview
🛠 Technologies Used
📊 Query Breakdown (Q1–Q10)
🎯 Key Insights
▶️ How to Run
📈 Use Cases
🧬 Overview

This project contains 10 analytical SQL queries (Q1–Q10) designed to extract meaningful business insights from transactional data.
The queries cover:
Revenue analysis
Customer ranking
Product profitability
Supplier-product relationships
Geographic insights
Time-series reporting
Churn prediction

🛠 Technologies Used
SQL Server
T-SQL
Window Functions (LAG, ROW_NUMBER, DENSE_RANK)
Aggregations (SUM, COUNT, STRING_AGG)
CTEs (Common Table Expressions)
Pivot Tables

📊 Query Breakdown
🔹 Q1 — Yearly Revenue & Growth Analysis
Goal: Analyze yearly performance and growth trends
✔ Calculates:
Total yearly revenue
Active sales months
Linear annual revenue (normalized to 12 months)
Year-over-year growth (%)
🧠 Techniques: CTEs, LAG(), aggregation
🔹 Q2 — Top 5 Customers per Quarter

Goal: Identify high-value customers over time
✔ Features:
Revenue per customer per quarter
Ranking using DENSE_RANK()
Top 5 filtering
📌 Insight: Highlights top-performing customers by quarter

🔹 Q3 — Top 10 Most Profitable Products
Goal: Find best-performing products
✔ Calculates:
Profit = ExtendedPrice - TaxAmount
Total profit per product
📌 Insight: Identifies key revenue drivers

🔹 Q4 — Product Profit Ranking (Nominal Margin)
Goal: Rank products by markup
✔ Formula:
Profit = RecommendedRetailPrice - UnitPrice
🧠 Techniques: ROW_NUMBER()
📌 Insight: Reveals products with highest margins

🔹 Q5 — Supplier → Product Mapping
Goal: Aggregate products per supplier
✔ Uses:
STRING_AGG() for concatenation
📌 Insight: Clean and readable supplier-product relationships

🔹 Q6 — Top 5 Customers by Revenue (with Geography)
Goal: Combine financial and geographic insights
✔ Includes:
City
Country
Continent
Region
📌 Insight: Identifies where top customers are located

🔹 Q7 — Monthly Revenue Dashboard
Goal: Build a complete financial report
✔ Includes:
Monthly revenue
Cumulative yearly revenue
Yearly Grand Total
🧠 Techniques: Window functions + UNION ALL

🔹 Q8 — Pivot Table (Orders by Month & Year)
Goal: Analyze seasonal trends
✔ Features:
Monthly order counts
Pivoted columns (2013–2016)
📌 Insight: Reveals seasonality patterns

🔹 Q9 — Customer Churn Detection
Goal: Identify at-risk customers
✔ Logic:
Average days between orders
Days since last order
Churn condition:
Inactivity > 2 × Avg Interval
📌 Output:
Active
Potential Churn
🧠 Techniques: LAG(), window functions

🔹 Q10 — Customer Category Distribution
Goal: Analyze customer segmentation
✔ Special grouping:
"Wingtip%" → one group
"Tailspin%" → one group

✔ Includes:
Category counts
Distribution percentages
📌 Insight: Customer base composition
🎯 Key Insights
📈 Revenue trends and growth patterns
🏆 Identification of top customers and products
🌍 Geographic distribution of revenue
📉 Early churn detection signals
📊 Seasonality and order behavior
🧩 Customer segmentation analysis

▶️ How to Run
Open SQL Server Management Studio (SSMS)
Load the WideWorldImporters database
Execute each query (Q1–Q10) individually
Review results in the output panel

📈 Use Cases
This project is ideal for:
📊 Data Analyst portfolios
🎓 Academic SQL assignments
🤖 Machine learning preprocessing
🧪 SQL practice and interview prep
📉 Business intelligence reporting

⭐ Final Notes
This project demonstrates strong skills in:
Writing complex SQL queries
Using analytical functions
Translating data into actionable insights
Structuring clean, readable SQL code
