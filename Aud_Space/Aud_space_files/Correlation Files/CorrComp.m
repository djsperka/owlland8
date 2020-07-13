function p=CorrComp(r1,r2,n1,n2)
%Takes in two correlation r-values, and the number of samples taken to
%calculate those rs, and determines if the r's are significantly different
%Step 1) Convert r-values to z-values using the Fisher z-Transformation
%Step 2) Use a two-sample t-test for samples w/ a variance of 1 and unequal
%sample sizes to generate a test statistic
%Step 3) Convert that test statistic to a p-value

%% Step 1) r-to-z transform
z1=.5*log((1+r1)/(1-r1));
z2=.5*log((1+r2)/(1-r2));

%% Step 2) two-sample t-test
z= (z1-z2) / ( 1/(n1-3) + 1/(n2-3) )^.5;

%% Step 3) Get p-value
p=Pvaluefromz(z);



