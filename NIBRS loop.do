* ECON 360: Data Appendix
* Vivian Wei
clear all
set more off

//
// local folder_path "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Source/NIBRS_victim"
// local files : dir "`folder_path'" files "*.dta"

forvalues i = 2016/2022 {
use "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Source/NIBRS_victim/nibrs_victim_segment_`i'", clear


** STEP 1: Drop unwanted variables
drop ori victim_sequence_number officer_type_activity officer_assignment_type officer_killed_other_agency_ori unique_incident_id
drop type_of_injury_3 type_of_injury_4 type_of_injury_5
drop ucr_offense_code_5 ucr_offense_code_6 ucr_offense_code_7 ucr_offense_code_8 ucr_offense_code_9 ucr_offense_code_10
drop offender_number_to_be_related1 offender_number_to_be_related2 relation_of_vict_to_offender2 offender_number_to_be_related3 relation_of_vict_to_offender3 offender_number_to_be_related4 relation_of_vict_to_offender4 offender_number_to_be_related5 relation_of_vict_to_offender5 offender_number_to_be_related6 relation_of_vict_to_offender6 offender_number_to_be_related7 relation_of_vict_to_offender7 offender_number_to_be_related8 relation_of_vict_to_offender8 offender_number_to_be_related9 relation_of_vict_to_offender9  offender_number_to_be_related10 relation_of_vict_to_offender10
drop agg_assault_homicide_circumsta1 agg_assault_homicide_circumsta2 addit_just_homicide_circumsta
drop ucr_offense_code_2 ucr_offense_code_3 ucr_offense_code_4
drop  type_of_injury_1 type_of_injury_2 age_of_victim

//keep only crime types that are simple assult, aggravated assult, and intimation
keep if ucr_offense_code_1 == "simple assault" |ucr_offense_code_1 == "aggravated assault" | ucr_offense_code_1 == "kidnapping/abduction" |ucr_offense_code_1 == "intimidation"| ucr_offense_code_1 == "extortion/blackmail" | ucr_offense_code_1 == "rape" | ucr_offense_code_1 == "sexual assault with an object"| ucr_offense_code_1 == "statutory rape" | ucr_offense_code_1 == "fondling (incident liberties/child molest)"
 	 
		 
** STEP 2: change variable into binary dummy variables

*relationship with offender
destring relation_of_vict_to_offender1, replace
encode relation_of_vict_to_offender1, gen(relationship)
tab relationship 
list relationship relation_of_vict_to_offender1 in 1/40, nolabel
gen IPV = (relationship == 22 | relationship == 4 | relationship == 10 | relationship ==14 | relationship ==7)
*22=spouse, 4=boyfriend/girlfriend, 10=ex-spouse, 14= homosexual relationship, 7= common-law spouse
keep if IPV  == 1
gen IPV_bfgf = relationship == 4
gen IPV_anyspouse = (relationship == 22 | relationship == 10 | relationship ==14 | relationship ==7)
lab var IPV "Victim is in Intimate Partner Relatioship with the offender"
lab var IPV_bfgf "Victim is boyfriend/girlfriend"
lab var IPV_anyspouse "Victim is spouse"
drop relationship relation_of_vict_to_offender1

*Gender
destring sex_of_victim, replace
encode sex_of_victim, gen(gender)
list sex_of_victim  gender in 1/2, nolabel
drop if sex_of_victim == "unknown"
gen female = gender == 1
lab var female "Victim is female"
drop gender sex_of_victim

*Race
destring race_of_victim, replace
encode race_of_victim,  gen(race)
list race_of_victim race in 1/50, nolabel
tab race_of_victim
drop if race_of_victim == "unknown"
tab race
gen white = race == 5
lab var white "Victim  is white"
gen black = race == 3
lab var black "Victim is black"
gen asian = race == 2
lab var asian "Victim is asian"
gen native_american = race == 1
lab var native_american "Victim is native american or alaskan native"
drop race_of_victim race

*Resident
destring resident_status_of_victim, replace
encode resident_status_of_victim, gen(resident)
list resident_status_of_victim resident in 1/2, nolabel
gen resident_status = resident == 2
lab var resident_status "Victim is a resident in the state"
drop resident_status_of_victim resident

*ethnicity
destring ethnicity_of_victim, replace
encode ethnicity_of_victim, gen(ethnicity)
gen hispanic = ethnicity == 1
lab var hispanic "Victim is hispanic"
drop ethnicity_of_victim ethnicity

*find duplicates
sort state year incident_number
quietly by state year incident_number:  gen dup = cond(_N==1,0,_n)
drop if dup>0
drop dup

save "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Derived/Victim/new`i'.dta"
}


