
function [h1,h2]=Plot_Corr (var1,var2,mt_labels,type)
% This is the updated version of Plot_Competition DJT 9/30/2014

xax_label{1}='';
xax_label(2:1+length(mt_labels))=mt_labels;
xax_label{end+1}='';

%% remove NaNs
for i=size(var1,1):-1:1
    if isnan(var1(i,1))
        var1(i,:)=[];
    end
end

for i=size(var2):-1:1
    if isnan(var2(i,1))
        var2(i,:)=[];
    end
end

var1=var1 ./ (var1(:,1)*ones(1,size(var1,2)));
var1_mean=mean(var1,1);
v1_scat_x=ones(size(var1,1),1) * (1:size(var1,2));
var1_std=std(var1,1);
v1_std_plot_y=[var1_mean-var1_std;var1_mean+var1_std];
v1_std_plot_x=ones(2,1)*[1:size(var1,2)];

h1=figure;
hold on;
bar(var1_mean);
plot (v1_scat_x',var1',':*r')
% plot (v1_std_plot_x,v1_std_plot_y,'g','linewidth',1.5)
t1=strcat(type,' Experiment:  Stimulus Response');
t2=sprintf(' :: # SUs = %.0f',size(var1,1));

title (strcat(t1,t2))
set (gca,'XTickLabel',xax_label)
xlabel('Stimulus Condition')
ylabel('Responses re. weak stim in RF')
hold off;

% var2=var2 ./ (var2(:,1)*ones(1,size(var2,2)));
var2_mean=mean(var2,1);
v2_scat_x=ones(size(var2,1),1)*(1:size(var2,2));
var2_std=std(var2,1);
v2_std_plot_y=[var2_mean-var1_std;var2_mean+var2_std];
v2_std_plot_x=ones(2,1)*[1:size(var2,2)];

h2=figure;
hold on;
bar(var2_mean);
plot (v2_scat_x',var2',':*r')
% plot (v2_std_plot_x,v2_std_plot_y,'g','linewidth',1.5)
t3=strcat(type,' Experiment: Response Covariance');
t4=sprintf(' :: # Pairs = %.0f',size(var2,1));
title (strcat(t3,t4))
set (gca,'XTickLabel',xax_label)
xlabel('Stimulus Condition')
ylabel('Correlation (r)')
hold off;


%% normalize to V-weak in
% % combined_resp=[pop_vis_resp,pop_aud_resp];
% % combined_nc=[pop_vis_nc,pop_aud_nc];
% for i=1:size(var2,1)
%     temp_vis_resp(i,:)=var2(i,:)/var2(i,1);
% end

%% plot visual response and NC
% plot_vis_resp=[mean(temp_vis_resp)',zeros(size(temp_vis_resp,2),1)];
% plot_vis_nc=[zeros(size(var1,2),1),mean(var1)'];
% 
% %% salience figure
% figure
% [ax,h1,h2]=plotyy(1:6,plot_vis_resp(1:6,:),1:6,plot_vis_nc(1:6,:),'bar','bar');
% % set(ax(1),'ylim',[-.5,1.5]);
% nc_yax=get (ax(2),'ylim');
% nc_min=nc_yax(1)/nc_yax(2);
% resp_yax=get(ax(1),'ylim');
% resp_min=resp_yax(1)/resp_yax(2);
% comp_mins=min(nc_min,resp_min);
% set (ax(1),'ylim',[comp_mins*resp_yax(2),resp_yax(2)]);
% set (ax(2),'ylim',[comp_mins*nc_yax(2),nc_yax(2)]);
% set (ax(1), 'XTickLabel',mt_labels(1:6));
% set (ax(2), 'XTickLabel','');
% 
% %% bimodal figure
% plot_bim=0;
% if plot_bim
%     %add the vis stim to the beginning
%     pop_aud_resp=[var2(:,1),pop_aud_resp];
%     pop_aud_nc=[var1(:,1),pop_aud_nc];
%     %normalize to vweak in
%     for i=1:size(pop_aud_resp,1)
%         pop_aud_resp(i,:)=pop_aud_resp(i,:)/pop_aud_resp(i,1);
%     end
% end
% 
% %% plot auditory response and NC
% plot_aud=0;
% if plot_aud
%     plot_aud_resp=[mean(pop_aud_resp)',zeros(size(pop_aud_resp,2),1)];
%     plot_aud_nc=[zeros(size(pop_aud_nc,2),1),mean(pop_aud_nc)'];
%     
%     figure
%     [ax,h1,h2]=plotyy(1:length(plot_aud_resp),plot_aud_resp(1:end,:),1:length(plot_aud_resp),plot_aud_nc(1:end,:),'bar','bar');
%     set(ax(1),'ylim',[-.5,3]);
%     nc_yax=get (ax(2),'ylim');
%     nc_min=nc_yax(1)/nc_yax(2);
%     resp_yax=get(ax(1),'ylim');
%     resp_min=resp_yax(1)/resp_yax(2);
%     comp_mins=min(nc_min,resp_min);
%     set (ax(1),'ylim',[comp_mins*resp_yax(2),resp_yax(2)]);
%     set (ax(2),'ylim',[comp_mins*nc_yax(2),nc_yax(2)]);
%     set (ax(1), 'XTickLabel',[mt_labels{2}(1),mt_labels{2}(aud2)]);
%     set (ax(2), 'XTickLabel','');
% end
% 
% % %% plot response
% % figure 
% % bar(1:12,mean(combined_resp)');
% % hold on
% % resp_eb=std(combined_resp);
% % h=errorbar(mean(combined_resp)',resp_eb,'r');
% % set (h(1),'linestyle','none');
% % set (gca, 'XTickLabel',mt_labels{1}([1:6,aud1]));
% % hold off
% % 
% % %% plot NC
% % figure 
% % bar(1:12,mean(combined_nc)');
% % hold on
% % nc_eb=std(combined_nc);
% % h=errorbar(mean(combined_nc)',nc_eb,'r');
% % set (h(1),'linestyle','none');
% % set (gca, 'XTickLabel',mt_labels{1}([1:6,aud1]));
% % hold off

