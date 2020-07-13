function Temp_Prenoise_ReCalc

[filenames,pathname]=uigetfile('multiselect','on');
for i=1:length(filenames)
    %open the site
    currpath=strcat(pathname,filenames{i});
    fprintf ('\nNow processing %s\n',filenames{i})
    site=open (currpath);
    temp=site.id_mt_data.post_cell{:};
    nR=size(temp,1); %number of reps
    [nU,nCond]=size(site.id_mt_data.data_rep);
    pre_cell=cell(1,nU);    
    
    %run through each unit and calculate how many pre-spikes it had in each
    %condition on each rep
    for j=1:nU
        trial_pre=nan(nR,nCond);
        for k=1:nCond
            for l=1:nR
                trial_pre(l,k)=sum(site.id_mt_data.data_rep{j,k}==l & site.id_mt_data.data_time{j,k}<0);
            end
        end     
        pre_cell{j}=trial_pre;
    end
    site.id_mt_data.pre_cell=pre_cell;
        
    %Calculate the pre-noise correlation for each site
    count=0;
    new_data_mt_pre_corr=nan(nU*(nU-1)/2,nCond);
    new_data_mt_pre_p=new_data_mt_pre_corr;
    for j=1:nU-1
            u1=pre_cell{j};
        for k=j+1:nU
            count=count+1;
            u2=pre_cell{k};
            [rho,pval]=corr(u1,u2);
            new_data_mt_pre_corr(count,:)=diag(rho);
            new_data_mt_pre_p(count,:)=diag(pval);            
        end
    end
    site.data_mt_pre_corr=new_data_mt_pre_corr;    
    site.data_mt_pre_p=new_data_mt_pre_p;
    
    %save the this site
    save (currpath,'-struct','site')
end