
SELECT
    *,
    
    -- Z-Score for Total Purchases
    (TOTAL_PURCHASES - AVG(TOTAL_PURCHASES) OVER ()) 
        / NULLIF(STDDEV_POP(TOTAL_PURCHASES) OVER (), 0) AS Z_TotalPurchases,

    -- Z-Score for Purchase Frequency
    (PURCHASE_FREQ - AVG(PURCHASE_FREQ) OVER ()) 
        / NULLIF(STDDEV_POP(PURCHASE_FREQ) OVER (), 0) AS Z_PurchaseFreq,

    -- Z-Score for Revenue
    (REVENUE_GENERATED - AVG(REVENUE_GENERATED) OVER ()) 
        / NULLIF(STDDEV_POP(REVENUE_GENERATED) OVER (), 0) AS Z_Revenue,

    -- Z-Score for Profit
    (PROFIT - AVG(PROFIT) OVER ()) 
        / NULLIF(STDDEV_POP(PROFIT) OVER (), 0) AS Z_Profit,

    -- Optional: Create a simple Z-based customer segment
    CASE
        WHEN 
            (TOTAL_PURCHASES - AVG(TOTAL_PURCHASES) OVER ()) 
                / NULLIF(STDDEV_POP(TOTAL_PURCHASES) OVER (), 0) > 1
            AND 
            (REVENUE_GENERATED - AVG(REVENUE_GENERATED) OVER ()) 
                / NULLIF(STDDEV_POP(REVENUE_GENERATED) OVER (), 0) > 1
            AND 
            (PROFIT - AVG(PROFIT) OVER ()) 
                / NULLIF(STDDEV_POP(PROFIT) OVER (), 0) > 1
        THEN 'Top Performer'
        
        WHEN 
            (TOTAL_PURCHASES - AVG(TOTAL_PURCHASES) OVER ()) 
                / NULLIF(STDDEV_POP(TOTAL_PURCHASES) OVER (), 0) < -1
            AND 
            (REVENUE_GENERATED - AVG(REVENUE_GENERATED) OVER ()) 
                / NULLIF(STDDEV_POP(REVENUE_GENERATED) OVER (), 0) < -1
        THEN 'Low Value'

        ELSE 'Mid Tier'
    END AS Z_Segment

FROM rfm_customer_segmentation;
