%% concatinate
pop_nc_prism=[];
pop_resp_prism=[];

%% grab out the aud in, aud out, Vw.ixA.i, Vw.oxA.i, Vw.i,A.o, Vw.oxA.o pairs
aud1=[7,8,9];
aud2=[7,8,9];
pop_resp_prism=mt_resp{1}(:,aud1); %note: no Vw.oxA.i, only A.s
pop_nc_prism=mt_nc{1}(:,aud1);
pop_resp_prism=[pop_resp_prism; mt_resp{2}(:,aud2)];
pop_nc_prism=[pop_nc_prism; mt_nc{2}(:,aud2)];

aud3=[7,8];
pop_resp_norm=mt_resp{3}(:,aud3);
pop_nc_norm=mt_nc{3}(:,aud3);

%% remove NaNs - prism
for i=size(pop_nc_prism,1):-1:1
    if isnan(pop_nc_prism(i,1))
        pop_nc_prism(i,:)=[];
    end
end

for i=size(pop_resp_prism):-1:1
    if isnan(pop_resp_prism(i,1))
        pop_resp_prism(i,:)=[];
    end
end

%% remove NaNs - normal
for i=size (pop_resp_norm,1):-1:1
    if isnan(pop_resp_norm(i,1))
        pop_resp_norm(i,:)=[];
    end
end

for i=size (pop_nc_norm,1):-1:1
    if isnan (pop_nc_norm(i,1))
        pop_nc_norm(i,:)=[];
    end
end


%% normalize to aud-in
for i=1:size(pop_resp_prism,1)
    pop_resp_prism(i,:)=pop_resp_prism(i,:)/pop_resp_prism(i,1);
end

for i=1:size(pop_resp_norm,1)
    pop_resp_norm(i,:)=pop_resp_norm(i,:)/pop_resp_norm(i,1);
end

%% plot resp and NC together
plot_resp=[mean(pop_resp_prism)',zeros(size(pop_resp_prism,2),1)];
plot_resp=[plot_resp;[0,0]];
plot_resp=[plot_resp;[mean(pop_resp_norm)',zeros(size(pop_resp_norm,2),1)]];
plot_nc=[zeros(size(pop_nc_prism,2),1),mean(pop_nc_prism)'];
plot_nc=[plot_nc;[0,0]];
plot_nc=[plot_nc;[zeros(size(pop_nc_norm,2),1),mean(pop_nc_norm)']];

figure
[ax,h1,h2]=plotyy(1:6,plot_resp,1:6,plot_nc,'bar','bar');
set(ax(1),'ylim',[-.2,1.2]);
nc_yax=get (ax(2),'ylim');
nc_min=nc_yax(1)/nc_yax(2);
resp_yax=get(ax(1),'ylim');
resp_min=resp_yax(1)/resp_yax(2);
comp_mins=min(nc_min,resp_min);
set (ax(1),'ylim',[comp_mins*resp_yax(2),resp_yax(2)]);
set (ax(2),'ylim',[comp_mins*nc_yax(2),nc_yax(2)]);
set (ax(1), 'XTickLabel',[mt_labels{1}(aud1),'--',mt_labels{3}(aud3)]);
set (ax(2), 'XTickLabel',[]);

%% plot resp and NC seperately
% figure 
% bar(1:3,mean(pop_resp_prism)');
% hold on
% resp_eb=std(pop_resp_prism);
% h=errorbar(mean(pop_resp_prism)',resp_eb,'r');
% set (h(1),'linestyle','none');
% set (gca, 'XTickLabel',mt_labels{1}(aud1));
% hold off
% 
% figure 
% bar(1:3,mean(pop_nc_prism)');
% hold on
% nc_eb=std(pop_nc_prism);
% h=errorbar(mean(pop_nc_prism)',nc_eb,'r');
% set (h(1),'linestyle','none');
% set (gca, 'XTickLabel',mt_labels{1}(aud1));
% hold off

