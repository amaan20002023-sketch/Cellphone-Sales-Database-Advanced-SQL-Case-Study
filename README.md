# Cellphone-Sales-Database-Advanced-SQL-Case-Study
https://github.com/amaan20002023-sketch/Cellphone-Sales-Database-Advanced-SQL-Case-Study

# Cellphone Sales Database – Advanced SQL Case Study (AnalytixLabs)

[![SQL](https://img.shields.io/badge/SQL-Advanced%20Queries-blue)](https://www.microsoft.com/en-us/sql-server)
[![AnalytixLabs](https://img.shields.io/badge/Assessment-AnalytixLabs-purple)](https://www.analytixlabs.co.in/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains my complete solution to the **Advanced SQL Case Study** on cellphone sales transactions from AnalytixLabs.

The task required creating a database schema from scratch (no raw data provided) based on the given ER diagram, then writing 10 complex SQL queries to answer real business questions about manufacturers, models, customers, locations, and sales trends.

## Project Overview

**Business Scenario**  
A cellphone sales database is used to analyze transaction patterns, manufacturer performance, model popularity, customer geography, and year-over-year changes.

**Tables (Star Schema)**
- **Dim_Manufacturer** – manufacturer_id, manufacturer_name
- **Dim_Model** – model_id, model_name, manufacturer_id (FK)
- **Dim_Customer** – customer_id, customer_name (demographics inferred)
- **Dim_Location** – location_id, zip_code, city, state, country
- **Fact_Transactions** – transaction_id, model_id (FK), customer_id (FK), location_id (FK), date, quantity, price (inferred)

**Key Rules Followed**
- Schema created exactly as per ER diagram representation
- No access to actual data → queries written generically and logically correct
- Each question wrapped in `-- Qx BEGIN` / `-- Qx END` comments
- Final submission format: single .sql file (renamed with email)

## Business Questions Solved (10 Queries)

1. List all states in the US where customers bought cellphones from 2005 onwards.
2. Find the US state that bought the most Samsung cellphones.
3. Show the number of transactions for each model per zip code per state.
4. Find the cheapest cellphone model (with its price).
5. List average price of each model in the top 5 manufacturers by total quantity sold.
6. Find customers who spent more than $500 on average in 2009.
7. Find models that appeared in the top 5 quantity sold in each of the years 2008, 2009, and 2010.
8. Find the manufacturer with the 2nd highest sales amount in 2009 and in 2010.
9. List manufacturers who sold cellphones in 2010 but did not sell any in 2009.
10. For the top 100 customers by total spend: show average spend & quantity per year, and % change in spend year-over-year.

## Repository Structure
