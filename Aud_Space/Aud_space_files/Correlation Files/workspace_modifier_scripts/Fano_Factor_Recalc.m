function Fano_Factor_Recalc()

tempcd=cd;
cd('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition')
[filenames,pathname]=uigetfile('multiselect','on');
cd(tempcd)
for i=1:length(filenames)
    %open the site
    currpath=strcat(pathname,filenames{i});
    fprintf ('\nNow processing %s\n',filenames{i})
    site=open (currpath);
    [nU,~]=size(site.data_fano); 
    [~,nCond]=size(site.id_mt_data.post_cell{1});
    ff=nan(nU,nCond);
    for j=1:nU
        unit_resp=site.id_mt_data.post_cell{j};
        ff(j,:)=(std(unit_resp)).^2 ./mean(unit_resp);        
    end
    
    site.data_fano=ff;
    
    
    save (currpath,'-struct','site')
end
