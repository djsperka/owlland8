function NoiseCorr_Wrap
global snd data_save save_corr  pre_post  root first_pass_stat first_pass_loom
global suppress_figs ALL_fig_hands save_mat save_tif %%%Figure related globals

%%%%% Global variables, so they don't have to be recalculated each time
%%%%% through NoiseCorr2D_Run
global pre_cell_stat post_cell_stat pre_cell_loom post_cell_loom 
%Make sure they are cleared, otherwise they can spill over from previous
%analyses you do during this same session
pre_cell_stat={};
post_cell_stat={};
pre_cell_loom={};
post_cell_loom={};

startdir=cd;

%% Check Inputs
if snd.interleave_alone
    error('\n\nERROR!  code not prepared to handle interleaved data! \n\n')
end

if length(find(pre_post==1))<1
    error ('Ya need to choose SOME kind of correlation. Dumbass.')
end

data_save=[]; 
ALL_fig_hands=[]; %This guy is in here just in case you end up with a ton of figures and you didn't choose to close em
%if that happens, use this code to close em
root=[];

%% IF saving, choose the file
if save_corr || save_mat || save_tif
    cd (snd.path)
    fprintf('\nPlease select the OwlLand file this is associated with\n')
    [file_name,pathname]=uigetfile;  
    % root=input('Enter root name for files (ie 7_2_2013_p1s1)  :','s');
    root=file_name;
end



%% Run correlation routines
first_pass_stat=1;
first_pass_loom=1;
cd(startdir)
pp_tag=find(pre_post==1); %ID what data should be analyzed; 1=adjusted, ...
% 2=pre only and 3=post only

for i=1:length(pp_tag) %Loop through each analysis type
    pp_type=pp_tag(i);    
    corrtype='stat';
    if length(snd.Var2array)>1
        NoiseCorr2D_Run (snd,corrtype,pp_type)
    else
        NoiseCorr1D_Run (snd,corrtype,pp_type)
    end
    
    if snd.inter_loom
        spikes=Inter_Loom_Builder(snd);
        corrtype='loom';
        
        if length(snd.Var2array)>1
            spikes.dataVar2=spikes.dataVar2_arr1;
            NoiseCorr2D_Run (spikes,corrtype,pp_type)
        else
            NoiseCorr1D_Run (spikes,corrtype,pp_type)
        end
    end

cd (snd.path)

%% Save and/or close figures
if ~suppress_figs
Fig_Ctrl (pp_type)
end
cd (startdir)

end

%% Save data to the pre-specified directory
if save_corr
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
fprintf('\nAbout to save\n')
% name_guess=strcat(root,'_corrdat');
name_guess=file_name;
keyboard
save(name_guess,'-struct','output');
end

fprintf('\nDone.  Check it out.  If you still have a million figures open, try using the ALL_fig_hands variable\n\n')
keyboard

end
    
%%%%% CODE DUMP

%% Old GUI of for controling figures

% myscreen=get(0,'screensize');
% figure('position',[myscreen(3)/2,myscreen(4)/2,myscreen(3)/5,myscreen(4)/10],'menubar','none','Color','w')
% 
% uicontrol('style','text',...
%     'units','normalized',...
%     'position', [.2 .6 .6 .3],...
%     'string','Correlation Figure Controls',...
%     'fontsize',12,...
%     'horizontalalignment','center');
% 
% uicontrol('style','checkbox',...
%     'units','normalized',...
%     'position', [.05 .1 .2 .3],...
%     'string','Save .mat',...
%     'fontsize',8,...
%     'tag','save_mat',...
%     'callback', 'update_Fig_Ctrl',...
%     'horizontalalignment','center');
% 
% uicontrol('style','checkbox',...
%     'units','normalized',...
%     'position', [.3 .1 .2 .3],...
%     'string','Save .tif',...
%     'fontsize',8,...
%     'tag','save_tif',...
%     'callback', 'update_Fig_Ctrl',...
%     'horizontalalignment','center');
% 
% uicontrol('style','checkbox',...
%     'units','normalized',...
%     'position', [.55 .1 .2 .3],...
%     'string','Close all',...
%     'fontsize',8,...
%     'tag','close_figs',...
%     'callback', 'update_Fig_Ctrl',...
%     'horizontalalignment','center');
% 
% uicontrol('units','normalized',...
%     'position', [.8 .1 .2 .3],...
%     'string','Execute',...
%     'fontsize',8,...
%     'callback', 'Fig_Ctrl',...
%     'horizontalalignment','center');


% fprintf('\nPausing to give you a chance to dick around with the figures\n')
% keyboard


