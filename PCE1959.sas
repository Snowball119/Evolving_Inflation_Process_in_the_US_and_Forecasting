*=======================;
*PCE Data;
*=======================;





*=======================;
*Read and transform data;
*=======================;

proc import datafile="D:\001UNC Charlotte\2017Spring\ECON6218\capstone\data\PCE\PCE.xls"
            DBMS=EXCELCS
			out     =pce1 replace;
            sheet   =sheet1;
            range   ="A11:B709";
            

run;

proc sort data=pce1; by date; run;
proc print data=pce1;run;


proc sgplot data=pce1;
scatter x=date y=PCE;
run;
quit;


*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*:Convert Frequency first then take difference
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;


*======================================;
*Convert Monthly Series to a Quarterly;
*======================================;
proc sort data=pce1;by date;run;

proc expand data=pce1 out=pceq1 from=month to=Qtr;
convert PCE / observed=average;
id date;
run;

proc print data=pceq1;run;


*======================================;
*Take first difference of Quarterly CPI;
*======================================;
data pceqd1;    /*dataqd q go first because we convert into quartly at first, then take difference d; */

set pceq1;
PCEqd= dif1(PCE);
run;

proc print data=pceqd1;run;


proc sgplot data=pceqd1;
scatter x=date y=PCEqd;
run;
quit;


Proc Autoreg data=pceqd1;
model PCEqd= / stationarity =(ERS);
run;

*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;
*:Take difference first then convert frenquency
*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++;

*======================================;
*Take first difference of Monthly CPI;
*======================================;
data pce1;

set pce1;
dPCE= dif1(PCE);
run;

proc print data=pce1;run;


*===============================================================+++++++++++++;
*Convert Monthly difference Series to a Quarterly difference;
*===================================================================++++++++;

proc sort data=pce1;by date;run;

proc expand data=pce1 out=pcedq1 from=month to=Qtr;    
*datadq d go first because we take difference at first, then convert the first difference level data into quartly; 
convert dPCE / observed=average;
id date;
run;

proc print data=pcedq1;run;


proc sgplot data=pcedq1;
scatter x=date y=dPCE;
run;
quit;


proc sgplot data=pce1;
scatter x=date  y=dPCE;
run;


Proc Autoreg data=pce1;
model dPCE= / stationarity =(ERS);  *stationary;
run;

