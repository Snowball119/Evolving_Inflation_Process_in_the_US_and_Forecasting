*=======================;
*UR Data;
*=======================;





*=======================;
*Read and transform data;
*=======================;

proc import datafile="D:\001UNC Charlotte\2017Spring\ECON6218\capstone\data\UR-Civilian-Monthly.xls"
            DBMS=EXCELCS
			out     =ur1 replace;
            sheet   =sheet1;
            range   ="A11:B840";
            

run;

proc sort data=ur1; by date; run;
proc print data=ur1;run;


proc sgplot data=ur1;
scatter x=date y=UNRATE;
run;
quit;


*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*:Convert Frequency first then take difference
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;


*======================================;
*Convert Monthly Series to a Quarterly;
*======================================;
proc sort data=ur1;by date;run;

proc expand data=ur1 out=urq1 from=month to=Qtr;
convert UNRATE / observed=average;
id date;
run;

proc print data=urq1;run;


proc sgplot data=urq1;
scatter x=date y=UNRATE;
run;
quit;


Proc Autoreg data=urq1;
model UNRATE= / stationarity =(ERS);
run;



*======================================;
*Take first difference of Quarterly CPI;
*======================================;
data urqd1;    /*dataqd q go first because we convert into quartly at first, then take difference d; */

set urq1;
UNRATEqd= dif1(UNRATE);
run;

proc print data=urqd1;run;


proc sgplot data=urqd1;
scatter x=date y=UNRATEqd;
run;
quit;


Proc Autoreg data=urqd1;
model UNRATEqd= / stationarity =(ERS);
run;
