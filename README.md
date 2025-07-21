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


--------

<img width="1291" height="345" alt="image" src="https://github.com/user-attachments/assets/811fede8-2b82-4abc-98be-a0fd7eded003" />

--------

<img width="1366" height="656" alt="image" src="https://github.com/user-attachments/assets/60dc8288-3fbb-4988-885d-9ef0db11afcc" />

--------

<img width="1532" height="602" alt="image" src="https://github.com/user-attachments/assets/ed22aff4-f8a7-435d-afc1-2b4c5b93caba" />

--------

<img width="1605" height="402" alt="image" src="https://github.com/user-attachments/assets/17cb936f-5e58-4fab-a7b6-fd6647e25f5e" />


Balanced inventory instances never crossed 16 in any given month, indicating room for improvement in aligning inventory levels with actual demand.
Understock and overstock events remained persistently high throughout the observed period (Jan 2015 – Dec 2017), reflecting ongoing challenges in demand forecasting and inventory planning.
Overstocking showed intermittent spikes — most prominently in August 2015 (32 cases) and March 2016 — but generally declined by late 2017, suggesting some gradual improvement in stock management.


