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
 
summarize earning [aweight = wgt], detail 
_pctile earning [aweight=wgt], p(1 5 10 20 40 60 80 90 95 99)
 return list
 
 * income
 summarize inc [aweight = wgt], detail 
_pctile inc [aweight=wgt], p(1 5 10 20 40 60 80 90 95 99)
 return list
 
  * networth/ wealth
 summarize wealth [aweight = wgt], detail 
_pctile wealth [aweight=wgt], p(1 5 10 20 40 60 80 90 95 99)
 return list
 
 
 /*
 
 . summarize earning [aweight = wgt], detail 

                           earning
-------------------------------------------------------------
      Percentiles      Smallest
 1%            0      -1546.498
 5%            0      -1546.498
10%            0      -1546.498       Obs              22,085
25%     6.787171      -1546.498       Sum of Wgt.   116107641

50%     37.02094                      Mean           63.82301
                        Largest       Std. Dev.      230.0835
75%     75.07023       161520.5
90%     126.0655       161520.5       Variance       52938.43
95%     180.1572       161520.5       Skewness       162.4619
99%     496.9855       161521.5       Kurtosis       69660.26

. _pctile earning [aweight=wgt], p(1 5 10 20 40 60 80 90 95 99)

.  return list

scalars:
                 r(r1) =  0
                 r(r2) =  0
                 r(r3) =  0
                 r(r4) =  0
                 r(r5) =  25.70898056030273
                 r(r6) =  50.38960266113281
                 r(r7) =  87.47819519042969
                 r(r8) =  126.0655288696289
                 r(r9) =  180.1572265625
                r(r10) =  496.9854736328125

.  
.  * income
.  summarize inc [aweight = wgt], detail 

                             inc
-------------------------------------------------------------
      Percentiles      Smallest
 1%     4.216273      -505.7471
 5%     8.926158      -504.9244
10%     12.34031      -503.6904       Obs              22,085
25%     23.85793      -503.3818       Sum of Wgt.   116107641

50%     47.30452                      Mean           83.58943
                        Largest       Std. Dev.      360.8683
75%     85.55949       187197.4
90%     141.9856       187197.4       Variance         130226
95%     207.2144       187198.4       Skewness       130.7656
99%     680.6813       187200.5       Kurtosis       36101.41

. _pctile inc [aweight=wgt], p(1 5 10 20 40 60 80 90 95 99)

.  return list

scalars:
                 r(r1) =  4.216272830963135
                 r(r2) =  8.926157951354981
                 r(r3) =  12.34031009674072
                 r(r4) =  20.06328964233398
                 r(r5) =  36.30108261108398
                 r(r6) =  58.82214736938477
                 r(r7) =  98.72248077392578
                 r(r8) =  141.9855651855469
                 r(r9) =  207.2143859863281
                r(r10) =  680.6812744140625

.  
.   * networth/ wealth
.  summarize wealth [aweight = wgt], detail 

                           wealth
-------------------------------------------------------------
      Percentiles      Smallest
 1%       -31.26         -473.7
 5%         -4.6         -426.4
10%          .03         -410.6       Obs              22,085
25%        14.15           -391       Sum of Wgt.   116107641

50%          121                      Mean           556.8022
                        Largest       Std. Dev.      3345.963
75%       372.75        1199640
90%        910.3        1393275       Variance       1.12e+07
95%      1900.17        1409656       Skewness       66.69465
99%      8374.54        1411730       Kurtosis       9607.335

. _pctile wealth [aweight=wgt], p(1 5 10 20 40 60 80 90 95 99)

.  return list

scalars:
                 r(r1) =  -31.26000022888184
                 r(r2) =  -4.599999904632568
                 r(r3) =  .0299999993294477
                 r(r4) =  7.329999923706055
                 r(r5) =  64.91500091552734
                 r(r6) =  197.8999938964844
                 r(r7) =  496.8999938964844
                 r(r8) =  910.2999877929688
                 r(r9) =  1900.170043945313
                r(r10) =  8374.5400390625

 
 
 */
 
************************************  TABLE 2 ******************************************************************


**** MEAN/Median and CV 
tabstat earning inc wealth [aweight=wgt], stats(cv mean median)


***variance of the log

g ln_earning=ln(earning)
g ln_inc=ln(inc)
g ln_wealth=ln(wealth)

 pctile EARNING_PC2=earning [aweight=wgt],nq(100) genp(earnpct2)
 tabstat earning[aweight=wgt], statistics(mean cv median p99) column(statistics)
 list EARNING_PC2 earnpct2 in 40/99
  
  
tabstat ln_earning ln_inc ln_wealth [aweight=wgt], stats(var)

  
*** LOCATION OF THE MEAN IN THE DISTRIBUTION

*** 1. get the value of the variables at each percentile
pctile pctile_ear =  earning [aweight=wgt],  nq(100) 
pctile pctile_inc = inc  [aweight=wgt],  nq(100) 
pctile pctile_wea = wealth [aweight=wgt],  nq(100)

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
pctile xtwgt=wgt, nq(100) 

pctile xtE=earning [aweight=wgt], nq(100) 
pctile xtI=inc [aweight=wgt],  nq(100)
pctile xtW=wealth [aweight=wgt],  nq(100)

 list xtE  xtI xtW in 40
 list xtE xtI  xtW in 99
 
 ***  40. | 25.70898   36.30108   64.915 
 ***  99. | 496.9855   680.6813   8374.54 
  
 list xtwgt in 40
 list xtwgt in 99
 
     +----------+
     |    xtwgt |
     |----------|
 40. | 5349.334 |
     +----------+

	
	
     +---------+
     |   xtwgt |
     |---------|
 99. | 12144.8 |
     +---------+

	 
	  g group_wgt=.
 replace group_wgt=1 if earning<=5349.334
  replace group_wgt=2 if earning>=12144.8 
 
 g dE=.
 replace dE=1 if earning<=25.70898
  replace dE=2 if earning>=496.9855
  
   g dI=.
 replace dI=1 if earning<=36.30108  
  replace dI=2 if earning>=680.6813
  
     g dW=.
 replace dW=1 if earning< =64.915 
  replace dW=2 if earning>=8374.54 
  
 
 egen cmsumE=total(earning_wt), by (group_wgt)
 egen cmsumI=total(inc_wt), by (group_wgt)
  egen cmsumW=total(wealth_wt), by (group_wgt)
  
   egen cmsumE_wgt=total(wgt), by (group_wgt)
 egen cmsumI_wgt=total(wgt), by (group_wgt)
  egen cmsumW_wgt=total(wgt), by (group_wgt)
  
  g weighcmsumE=cmsumE/cmsumE_wgt
  g weighcmsumI=cmsumI/cmsumI_wgt
  g weighcmsumW=cmsumW/cmsumW_wgt
  
  tab weighcmsumE group_wgt
  tab weighcmsumI group_wgt
  tab weighcmsumW group_wgt


*****gini index

*** I did this in R


****Lorenz curve






 
