clear

*do "${code_path}\spineplot.ado"
cd "C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data"
global graphs_path="C:\Users\Willkommen\Dropbox\Apps\Overleaf\intergenerational mobility in low income countries\Files"
*Drop USA for this example


use "geography_continents.dta",clear

merge m:m country  using "Data_Intergenerational_mobility.dta"
keep if _merge==3
drop _merge


drop if country==840
drop if country==124

replace coresidence=1 if AgeOld!=.

drop if coresidence==0


*Separate continents
gen Continents=0
replace Continents=1 if regionw<16 
replace Continents=2 if regionw==21 | regionw==22 | regionw==24
replace Continents=3 if regionw==23
replace Continents=4 if regionw==31 | regionw==32 | regionw==33 | regionw==34 | regionw==35
replace Continents=5 if regionw==41 | regionw==42 | regionw==43 | regionw==44 
replace Continents=6 if regionw==52

label define Mstatus 0 "None" 1 "Africa" 2 "Latin America and Caribbean" 3 "North America" 4 "Asia" 5 "Europe" 6 "Melanesia"
label value Continents Mstatus
*New transition plots that take into account size

gen EEE2=1 if Ed<0.5 
replace EEE2=2  if Ed>=0.5 & Ed!=.
replace EEE2=3 if Ed2>=0.5 & Ed2!=.
replace EEE2=4 if Ed3>=0.5 & Ed3!=.

do spineplot.ado

label variable EEE2 "Old generation"
label define Education  1 "less than primary"  2 "primary completed" 3  "secondary completed"  4 "university completed" 
label values EEE2 Education
gen Eyoung=edattain

spineplot edattain EEE2 if Continents==1 , ///
xlabel(, angle(25) axis(2)) ///
xtitle("", axis(2)) xtitle(fraction by parental attainment, axis(1)) ///
ytitle("",axis(2)) ytitle("likelihood of child attainment",axis(2))  ///
legend(pos(6) col(2)) ///
legend(label(1 "less than primary ") label(2 "primary completed ") label(3 "secondary completed") label(4 "university completed")) //////
graphregion(color(white))  
graph export "${graphs_path}/transition_new_Africa.png",replace

spineplot edattain EEE2 if Continents==2 , ///
xlabel(, angle(25) axis(2)) ///
xtitle("", axis(2)) xtitle(fraction by parental attainment, axis(1)) ///
ytitle("",axis(2)) ytitle("likelihood of child attainment",axis(2))  ///
legend(pos(6) col(2)) ///
legend(label(1 "less than primary ") label(2 "primary completed ") label(3 "secondary completed") label(4 "university completed")) //////
graphregion(color(white))  
graph export "${graphs_path}/transition_new_Latin.png",replace



spineplot edattain EEE2 if Continents==4 , ///
xlabel(, angle(25) axis(2)) ///
xtitle("", axis(2)) xtitle(fraction by parental attainment, axis(1)) ///
ytitle("",axis(2)) ytitle("likelihood of child attainment",axis(2))  ///
legend(pos(6) col(2)) ///
legend(label(1 "less than primary ") label(2 "primary completed ") label(3 "secondary completed") label(4 "university completed")) //////
graphregion(color(white))  
graph export "${graphs_path}/transition_new_Asia.png",replace










