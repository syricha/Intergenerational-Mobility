set more off
clear all
*global temp="\\ecnswn01p\data\NSyrichas\Data" 
*global graphs_path="\\ecnswn01p\data\NSyrichas\graphs\new"
*global code_path="\\ecnswn01p\data\NSyrichas\Code"

global temp="C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data" 
global graphs_path="C:\Users\Willkommen\Dropbox\Apps\Overleaf\intergenerational mobility in low income countries\Files"

cd "C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data"

use  "Data_Intergenerational_mobility_North_America.dta",clear
merge 1:1 sample serial pernum using "geography_full.dta"
keep if _merge==3
drop _merge


drop if coresidence==0



gen Continents=0
replace Continents=1 if regionw<16 
replace Continents=2 if regionw==21 | regionw==22 | regionw==24
replace Continents=3 if regionw==23
replace Continents=4 if regionw==31 | regionw==32 | regionw==33 | regionw==34 | regionw==35
replace Continents=5 if regionw==41 | regionw==42 | regionw==43 | regionw==44 
replace Continents=6 if regionw==52

label define Mstatus 0 "None" 1 "Africa" 2 "Latin America and Caribbean" 3 "North America" 4 "Asia" 5 "Europe" 6 "Melanesia"
label value Continents Mstatus

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

*preserve
*collapse rank_1 rank_1_max, by(geolev2 country Continents)
 *export delimited using "C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data\Granular_Data_for_maps.csv", replace
*restore


*preserve
*collapse rank_1 rank_1_max, by(geolev2 country Continents)
*export delimited using "C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data\Granular_Data_for_maps.csv", replace
*restore


collapse rank_1 rank_1_max, by(country year)

decode country, gen(Country)
drop country
rename Country country

merge 1:1 country year using World_Penn_table
keep if _merge==3
gen GD=  rgdpo/ emp
gen lgd=ln(GD)

export excel using "rank_PPP_US", firstrow(variables) replace

*fvset base 716 country
*reg rank_1 i.Ageold i.country i.year i.AgeYoung , cluster (country)
*reg rank_1_max i.Ageold i.country i.year i.AgeYoung , cluster (country)







*preserve
*collapse (mean)rank_1 (count)obs_rank_1=rank_1 ,by(Continents country)
*export excel using "${graphs_path}/rank_1_country.xlsx", firstrow(variables) replace
*restore



