set more off
clear all
*global temp="\\ecnswn01p\data\NSyrichas\Data" 
*global graphs_path="\\ecnswn01p\data\NSyrichas\graphs\new"
*global code_path="\\ecnswn01p\data\NSyrichas\Code"

global temp="C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data" 
global graphs_path="C:\Users\Willkommen\Dropbox\Apps\Overleaf\intergenerational mobility in low income countries\Files"

cd "C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data"

use  "Data_Intergenerational_mobility.dta",clear
append using  "Data_Intergenerational_mobility_North_America.dta"


drop if coresidence==0


gen lit_parents=. 
replace lit_parents=1 if Ed>=0.5 & Ed!=.
replace lit_parents=0 if Ed<0.5 & Ed!=.

gen lit_parents_max=. 
replace lit_parents_max=1 if Edmax>=0.5 & Edmax!=.
replace lit_parents_max=0 if Edmax<0.5 & Edmax!=.

gen rank_1=.
replace rank_1=1 if lit_parents==0 & edattain>2
replace rank_1=0 if lit_parents==0 & edattain<3

gen rank_1_max=.
replace rank_1_max=1 if lit_parents_max==0 & edattain>2
replace rank_1_max=0 if lit_parents_max==0 & edattain<3


gen AgeYoung=year-age
replace AgeYoung=10* floor(AgeYoung/10)

gen Ageold=year-AgeOld
replace Ageold=10* floor(Ageold/10)

drop if AgeOld>120

gen decade = 10 * floor(year/10)

ssc install reghdfe


drop if Ageold<1900
drop if Ageold>1980

drop if AgeYoung<1940
drop if AgeYoung>1990


fvset base 840 country

reg rank_1 i.Ageold i.country i.year i.AgeYoung,  cluster (country)
quietly estadd local fixedd "Yes", replace
quietly estadd local fixedq "Yes", replace
quietly estadd local fixedy "Yes", replace
estimates store m01, title(OLS)
eststo moOLs1


/* Export results to overleaf
quietly:estout m01  , cells(b(star fmt(3)) se(par fmt(2))) ///
  legend label varlabels(_cons Constant)
  esttab moOLs1  ///
 using "${graphs_path}\country_estimates.tex" ,  page replace title("Parameter estimates") ///
 nonum  nostar se wide  drop(*.year *.AgeYoung *.Ageold)  s(fixedd  fixedq  fixedy r2 N , label( "birth-decade FE" "birth-decade old FE"  "census-year FE" "R_squared" "Observations")) ///
 b(2) sfmt(2) obslast  label 
*/

*Export results to excel for maps

  esttab moOLs1  ///
 using "${graphs_path}\country_estimates.csv" ,replace




