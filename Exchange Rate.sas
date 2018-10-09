*=======================;
*Exchange Rate Data;
*=======================;





*=======================;
*Read and transform data;
*=======================;

proc import datafile="D:\001UNC Charlotte\2017Spring\ECON6218\capstone\data\International\Exchange Rate-Monthly.xls"
            DBMS=EXCELCS
			out     =exr1 replace;
            sheet   =sheet1;
            range   ="A11:B543";
            

run;

proc sort data=uexr1; by date; run;
proc print data=exr1;run;


proc sgplot data=exr1;
scatter x=date y=EX;
run;
quit;


*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*:Convert Frequency first then take difference
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;


*======================================;
*Convert Monthly Series to a Quarterly;
*======================================;
proc sort data=exr1;by date;run;

proc expand data=exr1 out=exrq1 from=month to=Qtr;
convert EX / observed=average;
id date;
run;

proc print data=exrq1;run;


proc sgplot data=exrq1;
scatter x=date y=EX;
run;
quit;


Proc Autoreg data=exrq1;
model EX= / stationarity =(ERS);
run;



*======================================;
*Take first difference of Quarterly CPI;
*======================================;
data exrqd1;    /*dataqd q go first because we convert into quartly at first, then take difference d; */

set exrq1;
EXqd= dif1(EX);
run;

proc print data=exrqd1;run;


proc sgplot data=exrqd1;
scatter x=date y=EXqd;
run;
quit;


Proc Autoreg data=exrqd1;
model EXqd= / stationarity =(ERS);
run;
