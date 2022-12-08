clear

*do "${code_path}\spineplot.ado"
cd "C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data"
use Data_Intergenerational_mobility.dta,replace

*Drop Canada
drop if country==124

keep if coresidence==1

egen ID=group(sample geolev2)
sort ID

by ID:  gen dup = cond(_N==1,0,_n)








