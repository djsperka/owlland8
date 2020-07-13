%% concatinate
pop_vis_nc=[];
pop_vis_resp=[];
for i=1:length(mt_nc)
    pop_vis_nc=[pop_vis_nc;mt_nc{i}(:,1:6)];
    pop_vis_resp=[pop_vis_resp;mt_resp{i}(:,1:6)];
end

%% grab out the aud in, aud out, Vw.ixA.i, Vw.oxA.i, Vw.i,A.o, Vw.oxA.o pairs
aud1=[7,9,10,12,11,13];
aud2=[7,9,10,12,11,13];
aud3=[7,8,9,11,10,12];
pop_aud_resp=mt_resp{1}(:,aud1); %note: no Vw.oxA.i, only A.s
pop_aud_nc=mt_nc{1}(:,aud1);
pop_aud_resp=[pop_aud_resp; mt_resp{2}(:,aud2)];
pop_aud_nc=[pop_aud_nc; mt_nc{2}(:,aud2)];
pop_aud_resp=[pop_aud_resp;mt_resp{3}(:,aud3)];
pop_aud_nc=[pop_aud_nc;mt_nc{3}(:,aud3)];


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
combined_resp=[pop_vis_resp,pop_aud_resp];
combined_nc=[pop_vis_nc,pop_aud_nc];
for i=1:size(pop_vis_resp,1)
    combined_resp(i,:)=combined_resp(i,:)/pop_vis_resp(i,1);
end

%% plot combined response and NC
plot_resp=[mean(combined_resp)',zeros(size(combined_resp,2),1)];
plot_nc=[zeros(size(combined_nc,2),1),mean(combined_nc)'];

figure
[ax,h1,h2]=plotyy(1:12,plot_resp,1:12,plot_nc,'bar','bar');
set(ax(1),'ylim',[-.5,3]);
nc_yax=get (ax(2),'ylim');
nc_min=nc_yax(1)/nc_yax(2);
resp_yax=get(ax(1),'ylim');
resp_min=resp_yax(1)/resp_yax(2);
comp_mins=min(nc_min,resp_min);
set (ax(1),'ylim',[comp_mins*resp_yax(2),resp_yax(2)]);
set (ax(2),'ylim',[comp_mins*nc_yax(2),nc_yax(2)]);
set (ax(1), 'XTickLabel',mt_labels{1}([1:6,aud1]));
set (ax(2), 'XTickLabel','');

%% plot response
figure 
bar(1:12,mean(combined_resp)');
hold on
resp_eb=std(combined_resp);
h=errorbar(mean(combined_resp)',resp_eb,'r');
set (h(1),'linestyle','none');
set (gca, 'XTickLabel',mt_labels{1}([1:6,aud1]));
hold off

%% plot NC
figure 
bar(1:12,mean(combined_nc)');
hold on
nc_eb=std(combined_nc);
h=errorbar(mean(combined_nc)',nc_eb,'r');
set (h(1),'linestyle','none');
set (gca, 'XTickLabel',mt_labels{1}([1:6,aud1]));
hold off

