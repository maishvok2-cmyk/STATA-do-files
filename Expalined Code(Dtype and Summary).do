* Work Flow:

		// Load dataset 

		// Create a temporary table (postfile) to store summaries

		// Define columns: Variable, VarLabel, VarType, Obs, Missing, %Missing, Mean, SD, Min, Max

		// Loop over numeric variables -> compute summaries

		// Detect type → Binary / Categorical / Continuous

		// Post rows into the temporary table

		// Close the table -> saves results

		// Export -> Excel for reporting

*--------------------------------------------------*
* 1️ Load your final merged dataset
*--------------------------------------------------*
use "C:\Users\Public\Documents\APHRC\K-YAGNS\National Survey\Final_Merged_Dataset.dta", clear
// clear ensures the previous dataset is removed from memory

*--------------------------------------------------*
* 2️  Create a temporary file to store variable summaries
*--------------------------------------------------*
tempfile varsummary
// tempfile creates a temporary file name stored in `varsummary`
// This is where the summary statistics will be saved

*--------------------------------------------------*
* 3️ Define the structure of the summary table
*--------------------------------------------------*
postfile handle str25 Variable str200 VarLabel str15 VarType ///
    double Obs double Missing double PctMissing double Mean double SD double Min double Max ///
    using `varsummary'
// postfile creates a table in memory with specific columns:
// handle        -> a pointer name for the table
// Variable      -> variable name (string, max 25 characters)
// VarLabel      -> variable label (string, max 200 characters)
// VarType       -> type classification (Binary/Categorical/Continuous, string 15 chars)
// Obs           -> number of non-missing observations (double = numeric)
// Missing       -> number of missing values
// PctMissing    -> percentage missing
// Mean, SD, Min, Max -> numeric summary statistics
// using `varsummary` -> specifies the temporary file to save the table

*--------------------------------------------------*
* 4️ Get list of numeric variables in the dataset
*--------------------------------------------------*
ds, has(type numeric)
// ds = dataset variables command
// has(type numeric) returns only numeric variables
local numvars `r(varlist)'
// store variable names in local macro `numvars` for looping

*--------------------------------------------------*
* 5 Loop through each numeric variable to compute summaries
*--------------------------------------------------*
foreach v of local numvars {

    * Get the variable label for reporting
    local lbl : variable label `v'

    * Exclude special survey codes like 98 or 99
    quietly summarize `v' if `v' < 90
    // quietly suppresses output

    * Store numeric summaries in locals
    local N = r(N)       // number of non-missing observations
    local mean = r(mean) // mean
    local sd = r(sd)     // standard deviation
    local min = r(min)   // minimum
    local max = r(max)   // maximum

    * Calculate missing values
    quietly count if missing(`v')
    local miss = r(N)
    quietly count
    local total = r(N)
    local pctmiss = 100 * (`miss' / `total')
    // calculates % missing

    * Detect variable type based on number of unique values
    quietly levelsof `v' if `v' < 90, local(levels)
    local nlevels : word count `levels'

    if `nlevels' == 2 & `min' == 0 & `max' == 1 {
        local vtype "Binary"
    }
    else if `nlevels' <= 10 {
        local vtype "Categorical"
    }
    else {
        local vtype "Continuous"
    }

    * Post a row into the summary table
    post handle ("`v'") ("`lbl'") ("`vtype'") (`N') (`miss') (`pctmiss') (`mean') (`sd') (`min') (`max')
}

*--------------------------------------------------*
* 6️ Close the postfile and save to `varsummary`
*--------------------------------------------------*
postclose handle
// must close the handle to finalize and save the table

*--------------------------------------------------*
* 7️ Load the summary table as a Stata dataset
*--------------------------------------------------*
use `varsummary', clear

*--------------------------------------------------*
* 8️ Export the summary table to Excel
*--------------------------------------------------*
export excel using "C:\Users\Public\Documents\APHRC\K-YAGNS\National Survey\Final Cleaned DataSets\KYAGN_Full_Survey_Summary.xlsx", ///
    firstrow(variables) replace
// firstrow(variables) ensures column names are in the first row
// replace overwrites existing file



*-----------------------------------------------------------------------------------------------------------------------------------------------

*--------------------------------------------------------------------------------------------------------------------------------------------------


*** TO INCLUDE 98 AND 99
*------------------------------------------------------------------------------------------
use "C:\Users\Public\Documents\APHRC\K-YAGNS\National Survey\Final_Merged_Dataset.dta", clear

tempfile varsummary

postfile handle str25 Variable str200 VarLabel str15 VarType double Obs double Missing double PctMissing double Mean double SD double Min double Max using `varsummary'

ds, has(type numeric)
local numvars `r(varlist)'

foreach v of local numvars {

    local lbl : variable label `v'

    *-----------------------------
    * Exclude survey special codes
    * Assuming 98, 99, 998, 999 are special codes
    *-----------------------------
    quietly summarize `v' if !inlist(`v', 98, 99, 998, 999)
    local N = r(N)
    local mean = r(mean)
    local sd = r(sd)
    local min = r(min)
    local max = r(max)

    * Missing calculations
    quietly count if missing(`v') | inlist(`v', 98, 99, 998, 999)
    local miss = r(N)
    quietly count
    local total = r(N)
    local pctmiss = 100 * (`miss' / `total')

    * Detect variable type based on unique values (excluding special codes)
    quietly levelsof `v' if !inlist(`v', 98, 99, 998, 999), local(levels)
    local nlevels : word count `levels'

    if `nlevels' == 2 & `min' == 0 & `max' == 1 {
        local vtype "Binary"
    }
    else if `nlevels' <= 10 {
        local vtype "Categorical"
    }
    else {
        local vtype "Continuous"
    }

    * Post the summary row
    post handle ("`v'") ("`lbl'") ("`vtype'") (`N') (`miss') (`pctmiss') (`mean') (`sd') (`min') (`max')
}

postclose handle

use `varsummary', clear

* Export to Excel
export excel using "C:\Users\Public\Documents\APHRC\K-YAGNS\National Survey\Final Cleaned DataSets\KYAGN_Full_Survey_Summary.xlsx", ///
    firstrow(variables) replace

