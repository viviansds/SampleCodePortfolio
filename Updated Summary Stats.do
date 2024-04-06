clear
cd "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Derived"
use "nibrs_acs.dta"
cd "/Users/vivi/Desktop/ECO360/Marijuana_IPV//Data/SA"

* STEP 1: Create a summary table of victim and offender for current year legalization
eststo clear
estpost sum victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian if Legal_Current==1
estimates store legalized


estpost sum victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian if Legal_Current==0
estimates store non_legalized

estpost sum victim_female victim_white victim_black victim_asian victim_native resident_status victim_hispanic offender_male offender_white offender_black offender_asian 
estimates store all


esttab all legalized non_legalized using "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Figures/sumstat_victim_offender.tex", ///
label stats(N ) nomti nonum frag compress cells("mean(fmt(3)) sd(fmt(3))" ) collabels("Mean" "S.D.") replace



* STEP 2: Create a summary table for control variables
use "nibrs_acs.dta"
eststo clear
estpost sum population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried if Legal_Current==1
estimates store legalized


estpost sum population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried if Legal_Current==0
estimates store non_legalized


estpost sum population asian_perc native_perc black_perc white_perc households high_school unemployment health_insurance median_income per_capita_income below_poverty perc_spouse perc_unmarried
estimates store all


esttab all legalized non_legalized using "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Figures/sum_stat_control.tex", ///
label stats(N ) nomti nonum frag compress cells("mean(fmt(3)) sd(fmt(3))" ) collabels("Mean" "S.D.") replace



**STEP 3: Summary Stats for dependent variables

eststo clear
estpost sum IPV IPV_bfgf IPV_anyspouse IPV_physical IPV_emotional IPV_sexual if Legal_Current==1
estimates store legalized


estpost sum IPV IPV_bfgf IPV_anyspouse IPV_physical IPV_emotional IPV_sexual if Legal_Current==0
estimates store non_legalized

estpost sum IPV IPV_bfgf IPV_anyspouse IPV_physical IPV_emotional IPV_sexual
estimates store all


esttab all legalized non_legalized using "/Users/vivi/Desktop/ECO360/Marijuana_IPV/Data/Figures/sumstat_IPV.tex", ///
label stats(N ) nomti nonum frag compress cells("mean(fmt(3)) sd(fmt(3))" ) collabels("Mean" "S.D.") replace











