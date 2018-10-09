

*=======================;
*CPI Data;
*=======================;





*=======================;
*Read and transform data;
*=======================;

proc import datafile="D:\001UNC Charlotte\2017Spring\ECON6218\capstone\data\CPI\CPIq.xls"
            DBMS=EXCELCS
			out     =cpi1 replace;
            sheet   =sheet1;
            range   ="E153:F281";
            

run;

proc sort data=cpi1; by date; run;
proc print data=cpi1;run;


proc sgplot data=cpi1;
scatter x=date y=CPI;
run;
quit;


*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*:Convert Frequency first then take difference
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;


*======================================;
*Convert Monthly Series to a Quarterly;
*======================================;
proc sort data=data1;by date;run;

proc expand data=data1 out=dataq1 from=month to=Qtr;
convert CPIAUCSL / observed=average;
id date;
run;

proc print data=dataq1;run;


*======================================;
*Take first difference of Quarterly CPI;
*======================================;
data dataqd1;    /*dataqd q go first because we convert into quartly at first, then take difference d; */

set dataq1;
dCPIAUCSLqd= dif1(CPIAUCSL);
run;

proc print data=dataqd1;run;


proc sgplot data=dataqd1;
scatter x=date y=dCPIAUCSLqd;
run;
quit;


Proc Autoreg data=dataqd1;
model dCPIAUCSLqd= / stationarity =(ERS);
run;

*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*:Take difference first then convert frenquency
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;

*======================================;
*Take first difference of Monthly CPI;
*======================================;
data data1;

set data1;
dCPIAUCSL= dif1(CPIAUCSL);
run;

proc print data=data1;run;


*===============================================================+++++++++++++;
*Convert Monthly difference Series to a Quarterly difference;
*===================================================================++++++++;
proc sort data=data1;by date;run;

proc expand data=data1 out=datadq1 from=month to=Qtr;    
/*datadq d go first because we take difference at first, then convert the first difference level data into quartly; */
convert dCPIAUCSL / observed=average;
id date;
run;

proc print data=datadq1;run;


proc sgplot data=datadq1;
scatter x=date y=dCPIAUCSL;
run;
quit;


Proc Autoreg data=datadq1;
model dCPIAUCSL= / stationarity =(ERS);   *stationary;
run;




*=========================================;
*The Proc AR is employed               ;
*Using SBC to identify p for AR(p) for CPIAUCSL         ;
*=========================================;
proc arima data= datadq1;
identify var= dCPIAUCSL; 
estimate p=1;                         *SBC=133.5587;
run;
quit;

proc arima data= datadq1;
identify var= dCPIAUCSL; 
estimate p=2;                         *SBC=133.3952;
run;
quit;

proc arima data= datadq1;
identify var= dCPIAUCSL; 
estimate p=3;                         *SBC=123.9077;
run;
quit;

proc arima data= datadq1;
identify var= dCPIAUCSL; 
estimate p=4;                         *SBC=127.4972;
run;
quit;

*=========================================;
*The Proc ARIMA is employed               ;
*Identifying ARIMA (p,d,q) for CPIAUCSL         ;
*=========================================;

*Plots of ACFs and PACFs;

Proc ARIMA Data= datadq1;
Identify var = dCPIAUCSL ;   *level form;      
Run;
Quit;

*SCAN (Squared Canonical Correlation) option;


Proc ARIMA Data= datadq1;
Identify var = dCPIAUCSL SCAN ;        
Run;
Quit;

*Forecasting;

proc arima data= datadq1;
identify var= dCPIAUCSL;
estimate p=1   q=1;
forecast lead=2 interval=Qtr id=date out=Forecast_CPI;
run;
quit;

