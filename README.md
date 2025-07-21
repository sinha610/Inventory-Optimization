# Inventory-Optimization

Problem Statement:

The objective of this project is to analyze demand-supply mismatch using orders data and inventory data at a Product ID - Year-Month level. The goal is to identify patterns of overstocking and understocking across time and help the warehouse and inventory teams optimize stock levels.

Additionally, the project aims to develop an ABC-XYZ Inventory Segmentation based on:

- Sales (Demand)
- Demand Variability (measured using Coefficient of Variation)
- Profit

This segmentation helps prioritize products that need tighter inventory controls and stocking strategies, especially at the Customer-Market level.


Approach

Data Preparation:

Merge orders and inventory data at the Product ID + Year-Month granularity.

Calculate key metrics:
- Total Sales / Demand
- Available Inventory
- Overstock Quantity
- Stockouts / Understock Quantity
- Profit
- Demand Variability (Coefficient of Variation)
- Demand-Supply Mismatch Analysis:

Identify products with consistent overstocking or understocking trends, both:

- Year-on-Year
- Quarter-on-Quarter
- ABC-XYZ Inventory Segmentation:
- Classify products based on:
- Sales (High, Medium, Low)
- Demand Variability (Low, Medium, High)
- Profitability (High, Medium, Low)


Tools Used:

SQL: Data extraction and transformation

Excel: Visaualisation and writing findings.
