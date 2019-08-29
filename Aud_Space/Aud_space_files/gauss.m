function y=gauss(params, x)

myu=params(1);
sigma=params(2);
a=params(3);
c=params(4);

y= a*exp(-((x-myu).^2/(2*sigma^2))) + c;
%y=y/(sigma*sqrt(2*pi));
% plot(x,y);

