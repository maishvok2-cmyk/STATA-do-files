*======================================================================================================
* Adolescent
*=======================================================================================================

* Import the excel file containing the labels

import excel "C:\Users\Public\Documents\APHRC\K-YAGNS\National Survey\Final Cleaned DataSets\Metadata\ADOL_Vatiable List.xlsx", firstrow clear
rename variable varname
rename label varlabel
tempfile labels
save `labels'

* Load your dataset

use "C:\Users\Public\Documents\APHRC\K-YAGNS\National Survey\Final Cleaned DataSets\Final Datasets\K-YAGNS Adolescent Clean.dta", clear

* Loop through each variable name in Excel
* Check if it exists in your dataset
* Apply the label

tempfile main
save `main'

use `labels', clear
levelsof varname, local(vars)

use `main', clear

foreach v of local vars {
    preserve
    use `labels', clear
    keep if varname == "`v'"
    local lbl = varlabel[1]
    restore
    capture confirm variable `v'
    if !_rc {
        label variable `v' "`lbl'"
    }
}

* Save final dataset
// save "C:\Users\Public\Documents\APHRC\K-YAGNS\National Survey\Final Cleaned DataSets\Final Datasets\K-YAGNS Adolescent Clean.dta", replace


*================================================================
*** Caregiver ## needed to Trim spaces in the variable labels
*==================================================================


* Import and clean labels (updated code from above)


import excel "C:\Users\Public\Documents\APHRC\K-YAGNS\National Survey\Final Cleaned DataSets\Metadata\PCG_Variable_List.xlsx", firstrow clear

rename variable varname
rename label varlabel

replace varlabel = subinstr(varlabel, `"""', "", .)
replace varlabel = subinstr(varlabel, char(10), "", .)
replace varlabel = subinstr(varlabel, char(13), "", .)
replace varlabel = strtrim(varlabel)

duplicates drop varname, force

tempfile labels
save `labels'


* Load your dataset

use "C:\Users\Public\Documents\APHRC\K-YAGNS\National Survey\Final Cleaned DataSets\Final Datasets\K-YAGNS Caregiver Clean.dta", clear

* Loop through each variable name in Excel
* Check if it exists in your dataset
* Apply the label

tempfile main
save `main'

use `labels', clear
levelsof varname, local(vars)

use `main', clear

foreach v of local vars {
    preserve
    use `labels', clear
    keep if varname == "`v'"
    local lbl = varlabel[1]
    restore
    capture confirm variable `v'
    if !_rc {
        label variable `v' "`lbl'"
    }
}


// save "C:\Users\Public\Documents\APHRC\K-YAGNS\National Survey\Final Cleaned DataSets\Final Datasets\K-YAGNS Caregiver Clean.dta", replace