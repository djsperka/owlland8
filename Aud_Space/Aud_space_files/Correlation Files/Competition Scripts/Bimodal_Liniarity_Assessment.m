function Bimodal_Liniarity_Assessment(resp,mt_labels)
% open site
% find Vweak in, Aud in, Vweak out, Aud out and bimodal conditions
% add together VwI and AI, plot scatter, plot mean, do ttesst, regress
% dbstack
% keyboard

%compare "in" responses
av_sum=resp(:,1)+resp(:,3);
x1=av_sum;
y1=resp(:,5);
figure
hold on
plot (x1,y1,'o');
plot (mean(x1),mean(y1),'r+','MarkerSize',15);
[pfit1]=polyfit(x1,y1,1);
[rho1,corr_p1]=corr(x1,y1);
[ttest_h1,ttest_p1]=ttest(x1,y1);
plot ([min(x1),max(x1)],[min(x1),1;max(x1),1]*[pfit1(1);pfit1(2)],':')
plot ([min(x1),max(x1)],[min(x1),max(x1)],'--k')

xlabel ('Resp(Vis) + Resp(Aud)')
ylabel ('Resp(Vis+Aud)')
title (sprintf('Do Aud and Vis Responses Sum Linearly (on Average)? for %s',mt_labels{5}))
leg{1}=sprintf('Unit Responses ... %.0f Units',length(x1));
leg{2}=sprintf('Mean: (%.2f , %.2f)\np[sum(resp)==resp(sum)]=%.4f',mean(x1),mean(y1),ttest_p1);
leg{3}=sprintf('y=%.2f + %.2f*x\nrho=%.2f',pfit1(2),pfit1(1),rho1);
leg{4}='x=y';
legend(leg)
hold off

%compare Ain-Vout to (Ain+Vout) - (Vin+Aout)
x2=resp(:,3)-resp(:,1);
y2=resp(:,7)-resp(:,6);
figure
hold on
plot (x2,y2,'o');
plot (mean(x2),mean(y2),'r+','MarkerSize',15);
[pfit2]=polyfit(x2,y2,1);
[rho2,corr_p2]=corr(x2,y2);
[ttest_h2,ttest_p2]=ttest(x2,y2);
plot ([min(x2),max(x2)],[min(x2),1;max(x2),1]*[pfit2(1);pfit2(2)],':')
plot ([min(x2),max(x2)],[min(x2),max(x2)],'--k')

xlabel (sprintf('%s - %s',mt_labels{3},mt_labels{1}))
ylabel (sprintf('%s - %s',mt_labels{7},mt_labels{6}))
title (sprintf('Do Averaged Aud and Vis Responses Predict Competitive Responses?'))
leg{1}=sprintf('Unit Responses ... %.0f Units',length(x2));
leg{2}=sprintf('Mean: (%.2f , %.2f)\np[sum(resp)==resp(sum)]=%.4f',mean(x2),mean(y2),ttest_p2);
leg{3}=sprintf('y=%.2f + %.2f*x\nrho=%.2f',pfit2(2),pfit2(1),rho2);
leg{4}='x=y';
legend(leg)
hold off