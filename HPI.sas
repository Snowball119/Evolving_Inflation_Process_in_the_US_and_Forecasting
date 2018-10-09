*=======================;
*House price index Data;
*=======================;





*=======================;
*Read and transform data;
*=======================;

proc import datafile="D:\001UNC Charlotte\2017Spring\ECON6218\capstone\data\House\Home Price index-Monthly.xls"
            DBMS=EXCELCS
			out     =hpi1 replace;
            sheet   =sheet1;
            range   ="A11:B516";
            

run;

proc sort data=hpi1; by date; run;
proc print data=hpi1;run;


proc sgplot data=hpi1;
scatter x=date y=HPI;
run;
quit;


*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*:Convert Frequency first then take difference
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;


*======================================;
*Convert Monthly Series to a Quarterly;
*======================================;
proc sort data=hpi1;by date;run;

proc expand data=hpi1 out=hpiq1 from=month to=Qtr;
convert HPI / observed=average;
id date;
run;

proc print data=hpiq1;run;


proc sgplot data=hpiq1;
scatter x=date y=HPI;
run;
quit;


Proc Autoreg data=hpiq1;
model HPI= / stationarity =(ERS);
run;


*======================================;
*Take first difference of Quarterly CPI;
*======================================;
data hpiqd1;    /*dataqd q go first because we convert into quartly at first, then take difference d; */

set hpiq1;
HPIqd= dif1(HPI);
run;


proc print data=hpiqd1;run;


proc sgplot data=hpiqd1;
scatter x=date y=HPIqd;
run;
quit;


Proc Autoreg data=hpiqd1;
model HPIqd= / stationarity =(ERS);
run;
