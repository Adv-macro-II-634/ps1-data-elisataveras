clear


** I will use the information from the original database 

use "C:\Users\elisa\Documents\Binghamton University\Fall 2019\ECON 634\PS1\rscfp2007.dta" 

/*
deflating the numbers since the summary statistics have the value of dollars in 2016

 since I am using the summarize version, and it is adjusted to be in 2016 value, I adjusted
 I follow the SAS code given in the page to https://www.federalreserve.gov/econres/files/bulletin.macro.txt
  calculate the values, based on the form: 
  %IF (&YEAR=2007) %THEN %DO;
    %LET CPIADJ=&CPIBASE/3063;
    %LET CPILAG=3046/2962;
    %IF (&PUBLIC NE YES) %THEN %LET SCFDS=SCF07I6;
    %ELSE %LET SCFDS=P07I6;
	
	where the base i defined 
	
	%BULLIT(YEAR=2007,REAL=YES,ADJINC=YES,CPIBASE=3547,PUBLIC=YES);
	
	Then  3547/3063=1.158015018 
	
	*/
	
g d7_wageinc=wageinc/(1.158015018)
g d7_bussefarminc=bussefarminc/(1.158015018)
g d7_intdivinc=intdivinc/(1.158015018)
g d7_kginc=kginc/(1.158015018)
g d7_ssretinc=ssretinc/(1.158015018)
g d7_transfothinc=transfothinc/(1.158015018)
g d7_penacctwd=penacctwd/(1.158015018)
g d7_asset=asset/(1.158015018)/(1.158015018)
g d7_debt=debt/(1.158015018*1000)/(1.158015018)
g d7_futpen=futpen/(1.158015018)
g d7_networth=networth/(1.158015018)

*** save the variables that I need 


***Calculating the total wages= WAGEINC+0.863*BUSSEFARMINC
g earning=(d7_wageinc +0.863*d7_bussefarminc)/(10^3)
g inc=((d7_wageinc+d7_bussefarminc+d7_intdivinc+d7_kginc+d7_ssretinc+d7_transfothinc))/(10^3)
g wealth=(d7_networth)/(10^3)


keep YY1 Y1 wgt earning inc wealth


save "C:\Users\elisa\Documents\GitHub\ps1-data-elisataveras\build_data\output\dtascf", replace

************************************  TABLE 1 ******************************************************************

*** doing the first table
**** firt get the summarize which give me the minimum, the max
* earnings
 
summarize earning [aw = wgt], detail 
_pctile earning [aw=wgt], p(1 5 10 20 40 60 80 90 95 99)
 return list
 
 * income
 summarize inc [aw = wgt], detail 
_pctile inc [aw=wgt], p(1 5 10 20 40 60 80 90 95 99)
 return list
 
  * networth/ wealth
 summarize wealth [aw = wgt], detail 
_pctile wealth [aw=wgt], p(1 5 10 20 40 60 80 90 95 99)
 return list
 
 


 
************************************  TABLE 2 ******************************************************************


**** MEAN/Median and CV 
tabstat earning inc wealth [aw=wgt], stats(cv mean median)


***variance of the log

g ln_earning=ln(earning)
g ln_inc=ln(inc)
g ln_wealth=ln(wealth)

 pctile EARNING_PC2=earning [aw=wgt],nq(100) genp(earnpct2)
 tabstat earning[aw=wgt], statistics(mean cv median p99) column(statistics)
 list EARNING_PC2 earnpct2 in 40/99
  
  
tabstat ln_earning ln_inc ln_wealth [aw=wgt], stats(var)

  
*** LOCATION OF THE MEAN IN THE DISTRIBUTION

*** 1. get the value of the variables at each percentile
pctile pctile_ear =  earning [aw=wgt],  nq(100) 
pctile pctile_inc = inc  [aw=wgt],  nq(100) 
pctile pctile_wea = wealth [aw=wgt],  nq(100)

** 2. get the proportion that are just bellow the mean

egen pcE = mean(100 * ((pctile_ear < 63.82301) / (pctile_ear < .)))
egen pcI = mean(100 * ((pctile_inc < 83.58943) / (pctile_inc < .)))
egen pcW = mean(100 * ((pctile_wea < 556.8022) / (pctile_wea < .)))
su pcE pcI pcW


*** GINI INDEX


*** TOP 1% / LOWEST 40%

** generate weighted values

g earning_wt=earning*wgt
g inc_wt=inc*wgt
g wealth_wt=wealth*wgt

*** GENERATE THE PERCENTILE THAT PEOPLE ARE IN
pctile xtE=earning [aw=wgt], nq(100) 
pctile xtI=inc [aw=wgt],  nq(100)
pctile xtW=wealth [aw=wgt],  nq(100)

 list xtE  xtI xtW in 40
 list xtE xtI  xtW in 99
 
 ***  40. | 25.70898   36.30108   64.915 
 ***  99. | 496.9855   680.6813   8374.54 
  

 
 g dE=.
 replace dE=1 if earning<=25.70898
  replace dE=2 if earning>=496.9855
  
   g dI=.
 replace dI=1 if earning<=36.30108  
  replace dI=2 if earning>=680.6813
  
     g dW=.
 replace dW=1 if earning< =64.915 
  replace dW=2 if earning>=8374.54 
  
 
 egen cmsumE=total(earning_wt), by (dE)
 egen cmsumI=total(inc_wt), by (dI)
  egen cmsumW=total(wealth_wt), by (dW)
  
   egen cmsumE_wgt=total(wgt), by (dE)
 egen cmsumI_wgt=total(wgt), by (dI)
  egen cmsumW_wgt=total(wgt), by (dW)
  
  g weighcmsumE=cmsumE/cmsumE_wgt
  g weighcmsumI=cmsumI/cmsumI_wgt
  g weighcmsumW=cmsumW/cmsumW_wgt
  
  tab weighcmsumE dE
  tab weighcmsumI dI
  tab weighcmsumW dW


*****gini index

*** I did this in R

 
************************************  LORENZ CURVE ******************************************************************


glcurve earning [aw=wgt], gl(lE) p(EqE) lorenz nograph
glcurve inc [aw=wgt], gl(lI) p(EqI) lorenz nograph
glcurve wealth [aw=wgt], gl(lW) p(EqW) lorenz nograph


graph twoway ///
line EqE EqE, legend( label( 1 "Lorenz Curve") label( 2 "Line of Equality" ) ) 

graph twoway ///
line lE EqE , sort  graphregion(color(white)) bgcolor(white) ytitle("Cumulative Share of Earnings")   xtitle("Cumulative Share of People from Lowest to Highest Earning")title("Graphical Representation of Gini Coefficient for Earning") subtitle("U.S., 2007") note("Source: SCF 2007")  || ///
line EqE EqE, legend( label( 1 "Lorenz Curve") label( 2 "Line of Equality" ) ) 
graph export "C:\Users\elisa\Documents\GitHub\ps1-data-elisataveras\build_data\output\Lorenz_earning.png", as(png) replace



graph twoway ///
line lI EqI , sort  graphregion(color(white)) bgcolor(white) ytitle("Cumulative Share of Income")   xtitle("Cumulative Share of People from Lowest to Highest Income")title("Graphical Representation of Gini Coefficient for Income") subtitle("U.S., 2007") note("Source: SCF 2007")  || ///
line EqI EqI, legend( label( 1 "Lorenz Curve") label( 2 "Line of Equality" ) ) 
graph export "C:\Users\elisa\Documents\GitHub\ps1-data-elisataveras\build_data\output\Lorenz_income.png", as(png) replace


graph twoway ///
line lW EqW , sort  graphregion(color(white)) bgcolor(white) ytitle("Cumulative Share of Wealth")   xtitle("Cumulative Share of People from Lowest to Highest Wealth")title("Graphical Representation of Gini Coefficient for Wealth") subtitle("U.S., 2007") note("Source: SCF 2007")  || ///
line EqW EqW, legend( label( 1 "Lorenz Curve") label( 2 "Line of Equality" ) ) 
graph export "C:\Users\elisa\Documents\GitHub\ps1-data-elisataveras\build_data\output\Lorenz_wealth.png", as(png) replace


 
