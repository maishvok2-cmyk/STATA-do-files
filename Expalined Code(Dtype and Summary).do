*======================================================================================================
* K-YAGNS FULL SURVEY SUMMARY PIPELINE
*======================================================================================================

*--------------------------------------------------*
* 1 Load final merged dataset
*--------------------------------------------------*
use "$data/Final_Merged_Dataset.dta", clear

*--------------------------------------------------*
* 2 Create temporary summary file
*--------------------------------------------------*
tempfile varsummary

postfile handle str25 Variable str200 VarLabel str15 VarType ///
    double Obs double Missing double PctMissing ///
    double Mean double SD double Min double Max ///
    using `varsummary'

*--------------------------------------------------*
* 3 Get numeric variables
*--------------------------------------------------*
ds, has(type numeric)
local numvars `r(varlist)'

*--------------------------------------------------*
* 4 Loop through numeric variables
*--------------------------------------------------*
foreach v of local numvars {

    local lbl : variable label `v'

    * Exclude survey special codes
    quietly summarize `v' if !inlist(`v', 98, 99, 998, 999)
    local N = r(N)
    local mean = r(mean)
    local sd = r(sd)
    local min = r(min)
    local max = r(max)

    * Missing including special codes
    quietly count if missing(`v') | inlist(`v', 98, 99, 998, 999)
    local miss = r(N)

    quietly count
    local total = r(N)

    local pctmiss = 100 * (`miss' / `total')

    * Detect variable type
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

    post handle ("`v'") ("`lbl'") ("`vtype'") ///
        (`N') (`miss') (`pctmiss') ///
        (`mean') (`sd') (`min') (`max')
}

*--------------------------------------------------*
* 5 Close and load summary table
*--------------------------------------------------*
postclose handle
use `varsummary', clear

*--------------------------------------------------*
* 6 Export to Excel
*--------------------------------------------------*
export excel using "$output/KYAGN_Full_Survey_Summary.xlsx", ///
    firstrow(variables) replace
