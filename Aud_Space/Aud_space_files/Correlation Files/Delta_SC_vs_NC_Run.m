function Delta_SC_vs_NC_Run(dp_stat,dp_loom,nc_stat,nc_loom)
% This funciton is designed to be called by SC_vs_NC_Wrap.m
% It compares how dot products and noise correlations differ when
% presenting static vs looming stimuli

delta_dp=dp_loom-dp_stat;
delta_nc=nc_loom-nc_stat;

dome=~isnan(delta_dp) & ~isnan(delta_nc);
[rho,pval]=corr(delta_dp(dome),delta_nc(dome));

%% Plot change in dot product vs change in noise correlation
figure
plot (delta_dp,delta_nc,'o')
hold on
plot ([-1,1],[-1,1],':r')
legtxt{1}=sprintf('rho=%.2f :: p=%.4f',rho,pval);
legtxt{2}='Unity';
legend(legtxt)
title ('Change in Dot Product vs Change in Noise Correlation')
xlabel('delta DP (loom-stat)')
ylabel('delta NC (loom-stat)')


%% Compare dot product from static with dot product from looming condition
if jbtest(dp_loom) || jbtest(dp_stat)
    p_dp=signrank(dp_loom,dp_stat);
    fprintf('\nUsed non-parametric signrank test on dot-product changes\n')
else
    [~,p_dp]=ttest(dp_loom,dp_stat);
    fprintf('\nUsed ttest on dot-product changes\n')
end
figure
subplot(2,1,1)
hist(delta_dp);
tittxt=sprintf('Change in Dot Product (Loom-Stat) :: n=%.0f :: mean=%.2f std=%.2f :: p(stat==loom)=%.4f',size(dp_loom,1),nanmean(delta_dp),nanstd(delta_dp),p_dp);
title(tittxt)
xlabel ('delta DP (loom-stat)')
ylabel ('count')

subplot (2,1,2)
plot (dp_stat,dp_loom,'o')
hold on
pfits=polyfit(dp_stat,dp_loom,1);
plot ([min(dp_stat),max(dp_stat)],pfits*([min(dp_stat),max(dp_stat);1,1]),'--r')
plot (get(gca,'xlim'),get(gca,'xlim'),':k')
title (sprintf('DP_{Static} vs DP_{Loom} :: n=%.0f',length(dp_stat)))
legtxt{1}='DP_{Static} vs DP_{Loom}';
[rho,pval]=corr(dp_stat,dp_loom);
pfit=polyfit(dp_stat,dp_loom,1);
legtxt{2}=sprintf('rho= %.2f   p=%.4f\ny=%.2f*x+%.2f',rho,pval,pfit(1),pfit(2));
legtxt{3}='Unity Line';
legend(legtxt);

%% Check to see if the noise correlation is changing in this population of cells
if jbtest(nc_loom) || jbtest(nc_stat)
    p_nc=signrank(nc_loom,nc_stat);
    fprintf('\nUsed non-parametric sign-rank test on noise-corr changes\n')
else
    [~,p_nc]=ttest(nc_loom,nc_stat);
    fprintf ('\nUsed ttest on noise-corr changes\n')
end
figure
hist(delta_nc);
tittxt=sprintf('Change in Noise Corr (Loom-Stat) :: n=%.0f :: mean=%.2f std=%.2f :: p(stat==loom)=%.4f',size(delta_nc,1),nanmean(delta_nc),nanstd(delta_nc),p_nc);
title(tittxt)
xlabel ('delta NC (loom-stat)')
ylabel ('count')

