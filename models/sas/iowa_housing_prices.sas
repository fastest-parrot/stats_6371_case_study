proc print data=work.housing_test;
run;

data test;
set work.housing_test;
SalePrice = .;
run;

data train2;
set work.housing_train work.housing_test;
run;

proc glm data = train2 plots=all;
class RoofStyle Exterior1st Exterior2nd MasVnrType;
model SalePrice = RoofStyle Exterior1st Exterior2nd MasVnrType LotArea BedroomAbvGr YearBuilt / cli solution;
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