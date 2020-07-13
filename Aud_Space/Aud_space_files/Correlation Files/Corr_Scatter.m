function [p,r]=Corr_Scatter(var1,var2,pvals)
global var1_choice var2_choice
%Takes in noise correlation and distance between best tuning and plots it.
%If pvals are also input then will plot red and blue circles around non
%significant and signifant data respectively. 

figure 
plot (var1,var2,'.')

switch var1_choice
    case 1; xax='Noise Correlation (r)';
    case 2; xax='Peak COM Seperation (degrees)';
    case 3; xax='Global COM Seperation (degrees)';
    case 4; xax='Dot Product';
    case 5; xax='Noise Correlation (r)';
    case 6; xax='Noise Correlation (r)';
end

switch var2_choice
    case 1; yax='Noise Correlation (r)';
    case 2; yax='Peak COM Seperation (degrees)';
    case 3; yax='Global COM Seperation (degrees)';
    case 4; yax='Dot Product';
    case 5; yax='Noise Correlation (r)';
    case 6; yax='Noise Correlation (r)';
end        

numbers=~isnan(var2) & ~isnan(var1);
[line,stats]=polyfit(var1(numbers),var2(numbers),1);
x=[min(var1),max(var1)];
y=x*line(1)+line(2);
[r,p]=corr(var1(numbers),var2(numbers));
legend(strcat('r=',num2str(r,3),'   p=',num2str(p,3),' ... y=',num2str(line(1),2),'x+',num2str(line(2),2)))
hold
plot(x,y)

if nargin==3
    sig_tag=find(pvals<.05);
    non_sig=find(pvals>.05);
    
    plot(var1(sig_tag),var2(sig_tag),'bo')
    plot (var1(non_sig),var2(non_sig),'ro')
end

xlabel(xax);
ylabel(yax);

hold off
% figure
% resid=nc-(sep*line(1)+line(2));
% plot(sep,resid,'.');
    

