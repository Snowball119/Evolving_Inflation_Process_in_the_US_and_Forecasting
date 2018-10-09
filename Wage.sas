*===========================================================================;
*Average Hourly Earning of Prodution and NOnsupervisory Employees Data;
*===========================================================================;





*=======================;
*Read and transform data;
*=======================;

proc import datafile="D:\001UNC Charlotte\2017Spring\ECON6218\capstone\data\Wage\Wage-Monthly.xls"
            DBMS=EXCELCS
			out     =wage1 replace;
            sheet   =sheet1;
            range   ="A11:B647";
            

run;

proc sort data=wage1; by date; run;
proc print data=wage1;run;


proc sgplot data=wage1;
scatter x=date y=WAGE;
run;
quit;


*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*:Convert Frequency first then take difference
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;


*======================================;
*Convert Monthly Series to a Quarterly;
*======================================;
proc sort data=wage1;by date;run;

proc expand data=wage1 out=wageq1 from=month to=Qtr;
convert WAGE / observed=average;
id date;
run;

proc print data=wageq1;run;


proc sgplot data=wageq1;
scatter x=date y=WAGE;
run;
quit;


Proc Autoreg data=wageq1;
model WAGE= / stationarity =(ERS);
run;



*======================================;
*Take first difference of Quarterly CPI;
*======================================;
data wageqd1;    /*dataqd q go first because we convert into quartly at first, then take difference d; */

set wageq1;
WAGEqd= dif1(WAGE);
run;

proc print data=wageqd1;run;


proc sgplot data=wageqd1;
scatter x=date y=WAGEqd;
run;
quit;


Proc Autoreg data=wageqd1;
model WAGEqd= / stationarity =(ERS);
run;
