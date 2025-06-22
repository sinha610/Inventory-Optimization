-- Aggregate Orders at Customer Market + Product + YearMonth

WITH cte_orders AS (
    SELECT
        customer_market,
        product_name,
        order_yearmonth,
        SUM(order_quantity) AS total_orders,
        SUM(gross_sales) AS total_gross_sales,
        SUM(profit) AS total_profit,
        AVG(discount) AS avg_discount
    FROM orders_and_shipments
    GROUP BY customer_market, product_name, order_yearmonth
),

-- Sales Ranking (ABC Buckets)

sales_ranking AS (
    SELECT *,
        NTILE(3) OVER (
            PARTITION BY customer_market
            ORDER BY total_gross_sales DESC
        ) AS sales_rank
    FROM cte_orders
),
sales_bucketed AS (
    SELECT *,
        CASE sales_rank
            WHEN 1 THEN 'High'
            WHEN 2 THEN 'Medium'
            ELSE 'Low'
        END AS sales_bucket
    FROM sales_ranking
),

-- Profit Ranking (Profit Buckets)
profit_ranking AS (
    SELECT *,
        NTILE(3) OVER (
            PARTITION BY customer_market
            ORDER BY total_profit DESC
        ) AS profit_rank
    FROM cte_orders
),
profit_bucketed AS (
    SELECT *,
        CASE profit_rank
            WHEN 1 THEN 'High'
            WHEN 2 THEN 'Medium'
            ELSE 'Low'
        END AS profit_bucket
    FROM profit_ranking
),

-- Demand Variability Calculation (CV)
cv_calc AS (
    SELECT
        customer_market,
        product_name,
        STDDEV_SAMP(total_orders) AS std_orders,
        AVG(total_orders) AS mean_orders,
        ROUND(STDDEV_SAMP(total_orders) / NULLIF(AVG(total_orders), 0), 4) AS demand_variability
    FROM cte_orders
    GROUP BY customer_market, product_name
),

-- Demand Variability Buckets (XYZ)
cv_bucketed AS (
    SELECT *,
        CASE
            WHEN demand_variability <= 0.5 THEN 'Low Variability'
            WHEN demand_variability <= 1.0 THEN 'Medium Variability'
            ELSE 'High Variability'
        END AS demand_bucket
    FROM cv_calc
)

--  Final Output
SELECT
    s.customer_market,
    s.product_name,
    s.order_yearmonth,
    CASE
        WHEN RIGHT(s.order_yearmonth, 2) IN ('01','02','03') THEN 'Q1'
        WHEN RIGHT(s.order_yearmonth, 2) IN ('04','05','06') THEN 'Q2'
        WHEN RIGHT(s.order_yearmonth, 2) IN ('07','08','09') THEN 'Q3'
        WHEN RIGHT(s.order_yearmonth, 2) IN ('10','11','12') THEN 'Q4'
    END AS quarter,
    s.total_orders,
    s.total_gross_sales,
    s.total_profit,
    s.avg_discount,
    s.sales_bucket,
    p.profit_bucket,
    d.demand_variability,
    d.demand_bucket,
    CASE
        WHEN s.sales_bucket = 'High' AND d.demand_bucket = 'Low Variability' THEN 'A-X'
        WHEN s.sales_bucket = 'High' AND d.demand_bucket = 'Medium Variability' THEN 'A-Y'
        WHEN s.sales_bucket = 'High' AND d.demand_bucket = 'High Variability' THEN 'A-Z'
        WHEN s.sales_bucket = 'Medium' AND d.demand_bucket = 'Low Variability' THEN 'B-X'
        WHEN s.sales_bucket = 'Medium' AND d.demand_bucket = 'Medium Variability' THEN 'B-Y'
        WHEN s.sales_bucket = 'Medium' AND d.demand_bucket = 'High Variability' THEN 'B-Z'
        WHEN s.sales_bucket = 'Low' AND d.demand_bucket = 'Low Variability' THEN 'C-X'
        WHEN s.sales_bucket = 'Low' AND d.demand_bucket = 'Medium Variability' THEN 'C-Y'
        WHEN s.sales_bucket = 'Low' AND d.demand_bucket = 'High Variability' THEN 'C-Z'
    END AS abc_xyz_segment,
    CASE
        WHEN s.sales_bucket = 'High' AND d.demand_bucket = 'Low Variability' THEN 'Top Focus'
        WHEN s.sales_bucket = 'High' AND d.demand_bucket = 'Medium Variability' THEN 'Growth Driver'
        WHEN s.sales_bucket = 'High' AND d.demand_bucket = 'High Variability' THEN 'Unstable Star'
        WHEN s.sales_bucket = 'Medium' AND d.demand_bucket = 'Low Variability' THEN 'Steady Opportunity'
        WHEN s.sales_bucket = 'Medium' AND d.demand_bucket = 'Medium Variability' THEN 'Mid-Tier Performer'
        WHEN s.sales_bucket = 'Medium' AND d.demand_bucket = 'High Variability' THEN 'Volatile Opportunity'
        WHEN s.sales_bucket = 'Low' AND d.demand_bucket = 'Low Variability' THEN 'Slow Mover'
        WHEN s.sales_bucket = 'Low' AND d.demand_bucket = 'Medium Variability' THEN 'Uncertain Value'
        WHEN s.sales_bucket = 'Low' AND d.demand_bucket = 'High Variability' THEN 'Phase Out'
    END AS segment_label

FROM sales_bucketed s
LEFT JOIN profit_bucketed p
    ON s.customer_market = p.customer_market
    AND s.product_name = p.product_name
    AND s.order_yearmonth = p.order_yearmonth
LEFT JOIN cv_bucketed d
    ON s.customer_market = d.customer_market
    AND s.product_name = d.product_name;
