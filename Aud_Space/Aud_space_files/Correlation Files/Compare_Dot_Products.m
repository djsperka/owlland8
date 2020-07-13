function Compare_Dot_Products()
% Quick custom script to compare the dot products measured during static
% and looming conditions on my OLD dataset, before I started doing my
% competition paradigm

tempcd=cd;
cd ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Interloom')
[filenames,path]=uigetfile('multiselect','on');
cd(tempcd);

if ~iscell(filenames)
    tempcell{1}=filenames;
    filenames=tempcell;
end

sitenames=cell(size(filenames));
sitechans=nan(size(filenames));

dps_pop=[];
dpl_pop=[];

for i=1:length(filenames)
    site=open(strcat(path,filenames{i}));
    
    sitenames{i}=sprintf('%s :: %s',site.site_date,site.site_id);
    
    unit_tag=double(site.id_su);
    unit_tag(site.id_layer~=3)=0;
    unit_tag(site.data_resp_by_eye~=1)=0;
    sitechans(i)=sum(unit_tag);
    
    uppert_mat=logical(ones(length(site.id_su)));
    uppert_mat=~tril(uppert_mat);
    pair_tag_mat=unit_tag*unit_tag';
    pair_tag=logical(pair_tag_mat(uppert_mat));
    sitepairs(i)=sum(pair_tag);
    
    dps_pop=[dps_pop;site.data_dp_stat(pair_tag)];
    dpl_pop=[dpl_pop;site.data_dp_loom(pair_tag)];
    
end

[~,ttp]=ttest(dps_pop,dpl_pop);
dpsp_mean=mean(dps_pop);
dplp_mean=mean(dpl_pop);

figure 
plot (dps_pop,dpl_pop,'o')
hold on
plot (dpsp_mean,dplp_mean,'xr','MarkerSize',15,'linewidth',5)
plot ([-1,1],[-1,1],':k','linewidth',3)

title ('Static vs Looming Dot Product')
xlabel ('Static Dot Product (unitless)')
ylabel ('Looming Dot Product (unitless)')

legtxt{1}=sprintf('Pairwise DP :: n=%.0f',length(dps_pop));
legtxt{2}=sprintf('Population Average: [%.3f , %.3f] \np(stat==loom)=%.4f',dpsp_mean,dplp_mean,ttp);
legend (legtxt)

fprintf('\n\n------------- POPULATION INFO ------------------')
fprintf('\nNumber of sites = %.0f',length(filenames))
for i=1:length(filenames)
    fprintf('\nSite: %s   Number of Channels: %.0f   Number of Pairs: %.0f',filenames{i},sitechans(i),sitepairs(i))
end
fprintf('\n')
