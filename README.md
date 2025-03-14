# Amazon Sales and Basket Analysis Using MySQL and Python (Part - I)
Objective 🎯 : 

1. Conduct an exhaustive analysis of Amazon product purchases that includes revenue analysis over different parts of the year, sales analysis, product analysis, and customer analysis. Performing analysis on the various aspects of the dataset will give us a holistic view of the trends,  hence helping us derive insights that can deliver a wider impact.

2. Conduct basket analysis using the Apriori algorithm to understand product relationships and generate product recommendations.

Business Questions 💵 :

- Average sales volume per day
- Average revenue per order
- Average price of products in each category
- Average spend by each customer per year
- Top 10 dates with the highest revenue
- Top 5 products with the highest revenue for each month and year
- Total revenue by each state

Methodology ⚙ :

- Data Source: The dataset comprises longitudinal purchase data from 5027 Amazon.com users in the US (2018-2022) and includes demographic and consumer-level survey data, linked by a 'Survey ResponseID' present in both the purchase and survey files (via Harvard Dataverse).

- Tools: MySQL for data cleaning and analysis, Python for basket analysis

- Techniques: The analysis employs basic to advanced SQL techniques including CTEs and window functions for ranking and filtering data, such as identifying top products and categories. It uses joins to enrich data and aggregates such as SUM and AVG to summarize revenue and volume. Additionally, subqueries are utilized for intermediate calculations. The project also utilizes Python for deploying Machine Learning algorithms that generate product recommendations.

Key Insights 💡 :

- High Revenue Dates: July consistently shows high revenue (appears thrice in the top 5), with top sales days on July 12, 2022, $174,408.54, and June 21, 2021, $132,127.46!

- Top States by Revenue: California leads with over $3.9 million, followed by Texas and Florida!

- Customer Spending: Average top 5 annual customer spend ranges from $12K to $18K!

Conclusion ✅ : 

This project provided valuable insights into sales and revenue patterns and highlighted the importance of data-driven decision-making on customer and product levels.

[Data Scource]([https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/YGLYDY])

In Part II, I'll visualize these findings using Tableau!...(to be continued)
