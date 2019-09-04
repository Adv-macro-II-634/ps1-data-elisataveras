clear


** I will use the information from the original database 

use "C:\Users\elisa\Documents\Binghamton University\Fall 2019\ECON 634\PS1\rscfp2007.dta" 

/*deflating the numbers since the summary statistics have the value of dollars in 2016

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
 
 *** table 2
 