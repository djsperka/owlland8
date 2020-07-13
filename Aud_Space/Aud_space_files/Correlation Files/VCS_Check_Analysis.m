function VCS_Check_Analysis(pbvar,pbcov,synth_var,synth_cov)

%%% Estimate Source Values
% Unpack variables
pop_aud_var=pbvar.aud;
pop_vis_var=pbvar.vis;
pop_bim_var=pbvar.bim;
pop_sum_var=pbvar.sum;

pop_aud_cov=pbcov.aud;
pop_vis_cov=pbcov.vis;
pop_bim_cov=pbcov.bim;
pop_sum_cov=pbcov.sum;
source_indx=pbcov.si;

% Calculate Variance by Source
est_var_int=pop_sum_var-pop_bim_var;
est_var_ap=pop_aud_var-est_var_int;
est_var_vp=pop_vis_var-est_var_int;

% Calculate Covariance by sourec
est_cov_int=pop_sum_cov-pop_bim_cov;
est_cov_ap=pop_aud_cov-est_cov_int;
est_cov_vp=pop_vis_cov-est_cov_int;

% %%% Unpack Values
% synth_aud_var=synth_var.aud;
% synth_vis_var=synth_var.vis;
% synth_bim_var=synth_var.bim;
% synth_sum_var=synth_var.sum;
% 
% synth_aud_cov=synth_cov.aud;
% synth_vis_cov=synth_cov.vis;
% synth_bim_cov=synth_cov.bim;
% synth_sum_cov=synth_cov.sum;

%%% Compare variances
true_var_ap=synth_var.var_ap;
true_var_ai=synth_var.var_ai;
true_var_vp=synth_var.var_vp;
true_var_vi=synth_var.var_vi;

true_var_bap=synth_var.var_bap;
true_var_bvp=synth_var.var_bvp;
true_var_bi=synth_var.var_bi;

dbstack
keyboard

x=est_var_ap';
y=true_var_bap;
logger=0;
dotsize=10;
regression_width=2;
legtxt=Plot_XvsY_thisfun(x,y,logger,dotsize,regression_width);
title ('Aud Variance')
xlabel('Est Var(Aud)')
ylabel('Actual Var(Bim Aud)')
legend (legtxt)

x=est_var_vp';
y=true_var_bvp;
logger=0;
dotsize=10;
regression_width=2;
legtxt=Plot_XvsY_thisfun(x,y,logger,dotsize,regression_width);
title ('Vis Variance')
xlabel('Est Var(Vis)')
ylabel('Actual Var(Bim Vis)')
legend (legtxt)

x=est_var_int';
y=true_var_bi;
logger=0;
dotsize=10;
regression_width=2;
legtxt=Plot_XvsY_thisfun(x,y,logger,dotsize,regression_width);
title ('Internal Variance')
xlabel('Est Var(Int)')
ylabel('Actual Var(Bim Int)')
legend (legtxt)

%%% Compare covariances
true_cov_ap=synth_cov.cov_ap;
true_cov_ai=synth_cov.cov_ai;
true_cov_vp=synth_cov.cov_vp;
true_cov_vi=synth_cov.cov_vi;

true_cov_bap=synth_cov.cov_bap;
true_cov_bvp=synth_cov.cov_bvp;
true_cov_bi=synth_cov.cov_bi;

x=est_cov_ap';
y=true_cov_bap;
logger=0;
dotsize=10;
regression_width=2;
legtxt=Plot_XvsY_thisfun(x,y,logger,dotsize,regression_width);
title ('Aud Covariance')
xlabel('Est Cov(Aud)')
ylabel('Actual Cov(Bim Aud)')
legend (legtxt)

x=est_cov_vp';
y=true_cov_bvp;
logger=0;
dotsize=10;
regression_width=2;
legtxt=Plot_XvsY_thisfun(x,y,logger,dotsize,regression_width);
title ('Vis Covariance')
xlabel('Est Cov(Vis)')
ylabel('Actual Cov(Bim Vis)')
legend (legtxt)

x=est_cov_int';
y=true_cov_bi;
logger=0;
dotsize=10;
regression_width=2;
legtxt=Plot_XvsY_thisfun(x,y,logger,dotsize,regression_width);
title ('Internal Covariance')
xlabel('Est Cov(Int)')
ylabel('Actual Cov(Bim Int)')
legend (legtxt)

function legtxt=Plot_XvsY_thisfun (x,y,logger,dotsize,regression_width)

figure
hold on

dropper=isnan(x) | isnan(y);
x(dropper)=[];
y(dropper)=[];

mask1=x>(mean(x)+3*std(x)) | x<(mean(x)-3*std(x)) ;
mask2=y>(mean(y)+3*std(y)) | y<(mean(y)-3*std(y)) ;
outliers=mask1 | mask2;
x(outliers)=[];
y(outliers)=[];

pfits=polyfit(x,y,1);
xminmax= [min(x),max(x)];

[p_mean,test]=Paired_Stats(x,y);

[rho,p_corr]=corr(x,y);
plotfit_x=xminmax(1):.01:xminmax(2);
plotfit_y=[plotfit_x',ones(size(plotfit_x'))]*pfits';

if logger
    %     plot (log2(1+x),log2(1+y),'.','MarkerSize',dotsize,'Color',lincol(1,:))
%     plot (log2(1+mean(x)),log2(1+mean(y)),'d','MarkerSize',10,'LineWidth',2,'Color',lincol(2,:))
%     plot (log2(1+plotfit_x),log2(1+plotfit_y),'--','Color',lincol(2,:),'LineWidth',regression_width)
    plot (log2(1+x),log2(1+y),'ok','MarkerSize',dotsize)
    plot (log2(1+mean(x)),log2(1+mean(y)),'dk','MarkerSize',10,'LineWidth',2)
    plot (log2(1+plotfit_x),log2(1+plotfit_y),'--k','LineWidth',regression_width)
else
    %     plot (x,y,'.','MarkerSize',dotsize,'Color',lincol(1,:))
%     plot (mean(x),mean(y),'d','MarkerSize',10,'LineWidth',2,'Color',lincol(2,:))
%     plot (plotfit_x,plotfit_y,'--','Color',lincol(2,:),'LineWidth',regression_width)
    plot (x,y,'ok','MarkerSize',dotsize)
    plot (mean(x),mean(y),'dk','MarkerSize',10,'LineWidth',2)
    plot (plotfit_x,plotfit_y,'--k','LineWidth',regression_width)
end

legtxt{1}=sprintf('DATA: n=%i',length(x));
legtxt{2}=sprintf('Mean = [%.2f %.2f], p(x==y)=%.2e : %s',mean(x),mean(y),p_mean, test);
legtxt{3}=sprintf('y= %.2f*x + %.2f \n r= %.2f, p=%.4f',pfits(1),pfits(2),rho,p_corr);

function [p_mean,test]=Paired_Stats(x,y)

if jbtest(x) || jbtest(y) %either distribution is not normal
    %do paired non-para test
    [p_mean,~]=signrank(x,y);
    test='SR';
else
    %do paired ttest
    [~,p_mean]=ttest(x,y);
    test='TT';
end
