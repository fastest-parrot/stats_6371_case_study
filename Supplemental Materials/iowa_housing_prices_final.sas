
*This shows most of plots we want;
proc univariate data=working_train  robustscale plot;
var SalePrice; *log_SalePrice;
title 'SalePrice Distribution/Outlier Analysis';
run;

proc univariate data=working_train_q1  robustscale plot;
class Neighborhood;
var SalePrice; *log_SalePrice;
title 'SalePrice Distribution/Outlier Analysis (By Neighborhood)';
run;



proc sgscatter data=outliers;
compare x=GrLivArea y=SalePrice;
run;

proc reg data=working_train_q1 plots(label)=(all);
model SalePrice = GrLivArea NAmes BrkSide Edwards   
			/ influence 
			adjrsq 
			press;
title 'Question 1 Variable Influence';
run;




proc univariate data=working_train robustscale plot;
var GrLivArea;
title 'GrLivArea Distribution/Outlier Analysis';
run;

proc univariate data=working_train_q1 robustscale plot;
class Neighborhood;
var GrLivArea;
title 'GrLivArea Distribution/Outlier Analysis By Neighborhood';
run;


proc sgscatter data=working_train;
compare x=GrLivArea y=SalePrice;
title 'Sale Price vs GrLivArea (Question 2)';
run;
proc sgpanel data=working_train_q1;
panelby Neighborhood / columns=1;
scatter x=GrLivArea y=SalePrice;
title 'Sale Price vs GrLivArea (Question 1)';
run;



*analysis 1 (simple linear regression, no dependence on neighborhood);
proc glm data=working_train_q1 plots=ALL;
model SalePrice = GrLivArea / solution clparm cli;
title 'Linear Regression (no neighborhood)';
run;

*Stepwise Selection;

proc glmselect data=working
				plots=all;
partition roleVar=Source(train='Train' test='Test');
class 
    Neighborhood (REF="NAmes") 
	OverallQual
	OverallCond
	MSZoning;
	
	
model SalePrice = GrLivArea
    |Neighborhood 
	|OverallQual
	|OverallCond
	|MSZoning
	@2
	/ selection=stepwise(choose = cv select=sl)
 	  stats=press 
 	  cvMethod=split(5)
 	  cvDetails=all
 	  hierarchy=single
 	  showpvalues;
 output out = stepwise_results p=Predict;
 title 'Stepwise Selection Results | 2 Interaction Limit 5 fold CV';
 run;

proc glmselect data=working
				plots=all;
partition roleVar=Source(train='Train' test='Test');
class 
    Neighborhood (REF="NAmes") 
	OverallQual
	OverallCond
	MSZoning;
	
model SalePrice = GrLivArea
    |Neighborhood 
	|OverallQual
	|OverallCond
	|MSZoning
	@2
	/ selection=forward(choose = cv)
 	  stats=press 
 	  cvMethod=split(5)
 	  cvDetails=all
 	  hierarchy=single
 	  showpvalues;
 output out = forward_results p=Predict;
 title 'Forward Selection Results | 2 Interaction Limit 5 fold CV';
 run;


proc glmselect data=working
				plots=all;
partition roleVar=Source(train='Train' test='Test');
class 
    Neighborhood (REF="Edwards") 
	OverallQual
	OverallCond
	MSZoning;
	
	
model SalePrice = GrLivArea
    |Neighborhood 
	|OverallQual
	|OverallCond
	|MSZoning
	@2
	/ selection=backward(choose = cv)
 	  stats=press 
 	  cvMethod=split(10)
 	  cvDetails=all
 	  hierarchy=single
 	  showpvalues;
 output out = backward_results p=Predict;
 title 'Backward Selection Results | 2 Interaction Limit 5 fold CV';
 run;


*with interactions;
proc glm data = working_train_q1 plots=all;
class Neighborhood (REF="NAmes");
model SalePrice = Neighborhood | GrLivArea / 
				cli 
				clparm
				solution;
output out = results p = Predict;
run;

*without interactions;
proc glm data = working_train_q1 plots=all;
class Neighborhood (REF="Names");
model SalePrice = Neighborhood  GrLivArea / 
				cli 
				clparm
				solution;
output out = results p = Predict;
run;


data kaggl_results_back;
set backward_results;
if Predict > 0 then SalePrice = Predict;
if Predict < 0 then SalePrice = 0; *dummy for now*;
if Id > 1460 THEN output;
keep id  Predict;

run;

proc export data=kaggl_results_back /* Rename the data= statement to include your Library.Dataset*/
outfile=_dataout 
dbms=csv replace;
run;
%let _DATAOUT_MIME_TYPE=text/csv;
%let _DATAOUT_NAME=kaggl_results_back.csv; /* Be sure to rename the CSV file here*/

proc means data = results2;
var SalePrice;
run;