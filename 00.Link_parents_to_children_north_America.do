clear

*do "${code_path}\spineplot.ado"
cd "C:\Users\Willkommen\Dropbox\IPUMS_data\Thesis_low_income\code\November 2022\Data"
use  "Data.dta" ,clear

*Drop USA for this example

keep if country==840 | country==124

* drop observations from censuses not organised in households Kenya 1979,Liberia 1974, Chile 1960, Colombia 1964,
* Costa Rica 1963, Dominican Republic 1960 and 1970 Ecuador 1960 and Suriname 2004

drop if age<18
drop if sex>1 & age<23




*Construction of table A6
*Here we assinged first degree individuals into  backets
gen generation=.
replace generation=0 if related==1000 | related==2000 | related==4400 | related==4410 | related==4430 | related==4820 | related==2100 | related==2200 | related==2210 | related==2300 |related==4420 |related==4830 | related==5130
replace generation=1 if related==3000 | related==3100 | related==3200 | related==3300 | related==3400 | related==4300 | related==4810 | related==5330 | related==5150 | related==5340 | related==5350 |related==4302 | related==4310 
replace generation=2 if related==4100 | related==4110 | related==4120 | related==4130
replace generation=-1 if related==4200 | related==4210 | related==4220 | related==4600 | related==4700 | related==4211 | related==5140	
replace generation=-2 if related==4500 | related==4130 |related==4510


**********How to construct the dataset for the remaining relatives not elsewhere identified
*find the age of the oldest household member
bysort  sample serial: egen Max_age=max(age)

*Any relative not elsewhere classified that is between 14-to 45 years younger of the older individual living in the household is identified as a child 
replace generation=1 if generation==. & relate==4 & Max_age-age>14 & Max_age-age<45

drop if sample==404197901
drop if sample==430197401
drop if sample==152196001
drop if sample==170196401
drop if sample==188196301
drop if sample==214196001
drop if sample==214197001
drop if sample==218196201
drop if sample==740200401


gen coresidence=0
replace coresidence=1 if generation!=0 & generation!=.
drop if generation==.



******************************************************************************************************************************
*Education of the older generation
*Replace education if one is educated
gen educ=.
replace educ=0 if edattain==1
replace educ=1 if edattain==2 |edattain==3| edattain==4

gen educ2=1  if edattain==3 | edattain==4
replace educ2=0 if edattain==1| edattain==2

gen educ3=1  if edattain==4
replace educ3=0 if edattain==1| edattain==2 | edattain==3


drop if educ==.
egen id=group(sample serial)
bysort id generation: egen v1=mean(age) 
bysort id generation: egen v2=max(age) 
bysort id generation: egen meduc=mean(educ) 
bysort id generation: egen meduc2=mean(educ2) 
bysort id generation: egen meduc3=mean(educ3) 
bysort id generation: egen Maxeduc=max(educ) 
bysort id generation: egen Maxeduc2=max(educ2) 
bysort id generation: egen Maxeduc3=max(educ3) 


gen Ed=.
gen Ed2=.
gen Ed3=.

gen Edmax=.
gen Ed2max=.



*Birth year of old
gen AgeOld=.
bysort id : replace AgeOld=v1[_n-1] if generation[_n]==2 & generation[_n-1]==1
bysort id : replace AgeOld=AgeOld[_n-1] if generation[_n]==generation[_n-1]
bysort id : replace AgeOld=v1[_n-1] if generation[_n]==1 & generation[_n-1]==0
bysort id : replace AgeOld=AgeOld[_n-1] if generation[_n]==generation[_n-1]
bysort id : replace AgeOld=v1[_n-1] if generation[_n]==0 & generation[_n-1]==-1
bysort id : replace AgeOld=AgeOld[_n-1] if generation[_n]==generation[_n-1]	
bysort id : replace AgeOld=v1[_n-1] if generation[_n]==-1 & generation[_n-1]==-2
bysort id : replace AgeOld=AgeOld[_n-1] if generation[_n]==generation[_n-1]		

gen AgeOldmax=.
bysort id : replace AgeOldmax=v2[_n-1] if generation[_n]==2 & generation[_n-1]==1
bysort id : replace AgeOldmax=AgeOldmax[_n-1] if generation[_n]==generation[_n-1]
bysort id : replace AgeOldmax=v2[_n-1] if generation[_n]==1 & generation[_n-1]==0
bysort id : replace AgeOldmax=AgeOldmax[_n-1] if generation[_n]==generation[_n-1]
bysort id : replace AgeOldmax=v2[_n-1] if generation[_n]==0 & generation[_n-1]==-1
bysort id : replace AgeOldmax=AgeOldmax[_n-1] if generation[_n]==generation[_n-1]	
bysort id : replace AgeOldmax=v2[_n-1] if generation[_n]==-1 & generation[_n-1]==-2
bysort id : replace AgeOldmax=AgeOldmax[_n-1] if generation[_n]==generation[_n-1]		


*Education attainment next
bysort id : replace Ed=meduc[_n-1] if generation[_n]==2 & generation[_n-1]==1
bysort id : replace Ed=Ed[_n-1] if generation[_n]==generation[_n-1]
bysort id : replace Ed=meduc[_n-1] if generation[_n]==1 & generation[_n-1]==0
bysort id : replace Ed=Ed[_n-1] if generation[_n]==generation[_n-1]
bysort id : replace Ed=meduc[_n-1] if generation[_n]==0 & generation[_n-1]==-1
bysort id : replace Ed=Ed[_n-1] if generation[_n]==generation[_n-1]	
bysort id : replace Ed=meduc[_n-1] if generation[_n]==-1 & generation[_n-1]==-2
bysort id : replace Ed=Ed[_n-1] if generation[_n]==generation[_n-1]	

*Education attainment next max
bysort id : replace Edmax=Maxeduc[_n-1] if generation[_n]==2 & generation[_n-1]==1
bysort id : replace Edmax=Edmax[_n-1] if generation[_n]==generation[_n-1]
bysort id : replace Edmax=Maxeduc[_n-1] if generation[_n]==1 & generation[_n-1]==0
bysort id : replace Edmax=Edmax[_n-1] if generation[_n]==generation[_n-1]
bysort id : replace Edmax=Maxeduc[_n-1] if generation[_n]==0 & generation[_n-1]==-1
bysort id : replace Edmax=Edmax[_n-1] if generation[_n]==generation[_n-1]	
bysort id : replace Edmax=Maxeduc[_n-1] if generation[_n]==-1 & generation[_n-1]==-2
bysort id : replace Edmax=Edmax[_n-1] if generation[_n]==generation[_n-1]	

*Education attainment for more than primary school
bysort id : replace Ed2=meduc2[_n-1] if generation[_n]==2 & generation[_n-1]==1
bysort id : replace Ed2=Ed2[_n-1] if generation[_n]==generation[_n-1]
bysort id : replace Ed2=meduc2[_n-1] if generation[_n]==1 & generation[_n-1]==0
bysort id : replace Ed2=Ed2[_n-1] if generation[_n]==generation[_n-1]
bysort id : replace Ed2=meduc2[_n-1] if generation[_n]==0 & generation[_n-1]==-1
bysort id : replace Ed2=Ed2[_n-1] if generation[_n]==generation[_n-1]	
bysort id : replace Ed2=meduc2[_n-1] if generation[_n]==-1 & generation[_n-1]==-2
bysort id : replace Ed2=Ed2[_n-1] if generation[_n]==generation[_n-1]	

*Education attainment for more than primary school
bysort id : replace Ed2max=Maxeduc2[_n-1] if generation[_n]==2 & generation[_n-1]==1
bysort id : replace Ed2max=Ed2max[_n-1] if generation[_n]==generation[_n-1]
bysort id : replace Ed2max=Maxeduc2[_n-1] if generation[_n]==1 & generation[_n-1]==0
bysort id : replace Ed2max=Ed2max[_n-1] if generation[_n]==generation[_n-1]
bysort id : replace Ed2max=Maxeduc2[_n-1] if generation[_n]==0 & generation[_n-1]==-1
bysort id : replace Ed2max=Ed2max[_n-1] if generation[_n]==generation[_n-1]	
bysort id : replace Ed2max=Maxeduc2[_n-1] if generation[_n]==-1 & generation[_n-1]==-2
bysort id : replace Ed2max=Ed2max[_n-1] if generation[_n]==generation[_n-1]

*Education attainment for more than primary school
bysort id : replace Ed3=meduc3[_n-1] if generation[_n]==2 & generation[_n-1]==1
bysort id : replace Ed3=Ed3[_n-1] if generation[_n]==generation[_n-1]
bysort id : replace Ed3=meduc3[_n-1] if generation[_n]==1 & generation[_n-1]==0
bysort id : replace Ed3=Ed3[_n-1] if generation[_n]==generation[_n-1]
bysort id : replace Ed3=meduc3[_n-1] if generation[_n]==0 & generation[_n-1]==-1
bysort id : replace Ed3=Ed3[_n-1] if generation[_n]==generation[_n-1]	
bysort id : replace Ed3=meduc3[_n-1] if generation[_n]==-1 & generation[_n-1]==-2
bysort id : replace Ed3=Ed3[_n-1] if generation[_n]==generation[_n-1]	

drop if age>22
keep if sex==1

save Data_Intergenerational_mobility_north_America.dta,replace

*Living arrangements. Find the fraction of children living with fathers and the fraction living with other relatives


**********************************************************************************************
*Count the number of households in a c survey
*collapse person,by(country year  serial)
*collapse (count)serial ,by(country year )
*collapse (sum)serial ,by(country )


**********************************************************************************************



