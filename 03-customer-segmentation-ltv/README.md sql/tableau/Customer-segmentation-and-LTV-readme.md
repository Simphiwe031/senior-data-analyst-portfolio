**Business problem**
The business lacked a clear understanding of which customers drive long-term revenue and which acquisition channels produce the highest lifetime value. Decision arounf marketing spend and retention were being made using short-term metrics instead of LTV.

This project aims to :
- Calculate customer LTV 
- Segment users by value 
- Identify high-ROI acquisition channels
- Support strategic investment decisions

**Dataset**
Synthetic SaaS data representing:
- Users
- Subscriptions
- Product events
The dataset was generated to reflect realistic subscription lifecycles, churn behaviour, and payment patterns.

**Data Preparation & Quality**
- Validated primary and foreign keys across all tables
- Checked for duplicates using window functions 
- Ensure date consisteny (subscription and invoice periods)
- Flagged invalid revenue value
- Profiled categorical variables (plan type, payment status)

**LTV Methodology**
The LTV was calculated by taking the sum of all customer payments. key steps include:
1. Aggregate total revenue per user
2. Join revenue to user and acquisition data
3. Segment users into High/Medium/Low value using percentile thresholds
4. Analyze LTV by:
    - Acquisition channel
    - Subscription plan 
    - Engagement behavior

**Key Insights**
- A small percentage of users account for a disproportional large share of revenue
- Social acquisition produced the highest total LTV despite not having the user count
- High-value customers showed stronger engagement and longer subscription duration 
- Significant opportunity exists to optimize acquisition spend toward high-LTV channels

**Business Impact**
- Enabled data-driven acquisition strategy
- Provided a foundation for target retention campaigns
- supported long-term revenue forecasting and planning

**Skills demostrated**
- Advanced SQL aggregation and joins
- Data validation and integrity checks
- LTV modeling and segmentation
- Business-focused storytelling