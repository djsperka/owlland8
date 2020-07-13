function DotProduct_Wrap
global snd 

fullpath=mfilename ('fullpath');
fprintf ('\nUsing Doug''s custom matlab startup located in %s\n\n',fullpath)

fname=mfilename;
fpath=fullpath(1:(findstr(fullpath,fname)-1));
csw_path=strcat(fpath,'..\Dougs_Data\Correlation Summary Workspaces\Competition');

startcd=cd;
cd (csw_path)
fprintf('\nPlease select the OwlLand file this is associated with\n')
[file_name,pathname]=uigetfile;
cd(startcd);

adjusted_mat_stat=(snd.datamat_post-(snd.posttime/snd.pre)*snd.datamat_pre)/snd.reps;
%calculate the normalized matrix, by subtracting the pre and dividing by
%reps



if snd.Var1>7 %visual stim
    if snd.size_change==0 % this was a static stim
        data_save.data_dp_vis_stat=DotProduct_Run(adjusted_mat_stat);
        data_save.id_vis_map_stat.post=snd.datamat_post/snd.reps / (snd.post/1000);
        data_save.id_vis_map_stat.pre=snd.datamat_pre/snd.reps / (snd.post/1000);
        data_save.id_vis_map_stat.resp=(snd.datamat_post-snd.datamat_pre*(snd.post/snd.pre)) / snd.reps / (snd.post/1000);
        data_save.id_vis_map_stat.Var1array=snd.Var1array;
        data_save.id_vis_map_stat.Var2array=snd.Var2array;
        data_save.id_vis_map_stat.snd=snd;        
    else % this was a looming stim 
        data_save.data_dp_vis_loom=DotProduct_Run(adjusted_mat_stat);
        data_save.id_vis_map_loom.post=snd.datamat_post/snd.reps / (snd.post/1000);
        data_save.id_vis_map_loom.pre=snd.datamat_pre/snd.reps / (snd.post/1000);
        data_save.id_vis_map_loom.resp=(snd.datamat_post-snd.datamat_pre*(snd.post/snd.pre)) / snd.reps / (snd.post/1000);
        data_save.id_vis_map_loom.Var1array=snd.Var1array;
        data_save.id_vis_map_loom.Var2array=snd.Var2array;
        data_save.id_vis_map_loom.snd=snd;
        
    end
else 
data_save.data_dp_aud=DotProduct_Run(adjusted_mat_stat);
data_save.id_aud_map.post=snd.datamat_post/snd.reps / (snd.post/1000);
data_save.id_aud_map.pre=snd.datamat_pre/snd.reps / (snd.post/1000);
data_save.id_aud_map.resp=(snd.datamat_post-snd.datamat_pre*(snd.post/snd.pre)) / snd.reps / (snd.post/1000);
data_save.id_aud_map.Var1array=snd.Var1array;
data_save.id_aud_map.Var2array=snd.Var2array;
end
   

if snd.inter_loom %if interloom, repeat
    adjusted_mat_loom=(snd.data_arr1_post-(snd.posttime/snd.pre)*snd.data_arr1_pre)/snd.reps;  
    data_save.data_dp_loom=DotProduct_Run(adjusted_mat_loom);
end

% fprintf('\nAbout to save.  Check that everything is hunky dorey\n')
% keyboard

%% Save data 

cd (pathname);
target=load(file_name);
%--------- remove fields if they already exist 
tempnames=fieldnames(data_save);
for i=1:length(tempnames)
if any(strcmp(tempnames{i},fieldnames(target)))
    target=rmfield(target,tempnames{i});
end
end %-----------------------------------------
output=Catstruct(target,data_save);
save(file_name,'-struct','output'); %NOTE: Saving with the same file name!
cd(startcd);
fprintf ('\nSaved with the same file name in the same location\n')
fprintf (strcat('Filename :',file_name,'\n'))
pathname

