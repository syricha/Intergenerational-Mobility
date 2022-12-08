set more off
clear all
*global temp="\\ecnswn01p\data\NSyrichas\Data" 
*global graphs_path="\\ecnswn01p\data\NSyrichas\graphs\new"
*global code_path="\\ecnswn01p\data\NSyrichas\Code"

global temp="C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data" 
global graphs_path="C:\Users\Willkommen\Dropbox\Apps\Overleaf\intergenerational mobility in low income countries\Files"

cd "C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data"

ssc install ineqdeco

use  "Data_Intergenerational_mobility_schooling.dta",clear
drop _merge

keep country year sample serial hhwt formtype pernum perwt resident age school lit edattain edattaind yrschool sex rank_1
merge 1:1 sample serial pernum using geography_full.dta 
keep if _merge==3
drop _merge

replace yrschool=0.1 if yrschool==0

gen regions=geolev2
replace regions=geolev1 if regions==.

gen gini_r=. 
gen gini_c=.   
egen subgroup = group(country regions)
                          
levels subgroup, local(levels) 
foreach i of local levels { 
	ineqdeco yrschool if subgroup == `i'
      replace gini_r = $S_gini if subgroup == `i' 
} 

drop subgroup 
egen subgroup = group(country)
foreach i of local levels { 
	ineqdeco yrschool if subgroup == `i'
      replace gini_c = $S_gini if subgroup == `i' 
} 

*collapse rank_1 gini_c gini_r ,by(country)

