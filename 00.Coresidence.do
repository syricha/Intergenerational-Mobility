clear

*do "${code_path}\spineplot.ado"
cd "C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data"
use Data_Intergenerational_mobility.dta,replace


*Drop USA and Canada for this example

drop if country==840
drop if country==124

replace coresidence=1 if AgeOld!=.
preserve
collapse coresidence,by(country)
export excel using "C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data\Cohabitation_boys_new.xlsx", sheetreplace firstrow(variables)
restore



*Living arrangements. Find the fraction of children living with fathers and the fraction living with other relatives

preserve
collapse (count)generation, by(hhtype coresidence)
drop if hhtype==.
export excel using "C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data\household_types.xlsx", sheetreplace firstrow(variables)
restore 

**********************************************************************************************
*Count the number of households in a c survey
*collapse person,by(country year  serial)
*collapse (count)serial ,by(country year )
*collapse (sum)serial ,by(country )


**********************************************************************************************



