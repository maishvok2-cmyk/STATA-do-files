Title
K YAGNS Survey Data Processing and Summary Workflow

Description
This repository contains Stata do files used to clean, label, and generate automated summary statistics for the K YAGNS survey datasets.

Modules Included

Variable Labeling Script
Applies variable labels from Excel metadata to cleaned datasets.

Automated Variable Summary Script
Generates a structured summary table for all numeric variables in the merged dataset and exports results to Excel.

Data Inputs

• ADOL_Vatiable List.xlsx or related metadata files

Required columns: variable, label

• Final_Merged_Dataset.dta

Final cleaned and merged survey dataset

Variable Labeling Workflow

• Import metadata from Excel
• Match variable names to dataset
• Apply labels automatically
• Skip variables not found

Automated Summary Workflow

The script performs the following steps:

• Loads the final merged dataset
• Identifies numeric variables
• Computes for each variable:

Non missing observations

Missing count

Percentage missing

Mean

Standard deviation

Minimum

Maximum
• Excludes survey special codes above 90 from summaries
• Classifies variables as:

Binary, if values are 0 and 1

Categorical, if 10 or fewer unique values

Continuous, otherwise
• Stores results in a structured temporary table
• Exports final summary table to Excel

Output

KYAGN_Full_Survey_Summary.xlsx

This file is ready for reporting and data quality review.

Assumptions

• Special survey codes such as 98 and 99 are treated as non analytic values
• Numeric variables are the focus of summary generation
• Variable names match metadata exactly

Author
Kelvin
