SaaS Retention & Churn Analysis

**Business Problem**
SaaS companies rely on recurring revenue, making customer retention and churn critical metrics. 
This project analyzes user subscription behavioir to identify churn trends, retention patterns, and risk signals that can inform growth and retention strategies.

**Objectives**
- measure overall and monthly churn
- Track active users over time
- Identify peak churn periods
- Build executive-ready KPIs for decision making
- Create a scalable analytics model suitable for SaaS businesses

**Data Model**
The project uses a relational schema with the core tables:
- Users - customer acquisition and signup data
- Subscriptions - plan details, start/end dates, pricing
- Product Events - user engagement signals
This structure mirrors real SaaS production databases.

**Data preparation & Feature Engineering**
- Cleaned and validated subscription dates
- Handled NULL end dates to represent active subcscriptions
- Created time-based features for monthly analysis
- Calculated rolling metrics to capture trends over time

**Key Metrcis & Analysis**
- Total active users
- Monthly churn rate
- Average churn 
- Peak churn 
- Rolling 3-month churn average
- Active vs churned users over time

**Dashboard (Tableau)**
An executive dashboard was built to:
- Monitor churn and retention KPIs
- Visualize trends across months and years
- Identify periods of elevated churn risk
- Support data-driven retention decisions

**Tools & Technologies**
- SQL (MySQL) -  data modeling, cleaning, analysis
- Tableau - KPI design and dashboarding
- Business metrics design - churn & retention modeling

**Key Insights**
- Churn is not evenlt distributed over time and exhibits seasonal spikes
- Rolling averages smooth volatility and reveal underlying churn trends
- Monitoring peak churn periods enables proactive retention actions

**Outcome**
This project demonstrates the ability to:
- Design scalable SaaS analytics models
- Translate raw subscription data into executive insights
- Build dashboards aligned with business decision-making