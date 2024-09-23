

SELECT * FROM Sales

ALTER TABLE Sales
ADD Delivery_Wait_Time INT;

UPDATE Sales
SET Delivery_Wait_Time = DATEDIFF(day, order_date_DateOrders, shipping_date_DateOrders);



WITH CustomerRetention AS
(
    SELECT
        Customer_Id,
        MAX(order_date_DateOrders) AS MaxOrderDate,
        MIN(order_date_DateOrders) AS MinOrderDate,
        COUNT(DISTINCT Order_Id) AS PurchaseCount
    FROM
        Sales
    GROUP BY Customer_Id
)
SELECT
    Customer_Id,
    ROUND( CAST( DATEDIFF(day, MinOrderDate, MaxOrderDate) AS FLOAT)
        / NULLIF(PurchaseCount - 1, 0),2) AS ReturnFrequency
INTO Frequency
FROM
    CustomerRetention
WHERE
    PurchaseCount > 1;

SELECT * FROM Frequency



SELECT 
RETURNFREQUENCY_BUCKET, COUNT(*) AS RETURNFREQUENCY
INTO ReturnFrequency
FROM (
SELECT 
    CASE 
        WHEN RETURNFREQUENCY BETWEEN 1 AND 30 THEN '<30 days'
        WHEN RETURNFREQUENCY BETWEEN 31 AND 60 THEN '<60 days'
        WHEN RETURNFREQUENCY BETWEEN 61 AND 90 THEN '<90 days'
        WHEN RETURNFREQUENCY BETWEEN 91 AND 120 THEN '<120 days'
        ELSE '> 120 days'
    END  AS RETURNFREQUENCY_BUCKET

FROM Frequency

) AS A
GROUP BY RETURNFREQUENCY_BUCKET
SELECT * FROM ReturnFrequency

SELECT * FROM sales