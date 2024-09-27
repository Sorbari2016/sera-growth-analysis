# Sera Sales performance & Growth analysis

## Objective 
- Sera Ltd - an international Saas company that provides its clients with financial information for investment. Client subscribe on a monthly basis.
- The company wants me to understand their sales trend and customer retention over time using their subscription data made available.
- My goal therefore will be to design a transformed database for Growth Analysis as well as a dashboard that answers important business questions. 


## Tools
- PostgreSQL for Data transformations and Analysis.
- Power BI visualizations of important KPIs, as well Dashboard design. 

## Techniques
- Data Transformations in SQL
- Data Analysis in SQL.
- Data Modelling in Power BI.
- Data Visualisation in Power BI. 

## Datasource
<a href = "https://resagratia.com"> Datascience Capstone Project on Resagratia </a>

## Data Transformation in SQL 
- I carried out some important data transformations on the sera subscription dataset that was made availabe, using PostgreSQL.
- Creating a datetime field using the transaction_date, another field for card_type_group where card types can only be verve, visa, or mastercard using the card_type field. 
- I created one more field called credit_or_debit which indicates whether the card created was either debit or credit,  also from the card_type field.
- I finally tied all the transformations together, by selecting the fields I needed for analysis, which  also included both the transformed field, to create a view. 
![Data Transformations in SQL](https://github.com/Sorbari2016/sera-growth-analysis-/blob/main/data_transformations.sql)

## Data Analysis in SQL 
- I checked and look at the fields I had, to better understand the dataset I had.
- I wrote some SQL queries to help the executives answer some important preliminary questions
![Data Analysis in SQL](https://github.com/Sorbari2016/sera-growth-analysis-/blob/main/data_analysis_sera_payments.sql)

## Data Modelling & Visualisation in Power BI 

## Growth Analysis & Recommendations 

## Download 
