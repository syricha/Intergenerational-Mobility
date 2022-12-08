set more off
clear all
*global temp="\\ecnswn01p\data\NSyrichas\Data" 
*global graphs_path="\\ecnswn01p\data\NSyrichas\graphs\new"
*global code_path="\\ecnswn01p\data\NSyrichas\Code"

global temp="C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data" 
global graphs_path="C:\Users\Willkommen\Dropbox\Apps\Overleaf\intergenerational mobility in low income countries\Files"

cd "C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data"

use  "Data_Intergenerational_mobility.dta",clear
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

gen regions=geolev2
	replace regions=geolev1 if geolev2==.

save "${data_path}/IM_rank_1.dta",replace

use "${data_path}/IM_rank_1.dta",replace


	foreach var in  1950 1960 1970 1980 1990 2000 2010  {
	use  "${data_path}/IM_rank_1.dta",replace
	
	keep if decade==`var'
	
	gen regions=geolev2
	replace regions=geolev1 if geolev2==.
	
	drop if obs<50

	sort decade country 
	bys decade country :gen newid1 = 1 if _n==1
	bys decade Continents :replace newid1 = sum(newid1)
	bys decade:egen locations_countries=max(newid1)

	
	bysort decade country: egen obs_country=count(educ)
	bysort decade Continents: egen obs_sum=count(educ)
	bysort decade Continents: egen average_IM_continents=mean(rank_1)
	bysort decade country: egen average_IM_country=mean(rank_1)
	
	gen varl=(rank_1-average_IM_country)^2
	gen share_obs=obs_country/obs_sum
	gen share_obs_country=obs_country/obs_sum

	*Estimate B
	sort  plz
	by plz:gen newid = 1 if _n==1
	replace newid = sum(newid)
	egen total_number_of_locations=max(newid)
	bysort plz :egen varlpi=sum(varl)
	gen VAR=varlpi/postings_zip
	gen B_l=share_postings*VAR/postings_zip
	bysort ajahr:egen B=sum(B_l)
	bysort ajahr:egen p=sd(resi2)
	gen pp=p^2

	*Estimate C
	gen Varbetween=(average_log_realprice_locations-average_log_realprice)^2
	gen C_l=share_postings*Varbetween/postings_zip
	bysort ajahr:egen C=sum(C_l)


	 
	 collapse A B C ,by(decade)
	save "${data_path}/`var'_new.dta",replace	
	}
	use "${data_path}/2009_new.dta",clear
	foreach var  in   2010 2011 2012 2013 2014 2015 2016 2017 {
	append using "${data_path}/`var'_new.dta"
	}
