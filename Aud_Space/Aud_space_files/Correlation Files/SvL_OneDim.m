function [title_out,p_disp]=SvL_OneDim(var_stat,var_loom,norm)

num_samp=length(var_stat);
num_samp_txt=num2str(num_samp);
tbox_loc=[.75 .8 .1 .1];

%Compare Means
if norm %if v1 static and loom both normally distributed
    [junk_h,p_SvL,junk_ci,stats_S]=ttest2(var_stat,var_loom); %Perform the students t-test
    [h_disp,p_disp]=vartest2(var_stat,var_loom)
    anal_type='ttest';
else
    [p_SvL,junk_h,stats_v1Sxv1L]=ranksum(var_stat,var_loom); %Perform the students t-test
    [h_disp,p_disp]=ansaribradley(var_stat,var_loom);
    anal_type='ranksum';
end

box_in=[var_stat,var_loom];
figure
boxplot(box_in,'Labels',{'Static','Looming'})
stat_mean=mean(var_stat);
stat_med=median(var_stat);
loom_mean=mean(var_loom);
loom_med=median(var_loom);
annotation ('textbox',[.25 .1 0 0],'String',strcat('Mean=',num2str(stat_mean,3)))
annotation ('textbox',[.25 .05 0 0],'String',strcat('Median=',num2str(stat_med,3)))
annotation ('textbox',[.65 .1 0 0],'String',strcat('Mean=',num2str(loom_mean,3)))
annotation ('textbox',[.65 .05 0 0],'String',strcat('Median=',num2str(loom_med,3)))

%Calculate pair-wise changes
% change_LS_v1=var_loom-var_stat;
% change_mag_LS_v1=abs(change_LS_v1);
% if jbtest(change_LS_v1) || jbtest(change_mag_LS_v1)
%     [p_change_v1,h_change_v1]=ranksum(change_LS_v1,change_mag_LS_v1);
% else
%     [h_change_v1,p_change_v1]=ttest2(change_LS_v1,change_mag_LS_v1);
% end
% change_trend_v1=sum(change_LS_v1) / sum(change_mag_LS_v1);
hold on
plot (box_in','k:'); %this connects the pairs in the boxplot with lines
hold off
%label plot
title_out=strcat(' :: test=',anal_type,' :: n=',num_samp_txt,' :: p-Val=',num2str(p_SvL,3));

% box_text={'Change Direction Metric',strcat('val=',num2str(change_trend_v1,3),' p=',num2str(p_change_v1,3))};
% annotation('textbox',tbox_loc,'String',box_text)

