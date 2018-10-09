

*=================================================;

*VAR 1985-2015 model
*=================================================;




proc import datafile="D:\001UNC Charlotte\2017Spring\ECON6218\capstone\data\VAR.xlsx"
            DBMS=EXCELCS
			out     =data2016 replace;
            sheet   =sheet1;
            range   ="A5:L133";
            

run;

proc sort data=data2016; by date; run;

proc print data=data2016;run; 


data data2015;                        /*data2015 include dataset from 1985-2015*/
set data2016;
if year(date)<=2015;
run;
proc print data=data2015;run;


proc timeseries data=data1 vectorplot=series;
id date interval=Qtr;
var CPI GDP M2 SP500 UR FED HPI IMP EXRATE Oil WAGE;
run;



*Step1 Granger Causality Test;

*Note, first need to find the appropriate lag-order for the Granger causality test and then results' interpretation;


*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*Granger Causality Test;


*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*=================================================;
*The Granger-causality test for two variables   ;
*=================================================;


proc varmax data=data2016;

model CPI UR / p=1 ;                                        /*p here is autoregressive order*/

	causal group1= (CPI) group2= (UR);                /*SBC=*/
		causal group1= (UR)  group2= (CPI);
	
run;
quit;



proc varmax data=data2016;

model CPI GDP / p=1 ;                                        /*p here is autoregressive order*/

	causal group1= (CPI) group2= ( GDP);                /*SBC=*/
     causal group1= (GDP)  group2= (CPI);
	
run;
quit;

proc varmax data=data2016;

model CPI M2 / p=1 ;                                        /*p here is autoregressive order*/

	causal group1= (CPI) group2= ( M2);                /*SBC=*/

	causal group1=(M2) group2= (CPI);
run;
quit;


proc varmax data=data2016;

model CPI SP500 / p=1;

    causal group1 =(CPI) group2=(SP500);

	causal group1 =(SP500) group2=(CPI);
	run;
quit;







proc varmax data=data2016;

model CPI FED / p=1 ;                                        /*p here is autoregressive order*/

	causal group1= (CPI) group2= (FED);                /*SBC=*/
    causal group1=(FED) group2= (CPI);
	
run;
quit;


proc varmax data=data2016;

model CPI HPI / p=1 ;                                        /*p here is autoregressive order*/

	causal group1= (CPI) group2= (HPI);                /*SBC=*/

	causal group1=(HPI) group2= (CPI);
run;
quit;


proc varmax data=data2016;

model CPI IMP / p=1 ;                                        /*p here is autoregressive order*/

	causal group1= (CPI) group2= (IMP);                /*SBC=*/

	causal group1=(IMP) group2= (CPI);
run;
quit;


proc varmax data=data2016;

model CPI EXRATE / p=1 ;                                        /*p here is autoregressive order*/

	causal group1= (CPI) group2= (EXRATE);                /*SBC=*/

	causal group1=(EXRATE) group2= (CPI);
run;
quit;


proc varmax data=data2016;

model CPI OIL / p=1 ;                                        /*p here is autoregressive order*/

	causal group1= (CPI) group2= (OIL);                /*SBC=*/

	causal group1=(OIL) group2= (CPI);
run;
quit;


proc varmax data=data2016;

model CPI WAGE / p=3 ;                                        /*p here is autoregressive order*/

	causal group1= (CPI) group2= (WAGE);                /*SBC=*/

	causal group1=(WAGE) group2= (CPI);
run;
quit;



*=================================================;
*The Granger-causality test for three variables   ;
*=================================================;


proc varmax data=data2016;

model CPI FED GDP / p=2 ;                                        /*p here is autoregressive order*/

	causal group1=(CPI) group2=( GDP FED);            /*SBC=254*/
		causal group1=(FED) group2=(CPI GDP);
		causal group1=(GDP) group2=(CPI FED);
run;
quit;


proc varmax data=data2016;

model CPI FED SP500 / p=2 ;                                        /*p here is autoregressive order*/

	causal group1=(CPI) group2=( SP500 FED);            /*SBC=254*/
	
run;
quit;


proc varmax data=data2016;

model CPI FED HPI / p=2 ;                                        /*p here is autoregressive order*/

	causal group1=(CPI) group2=( HPI FED);            /*SBC=254*/
	
run;
quit;




proc varmax data=data2016;

model CPI FED GDP IMP / p=2 ;                                        /*p here is autoregressive order*/

	causal group1=(CPI) group2=( FED GDP IMP);            /*SBC=613*/
	
run;
quit;


proc varmax data=data2016;

model CPI FED GDP EXRATE / p=2 ;                                        /*p here is autoregressive order*/

	causal group1=(CPI) group2=( FED GDP EXRATE);            /*SBC=613*/
	
run;
quit;


proc varmax data=data2016;

model CPI FED GDP Oil / p=2 ;                                        /*p here is autoregressive order*/

	causal group1=(CPI) group2=( FED GDP Oil);            /*SBC=613*/
	
run;
quit;

*=================================================;
*The Granger-causality test for more variables   ;
*=================================================;

proc varmax data=data2016;

model CPI FED GDP SP500/ p=2 ;                                        /*p here is autoregressive order*/

	causal group1=(CPI) group2=( GDP FED SP500);            /*SBC=254*/
		
run;
quit;



proc varmax data=data2016;

model CPI FED GDP SP500  HPI/ p=1 ;                                        /*p here is autoregressive order*/

	causal group1=(CPI) group2=( GDP FED SP500 HPI);            /*SBC=1134.078*/
		
run;
quit;



*=======================================================================================================;
*The Granger-causality test for Full model but UR not in, and IMP and EXRATE are not in the same model  ;
*=========================================================================================================;

proc varmax data=data2016;

model CPI FED GDP SP500 HPI IMP OIL/ p=1;                                        /*p here is autoregressive order*/

	causal group1=(CPI) group2=( FED GDP SP500 HPI IMP OIL);            /*SBC=2021*/
		
run;
quit;


*=======================================================================================================;
*The Granger-causality test for Full model , all variables are in;
*=========================================================================================================;

proc varmax data=data2016;

model CPI UR FED GDP M2 SP500 HPI IMP EXRATE OIL WAGE/ p=1;                                        /*p here is autoregressive order*/

	causal group1=(CPI)     group2=( UR FED GDP M2 SP500 HPI IMP EXRATE OIL WAGE);            /*SBC=1577*/
	causal group1=(UR)	    group2=( CPI FED GDP M2 SP500 HPI IMP EXRATE OIL WAGE);
    causal group1=(FED)     group2=(CPI UR GDP  M2 SP500 HPI IMP EXRATE OIL WAGE);
	     causal group1=(GDP)     group2=(CPI UR FED M2 SP500 HPI IMP EXRATE OIL WAGE);
		causal group1=(M2)     group2=( CPI UR FED GDP SP500 HPI IMP EXRATE OIL WAGE);  
			causal group1=(SP500)     group2=( CPI UR FED GDP M2  HPI IMP EXRATE OIL WAGE);  
				causal group1=(HPI)     group2=(CPI UR FED GDP M2 SP500 IMP EXRATE OIL WAGE);  
					causal group1=(IMP)     group2=( CPI UR FED GDP M2 SP500 HPI EXRATE OIL WAGE);  
						causal group1=(EXRATE)     group2=( CPI UR FED GDP M2 SP500 HPI IMP OIL WAGE);  
							causal group1=(OIL)     group2=( CPI UR FED GDP M2 SP500 HPI IMP EXRATE  WAGE);  
								causal group1=(WAGE)     group2=( CPI UR FED GDP M2 SP500 HPI IMP EXRATE OIL );  
									

run;
quit;




*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*Forest ;


*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;


*====================================================================================;
*Phillips Curve ;
*====================================================================================;



proc varmax data=data2015;

model CPI UR   / p=1 ;

id date interval=qtr;
     output lead=4 out=forecast;	

run;
quit;


proc varmax data=data2016;

model CPI UR   / p=1 ;

id date interval=qtr;
     output lead=8 out=forecast;	

run;
quit;



*====================================================================================;
*FED FUND RATE ;
*====================================================================================;



proc varmax data=data2015;

model CPI FED   / p=1 ;

id date interval=qtr;
     output lead=4 out=forecast;	

run;
quit;


proc varmax data=data2016;

model CPI FED   / p=1 ;

id date interval=qtr;
     output lead=8 out=forecast;	

run;
quit;





*====================================================================================;
*FED FUND RATE  and GDP;
*====================================================================================;



proc varmax data=data2015;

model CPI FED GDP / p=2 ;

id date interval=qtr;
     output lead=4 out=forecast;	

run;
quit;


proc varmax data=data2016;

model CPI FED GDP  / p=2 ;

id date interval=qtr;
     output lead=8 out=forecast;	

run;
quit;


*====================================================================================;
*FED FUND RATE  and SP500;
*====================================================================================;



proc varmax data=data2015;

model CPI FED SP500 / p=2 ;

id date interval=qtr;
     output lead=4 out=forecast;	

run;
quit;


proc varmax data=data2016;

model CPI FED SP500  / p=2 ;

id date interval=qtr;
     output lead=8 out=forecast;	

run;
quit;


*====================================================================================;
*FED FUND RATE  and HPI;
*====================================================================================;



proc varmax data=data2015;

model CPI FED HPI / p=2 ;

id date interval=qtr;
     output lead=4 out=forecast;	

run;
quit;


proc varmax data=data2016;

model CPI FED HPI  / p=2 ;

id date interval=qtr;
     output lead=8 out=forecast;	

run;
quit;




*====================================================================================;
*FED FUND RATE  GDP and SP500;
*====================================================================================;



proc varmax data=data2015;

model CPI FED GDP SP500 / p=2 ;

id date interval=qtr;
     output lead=4 out=forecast;	

run;
quit;


proc varmax data=data2016;

model CPI FED GDP SP500  / p=2 ;

id date interval=qtr;
     output lead=8 out=forecast;	

run;
quit;






*====================================================================================;
*FED FUND RATE  GDP and HPI;
*====================================================================================;



proc varmax data=data2015;

model CPI FED GDP HPI / p=2 ;

id date interval=qtr;
     output lead=4 out=forecast;	

run;
quit;


proc varmax data=data2016;

model CPI FED GDP HPI / p=2 ;

id date interval=qtr;
     output lead=8 out=forecast1;	

run;
quit;




*====================================================================================;
*FED FUND RATE  GDP and IMP;
*====================================================================================;



proc varmax data=data2015;

model CPI FED GDP IMP / p=2 ;

id date interval=qtr;
     output lead=4 out=forecast;	

run;
quit;


proc varmax data=data2016;

model CPI FED GDP IMP / p=2 ;

id date interval=qtr;
     output lead=8 out=forecast;	

run;
quit;


*====================================================================================;
*FED FUND RATE  GDP and EXRATE;
*====================================================================================;



proc varmax data=data2015;

model CPI FED GDP EXRATE / p=2 ;

id date interval=qtr;
     output lead=4 out=forecast;	

run;
quit;


proc varmax data=data2016;

model CPI FED GDP EXRATE / p=2 ;

id date interval=qtr;
     output lead=8 out=forecast1;	

run;
quit;


*====================================================================================;
*FED FUND RATE  GDP and Oil;
*====================================================================================;



proc varmax data=data2015;

model CPI FED GDP Oil / p=2 ;

id date interval=qtr;
     output lead=4 out=forecast;	

run;
quit;


proc varmax data=data2016;

model CPI FED GDP OIL / p=2 ;

id date interval=qtr;
     output lead=8 out=forecast1;	

run;
quit;




*====================================================================================;
*Full Model, no UR, no M2, and IMP and EXRATE are not in the same model
*====================================================================================;



proc varmax data=data2015;

model CPI FED GDP SP500 HPI IMP OIL / p=1 ;

id date interval=qtr;
     output lead=4 out=forecast;	

run;
quit;


proc varmax data=data2016;

model  CPI FED GDP SP500 HPI IMP OIL / p=1 ;

id date interval=qtr;
     output lead=8 out=forecast1;	

run;
quit;

*====================================================================================;
*Full Model,exclude M2
*====================================================================================;



proc varmax data=data2015;

model CPI UR FED GDP SP500 HPI IMP EXRATE OIL WAGE/ p=1;

id date interval=qtr;
     output lead=4 out=forecast;	

run;
quit;


proc varmax data=data2016;

model CPI UR FED GDP SP500 HPI IMP EXRATE OIL WAGE/ p=1;

id date interval=qtr;
     output lead=8 out=forecast1;	

run;
quit;




*====================================================================================;
*Full Model,Include all variables
*====================================================================================;



proc varmax data=data2015;

model CPI UR FED GDP M2 SP500 HPI IMP EXRATE OIL WAGE/ p=1;

id date interval=qtr;
     output lead=4 out=forecast;	

run;
quit;


proc varmax data=data2016;

model CPI UR FED GDP M2 SP500 HPI IMP EXRATE OIL WAGE/ p=1;

id date interval=qtr;
     output lead=8 out=forecast1;	

run;
quit;



                                   
proc varmax data=data2016;
model CPI UR FED GDP M2 SP500 HPI IMP EXRATE OIL WAGE/ p=1 print=(decompose(1) estimates diagnose impulse=(stderr))
                   printform=both lagmax=3;  /*variance decompose*/
run;
quit;



proc varmax data=data2016 plot=Impulse(accum);
    model 	CPI UR FED GDP M2 SP500 HPI IMP EXRATE OIL WAGE/ p=1 printform=univariate
				print=(IMPULSE(12)=all estimates);
   id date interval=qtr;

run;quit;
  *output  out=for ;
