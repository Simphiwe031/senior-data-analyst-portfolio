**Business Problem**
Missed medical appointment reduce operational efficiency, increase costs, and delay patient care.
This project analyzes appointment behavior to identify drivers of no shows and demonstrates how analytics can support operational and predictive interventions.

**Objectives**
- Measure overall appointment no-show rate
- Identify high-risk patient and scheduling segments
- Evaluate the impact of SMS reminders
- Build a decision-support dashboard
- Prepare an ML-ready dataset to predict no-show risk

**Dataset**
A synthetic healthcare dataset was generated to reflect real-world appointment data, including:
- Patient demographics
- Scheduled vs appointment dates
- SMS reminder indicators
- Attandance outcomes
The dataset was designed to avoid encoding issues while maintaining analytical realism.

**Data Preparation & Feature Engineering**
- Calculated lead time between booking and appointment
- Created age groups and lead-time buckets
- Extracted appointment day of week and month
- Standardized categorical fields for analytics and ML
- Validated data quality (negative lead times, invalid ages)

**Key Metrics & Analysis**
- Overall no-show rate
- No-show rate by:
    - Lead time group
    - Age group
    - SMS reminder status
    - Day of week
- Identification of highest risk scheduling patterns 

**Dashboard (Tableau)**
An executive healthcare operations dashboard was built featuring:
- KPI tiles(no-show rate, SMS effectiveness, highest-risk lead time)
- Risk segmentation visuals
- Clear storytelling and operational insights

**Predictive Modeling (Optional Enhancement)**
- Prepared an ML-ready feature set
- Trained a logistic regression model to predict no-show risk
- Evaluated performance using ROC-AUC, precision, recall and F1-score
- Interpreted model coefficients to identify key risk drivers
- Generated risk scores to demonstrate proactive intervention use cases

**Tools & Technologies**
- SQL (MySQL) - data modeling & feature engineering
- Python (Pandas, Scikit-learn) - encoding, modeling, evaluation
- Tableau - executive dashboards and story telling
- Logistic Regression - interpretable predictive modeling 

**Key Insights**
- Longer lead times and same day appointments increase no-show risk.
- SMS reminders are associated with no-show rates
- Certain age group exhibit consistently higher risk
- Predictive risk scoring enables targeted operation interventions

**Outcomes**
This project demonstrates the ability to:
- Build end-to-end analytics pipelines
- Combine descriptive, diagnostic, and predictive analytics
- Translate data insights into operational healthcare decisions