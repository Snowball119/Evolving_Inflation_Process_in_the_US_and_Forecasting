
*=======================;
*FED funds rate Data;
*=======================;





*=======================;
*Read and transform data;
*=======================;

proc import datafile="D:\001UNC Charlotte\2017Spring\ECON6218\capstone\data\Monetary Policy\FEDFUNDS-Monthly.xls"
            DBMS=EXCELCS
			out     =fed1 replace;
            sheet   =sheet1;
            range   ="A11:B764";
            

run;

proc sort data=fed1; by date; run;
proc print data=fed1;run;


proc sgplot data=fed1;
scatter x=date y=FEDFUNDS;
run;
quit;


*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*:Convert Frequency first then take difference
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;


*======================================;
*Convert Monthly Series to a Quarterly;
*======================================;
proc sort data=fed1;by date;run;

proc expand data=fed1 out=fedq1 from=month to=Qtr;
convert FEDFUNDS / observed=average;
id date;
run;

proc print data=fedq1;run;


proc sgplot data=fedq1;
scatter x=date y=FEDFUNDS;
run;
quit;


Proc Autoreg data=fedq1;
model FEDFUNDS= / stationarity =(ERS);
run;



*======================================;
*Take first difference of Quarterly CPI;
*======================================;
data fedqd1;    /*dataqd q go first because we convert into quartly at first, then take difference d; */

set fedq1;
FEDFUNDSqd= dif1(FEDFUNDS);
run;

proc print data=fedqd1;run;


proc sgplot data=fedqd1;
scatter x=date y=FEDFUNDSqd;
run;
quit;


Proc Autoreg data=fedqd1;
model FEDFUNDSqd= / stationarity =(ERS);
run;
