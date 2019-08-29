function y=sig(params, x)

myu=params(1);
sigma=params(2);

y= 1./(1+exp((myu-x)/sigma));


