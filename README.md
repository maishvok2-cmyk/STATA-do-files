Title
K YAGNS Adolescent Variable Labeling Script

Description
This Stata do file applies variable labels to the K YAGNS Adolescent cleaned dataset using an external Excel metadata file.

Files Required

• ADOL_Vatiable List.xlsx

Columns: variable, label

• K-YAGNS Adolescent Clean.dta

What the Script Does

• Imports metadata from Excel
• Matches variable names to the cleaned dataset
• Applies variable labels automatically
• Skips variables not found

Output

Dataset in memory with updated variable labels.
Save manually after running:

save "K-YAGNS Adolescent Clean_labeled.dta", replace

Assumptions on first code(solved in the second code) include:

• Variable names match exactly between Excel and Stata
• No duplicate variable names in metadata
• Labels do not contain unescaped quotation marks

Author
Kelvin
