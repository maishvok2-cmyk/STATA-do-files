*======================================================================================================
* Adolescent
*======================================================================================================

* Import metadata
import excel "$metadata/ADOL_Variable_List.xlsx", firstrow clear
rename variable varname
rename label varlabel

tempfile labels
save `labels'

* Load dataset
use "$data/Final_Merged_Dataset.dta", clear

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

* Save if needed
* save "$data/K-YAGNS_Adolescent_Clean.dta", replace


*======================================================================================================
* Caregiver
*======================================================================================================

* Import and clean metadata
import excel "$metadata/PCG_Variable_List.xlsx", firstrow clear
rename variable varname
rename label varlabel

replace varlabel = subinstr(varlabel, `"""', "", .)
replace varlabel = subinstr(varlabel, char(10), "", .)
replace varlabel = subinstr(varlabel, char(13), "", .)
replace varlabel = strtrim(varlabel)

duplicates drop varname, force

tempfile labels
save `labels'

* Load dataset
use "$data/K-YAGNS_Caregiver_Clean.dta", clear

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

* Save if needed
* save "$data/K-YAGNS_Caregiver_Clean.dta", replace
