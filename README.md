# SQL-Data-Analysis
📘 README — SQL Analysis Queries Explained

This document explains the purpose and logic behind each SQL query (Q1–Q10).
All queries are based on the WideWorldImporters sample database.

Q1 — Yearly Revenue, Linear Annual Revenue & Growth Rate

Purpose
Calculate:
Total income per year
Number of distinct months with sales
Linearized annual revenue (projecting partial-year data to 12 months)
Year-over-year growth rate
How it works
YearlySales CTE
Groups invoices by year
Computes revenue = ExtendedPrice - TaxAmount
Counts distinct months
Computes linear annual revenue:
YearlyLinearIncome
=
Income
Months
×
12
Growth CTE
Uses LAG() to get previous year's revenue
Final SELECT
Formats numbers
Computes growth %
Insight
Shows how revenue changes year-to-year and adjusts for incomplete years.

Q2 — Top 5 Customers per Quarter

Purpose
Find the top 5 customers in each year-quarter based on revenue.
How it works
Groups by year, quarter, and customer
Calculates revenue per customer per quarter
Uses DENSE_RANK() to rank customers
Filters to top 5
Insight
Identifies the most valuable customers per quarter.

Q3 — Top 10 Most Profitable Stock Items

Purpose
Find the top 10 products by total profit (ExtendedPrice − TaxAmount).
How it works
Joins invoice lines with stock items
Sums profit per item
Orders descending
Takes top 10
Insight
Shows which products generate the most revenue.

Q4 — Product Profit Ranking (Nominal Profit)

Purpose
Rank products based on recommended retail price − unit price.
How it works
Computes nominal profit per product
Uses ROW_NUMBER() to rank
Filters out items with null LastEditedBy
Insight
Shows which products have the highest markup.

Q5 — Supplier Product Aggregation

Purpose
List each supplier with all their products in a single aggregated string.
How it works
Joins suppliers with archived stock items
Uses STRING_AGG() to concatenate product IDs and names
Insight
Creates a readable supplier → product list mapping.

Q6 — Top 5 Customers by Total Extended Price (with Geography)

Purpose

Find the top 5 customers by revenue, including:
City
Country
Continent
Region
How it works
Joins invoices → invoice lines → customers → cities → states → countries
Groups by customer and location
Orders by revenue
Takes top 5
Insight
Shows which customers generate the most revenue and where they are located.

Q7 — Monthly Revenue + Cumulative Revenue + Grand Total

Purpose
Produce a monthly revenue report with:
Monthly totals
Cumulative totals per year
A “Grand Total” row for each year
How it works
First SELECT: monthly totals + cumulative window function
Second SELECT: yearly totals labeled “Grand Total”
UNION ALL merges them
Sorts by year and month
Insight
Provides a complete year-over-year monthly revenue dashboard.

Q8 — Pivot Table of Orders by Month and Year

Purpose
Create a pivot table showing number of orders per month for years 2013–2016.
How it works
Extracts year and month
Pivots using COUNT(OrderYear)
Columns become years
Insight
Shows seasonal patterns and order volume trends.

Q9 — Customer Churn Detection

Purpose
Identify customers who may be at risk of churn.
How it works
OrdersWithLag
Uses LAG() to compute days between orders
CustomerStats
Computes average days between orders
Finds last order date per customer
LastDateAll
Finds the most recent order in the entire system
Final SELECT
Calculates days since last order
Flags customers as:
Potential Churn if inactivity > 2 × average interval
Active otherwise
Insight
A simple but effective churn prediction model.

Q10 — Customer Category Distribution

Purpose
Count customers per category, with special grouping:
All names starting with Wingtip count as one
All names starting with Tailspin count as one

How it works

Uses CASE to normalize names
Counts distinct normalized names
Computes total customers using window function
Computes distribution %
Insight
Shows how customer categories are distributed across the customer base.

✔️ Summary

This README explains all SQL queries from Q1–Q10, covering:
Revenue analysis
Customer ranking
Product profitability
Supplier-product mapping
Geographic revenue distribution
Monthly and yearly financial reporting
Pivot tables
Churn analysis
Customer category distribution
