# Consumer Loan Portfolio Analysis and Risk Assessment
### Stack: SQL (PostgreSQL/SQLite), Microsoft Excel.

#### What was done:

 - Data Processing (ETL): Cleaned and structured a "raw" dataset
   (German Credit Data) of 1000 records.
 - SQL: Wrote a series of queries using CTE, and Case When to segment
   customers by risk level, age, and loan purpose.
 - Excel Modeling: Built an automated table using XLOOKUP and IFS
   functions to decipher categorical codes. After that, pivot tables
   were created to calculate the average check and the percentage of
   defaulted loans by housing conditions and professions.
 #### Result: 
 <i> An analytical report has been generated that identifies the highest-risk segments of borrowers (for example, young people with education loans), which allows for optimizing credit policy. </i>
 ### Short work progress
This dataset was downloaded in the .data extension, so to work with it efficiently, it was first converted to a tabular format and headers were added. This was implemented using Python:

     import pandas as pd
    # Create column name
    columns = [
        "Status", "Duration", "CreditHistory", "Purpose", "Amount", 
        "Savings", "Employment", "InstallmentRate", "PersonalStatus", 
        "OtherDebtors", "ResidenceTime", "Property", "Age", 
        "OtherInstallmentPlans", "Housing", "ExistingCredits", 
        "Job", "Dependents", "Telephone", "ForeignWorker", "CreditRisk"
    ]
    # Read the file
    try:
        df = pd.read_csv('german.data', sep=' ', names=columns, header=None)
        """
        #Decoding of output values
        df['CreditRisk'] = df['CreditRisk'].replace({1: 'Good', 2: 'Bad'})
        #This way it is possible to decode the all table. This will be much faster and more efficient
        """
        # Save as CSV
        df.to_csv('german_credit_cleaned.csv', index=False)     
        # First 5 line
        print(df.head())
    except FileNotFoundError:
        print("Error")
        
The first step was to explore the data using SQL queries. A series of queries were written that help to better understand the customer categories that can be understanding as good candidate the loan. Aggregations, filtering, CTE and CASE when were used for implementation. For exemple:

        -- purpose with the largest average loan amount
    WITH MaxAvgAmount AS (
    	SELECT AVG(Amount) as AvgAm
    	FROM 'german_credit_cleaned.csv'
    )
    
    SELECT DISTINCT(Purpose), CONCAT('€ ', ROUND(AVG(Amount), 2)) as HighestAmount
    FROM 'german_credit_cleaned.csv'
    WHERE Amount > ALL(SELECT AvgAm FROM MaxAvgAmount)
    GROUP BY Purpose
    ORDER BY AVG(Amount) DESC
    LIMIT 3; 

The second step is to decode the data in Excel using XLOOKUP, and select only those columns that will be used in further analysis. This was done for better understanding of the data by managers. In addition, using IFS functions, the data was divided into categories, so that the person viewing the data will easily understand which people can be given loans.

As a result, pivot tables were created showing the calculation of the average check and the percentage of defaulted loans by housing conditions and jobs.
<img width="956" height="508" alt="image" src="https://github.com/user-attachments/assets/0df5210b-657b-4f74-94a9-800a07906fb5" />
