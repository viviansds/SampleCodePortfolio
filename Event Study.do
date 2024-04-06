
set more off
clear
cd "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Derived"
use "nibrs_acs.dta"
sort(state year)
egen first_legalization_year = min(cond(Legal_Current == 1, year, .)), by(state)
egen last_0_year = max(cond(Legal_Current == 0, year, .)), by(state)
gen legalized = (last_0_year!=2021)
by state: gen time_since_legalized = year - first_legalization_year 
keep if legalized == 1
save "only_legalized.dta",replace
tab time_since_legalized, gen (Y)


estimates clear
reg IPV Y2-Y20 victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried S1-S35 i.year, vce(robust)
estadd ysumm
estimates store total_ipv


reg IPV_bfgf Y2-Y20 victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried S1-S35 i.year, vce(robust)
estadd ysumm
estimates store bfgf


reg IPV_anyspouse Y2-Y20 victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried S1-S35 i.year, vce(robust)
estadd ysumm
estimates store anyspouse


reg IPV_physical Y2-Y20 victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income S1-S35 i.year, vce(robust)
estadd ysumm
estimates store physical

reg IPV_emotional Y2-Y20 victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income S1-S35 i.year, vce(robust)
estadd ysumm
estimates store emotional

reg IPV_sexual Y2-Y20 victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income S1-S35 i.year, vce(robust)
estadd ysumm
estimates store sexual

esttab total_ipv bfgf anyspouse physical emotional sexual using "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Figures/event_study.tex", ///
nogaps fragment nomtitles r2 se label star(* 0.10 ** 0.05 *** 0.01) ///
replace b(%9.4f) keep(Y2 Y3 Y4 Y5 Y6 Y7 Y8 Y9 Y10 Y11 Y12 Y13 Y14 Y15 Y16 Y17 Y18 Y19  Y20) ///
stats(ymean r2 N, labels("Mean Dept. Var." "R-squared" "N"))
save "only_legalized.dta",replace

lab var Y2 "-10"
lab var Y3 "-9"
lab var Y4 "-8"
lab var Y5 "-7"
lab var Y6 "-6"
lab var Y7 "-5"
lab var Y8 "-4"
lab var Y9 "-3"
lab var Y10 "-2"
lab var Y11 "-1"
lab var Y12 "0"
lab var Y13 "1"
lab var Y14 "2"
lab var Y15 "3"
lab var Y16 "4"
lab var Y17 "5"
lab var Y18 "6"
lab var Y19 "7"
lab var Y20 "8"
lab var Y21 "8"

save "only_legalized.dta",replace

**====================GRAPH=======================

reg IPV Y2-Y20 victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried S1-S35 i.year, vce(robust)


coefplot, keep(Y2 Y3 Y4 Y5 Y6 Y7 Y8 Y9 Y10 Y11 Y12 Y13 Y14 Y15 Y16 Y17 Y18 Y19 Y20) vertical yline(0,lcolor("106 208 200") lpattern(dash)) xline(11, lcolor("236 196 77")) title("Event Study: Total IPV")


graph export "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Figures/event_study.jpg", replace



