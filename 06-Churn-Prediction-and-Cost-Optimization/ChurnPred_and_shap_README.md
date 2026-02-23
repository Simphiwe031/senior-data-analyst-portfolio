**SaaS Customer Churn Prediction & Cost Optimization (Random Forest + SHAP)**

**Bussiness Problem**
SaaS businesses lose revenue when customers churn. This project builds a churn prediction model and uses explainability (SHAP) + cost optimization to decide which customers to target with retention offers to maximize net savings.

**Dataset Overview**
Synthetic SaaS churn dataset with 100,000 customer with the following fields:
- customer_id : unique identifier
- tenure_months : months the customer has been active
- monthly_charges : monthly subscription fee
- avg_monthly_usage : average product usage level
- plan_type : Basic/ Standard/ Premium (one-hot-encoded)
- payment_failures : count of failed payment attempts
- support_tickets : number of support tickets raissed
- last_login_days : days since last login
- churn : target (1=churned, 0=retained)

**WOrkflow (End-to-end)**
1. Data check
    - Verified row count,data types, missing values
    - Confirmed target distribution
2. Feature engineering
    - One-hot encoded plan_type column
3. Modeling
    - Trained a Logistic Regression model
    - Trained a Random Forest Classifier
    - Evaluated models using ROC-AUC and Classification report
4. Explainability
    - used SHAP summary plot for class 1 (churn)
5. Cost optimization
    - Simulated different probability thresholds for targeting retention offers.
    - Compared cost of offers sent, expected benefit from churn prevented
    - net savings to choose the best threshold

**Model Perfomance**
- Random Forest achieved stronger ROC-AUC than baseline Logistic Regression in this run.
- The Random Forset is useful for ranking risk(who is more likely to churn), and then applying business rules for targeting.

**Key insights**
- Customers with high last_login_days have the highest churn risk. Engagement decay is the most powerful early warning indicator.
- Customers with multiple payment_failures show a strong positive SHAP impact toward churn, highlighting operatoinal friction as a key driver.
- Customers with low avg_monthly_usage consistenly push toward higher churn risk, confirming that engagement depth matters more than pricing.
- Lower tenure_months increase churn risk, indicating onboarding and early lifecycle management are critical retention stages.
- monthly_charges an plan_type have minimal SHAP compared to other behavioral variables, suggesting that chuutn is driven more by usage and friction rather than price alone.

**Business Impact**
1. Enables targeted retention instead of blanket campaigns
    - The model allows the company to focus retention efforts on high-risk customers than applying costly offers to all users.
2. Supports proactive engagement strategies
    - Inactivity thresholds (e.g., X days since login) can trigger automated re-engagement campaigns before churn occurs.
3. Improves payment recovery processes
    - Strong impact of payment failures highlights the need for improved retry logic, reminders, and billing communication.
4. Optimizes retention spend through cost simulation
    - Probability threshold simulations balance retention offer cost against expected savings, maximizing net financial return.
5. Shift focus from pricing to behavior-driven retention
    - Findings show engagement and friction matter more than plan price, guiding product and customer success teams toward behavioral interventions.

**Skills Demonstrated**
1. Technical
    - Python (Pandas, Numpy, Scikit-learn)
    - Random Forest Modeling
    - Model Evaluation (ROC-AUC, Precision, Recall, F1)
    - SHAP explainability
    - Threshold & Cost simulation analysis

2. Analytical 
    - Feature Engineerng & encoding
    - Handling Imbalanced Data
    - Model Interpretation for Non-Technical Stakeholders
    - Translating Predictive Output into Business Decisions
    - Risk-Based Customer Targeting Strategy

3. Business & Strategy
    - Retention economics
    - ROI optimization
    - Behavioral Analytics
    - Decidion-oriented modeling (beyond accuracy)