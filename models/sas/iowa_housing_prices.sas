
data test;
set work.housing_test;
where Neighborhood = 'NAmes'
or Neighborhood = 'Edwards'
or Neighborhood = 'BrkSide';
SalePrice = .;
select(Neighborhood);
	when('NAmes') do;
		NAmes = 1;
		Edwards = 0;
		BrkSide = 0;
	end;
	when('Edwards') do;
		NAmes = 0;
		Edwards = 1;
		BrkSide = 0;
	end;
	when('BrkSide') do;
		NAmes = 0;
		Edwards = 0;
		BrkSide = 1;
	end;
end;
run;

*split and filter the data;

data train;
set work.housing_train;
where Neighborhood = 'NAmes'
or Neighborhood = 'Edwards'
or Neighborhood = 'BrkSide';
log_SalePrice = log(SalePrice);
log_GrLivArea = log(GrLivArea);
select(Neighborhood);
	when('NAmes') do;
		NAmes = 1;
		Edwards = 0;
		BrkSide = 0;
	end;
	when('Edwards') do;
		NAmes = 0;
		Edwards = 1;
		BrkSide = 0;
	end;
	when('BrkSide') do;
		NAmes = 0;
		Edwards = 0;
		BrkSide = 1;
	end;
end;
run;

*TODO: Plot Log;
*This shows most of plots we want;
*TODO: scatters by neighborhood;
proc univariate data=train robustscale plot;
class Neighborhood;
var SalePrice;
run;


proc sgpanel data=train;
panelby Neighborhood;
scatter x = GrLivArea y=SalePrice;
title 'Sale Price vs GrLivArea By Neighborhood';
run;

proc contents data=train;
run;
proc contents data=test;
run;


proc glm data = train plots=all;
class Neighborhood (REF="Edwards");
model log_SalePrice = Neighborhood | log_GrLivArea / cli solution ;
output out = results p = Predict;
run;

data results2;
set results;
if Predict > 0 then SalePrice = Predict;
if Predict < 0 then SalePrice = 10000; *dummy for now*;
keep id SalePrice;
where id > 1460;
run;

proc means data = results2;
var SalePrice;
run;