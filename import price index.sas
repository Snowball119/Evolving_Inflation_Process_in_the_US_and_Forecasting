*=======================;
*Import price index Data;
*=======================;





*=======================;
*Read and transform data;
*=======================;

proc import datafile="D:\001UNC Charlotte\2017Spring\ECON6218\capstone\data\International\Import Price Index-monthly.xls"
            DBMS=EXCELCS
			out     =ir1 replace;
            sheet   =sheet1;
            range   ="A11:B426";
            

run;

proc sort data=ir1; by date; run;
proc print data=ir1;run;


proc sgplot data=ir1;
scatter x=date y=IR;
run;
quit;


*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*:Convert Frequency first then take difference
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;


*======================================;
*Convert Monthly Series to a Quarterly;
*======================================;
proc sort data=ir1;by date;run;

proc expand data=ir1 out=irq1 from=month to=Qtr;
convert IR / observed=average;
id date;
run;

proc print data=irq1;run;


proc sgplot data=irq1;
scatter x=date y=IR;
run;
quit;


Proc Autoreg data=irq1;
model IR= / stationarity =(ERS);
run;



*======================================;
*Take first difference of Quarterly CPI;
*======================================;
data irqd1;    /*dataqd q go first because we convert into quartly at first, then take difference d; */

set irq1;
IRqd= dif1(IR);
run;

proc print data=irqd1;run;


proc sgplot data=irqd1;
scatter x=date y=IRqd;
run;
quit;


Proc Autoreg data=irqd1;
model IRqd= / stationarity =(ERS);
run;
