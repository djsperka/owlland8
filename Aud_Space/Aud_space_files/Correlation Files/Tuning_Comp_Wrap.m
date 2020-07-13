function Tuning_Comp_Wrap()
global chan_select rec snd
global wap_on wap_edge
global wag_on
chans=find(chan_select==1);
wa_peak_vect=NaN(rec.numch,2);
wap_edge=zeros(rec.numch,1);

%% Build data arrays & Check for Significant Responses
for i=1:length(chans)
    rec.dispch=chans(i);
    [store_dispmat{chans(i)},store_disparr1{chans(i)},store_disparr2{chans(i)}]=Display_Calc;
end 

%% Weighted Average Around Peak
if wap_on
    
    if snd.inter_loom
        figure(findobj(0,'tag','disp_win_3'));
        set(findobj(gcf,'tag','interloom_type'),'value',1);
    end
    
    for i=1:length(chans)
        rec.dispch=chans(i);
        dispmat=store_dispmat{chans(i)}; 
        disparr1=store_disparr1{chans(i)};
        disparr2=store_disparr2{chans(i)};
        wa_peak_vect(chans(i),:)=WAPeak_Run(dispmat,disparr1,disparr2);
    end
    
    if snd.Var1>7 %if this was a vis stim
        if snd.size_change>0
            data_save.id_wa_peak_vis_loom=wa_peak_vect;
            data_save.data_wap_sep_vis_loom=SepCalc(wa_peak_vect);            
        else
            data_save.id_wa_peak_vis=wa_peak_vect;
            data_save.data_wap_sep_vis=SepCalc(wa_peak_vect);
        end
    else 
    wa_peak_vect(:,1)=wa_peak_vect(:,1)/2.5; %convert ITD to degrees
    %Since ILD conversion is kind of messy I'm just ignoring that 
    data_save.id_wa_peak_aud=wa_peak_vect; 
    data_save.data_wap_sep_aud=SepCalc(wa_peak_vect);
    end
        
    
    %if this was interloom data
    if snd.inter_loom
        figure(findobj(0,'tag','disp_win_3'));
        set(findobj(gcf,'tag','interloom_type'),'value',2);
        wa_peak_vect_loom=NaN(rec.numch,2);
        for i=1:length(chans)
            rec.dispch=chans(i);
            dispmat=store_dispmat{chans(i)};
            disparr1=store_disparr1{chans(i)};
            disparr2=store_disparr2{chans(i)};
            wa_peak_vect_loom(chans(i),:)=WAPeak_Run(dispmat,disparr1,disparr2);
        end
        data_save.id_wa_peak_loom=wa_peak_vect_loom;
        data_save.data_wap_sep_loom=SepCalc(wa_peak_vect_loom);
        
    end
    
end %wap_on

%% Global Weighted Average
if wag_on
    if snd.inter_loom
        figure(findobj(0,'tag','disp_win_3'));
        set(findobj(gcf,'tag','interloom_type'),'value',1);
    end
    
    wa_glob_vect=NaN(rec.numch,2);
    
    for i=1:length(chans)
        rec.dispch=chans(i);
        dispmat=store_dispmat{chans(i)}; 
        disparr1=store_disparr1{chans(i)};
        disparr2=store_disparr2{chans(i)};
        wa_glob_vect(chans(i),:)=WAGlob_Run(dispmat,disparr1,disparr2);
    end
    if snd.Var1>7 %if this was visual
        if snd.size_change>0
            data_save.id_wa_glob_vis_loom=wa_glob_vect;
            data_save.data_wag_sep_vis_loom=SepCalc(wa_glob_vect);            
        else
            data_save.id_wa_glob_vis=wa_glob_vect;
            data_save.data_wag_sep_vis=SepCalc(wa_glob_vect);
        end
    else 
    wa_peak_vect(:,1)=wa_peak_vect(:,1)/2.5; %convert ITD to degrees
    %Since ILD conversion is kind of messy I'm just ignoring that 
    data_save.id_wa_glob_aud=wa_glob_vect;
    data_save.data_wag_sep_aud=SepCalc(wa_glob_vect);
    end
    
    if snd.inter_loom
        figure(findobj(0,'tag','disp_win_3'));
        set(findobj(gcf,'tag','interloom_type'),'value',2);
        wa_glob_vect_loom=NaN(rec.numch,2);
        for i=1:length(chans)
            rec.dispch=chans(i);
            dispmat=store_dispmat{chans(i)};
            disparr1=store_disparr1{chans(i)};
            disparr2=store_disparr2{chans(i)};
            wa_glob_vect_loom(chans(i),:)=WAGlob_Run(dispmat,disparr1,disparr2);
        end
        data_save.id_wa_glob_loom=wa_glob_vect_loom;
        data_save.data_wag_sep_loom=SepCalc(wa_glob_vect_loom);
    end
end

%% Save Data
cd ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition')
fprintf('\nPlease select the ''corrdat'' file this is associated with\n')
[file_name,pathname]=uigetfile;

cd (pathname);
target=load(file_name);
%--------- remove fields if they already exist 
tempnames=fieldnames(data_save);
for i=1:length(tempnames)
if any(strcmp(tempnames{i},fieldnames(target)))
    target=rmfield(target,tempnames{i});
end
end %----------------------------------------
output=Catstruct(target,data_save);
fprintf('\n')
save(file_name,'-struct','output');

fprintf('\nDone.\n')