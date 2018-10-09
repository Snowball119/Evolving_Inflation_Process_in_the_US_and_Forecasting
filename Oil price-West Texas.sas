*=====================================================;
*West Texas Intermediate Spot Crude oil price Data;
*=====================================================;





*=======================;
*Read and transform data;
*=======================;

proc import datafile="D:\001UNC Charlotte\2017Spring\ECON6218\capstone\data\Oil Price\WTISPLC.xls"
            DBMS=EXCELCS
			out     =oil1 replace;
            sheet   =sheet1;
            range   ="A11:B866";
            

run;

proc sort data=oil1; by date; run;
proc print data=oil1;run;


proc sgplot data=oil1;
scatter x=date y=OIL;
run;
quit;


*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*:Convert Frequency first then take difference
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;


*======================================;
*Convert Monthly Series to a Quarterly;
*======================================;
proc sort data=oil1;by date;run;

proc expand data=oil1 out=oilq1 from=month to=Qtr;
convert OIL / observed=average;
id date;
run;

proc print data=oilq1;run;


proc sgplot data=oilq1;
scatter x=date y=OIL;
run;
quit;


Proc Autoreg data=oilq1;
model OIL= / stationarity =(ERS);
run;



*======================================;
*Take first difference of Quarterly CPI;
*======================================;
data oilqd1;    /*dataqd q go first because we convert into quartly at first, then take difference d; */

set oilq1;
OILqd= dif1(OIL);
run;

proc print data=oilqd1;run;


proc sgplot data=oilqd1;
scatter x=date y=OILqd;
run;
quit;


Proc Autoreg data=oilqd1;
model OILqd= / stationarity =(ERS);
run;
