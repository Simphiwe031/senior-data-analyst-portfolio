**Data Cleaning and Standardization (MySQL)**

**Overview**
This project demonstrates an end-to-end SQL data cleaning pipeline for a messy subscription orders data sets with 6000 records. The object was to transform raw export data into a clean, analysis-ready dataset using MySQL.

**Raw Data Issues Identified**
- Multiple representation of NULL ('','n/a','-','null')
- Currency symbols and commas in numeric fields
- Mixed datetime formats
- Duplicate orders IDs
- Negative revenue values
- Invalid quantities (<0)
- Extreme statistical outliers

**Cleaning Strategy**
1. Staging Layer
    - Standardized fake NULL values to proper SQL NULL
    - Preserved raw dataset integrity
2. Clean Layer
    - Standardized order_id formatting
    - Parsed order_amount safely using regex validation
    - Convertrd quantity to integer
    - Flagged:
        - Missing values
        - Business-rule invalids
        - Statistical outliers (IQR method)
3. Outlier Detection
Used IQR method.
For order_amount:
- Q1 = 107.87
- Q3 = 1099.35
- IQR = Q3 - Q1 = 991.48
- Upper bound = 2586.57

For quantity
- Q1 = 1
- Q3 = 2
- IQR = 1
- Upper bound = 3
Outliers were winsorized instead of removed to preserve data distribution.

**Deduplication**
Used ROW_NUMBER() window function to retain best record per standardized order_id