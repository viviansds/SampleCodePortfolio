set more off
clear
cd "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Derived"
use "nibrs_acs.dta"

drop state_abb Abbreviation
 
tabulate state, generate(S)
gen IPV_log = log(IPV)
replace health_insurance = 0 if missing(health_insurance)
save "nibrs_acs.dta",replace
*Experimental Regression 
// reg IPV Legal_Current victim_female victim_black victim_white victim_asian resident_status victim_hispanic offender_male offender_white offender_black offender_asian asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income S1-S35 year, vce(robust)
*Legal_Current = 5.980878  p-value= 0.008   



// reg IPV_log Legal_Current victim_female victim_black victim_white victim_asian resident_status victim_hispanic offender_male offender_white offender_black offender_asian asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income S1-S35 year, vce(robust)
* Legal_Current =.3187316  p-value = 0.026 

//
// reghdfe IPV_log Legal_Current victim_female victim_black victim_white victim_asian resident_status victim_hispanic offender_male offender_white offender_black offender_asian asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income, absorb (state year) 
//
// reghdfe IPV_log Legal_Current victim_female victim_black victim_white victim_asian resident_status victim_hispanic offender_male offender_white offender_black offender_asian asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income, absorb (state year) vce (cluster state)
//
// *change legalized to years before
// reg IPV Legal_Previous victim_female victim_black victim_white victim_asian resident_status victim_hispanic offender_male offender_white offender_black offender_asian asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income S1-S35 year, vce(robust)
// *change legalized to years after
// reg IPV Legal_Following victim_female victim_black victim_white victim_asian resident_status victim_hispanic offender_male offender_white offender_black offender_asian asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income S1-S35 year, vce(robust)
// **log IPV
// reg IPV_log Legal_Following victim_female victim_black victim_white victim_asian resident_status victim_hispanic offender_male offender_white offender_black offender_asian asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income S1-S35 year, vce(robust)

** IPV Total Regression table========================================================
estimates clear
reg IPV Legal_Current S1-S36 i.year , vce(cluster state)
estadd ysumm
estimates store total_ipv

reg IPV  Legal_Current population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried S1-S36 i.year, vce(cluster state)
estadd ysumm
estimates store total_ipv_full


esttab total_ipv  total_ipv_full using "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Figures2/main_regressions_totalipv.tex", ///
nogaps fragment nomtitles r2 se label star(* 0.10 ** 0.05 *** 0.01) ///
replace b(%9.4f) keep(Legal_Current) ///
stats(ymean r2 N, labels("Mean Dept. Var." "R-squared" "N"))

**Relationship IPV==================================================================

reg IPV_bfgf Legal_Current  S1-S36 i.year , vce(cluster state)
estadd ysumm
estimates store ipv_gfbf


reg IPV_bfgf Legal_Current population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried S1-S36 i.year, vce(cluster state)
estadd ysumm
estimates store ipv_gfbf_full


reg IPV_anyspouse Legal_Current S1-S36 i.year, vce(cluster state)
estadd ysumm
estimates store ipv_anyspouse


reg IPV_anyspouse Legal_Current population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried S1-S36 i.year, vce(cluster state)
estadd ysumm
estimates store ipv_anyspouse_full


esttab ipv_gfbf ipv_gfbf_full ipv_anyspouse ipv_anyspouse_full using "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Figures2/main_regressions_relationship.tex", ///
nogaps fragment nomtitles r2 se label star(* 0.10 ** 0.05 *** 0.01) ///
replace b(%9.4f) keep(Legal_Current) ///
stats(ymean r2 N, labels("Mean Dept. Var." "R-squared" "N"))


*** Type of IPV regression table==========================================================

estimates clear
reg IPV_physical Legal_Current S1-S35 i.year, vce(cluster state)
estadd ysumm
estimates store ipv_physical 


reg IPV_physical Legal_Current population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried S1-S35 i.year, vce(cluster state)
estadd ysumm
estimates store ipv_physical_full

reg IPV_emotional Legal_Current S1-S35 i.year, vce(cluster state)
estadd ysumm
estimates store ipv_emotional 


reg IPV_emotional Legal_Current population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried S1-S35 i.year, vce(cluster state)
estadd ysumm
estimates store ipv_emo_full

reg IPV_sexual Legal_Current S1-S35 i.year, vce(cluster state)
estadd ysumm
estimates store ipv_sex


 
reg IPV_sexual Legal_Current population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried S1-S35 i.year, vce(cluster state)
estadd ysumm
estimates store ipv_sex_full

esttab ipv_physical ipv_physical_full ipv_emotional ipv_emo_full ipv_sex ipv_sex_full using "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Figures2/main_regressions_type.tex", ///
nogaps fragment nomtitles r2 se label star(* 0.10 ** 0.05 *** 0.01) ///
replace b(%9.4f) keep(Legal_Current) ///
stats(ymean r2 N, labels("Mean Dept. Var." "R-squared" "N"))


save "nibrs_acs.dta",replace


*** Log IPV========================================================================= 
estimates clear
reg IPV_log Legal_Current S1-S35 i.year, vce(robust)
estadd ysumm
estimates store ipv_log

reg IPV_log Legal_Current victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian S1-S35 i.year, vce(robust)
estadd ysumm
estimates store ipv_log_crime

reg IPV_log Legal_Current victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried S1-S35 i.year, vce(robust)
estadd ysumm
estimates store ipv_log_full

esttab ipv_log ipv_log_crime ipv_log_full using "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Figures/main_regressions_log.tex", ///
nogaps fragment nomtitles r2 se label star(* 0.10 ** 0.05 *** 0.01) ///
replace b(%9.4f) keep(Legal_Current) ///
stats(ymean r2 N, labels("Mean Dept. Var." "R-squared" "N"))


*** Different Legalization year =======================================================

*change legalized to years before
reg IPV Legal_Previous S1-S35 i.year, vce(robust)
estadd ysumm
estimates store ipv_pre

reg IPV Legal_Previous victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian S1-S35 i.year, vce(robust)
estadd ysumm
estimates store ipv_pre_crime

reg IPV Legal_Previous victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried S1-S35 i.year, vce(robust)
estadd ysumm
estimates store ipv_pre_full

*change legalized to years after
reg IPV Legal_Following S1-S35 i.year, vce(robust)
estadd ysumm
estimates store ipv_fol

reg IPV Legal_Following victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian S1-S35 i.year, vce(robust)
estadd ysumm
estimates store ipv_fol_crime

reg IPV Legal_Following victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried S1-S35 i.year, vce(robust)
estadd ysumm
estimates store ipv_fol_full

esttab ipv_pre ipv_pre_crime ipv_pre_full ipv_fol ipv_fol_crime ipv_fol_full using "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Figures/main_regressions_legalized.tex", ///
nogaps fragment nomtitles r2 se label star(* 0.10 ** 0.05 *** 0.01) ///
replace b(%9.4f) keep(Legal_Previous Legal_Following) ///
stats(ymean r2 N, labels("Mean Dept. Var." "R-squared" "N"))


graph save "histogram_ipv.gph", replace
graph export "histogram_graph.png", replace


