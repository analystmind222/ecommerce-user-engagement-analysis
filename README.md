# ecommerce-user-engagement-analysis
SQL + Power BI project analyzing user funnel, conversion rate and customer behavior.

# E-Commerce Product Analytics: User Engagement, Funnel & Conversion Analysis

## Project Overview
This project analyzes user behavior across an e-commerce purchase journey using SQL and Power BI. The objective was to understand user engagement, identify conversion bottlenecks, measure cart abandonment, and generate business insights to improve customer conversion and retention.

---

## Tools Used
- MySQL
- Power BI
- Excel

---

## Dataset
Dataset: E-commerce Events History in Cosmetics Store

Period Covered: October 2019

Key Fields:
- event_time
- event_type
- product_id
- category_code
- brand
- user_id
- user_session
- price

---

## Business Objectives
- Analyze user engagement patterns
- Understand customer purchase funnel
- Measure conversion rates
- Analyze cart abandonment behavior
- Identify top-performing products, brands, and categories
- Evaluate returning vs new user behavior

---

## Data Cleaning & Validation
- Reviewed dataset schema
- Validated event types
- Checked missing values
- Performed duplicate analysis
- Verified data consistency before analysis

### Event Types
- View
- Cart
- Remove From Cart
- Purchase

---

## Funnel Analysis
### Funnel Stages
| Stage | Users |
|---------|--------:|
| Viewed Users | 2526 |
| Cart Users | 716 |
| Purchased Users | 149 |

### Conversion Metrics
| Metric | Value |
|----------|--------:|
| View-to-Cart Conversion | 28.35% |
| Cart-to-Purchase Conversion | 20.81% |
| Overall Conversion Rate | 5.90% |

---

## Cart Abandonment Analysis
| Metric | Value |
|----------|--------:|
| Cart Users | 716 |
| Purchased Users | 149 |
| Abandoned Users | 567 |
| Cart Abandonment Rate | 79.19% |

---

## User Segmentation
| Segment | Users |
|------------|--------:|
| One Session Users | 2282 |
| Returning Users | 415 |

### User Distribution
- One Session Users: 84.61%
- Returning Users: 15.39%

---

## Dashboard Components
### KPI Cards
- Total Events
- Total Users
- Viewed Users
- Cart Users
- Purchased Users
- Overall Conversion Rate
- Cart Abandonment Rate

### Visualizations
- Conversion Funnel
- Event Distribution
- Top Categories by Events
- Top Brands by Events
- Top Products by Events
- Returning vs New Users

---

## Key Insights
- Only 5.90% of users completed a purchase.
- Cart abandonment rate reached 79.19%.
- Most users interacted with the platform only once.
- A small number of categories and brands generated the majority of engagement.
- Returning users accounted for only 15.39% of total users.

---

## Skills Demonstrated
- SQL
- Data Cleaning
- Exploratory Data Analysis (EDA)
- Funnel Analysis
- User Segmentation
- KPI Development
- Power BI Dashboarding
- Business Insight Generation
