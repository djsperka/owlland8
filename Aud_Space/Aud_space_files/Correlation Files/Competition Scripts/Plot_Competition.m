
function Plot_Competition (mt_nc,mt_resp,mt_labels)

pop_vis_nc=[];
pop_vis_resp=[];
% for i=1:length(mt_nc)
    pop_vis_nc=[pop_vis_nc;mt_nc(:,1:6)];
    pop_vis_resp=[pop_vis_resp;mt_resp(:,1:6)];
% end

%% grab the aud in, aud out, Vw.ixA.i, Vw.oxA.i, Vw.i,A.o, Vw.oxA.o pairs
pop_aud_resp=mt_resp(:,7:13); %note: no Vw.oxA.i, only A.s
pop_aud_nc=mt_nc(:,7:13);
% pop_aud_resp=[pop_aud_resp; mt_resp{2}(:,aud2)];
% pop_aud_nc=[pop_aud_nc; mt_nc{2}(:,aud2)];
% pop_aud_resp=[pop_aud_resp;mt_resp{3}(:,aud3)];
% pop_aud_nc=[pop_aud_nc;mt_nc{3}(:,aud3)];


%% remove NaNs
for i=size(pop_vis_nc,1):-1:1
    if isnan(pop_vis_nc(i,1))
        pop_vis_nc(i,:)=[];
        pop_aud_nc(i,:)=[];
    end
end

for i=size(pop_vis_resp):-1:1
    if isnan(pop_vis_resp(i,1))
        pop_vis_resp(i,:)=[];
        pop_aud_resp(i,:)=[];
    end
end

%% normalize to V-weak in
% combined_resp=[pop_vis_resp,pop_aud_resp];
% combined_nc=[pop_vis_nc,pop_aud_nc];
for i=1:size(pop_vis_resp,1)
    temp_vis_resp(i,:)=pop_vis_resp(i,:)/pop_vis_resp(i,1);
end

%% plot visual response and NC
plot_vis_resp=[mean(temp_vis_resp)',zeros(size(temp_vis_resp,2),1)];
plot_vis_nc=[zeros(size(pop_vis_nc,2),1),mean(pop_vis_nc)'];

%% salience figure
figure
[ax,h1,h2]=plotyy(1:6,plot_vis_resp(1:6,:),1:6,plot_vis_nc(1:6,:),'bar','bar');
% set(ax(1),'ylim',[-.5,1.5]);
nc_yax=get (ax(2),'ylim');
nc_min=nc_yax(1)/nc_yax(2);
resp_yax=get(ax(1),'ylim');
resp_min=resp_yax(1)/resp_yax(2);
comp_mins=min(nc_min,resp_min);
set (ax(1),'ylim',[comp_mins*resp_yax(2),resp_yax(2)]);
set (ax(2),'ylim',[comp_mins*nc_yax(2),nc_yax(2)]);
set (ax(1), 'XTickLabel',mt_labels(1:6));
set (ax(2), 'XTickLabel','');

%% bimodal figure
plot_bim=0;
if plot_bim
    %add the vis stim to the beginning
    pop_aud_resp=[pop_vis_resp(:,1),pop_aud_resp];
    pop_aud_nc=[pop_vis_nc(:,1),pop_aud_nc];
    %normalize to vweak in
    for i=1:size(pop_aud_resp,1)
        pop_aud_resp(i,:)=pop_aud_resp(i,:)/pop_aud_resp(i,1);
    end
end

%% plot auditory response and NC
plot_aud=0;
if plot_aud
    plot_aud_resp=[mean(pop_aud_resp)',zeros(size(pop_aud_resp,2),1)];
    plot_aud_nc=[zeros(size(pop_aud_nc,2),1),mean(pop_aud_nc)'];
    
    figure
    [ax,h1,h2]=plotyy(1:length(plot_aud_resp),plot_aud_resp(1:end,:),1:length(plot_aud_resp),plot_aud_nc(1:end,:),'bar','bar');
    set(ax(1),'ylim',[-.5,3]);
    nc_yax=get (ax(2),'ylim');
    nc_min=nc_yax(1)/nc_yax(2);
    resp_yax=get(ax(1),'ylim');
    resp_min=resp_yax(1)/resp_yax(2);
    comp_mins=min(nc_min,resp_min);
    set (ax(1),'ylim',[comp_mins*resp_yax(2),resp_yax(2)]);
    set (ax(2),'ylim',[comp_mins*nc_yax(2),nc_yax(2)]);
    set (ax(1), 'XTickLabel',[mt_labels{2}(1),mt_labels{2}(aud2)]);
    set (ax(2), 'XTickLabel','');
end

% %% plot response
% figure 
% bar(1:12,mean(combined_resp)');
% hold on
% resp_eb=std(combined_resp);
% h=errorbar(mean(combined_resp)',resp_eb,'r');
% set (h(1),'linestyle','none');
% set (gca, 'XTickLabel',mt_labels{1}([1:6,aud1]));
% hold off
% 
% %% plot NC
% figure 
% bar(1:12,mean(combined_nc)');
% hold on
% nc_eb=std(combined_nc);
% h=errorbar(mean(combined_nc)',nc_eb,'r');
% set (h(1),'linestyle','none');
% set (gca, 'XTickLabel',mt_labels{1}([1:6,aud1]));
% hold off

