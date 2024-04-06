clear
cd "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Derived/Victim"

use "new2010.dta"
append using "new2011.dta"
append using "new2012.dta"
append using "new2013.dta"
append using "new2014.dta"
append using "new2015.dta"
append using "new2016.dta"
append using "new2017.dta"
append using "new2018.dta"
append using "new2019.dta"
append using "new2020.dta"
append using "new2021.dta"
cd "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Derived/"
save "new_Master_data.dta", replace


** STEP 2: Extract date
clear 
use "new_Master_data.dta"
gen incident_date_new = date(incident_date, "YMD")
gen new_year = year(incident_date_new)
drop incident_date incident_date_new
drop year
rename new_year year
order year, first
sort state year incident_number
*find duplicates
quietly by state year incident_number:  gen dup = cond(_N==1,0,_n)
drop if dup>0
drop dup
save "new_Master_data.dta",replace

***generate different IPV outcomes
destring ucr_offense_code_1, replace
encode ucr_offense_code_1, gen(crime)
tab crime
gen IPV_physical = (crime == 8|crime ==1 |crime ==5)
gen IPV_emotional = (crime == 2|crime ==4 )
gen IPV_sexual = (crime == 3|crime ==6 |crime ==7 |crime ==9 )
drop ucr_offense_code_1 crime
save "new_Master_data.dta",replace
*1=aggravated assult, 2=extorcion, 3=fondeling, 4=intimidation, 5=kidnapping, 6=rape, 7=sexual assault with an object, 8= simple assault, 9=statutory rape

** STEP 3: Merge Victim and Offender data together
clear
use "new_Master_data.dta", clear
sort state year incident_number
merge 1:m state year incident_number using "offender_Master_data.dta"
keep if _merge == 3
drop _merge
save "victim_offender_master.dta",replace
rename white victim_white
rename black victim_black
rename asian victim_asian
rename native_american victim_native
rename hispanic victim_hispanic
drop type_of_victim incident_number
save "victim_offender_master.dta",replace

** STEP 4: Aggregate the crime data from county to state-level
clear 
use "victim_offender_master.dta"
sort state year
collapse (mean)female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian (sum) IPV IPV_bfgf IPV_anyspouse IPV_physical IPV_emotional IPV_sexual, by(state year state_abb)   
tab state year

save "new_aggregated1.dta",replace
use "new_aggregated1.dta"


** STEP 5: Remove state that don't have enough years of data
egen state_freq = total(year), by(state)
keep if state_freq == 24186
tab state 
*total of 36 states
tab year 
drop state_freq
sort state year
save "new_aggregated1.dta",replace

** STEP 6: Merge with legalization data
clear
use "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Derived/Legalization_Data"
keep State Abbreviation Year Legal_Current Legal_Following Legal_Previous

*change year data type to avoid mismatch
gen state = lower(State)
drop State
rename Year year
gen year_float = float(year)
drop year
rename year_float year
destring state,replace
save "new_legalization.dta",replace


use  "new_aggregated1.dta", clear
sort state year
use "new_legalization.dta", clear
sort state year


merge 1:m state year using "new_aggregated1.dta"
keep if _merge == 3
drop _merge

** STEP 7: Rename all variables
rename female victim_female
lab var victim_female "Vitcim is female"
labe var victim_white "Victim is white" 
labe var victim_black "Victim is black" 
lab var victim_asian "Victim is asian"
lab var victim_native "Victim is Native American or Alaskan Indian"
lab var resident_status "Victim is resident in the state"
lab var victim_hispanic "Victim's ethnicity is hispanic"
lab var offender_male "Offender is male"
lab var offender_black "Offender is black"
lab var offender_white "Offender is white"
lab var offender_asian "Offender is Asian"
lab var IPV "Total Intimate partner violence"
lab var IPV_bfgf "Boyfriend/Girlfriend"
lab var IPV_anyspouse "Any other form of spouse"
lab var IPV_physical "Physical IPV"
lab var IPV_emotional "Emotional IPV"
lab var IPV_sexual "Sexual IPV"


save "final1.dta",replace
*merge with ACS data
use "final1.dta"
sort state year
merge 1:m state year using "acs.dta"
keep if _merge == 3
drop _merge

save "nibrs_acs.dta",replace

lab var population "Total Population"
lab var asian_perc "% Asian"
lab var native_perc "% Native American"
lab var black_perc "% Black"
lab var white_perc "% White"
lab var households "Total Households"
lab var high_school "Population with High School degree or higher"
lab var unemployment "Unemployment Rate"
lab var health_insurance "% with health insurance"
lab var median_income "Household median income"
lab var per_capita_income "Per Capita Income"
lab var below_poverty "% of families and people have income below poverty in the past 12 months" 
lab var perc_spouse "% of spouse in total households"
lab var perc_unmarried "% of unmarried partner in households"
save "nibrs_acs.dta",replace

**modify IPV variable to rate
replace IPV = (IPV/population)*10000
replace IPV_bfgf = (IPV_bfgf/population)*10000
replace IPV_anyspouse = (IPV_anyspouse/population)*10000
replace IPV_physical = (IPV_physical/population)*10000
replace IPV_emotional = (IPV_emotional/population)*10000
replace IPV_sexual = (IPV_sexual/population)*10000

save "nibrs_acs.dta",replace
