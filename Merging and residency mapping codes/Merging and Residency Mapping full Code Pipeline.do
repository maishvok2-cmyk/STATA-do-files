*--------------------------------------------------*
* 1. Load Adolescent Dataset
*--------------------------------------------------*
use "$data/ADOL_Cleaned_Dataset.dta", clear

* Create common caregiver ID
gen caregiver_id = ag_hh_caregiver_id

* Clean string variables
gen clean_county = strproper(strtrim(countys_name))
gen clean_ea = strproper(strtrim(ag_hh_ea_name))
gen clean_interviewer = strproper(strtrim(interviewer_name))

* Save temporarily
tempfile df1
save `df1'

*--------------------------------------------------*
* 2. Load Caregiver Dataset
*--------------------------------------------------*
use "$data/PCG_cleaned_dataset.dta", clear

* Create common caregiver ID
gen caregiver_id = cg_hh_caregiver_id

* Clean string variables
gen clean_county = strproper(strtrim(countys_name))
gen clean_ea = strproper(strtrim(cg_hh_ea_name))
gen clean_interviewer = strproper(strtrim(interviewer_name))

*--------------------------------------------------*
* 3. Merge (Outer Merge Equivalent)
*--------------------------------------------------*
merge 1:1 caregiver_id using `df1'

*--------------------------------------------------*
* 4. Inspect Merge Results
*--------------------------------------------------*
tab _merge
count
distinct caregiver_id   // if you have distinct installed

*--------------------------------------------------*
* 5. Save Final Dataset
*--------------------------------------------------*
* save "$data/K-YAGNS_Merged_Clean.dta", replace


*--------------------------------------------------*
* 1. Open Final Merged Dataset
*--------------------------------------------------*
use "$data/K-YAGNS_Merged_Clean.dta", clear

*--------------------------------------------------*
* 2. Rename variables to match EA mapping file
*--------------------------------------------------*
rename ag_hh_ea_code EACodeFull
rename ag_hh_ea_name EAName

* Clean EAName to avoid merge mismatch
replace EAName = strproper(strtrim(EAName))

* Save temporarily
tempfile main
save `main'

*--------------------------------------------------*
* 3. Import EA Mapping Excel File
*--------------------------------------------------*
import excel "$data/KYAGN_Sampled EAs..xlsx", firstrow clear

* Clean EAName in mapping file too
replace EAName = strproper(strtrim(EAName))

* Save mapping file
tempfile ea_map
save `ea_map'

*--------------------------------------------------*
* 4. Merge Residency
*--------------------------------------------------*
use `main', clear
merge m:1 EAName using `ea_map'

** Rename _merge if already exists

// rename _merge _merge_caregiver
// merge m:1 EAName using `ea_map'



*--------------------------------------------------*
* 5. Check Merge & Missing Residency
*--------------------------------------------------*
tab _merge

* Count missing residency
count if missing(Residence1Rural2Urban)

* Tabulate including missing
tab Residence1Rural2Urban, missing

*--------------------------------------------------*
* 6. Save Final Dataset
*--------------------------------------------------*
save "$data/\KYAGN_Final_Merged_Dataset.dta", replace

* Optional: Export to Excel
export excel using "$data/\KYAGN_Final_Merged_Dataset.xlsx", firstrow(variables) replace




