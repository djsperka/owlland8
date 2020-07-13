function [uttest_out,mt_labels,tit1]=Pop_Analysis_Run_Competition(handles)

% This is the function that runs when you press Plot it! in the
% Pop_Analysis_GUI_competition. It starts by reading in all of the
% different settings that are initialized in the GUI.  Then it loops
% through every site ite the site_cell and tags the data that will be
% processed (based on the selected settings)from each single unit and each
% pair of units using the unit_tagger and pair_tagger variables
% respectively.  Once these tags are assigned, concatenate the tagged data
% from this site onto the concatenated data vectors acrossed all sites.  If
% plotting mtrace data, separate it based on the type of analysis
% 
% Once all the data is concatenated, it is processed graph it. 

% 7/13/2015 Modification; currently this is setup to put everything
% together into complete mtrace population matrices, then push it into the
% plotting function and specify which 2 columns are to be used for the
% "2way comparison".  However, due to the coding error that screwed up
% SizeChange2 during my stim presentation, most traces won't have
% their complete Mtrace matrix. Modifying it so that unless "Show Response
% Bar Graph" or "Show Noise Corr" are checked, only the data chosen for
% "Conditional Comparisons" is pulled and used, so that the "incomplete"
% traces don't have to be dropped, as long as the comparison of interest
% is available. 

% 7/16/2015 Added an output, uttest_out so that this script can be hijacked
% to give inputs for an unpaired ttest DJT 7/16/2015

global site_cell site_names var1_choice var2_choice
global do_competition do_bimodal do_prism

% addpath ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Correlation Files\Competition Scripts');

%% Read in Setting
unit_type=get(handles.unit_type,'Value');
supe=get(handles.layer_supe,'Value');
inter=get(handles.layer_inter,'Value');
deep=get(handles.layer_deep,'Value');
layer_combo=get(handles.layer_combo,'Value');
same_trode=get(handles.same_trode_type,'Value');
var1_choice=get(handles.variable_1,'Value');
var2_choice=get(handles.variable_2,'Value');
no_prism=get (handles.no_prism,'Value'); %Don't anaylize prism data for bimodal and competitoin`
compare2=get(handles.comp2,'Value'); % are you directly comparing two conditions?
bim_linear=get(handles.av_integration,'Value'); %are you assessing bimodal response integration?

%required response characteristics
rrc_vis_tune=get(handles.rrc_vis_resp,'Value'); %responds to vis stim
rrc_aud_tune=get(handles.rrc_aud_resp,'Value'); %responds to aud stim
rrc_vwi=get(handles.rrc_vwi,'Value'); %Vw.I>0
rrc_vwo=get(handles.rrc_vwo,'Value'); %Vw.O~>0
rrc_vwi_vwo=get(handles.rrc_vwi_and_vwo,'Value'); %Vw.I>Vw.O
rrc_ai=get(handles.rrc_ai,'Value'); %A.I>0
rrc_ao=get(handles.rrc_ao,'Value'); %A.O~>0
rrc_as=get (handles.rrc_as,'Value'); %A.S~>0

%bin data
cutoff=nan;
bin_TC=get(handles.bin_TC,'Value');
if bin_TC
    cutoff=str2double(get(handles.TC_cutoff,'String'));
end
bin_DP=get(handles.bin_DP,'Value');
if bin_DP
    cutoff=str2double(get(handles.DP_cutoff,'String'));
end
bin_sep=get(handles.bin_sep,'Value');
if bin_sep
    cutoff=str2double(get(handles.sep_cutoff,'String'));
end
bin_CR=get(handles.bin_CR,'Value');
if bin_CR
    cutoff=str2double(get(handles.CR_cutoff,'String'));
    cutoff=cutoff/100; %put in terms of percent
    
    pref_weak_comb=[];
    pref_strong_comb=[];
    pref_neith_comb=[];
    weak_x_weak=[]; %zeros(size(var2_pop,1),1); 
    strong_x_strong=weak_x_weak;
    neith_x_neith=weak_x_weak;
    weak_x_strong=weak_x_weak;
    weak_x_neith=weak_x_weak;
    strong_x_neith=weak_x_weak;
    
end


%% Select Analyses
if var1_choice>6 || var2_choice>6 %this means its mtrace data
    global stopper set_comp_handle
    stopper=1;
    while stopper==1
    Set_Competition_Anal %open GUI to select which analyses to do
    end
    close (set_comp_handle)
end

% This keeps the order consistant, which is convenient for coding reasons
if var2_choice==7 && (var1_choice==8 || var1_choice==9 || var1_choice==10);
    tv1=var1_choice;
    var1_choice=var2_choice;
    var2_choice=tv1;
end

if var2_choice<7 && var1_choice>6
    tv1=var1_choice;
    var1_choice=var2_choice;
    var2_choice=tv1;
end

%% Initialize Data Assembly Vectors

%Initialize assembly vectors
v1_is_mt= (var1_choice==7 || var1_choice==8 || var1_choice==9 || var1_choice==10 || var1_choice==11);
v2_is_mt= (var2_choice==7 || var2_choice==8 || var2_choice==9 || var2_choice==10 || var2_choice==11);


%if either variable is signal or noise correlation
if var1_choice==1 ||var1_choice==4  ||var2_choice==1 ||var2_choice==4 
    combined_p=[];
end

var1_pop=[]; %if doing prism, _pop will be the NTD owls
var1_prism=[];

tuning_corr_pop=[];
tuning_ang_pop=[];
tuning_dp_pop=[];

tuning_corr_prism=[];
tuning_ang_prism=[];
tuning_dp_prism=[];

prenc=[]; %pre-period noise correlation
prenc_prism=[];

changesameway=[]; 
combined_chans=[]; %stores a list of the channels
site_source=[]; %keeps track of which site each pair of units comes from

angular_sep_2var=[]; %used to store the 2-way angular separation data when compare2 is activated. 
plotme=nan; %used to determine which 2 conditions get plotted

glob_expvar=[]; %save the global explained variance
glob_nc=[]; %save the correlation between unit noise and global noise

% else
%     combined_var1=[];
% end
if v2_is_mt
    var2_pop=[];
    var2_prism=[];
    if var2_choice==7
        tuning_corr_pop=[];
        tuning_ang_pop=[];
        tuning_dp_pop=[];
        
        tuning_corr_prism=[];
        tuning_ang_prism=[];
        tuning_dp_prism=[];
       
    end
else
    combined_var2=[];
end

if get(handles.plot_n2o,'value')
    v1_n2o=[];
    v2_n2o=[];
end

% Select either all the loaded data, or just whats highlighted in the list
plot_select_butt=get(handles.plot_select_butt,'Value');
if plot_select_butt
    %Plot selected dataset
    site_choice=get(handles.sites_list,'Value');
    analysis_cell={};
    analysis_cell{1}=site_cell{site_choice};
else
    %Plot all datasets
    analysis_cell=site_cell;
end

reassign_plotme=0; %this variable is to re-assign values if you are only 
% doing a "compare 2" as opposed to a full m-trace analysis
                
fprintf('\nGlobal_Noise_Corr.m Disabled for debugging purposes!\n')

%% Loop through all the datasets, select appropriate data and concatenate it
for i=1:length(analysis_cell)
    site_data=analysis_cell{i};
    site_combo=length(site_data.data_chans);
    pair_tagger=ones(site_combo,1);
    unit_tagger=ones(length(site_data.id_chan),1);
    
%     if i==27
%         dbstack
%         keyboard
%     end
    
    drop_site=0;
    
    %% Tag all of the pairs to be analyzed   
    % Isolate single or multi units
    [pair_tagger,unit_tagger]=SU_Selector(unit_type,site_data,pair_tagger,unit_tagger);
    if sum(site_data.id_su~=1)>0
        fprintf('\nYOu were having trouble with the SU_Selector on 4/19/15 when you ran it with your "interloom" scripts')
        fprintf('\nWhen you checked, there weren''t any non-SUs in your competition data so you ignored it')
        fprintf('\nHowever I just detected a non-SU, so I''m pausing the script for you to scope it out')
        dbstack
        keyboard
    end
    
    % Sort by layers
    if ~supe
        %if superficial layers aren't selected, drop all pairs w/ superficial
        %units
        pair_tagger=Layer_Selector (1,site_data,pair_tagger);
        unit_tagger(site_data.id_layer==1)=0;
    end
    if ~inter
        pair_tagger=Layer_Selector (2,site_data,pair_tagger);
        unit_tagger(site_data.id_layer==2)=0;
    end
    if ~deep
        pair_tagger=Layer_Selector (3,site_data,pair_tagger);
        unit_tagger(site_data.id_layer==3)=0;
    end
    
    % Sort by layer combination (ie. supeXsupe, supeXdeep etc)
    pair_tagger=Layer_Combo_Selector (layer_combo,site_data,pair_tagger);
    
    % Remove pairs that are from the same electrode
    if same_trode
        pair_tagger=Same_Trode_Dropper(site_data,pair_tagger);
    end
    
    %% Remove units that don't have tuning %%%
    
    %If vis only activated
    if rrc_vis_tune
        vis_ut=unit_tagger;
        vis_ut(~site_data.id_tuned_vis)=0;
        unit_tagger=vis_ut; 
        
        counter=0;
        vis_pt=pair_tagger;
        for j=1:size(unit_tagger,1)-1
            for k=j+1:size(unit_tagger,1)
                counter=counter+1;
                if vis_ut(j)==0 || vis_ut(k)==0
                    vis_pt(counter)=0;
                end
            end
        end
        pair_tagger=vis_pt;
    end
    
    %If aud only activated
    if rrc_aud_tune
        aud_ut=unit_tagger;
        site_data.id_tuned_aud(isnan(site_data.id_tuned_aud))=0;
        aud_ut(~site_data.id_tuned_aud)=0;
        unit_tagger=aud_ut;
        
        counter=0;
        aud_pt=pair_tagger;
        for j=1:size(unit_tagger,1)-1
            for k=j+1:size(unit_tagger,1)
                counter=counter+1;
                if aud_ut(j)==0 || aud_ut(k)==0
                    aud_pt(counter)=0;
                end
            end
        end
        pair_tagger=aud_pt;
    end
    
    % Sort by in-out responders/non responders
    if rrc_vwi %If there IS NOT a vis in response, drop unit
        pointer=strcmp('Vw_I  ',site_data.id_mt_labels); 
        unit_tagger(~logical(site_data.data_responds(:,pointer)))=0;       
    end
    if rrc_vwo %If there IS a vis out response, drop unit
        pointer=strcmp('Vw_O  ',site_data.id_mt_labels); 
        unit_tagger(logical(site_data.data_responds(:,pointer)))=0; 
    end
    if rrc_vwi_vwo %If vis.in IS NOT greater than vis.out, drop unit
        pointer=strcmp('Vi.w>Vi.o',site_data.id_mt_resp_ttest_labels);
        unit_tagger(~logical(site_data.data_mt_resp_ttest(:,pointer)))=0; 
    end
    if rrc_ai %If there IS NOT an aud.in response, drop unit
        pointer=strcmp('A_I  ',site_data.id_mt_labels); 
        unit_tagger(~logical(site_data.data_responds(:,pointer)))=0;  
    end
    if rrc_ao %If there IS an aud.out response, drop unit
        pointer=strcmp('A_O  ',site_data.id_mt_labels); 
        unit_tagger(logical(site_data.data_responds(:,pointer)))=0;  
    end
    if rrc_as %If there IS an aud.suppressed response, drop unit
        pointer=strcmp('A_S  ',site_data.id_mt_labels); 
        unit_tagger(logical(site_data.data_responds(:,pointer)))=0;  
    end  
    
    % update the pair tagger
    counter=0;
    for j=1:length(unit_tagger)-1
        for k=j+1:length(unit_tagger)
            counter=counter+1;
            if ~unit_tagger(j) || ~unit_tagger(k)
                pair_tagger(counter)=0;
            end
        end
    end
    
    if sum(unit_tagger)==0
        drop_site=1;
    end
    
    %% Assemble tagged pairs into concatinated vectors
   
    % Decide whether the chosen variables apply to single units or pairs
    pairflag=[1,1];
    [var1,tit1,pairflag(1)]=Var_Builder(var1_choice,site_data);
    [var2,tit2,pairflag(2)]=Var_Builder(var2_choice,site_data);
    
    if ~pairflag(1)
        site_var1=var1{1}(unit_tagger==1,:);
    else
        site_var1=var1{1}(pair_tagger==1,:);
    end
    if ~pairflag(2)
        site_var2=var2{1}(unit_tagger==1,:);
    else
        site_var2=var2{1}(pair_tagger==1,:);
    end  
    
    if pairflag(1) || pairflag(2)
        chan_pairs=site_data.data_chans(pair_tagger==1,:);
        combined_chans=[combined_chans;chan_pairs];
%         combined_sites=[combined_sites;i*ones(
    end

    site_source(i)=size(site_var1,1); %keeps track of how many pairs came from each site
    
    %if this was NC data, get the p-values
    if length(var1)>1
        site_p=var1{2}(bim_pairs);
        combined_p=[combined_p;site_p];
    elseif length(var2)>1
        site_p=var2{2}(bim_pairs);
        combined_p=[combined_p;site_p];
    end
    
    % If you have multi-trace data
%     if (v1_is_mt || v2_is_mt) && ~isempty(site_var1)
        if site_data.site_shift==0 || ~no_prism %if this isn't prism data OR you don't care if it is or not
            
                
            % first put data in the correct order and calculate tuning
            % correlations
            if do_competition
                [mt_labels,alt_labels,plotme]=Order_MT(handles,1);
            elseif do_bimodal
                [mt_labels,alt_labels,plotme]=Order_MT(handles,2);
            else %do prism ... control data
                [mt_labels,alt_labels,plotme]=Order_MT(handles,3);
            end
            
            
            % if you are doing something that demands having all of the
            % mtrace categories populated
            if get(handles.show_resp,'value') || get (handles.show_nc,'value') || get(handles.comp_to_preNC,'value')
                
                % find data from this specific site that has correct labels
                
                order=nan(size(mt_labels));
                for j=1:length(mt_labels)
                    if ~isempty(find(strcmp(mt_labels{j},site_data.id_mt_labels), 1))
                        order(j)=find(strcmp(mt_labels{j},site_data.id_mt_labels),1);
                    elseif ~isempty (find(strcmp(alt_labels{j},site_data.id_mt_labels), 1))
                        order(j)=find(strcmp(alt_labels{j},site_data.id_mt_labels));
                    else
                        fprintf ('\n\nCrap! Didn''t find the appropriate label.  Pausing script so you can check it out.')
                        fprintf('\nIf the data is just missing, continue script and it will ignore this site')
                        fprintf('\nSite Date:  %s\nSite ID:  %s\n',site_data.site_date,site_data.site_id)
                        fprintf(' Looking for ::  %s\nMtrace labels available: \n',mt_labels{j})
                        fprintf(': %s :',site_data.id_mt_labels{:})
                        fprintf('\n')
                        if ~get(handles.no_pause,'Value')
                            keyboard
                        end
                        drop_site=1;
                        break
                    end
                end
            elseif compare2 %only grab the values for the 2 way conditional comparison
                reassign_plotme=1;
%                 drop_site=0;
                order=nan(size(plotme));
                
                for j=1:length(plotme)
                    if ~isempty(find(strcmp(mt_labels{plotme(j)},site_data.id_mt_labels),1))
                        order(j)=find(strcmp(mt_labels{plotme(j)},site_data.id_mt_labels),1);
                    elseif ~isempty(find(strcmp(alt_labels{plotme(j)},site_data.id_mt_labels),1))
                        order(j)=find(strcmp(alt_labels{plotme(j)},site_data.id_mt_labels),1);
                    else
                        fprintf ('\n\nCrap! Didn''t find the appropriate label.  Pausing script so you can check it out.')
                        fprintf('\nIf the data is just missing, continue script and it will ignore this site')
                        fprintf('\nSite Date:  %s\nSite ID:  %s\n',site_data.site_date,site_data.site_id)
                        fprintf(' Looking for ::  %s\nMtrace labels available: \n',mt_labels{plotme(j)})
                        fprintf(': %s :',site_data.id_mt_labels{:})
                        fprintf('\n')
                        if ~get(handles.no_pause,'Value')
                            keyboard
                        end
                        drop_site=1;
                        site_source(i)=0; %no longer have sites from this cohort
                    end
                    
                    
                end
                
            else %neither mtrace or compare2 conditions
%                 drop_site=0;
                
            end
            
            if ~drop_site
                
                %calculate the relationship between this each unit's
                %response and the global noise
%                 fprintf('\nGlobal_Noise_Corr.m Disabled for debugging purposes!\n')
%                 [site_glob_expl_var, site_glob_nc]=Global_Noise_Corr(site_data,unit_tagger,handles);
%                 glob_expvar=[glob_expvar; site_glob_expl_var(:,order)];
%                 glob_nc=[glob_nc; site_glob_nc(:,order)];
                
                %if you are comparing to pre-period noise corrs
                if get(handles.comp_to_preNC,'Value')
                    prenc=[prenc;site_data.data_mt_pre_corr(logical(pair_tagger),order)];
                end
                
                % Measure tuning similarity based on responses
                if v1_is_mt
                    ordered_sv1=site_var1(:,order);
                    var1_pop=[var1_pop;ordered_sv1];
                    if var1_choice==7
                        
                        [tuning_corr,tuning_dp,tuning_ang]=Calc_Tuning_Corr(ordered_sv1);
                        
                        tuning_corr_pop=[tuning_corr_pop;tuning_corr'];
                        tuning_ang_pop=[tuning_ang_pop;tuning_ang'];
                        tuning_dp_pop=[tuning_dp_pop;tuning_dp'];
                    end
                else
                    var1_pop=[var1_pop;site_var1];
                end
                if v2_is_mt
                    
                    ordered_sv2=site_var2(:,order);
                    var2_pop=[var2_pop;ordered_sv2];
                    if var2_choice==7
                        
                        [tuning_corr,tuning_dp,tuning_ang]=Calc_Tuning_Corr(ordered_sv2);
                        
                        tuning_corr_pop=[tuning_corr_pop;tuning_corr'];
                        tuning_ang_pop=[tuning_ang_pop;tuning_ang'];
                        tuning_dp_pop=[tuning_dp_pop;tuning_dp'];
                    end
                else
                    var2_pop=[var2_pop;ordered_sv2];
                end
                
                %compare the angular seperation between two conditions
                %w/ the noise correlation for one of those condition
                if compare2 && get(handles.plot_ang_sep,'Value')
                    site_ang_sep=Calc_Ang_Sep(ordered_sv1,plotme);
                    angular_sep_2var=[angular_sep_2var,site_ang_sep];
                end
                
                %if binning based on the differences in responses
                if get(handles.bin_2way,'Value')
                    var1diff=ordered_sv1(:,plotme(2))-ordered_sv1(:,plotme(1));
                    var1prod=var1diff*var1diff';
                    samesig=nan(size(ordered_sv2,1),1);
                    counter=0;
                    for j=1:length(var1diff)-1
                        for k=j+1:length(var1diff)
                            counter=counter+1;
                            samesig(counter)=var1prod(j,k);
                        end
                    end
                    changesameway=[changesameway;samesig>0];                    
                end
                
                if get(handles.plot_n2o,'value')
                    v1_n2o=[v1_n2o; ones(size(site_var1,1),1)*site_data.data_N2O];
                    v2_n2o=[v2_n2o; ones(size(site_var2,1),1)*site_data.data_N2O];
                end
            end
            
            % If binning based on competitor responses
            if bin_CR
                
                if do_competition
                    weak=5;
                    strong=6;
                else
                    fprintf(['\nDon''t have a way to bin based on competitor ' ...
                        'responses for anything besides the do_competition analyses. Pausing\n'])
                    dbstack
                    keyboard
                end
                
                cut_range=ordered_sv1(:,weak)*cutoff;
                pref_weak=ordered_sv1(:,strong)<(ordered_sv1(:,weak)-cut_range);
                pref_strong=ordered_sv1(:,strong)>(ordered_sv1(:,weak)+cut_range);
                pref_neith=~pref_weak&~pref_strong;
                
                pref_weak_comb=[pref_weak_comb;pref_weak];
                pref_strong_comb=[pref_strong_comb;pref_strong];
                pref_neith_comb=[pref_neith_comb;pref_neith];
                
                counter = size(weak_x_weak,1); %set counter to equal the number of elements before update
                weak_x_weak=[weak_x_weak;zeros(size(site_var2,1),1)];
                strong_x_strong=[strong_x_strong;zeros(size(site_var2,1),1)];
                neith_x_neith=[neith_x_neith;zeros(size(site_var2,1),1)];
                weak_x_strong=[weak_x_strong;zeros(size(site_var2,1),1)];
                weak_x_neith=[weak_x_neith;zeros(size(site_var2,1),1)];
                strong_x_neith=[strong_x_neith;zeros(size(site_var2,1),1)];
                
                for j=1:size(ordered_sv1,1)-1
                    for k=j+1:size(ordered_sv1,1)
                        counter=counter+1;
                        if pref_weak(j) && pref_weak(k)
                            weak_x_weak(counter)=1;
                        elseif pref_strong(j) && pref_strong(k)
                            strong_x_strong(counter)=1;
                        elseif pref_neith(j) && pref_neith(k)
                            neith_x_neith(counter)=1;
                        elseif pref_weak(j) && pref_strong(k) || pref_weak(k) && pref_strong(j)
                            weak_x_strong(counter)=1;
                        elseif pref_weak(j) && pref_neith(k) || pref_weak(k) && pref_neith(j)
                            weak_x_neith(counter)=1;
                        elseif pref_strong(j) && pref_neith(k) || pref_strong(k) && pref_neith(j)
                            strong_x_neith(counter)=1;
                        end
                    end
                end
            end
            
        else %make prism data
            
            [mt_labels_prism,alt_labels_prism,plotme]=Order_MT(handles,3);
            
            drop_site=0;
            order=nan(size(mt_labels_prism));
            for j=1:length(mt_labels_prism)
                locater=find(strcmp(mt_labels_prism{j},site_data.id_mt_labels));
                if isempty(locater)
                    fprintf ('\n\nCrap! Didn''t find the appropriate label.  Pausing script so you can check it out.')
                    fprintf('\nIf the data is just missing, continue script and it will ignore this site')
                    fprintf('\nSite Date:  %s\nSite ID:  %s\n',site_data.site_date,site_data.site_id)
                    fprintf(' Looking for ::  %s\nMtrace labels available: \n',mt_labels_prism{j})
                    fprintf(': %s :',site_data.id_mt_labels{:})
                    fprintf('\n')
                    keyboard
                    drop_site=1;
                    break
                else
                    order(j)=locater;
                end
            end
            
            if ~drop_site
                if v1_is_mt
                    ordered_sv1=site_var1(:,order);
                    var1_prism=[var1_prism;ordered_sv1];
                    if var1_choice==7
                        
                        [tuning_corr,tuning_dp,tuning_ang]=Calc_Tuning_Corr(ordered_sv1);
                        
                        tuning_corr_prism=[tuning_corr_prism;tuning_corr'];
                        tuning_ang_prism=[tuning_ang_prism;tuning_ang'];
                        tuning_dp_prism=[tuning_dp_prism;tuning_dp'];
                    end
                else
                    var1_prism=[var1_prism;site_var1];
                end
                if v2_is_mt
                    ordered_sv2=site_var2(:,order);
                    var2_prism=[var2_prism;ordered_sv2];
                    if var2_choice==7
                        
                        [tuning_corr,tuning_dp,tuning_ang]=Calc_Tuning_Corr(ordered_sv2);
                        
                        tuning_corr_prism=[tuning_corr_prism;tuning_corr'];
                        tuning_ang_prism=[tuning_ang_prism;tuning_ang'];
                        tuning_dp_prism=[tuning_dp_prism;tuning_dp'];
                    end
                else
                    var2_prism=[var2_prism;site_var2];
                end
                
                %if comparing 2 variables
                if compare2 && get(handles.plot_ang_sep,'Value')
                    site_ang_sep=Calc_Ang_Sep(ordered_sv1,plotme);
                    angular_sep_2var=[angular_sep_2var,site_ang_sep];
                end
            end
        end
        
%     end
        
end %end site_cell loop

if compare2
    angular_sep_2var=angular_sep_2var';
end

%% Generate Plots and Perform Statistical Comparisons

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if you only grabbed data for compare2, then change plotme so that the
% correct traces get read while plotting
if reassign_plotme
    mt_labels=mt_labels(plotme);
    plotme=[1 2];
end

if strcmp(get(handles.UTT_running,'String'),'YES')
   uttest_out=var1_pop(:,plotme); 
   return
end

% Decide on a similarity metric
tuning_similarity=[];
if get(handles.show_scat,'Value') && (var1_choice==7 || var2_choice==7);
    sim_type=get(handles.sim_metric_type,'Value');
    switch sim_type
        case 1
            tuning_similarity=tuning_ang_pop;
        case 2
            tuning_similarity=tuning_dp_pop;
        case 3
            tuning_similarity=tuning_corr_pop;
    end
end
if ~v1_is_mt
    tuning_similarity=var1;
end

changesameway=logical(changesameway);

% if v1_is_mt && v2_is_mt


% Compare correlations in the pre-period to correlations in the
% post-period
if get(handles.comp_to_preNC,'Value')
    Compare_to_Pre(prenc,var2_pop,mt_labels);
end

if get(handles.glob_nc,'value')
    Plot_Global_NC (glob_expvar,glob_nc,var1_pop,handles,mt_labels)
end

if get(handles.twoway_glob_nc,'Value')
    Compare_Global_NC (glob_expvar,glob_nc,handles,mt_labels,plotme)
end

if get(handles.plot_n2o,'Value')
    if v1_is_mt
        Plot_N2O (var1_pop(:,plotme),v1_n2o,mt_labels,tit1)
    else
        Plot_N2O ([var1_pop,var1_pop],[v1_n2o,v1_n2o],{'map','map'},tit1)
    end
    Plot_N2O (var2_pop(:,plotme),v2_n2o,mt_labels,tit2)
end
    
if do_bimodal
    analysis_type='Bimodal';
elseif do_competition
    analysis_type='Competition';
else
    analysis_type='Prism';
end

%% Enter main plotting function
if v1_is_mt && v2_is_mt %if they are both multitrace-data
    addpath('C:\Users\Doug\Box Sync\Everything\Dougs DeBello Dump\OwlLand_8chan\Aud_Space\Aud_Space_files\Correlation Files\Competition Scripts')
    [hb1,hb2]=Plot_Corr_2MT (var1_pop,var2_pop,tuning_similarity,angular_sep_2var,cutoff,changesameway,mt_labels,handles,analysis_type,plotme,tit1,tit2);
    
    %compare response magnitude to noise correlations
    if get(handles.respmag_vs_nc,'Value') 
        Rate_NC_Relationship(var1_pop(:,plotme),var2_pop(:,plotme),site_source,mt_labels)
    end
    
    if get(handles.resp_vs_ff,'Value')
        Rate_vs_FF (var1_pop(:,plotme),var2_pop(:,plotme),mt_labels,tit1,tit2)
    end
    
else %if one of your variables isn't multritrace-data
    Plot_Corr_1MT(var1_pop,tit1,var2_pop,tit2,handles,mt_labels)
end

fprintf ('\nFor %s Data:\nNum cells = %.0f\nNum pairs = %.0f\n',analysis_type,size(var1_pop,1),size(var2_pop,1))
    
% See if auditory and visual responses sum linearly
if bim_linear
    if var1_choice~=7
        fprintf('\nSorry mate, you gotta have your Var1 Choice be "Mtrace Response" to assess bimodal linearity\n')
        dbstack
        keyboard
    elseif ~do_bimodal
        fprintf('\nSorry mate, you gotta do a bimodal analysis to assess bimodal linearity\n')
        dbstack
        keyboard
    else
        Bimodal_Liniarity_Assessment (var1_pop,mt_labels)
    end
end

% if you are binning based on competition responses
if do_competition && bin_CR
    
    % Plot weak vs weak
    [hc1,hc2]=Plot_Corr_2MT (var1(logical(pref_weak_comb),:),var2_pop(logical(weak_x_weak),:),[],[],nan,[],mt_labels,handles,analysis_type,plotme);
    figure (hc1);
    htit=get(gca,'Title');
    titstr=get(htit,'String');
    title(strcat(titstr,' (Vw_I Vs_O) > (Vw_O Vs_I)'));
    figure (hc2);
    htit=get(gca,'Title');
    titstr=get(htit,'String');
    title(strcat(titstr,' (Vw_I Vs_O) > (Vw_O Vs_I)'));
    
    % Plot strong vs strong
    [hc1,hc2]=Plot_Corr_2MT (var1(logical(pref_strong_comb),:),var2_pop(logical(strong_x_strong),:),[],[],nan,[],mt_labels,handles,analysis_type,plotme);
    figure (hc1);
    htit=get(gca,'Title');
    titstr=get(htit,'String');
    title(strcat(titstr,' (Vw_O Vs_I) > (Vw_I Vs_O)'));
    figure (hc2);
    htit=get(gca,'Title');
    titstr=get(htit,'String');
    title(strcat(titstr,' (Vw_O Vs_I) > (Vw_I Vs_O)'));
    
    % Plot neith vs neith
    [hc1,hc2]=Plot_Corr_2MT (var1(logical(pref_neith_comb),:),var2_pop(logical(neith_x_neith),:),[],[],nan,[],mt_labels,handles,analysis_type,plotme);
    figure (hc1);
    htit=get(gca,'Title');
    titstr=get(htit,'String');
    title(strcat(titstr,' (Vw_O Vs_I) = (Vw_I Vs_O)'));
    figure (hc2);
    htit=get(gca,'Title');
    titstr=get(htit,'String');
    title(strcat(titstr,' (Vw_O Vs_I) = (Vw_I Vs_O)'));
    
    % Plot weak vs strong
    [hc1,hc2]=Plot_Corr_2MT (var1((logical(pref_weak_comb) | logical(pref_strong_comb)),:),var2_pop(logical(weak_x_strong),:),[],[],nan,[],mt_labels,handles,analysis_type,plotme);
    figure (hc1);
    close;
    figure (hc2);
    htit=get(gca,'Title');
    titstr=get(htit,'String');
    title(strcat(titstr,' [(Vw_O Vs_I) > (Vw_I Vs_O)] X [(Vw_O Vs_I) < (Vw_I Vs_O)]'));
    
end
if do_prism
    
    [hc1,hc2]=Plot_Corr_2MT (var1_prism,var2_prism,tuning_similarity,angular_sep_2var,cutoff,changesameway,mt_labels_prism,handles,analysis_type,plotme);
    
    if get(handles.prism_vs_normal,'Value')
        [hp1,hp2]=Plot_Corr_2MT_Prism(var1_norm,var1_prism,var2_norm,var2_prism,tuning_similarity,angular_sep_2var,cutoff,mt_labels_prism,handles,analysis_type,plotme)  ;
    end
    fprintf ('\nFor Prism Data:\nNum cells = %.0f\nNum pairs = %.0f\n',size(var1_prism,1),size(var2_prism,1))
end

%%-------------------%%-------------------%%-------------------%%-------------------%%%-------------------%%-------------------%%-------------------%%-------------------%
%%-------------------%%-------------------%%-------------------%%-------------------%%%-------------------%%-------------------%%-------------------%%-------------------%
%%-------------------%%-------------------%%-------------------%%-------------------%%%-------------------%%-------------------%%-------------------%%-------------------%
%%-------------------%%-------------------%%-------------------%%-------------------%%%-------------------%%-------------------%%-------------------%%-------------------%
%%-------------------%%-------------------%%-------------------%%-------------------%%%-------------------%%-------------------%%-------------------%%-------------------%
%%-------------------%%-------------------%%-------------------%%-------------------%%%-------------------%%-------------------%%-------------------%%-------------------%
%% End Main Script

function [tuning_corr,tuning_dp,tuning_ang]=Calc_Tuning_Corr(resp_vect)
rho=corr(resp_vect');
var_dp=resp_vect*resp_vect'; % gives NxN matrix of condition dot products
var_norms=(diag(var_dp)).^.5; %the diagonal is the sum of the squares, so the root of that is the norm
rc_count=0;
tuning_corr=[];
tuning_ang=[];
tuning_dp=[];
for r=1:length(rho)-1;
    for c=r+1:length(rho);
        rc_count=rc_count+1;
        tuning_corr(rc_count)=rho(r,c);
        tuning_dp(rc_count)=var_dp(r,c) / (var_norms(r) * var_norms(c) );
        tuning_ang(rc_count)=acosd( var_dp(r,c) / (var_norms(r) * var_norms(c) ) ); %this gives the angle of seperation
    end
end

function angular_sep_2var=Calc_Ang_Sep(resp_vect,plotme)
angular_sep_2var=[];
for j=1:size(resp_vect,1)-1;
    for k=j+1:size(resp_vect,1);
        r1=resp_vect(j,plotme);
        r2=resp_vect(k,plotme);
        angular_sep_2var(end+1)=acosd ( (r1*r2') / (norm(r1)*norm(r2)));
        %             figure
        %             hold on;
        %             plot ([r1(1) r2(1);0 0],[r1(2) r2(2);0 0]);
        %             plot ([-1 0;1 0],[0 -1;0 1],':k');
        %             templeg=sprintf('Angle between points is %.2f',angle_pop_vect(count));
        %             legend(templeg);
        %             xlim([-.1 .1]);
        %             ylim([-.1 .1]);
        %             hold off
        %             close
        
    end
end

function Compare_to_Pre(prenc,var2_pop,mt_labels)
% Compare the correlations in the pre-period to the correlations in the
% post-period for each condition
% dbstack
% keyboard

% Figure out the number of rows and columns for tiling the graphs across
% the screen
myscreen=get(0,'screensize');
[nU,nC]=size(prenc); %nUnits, nConditions

nRows=floor(nC^.5);
nCols=ceil(nC/nRows);
width=myscreen(3)/nCols;
height=myscreen(4)/nRows;


col=1;
row=1;

for i=1:length(mt_labels)
    plotme=i;
    
    % If you passed the last column, go down a row and start over
    if col>nCols
        row=row+1;
        col=1;
    end
    
    % Find all non-nan sites to display
    tag1=~isnan(prenc(:,plotme)) & ~isnan(var2_pop(:,plotme));
    x1=prenc(tag1,plotme);
    y1=var2_pop(tag1,plotme);
    
    h(i)=figure ('Position',[(col-1)*width,(nRows-row)*height,width,height-100]);
    hold on
    plot (x1,y1,'o')
    plot (mean(x1),mean(y1),'rx','MarkerSize',15)
    [~,ttest_p1]=ttest(x1, y1);
    [rho1,~]=corr(x1,y1);
    pfit1=polyfit(x1,y1,1);
    plot ([min(x1) max(x1)],[min(x1)*pfit1(1)+pfit1(2),max(x1)*pfit1(1)+pfit1(2)],':r');
    plot ([min(x1),max(x1)],[min(x1),max(x1)],'--k')
    xlabel ('Pre-Period Correlation')
    ylabel ('Post-Period Correlation')
    title (sprintf('Correlation Comparison for %s',mt_labels{plotme}))
    leg{1}=sprintf('Pre vs Post ... %.0f Pairs',sum(tag1));
    leg{2}=sprintf('Mean: (%.2f , %.2f)\np(pre==post)=%.4f',mean(x1),mean(y1),ttest_p1);
    leg{3}=sprintf('y=%.2f + %.2f*x\nrho=%.2f',pfit1(2),pfit1(1),rho1);
    leg{4}='x=y';
    legend(leg)
    hold off
    
    col=col+1;
end

function Plot_Global_NC (glob_expvar,glob_nc,resp,handles,mt_labels);
% dbstack
% keyboard
myscreen=get(0,'screensize');
[nU,nC]=size(glob_expvar); %nUnits, nConditions

nRows=floor(nC^.5);
nCols=ceil(nC/nRows);
width=myscreen(3)/nCols;
height=myscreen(4)/nRows;

%normalize the responses
if get(handles.gnc_log_abs,'Value') && get(handles.gnc_abs_sqrt,'Value')
    fprintf('\nWhoa, hang on there chap.  You can only have ONE global NC normalization\n')
    dbstack
    keyboard
end
if get(handles.gnc_log_abs,'Value')
    resp=log(abs(resp)+.1);
    ylab_text='log(abs(resp)+0.1)';
elseif get(handles.gnc_abs_sqrt,'Value')
    resp=(abs(resp)+1).^.5;
    ylab_text='(|resp|+1)^{1/2}';
else
    ylab_text = 'Response (post-pre : spikes/sec)';
end

row=1;
col=1;
for i=1:nC
    if col>nCols
        row=row+1;
        col=1;
    end
        
    plotme=~isnan(glob_nc(:,i));
    x1=(abs(glob_expvar(plotme,i))).^.5; %through an abs() in there because once there was a -0.0000 that screwed things up
    x2=glob_nc(plotme,i);
    y=resp(plotme,i);
    
    h1(i)=figure ('Position',[(col-1)*width,(nRows-row)*height,width,height-100]);
    hold on
    plot (x1,y,'o')
    plot (mean(x1),mean(y),'rx','MarkerSize',15)
%     [~,ttest_p1]=ttest(x1, y);
    [rho1,~]=corr(x1,y);
    pfit1=polyfit(x1,y,1);
    plot ([min(x1) max(x1)],[min(x1)*pfit1(1)+pfit1(2),max(x1)*pfit1(1)+pfit1(2)],':r');
    xlabel ('(Global Explained Variance)^{1/2}')
    ylabel (ylab_text)
    title (sprintf('Global Explained Variance vs Response for %s',mt_labels{i}))
    leg{1}=sprintf('GEV vs Resp ... %.0f Units',sum(plotme));
    leg{2}=sprintf('Mean: (%.2f , %.2f',mean(x1),mean(y));
    leg{3}=sprintf('y=%.2f + %.2f*x\nrho=%.2f',pfit1(2),pfit1(1),rho1);
    legend(leg)
    hold off
    
    h2(i)=figure ('Position',[(col-1)*width+25,(2-row)*height+25,width,height-100]);
    hold on
    plot (x2,y,'o')
    plot (mean(x2),mean(y),'rx','MarkerSize',15)
%     [~, ttest_p2]=ttest(x2, y);
    [rho2, ~]=corr(x2,y);
    pfit2=polyfit(x2,y,1);
    plot ([min(x2) max(x2)],[min(x2)*pfit2(1)+pfit2(2),max(x2)*pfit2(1)+pfit2(2)],':r');
    xlabel ('Global Noise Correlation')  
    ylabel (ylab_text)
    title (sprintf('Global Noise Corr vs Response for %s',mt_labels{i}))
    leg{1}=sprintf('NC vs Resp ... %.0f Units',sum(plotme));
    leg{2}=sprintf('Mean: (%.2f , %.2f)',mean(x2),mean(y));
    leg{3}=sprintf('y=%.2f + %.2f*x\nrho=%.2f',pfit2(2),pfit2(1),rho2);
    legend(leg)
    hold off
    
    col=col+1;
end

function Compare_Global_NC (glob_expvar,glob_nc,handles,mt_labels,plotme)
% dbstack
% keyboard

x1=abs(glob_expvar(:,plotme(1)));
y1=abs(glob_expvar(:,plotme(2)));
x2=glob_nc(:,plotme(1));
y2=glob_nc(:,plotme(2));

%drop nans
notnans=~isnan(x2) & ~isnan(y2);
x1=x1(notnans);
y1=y1(notnans);
x2=x2(notnans);
y2=y2(notnans);
  
%% plot global explained variance

%Use (Var) or (Var)^.5 for explained variance?
expvar_xlabel='';
if get(handles.gnc_sqrt,'Value')
    x1=x1.^.5;
    y1=y1.^.5;
    expvar_xlabel='^{1/2}';
end

figure 
hold on
plot (x1,y1,'o')
plot (mean(x1),mean(y1),'rx','MarkerSize',15)
[~,ttest_p1]=ttest(x1, y1);
[rho1,~]=corr(x1,y1);
pfit1=polyfit(x1,y1,1);
plot ([min(x1) max(x1)],[min(x1)*pfit1(1)+pfit1(2),max(x1)*pfit1(1)+pfit1(2)],':r');
plot ([min(x1),max(x1)],[min(x1),max(x1)],'--k')
xlabel (sprintf('%s (%% Explainted Variance)%s',mt_labels{plotme(1)},expvar_xlabel))
ylabel (sprintf('%s (%% Explainted Variance)%s',mt_labels{plotme(2)},expvar_xlabel))
title (sprintf('Comparing Variance Explained by Global Noise :: %s vs %s',mt_labels{plotme}))
leg{1}=sprintf('Unit Comparison ... %.0f Units',sum(notnans));
leg{2}=sprintf('Population Mean: (%.2f , %.2f)\np(%s==%s)=%.4f',mean(x1),mean(y1),mt_labels{plotme},ttest_p1);
leg{3}=sprintf('y=%.2f + %.2f*x\nrho=%.2f',pfit1(2),pfit1(1),rho1);
leg{4}='x=y';
legend(leg)
hold off
    
%% plot global noise correlations

%Use (rho) or (rho)^2 for glob_nc?
glob_nc_xlabel='';
if get(handles.gnc_rho_sq,'Value')
    x2=x2.^2;
    y2=y2.^2;
    glob_nc_xlabel='^2';
end

figure 
hold on
plot (x2,y2,'o')
plot (mean(x2),mean(y2),'rx','MarkerSize',15)
[~,ttest_p2]=ttest(x2, y2);
[rho2,~]=corr(x2,y2);
pfit2=polyfit(x2,y2,1);
plot ([min(x2) max(x2)],[min(x2)*pfit2(1)+pfit2(2),max(x2)*pfit2(1)+pfit2(2)],':r');
plot ([min(x2),max(x2)],[min(x2),max(x2)],'--k')
xlabel (sprintf('%s (rho)%s',mt_labels{plotme(1)},glob_nc_xlabel))
ylabel (sprintf('%s (rho)%s',mt_labels{plotme(2)},glob_nc_xlabel))
title (sprintf('Comparing Correlations w/ Global Noise :: %s vs %s',mt_labels{plotme}))
leg{1}=sprintf('Unit Comparison ... %.0f Units',sum(notnans));
leg{2}=sprintf('Population Mean: (%.2f , %.2f)\np(%s==%s)=%.4f',mean(x2),mean(y2),mt_labels{plotme},ttest_p2);
leg{3}=sprintf('y=%.2f + %.2f*x\nrho=%.2f',pfit2(2),pfit2(1),rho2);
leg{4}='x=y';
legend(leg)
hold off


function [mt_labels,alt_labels,plotme]=Order_MT(handles,framework)
%framework 1 = competition, 2=bimodal, 3=prism

%--------- Condition Lookup Table------------
% 1) Vw_I
% 2) Vw_O
% 3) -----
% 4) Vs_I
% 5) Vs_O
% 6) Lose
% 7) Win
% 8) Vw_I+Vw_O
% 9) -----
% 10) A_I
% 11) A_O
% 12) A_S
% 13) A_I+A_O
% 14) -----
% 15) A_I + V_I
% 16) A_O + V_I
% 17) A_I + V_O
% 18) A_O + V_O
                
allow_tie=get(handles.allow_tie,'Value'); %do you want the "vwi + vwo" or "ai + ao" conditions?
plotme=nan;

% Make the appropriate MT_labels
switch framework
    case 1 %competition
        mt_labels{1}='Vw_I  ';
        mt_labels{2}='Vw_O  ';
        mt_labels{3}='Vs_I  ';
        mt_labels{4}='Vs_O  ';
        mt_labels{5}='Vs_O  Vw_I';
        mt_labels{6}='Vw_O  Vs_I';
        
        alt_labels{5}='Vw_I  Vs_O';
        alt_labels{6}='Vs_I  Vw_O';
        
        if allow_tie
            mt_labels{7}='Vw_O  Vw_I';            
            alt_labels{7}='Vw_I  Vw_O';
        end
        
    case 2 %bimodal
            mt_labels{1}='Vw_I  ';
            mt_labels{2}='Vw_O  ';
            mt_labels{3}='A_I  ';
            mt_labels{4}='A_O  ';
            mt_labels{5}='A_I  Vw_I';
            mt_labels{6}='A_O  Vw_I';
            mt_labels{7}='A_I  Vw_O';
            mt_labels{8}='A_O  Vw_O';
            
            alt_labels{5}='Vw_I  A_I';
            alt_labels{6}='Vw_I  A_O';
            alt_labels{7}='Vw_O  A_I';
            alt_labels{8}='Vw_O  A_O';
            
        if allow_tie
            mt_labels{9}='Vw_O  Vw_I';
            mt_labels{10}='A_O  A_I';
            
            alt_labels{9}='Vw_I  Vw_O';
            alt_labels{10}='A_I  A_O';
        end
        
    case 3 %prism
        mt_labels{1}='Vw_I  ';
        mt_labels{2}='Vw_O  ';
        mt_labels{3}='A_I  ';
        mt_labels{4}='A_O  ';
%         if ~site_data.site_shift==0 % this is prism data
%             mt_labels{5}='A_S  ';
%         end
        
        alt_labels={};
end

% find tag for 2-way comparisons
if get(handles.comp2,'Value') || get(handles.twoway_glob_nc,'Value') %if you are making a comparison between two conditions
    conditions(1)=get(handles.comp_cond_1,'Value');
    conditions(2)=get(handles.comp_cond_2,'Value');
    
    switch framework
        case 1 %competition
            reorder(1)= 1; % 1) Vw_I
            reorder(2)= 2; % 2) Vw_O
            reorder(3)= nan; % 3) -----
            reorder(4)= 3; % 4) Vs_I
            reorder(5)= 4; % 5) Vs_O
            reorder(6)= 5; % 6) Lose
            reorder(7)= 6; % 7) Win
            if conditions(1)==8 || conditions(2)==8
                reorder(8)= 7; % 8) Vw_I+Vw_O
            else
                reorder(8)= nan; % 8) Vw_I+Vw_O
            end
            reorder(9)= nan; % 9) -----
            reorder(10)= nan; % 10) A_I
            reorder(11)= nan; % 11) A_O
            reorder(12)= nan; % 12) A_S
            reorder(13)= nan; % 13) A_I+A_O
            reorder(14)= nan; % 14) -----
            reorder(15)= nan; % 15) A_I + V_I
            reorder(16)= nan; % 16) A_O + V_I
            reorder(17)= nan; % 17) A_I + V_O
            reorder(18)= nan; % 18) A_O + V_O
            
            if allow_tie
                reorder(8)= 7; % 8) Vw_I+Vw_O
            end
            
            plotme=reorder(conditions);
            if sum(isnan(plotme))>0
                fprintf(['\nLooks like you are trying to compare two' ...
                    ' conditions that aren''t both just visual\n'])
                dbstack
                keyboard
            end
            
        case 2 %bimodal
            reorder(1)= 1; % 1) Vw_I
            reorder(2)= 2; % 2) Vw_O
            reorder(3)= nan; % 3) -----
            reorder(4)= nan; % 4) Vs_I
            reorder(5)= nan; % 5) Vs_O
            reorder(6)= nan; % 6) Lose
            reorder(7)= nan; % 7) Win
            reorder(8)= nan; % 8) Vw_I+Vw_O
            reorder(9)= nan; % 9) -----
            reorder(10)= 3; % 10) A_I
            reorder(11)= 4; % 11) A_O
            reorder(12)= nan; % 12) A_S
            reorder(13)= nan; % 13) A_I+A_O
            reorder(14)= nan; % 14) -----
            reorder(15)= 5; % 15) A_I + V_I
            reorder(16)= 6; % 16) A_O + V_I
            reorder(17)= 7; % 17) A_I + V_O
            reorder(18)= 8; % 18) A_O + V_O
            
            if allow_tie
                reorder(8)= 9; % 8) Vw_I+Vw_O
                reorder(13)= 10; % 13) A_I+A_O                
            end
            
            plotme=reorder(conditions);
            if sum(isnan(plotme))>0
                fprintf(['\nLooks like you are trying to compare two' ...
                    ' conditions that aren''t accepted bimodal classes\n'])
                dbstack
                keyboard
            end
            
        case 3 % prism
            reorder(1)= 1; % 1) Vw_I
            reorder(2)= 2; % 2) Vw_O
            reorder(3)= nan; % 3) -----
            reorder(4)= nan; % 4) Vs_I
            reorder(5)= nan; % 5) Vs_O
            reorder(6)= nan; % 6) Lose
            reorder(7)= nan; % 7) Win
            reorder(8)= nan; % 8) Vw_I+Vw_O
            reorder(9)= nan; % 9) -----
            reorder(10)= 3; % 10) A_I
            reorder(11)= 4; % 11) A_O
            reorder(12)= nan; % 12) A_S
            reorder(13)= nan; % 13) A_I+A_O
            reorder(14)= nan; % 14) -----
            reorder(15)= nan; % 15) A_I + V_I
            reorder(16)= nan; % 16) A_O + V_I
            reorder(17)= nan; % 17) A_I + V_O
            reorder(18)= nan; % 18) A_O + V_O
            
%             if ~site_data.site_shift==0 % this is prism data
%             reorder(12)= 5; % 12) A_S
%             end
            
            plotme=reorder(conditions);
            if sum(isnan(plotme))>0
                fprintf(['\nLooks like you are trying to compare two' ...
                    ' conditions that don''t jive with the "do prism" selection\n'])
                dbstack
                keyboard
            end
            
    end
end
              
                
function Rate_vs_FF(v1,v2,mt_labels,tit1,tit2)
% Function to display the firing rate vs the fano factor, and determine the
% degree to which the change in firing rate predicts the change in fano
% factor

% Plot condition-wise response vs fano factor
[rho,pval]=corr(v1,v2);
rho=diag(rho);
pval=diag(pval);
pfits=polyfit(v1(:,1),v2(:,1),1);
pfits(2,:)=polyfit(v1(:,2),v2(:,2),1);
figure
plot (v1,v2,'o')
hold on
if pval(1)<.05
    plot ([min(v1(:,1)),max(v1(:,1))],pfits(1,:)*[min(v1(:,1)),max(v1(:,1));1,1],':r')
end
if pval(2)<.05 
    plot ([min(v1(:,2)),max(v1(:,2))],pfits(2,:)*[min(v1(:,2)),max(v1(:,2));1,1],':r')
end
xlabel (tit1)
ylabel (tit2)
tittxt=sprintf('%s vs %s for %s and %s',tit1,tit2,mt_labels{1},mt_labels{2});
title(tittxt);
legtxt{1}=sprintf('%s\nr=%.2f  pval=%.4f',mt_labels{1},rho(1),pval(1));
legtxt{2}=sprintf('%s\nr=%.2f  pval=%.4f',mt_labels{2},rho(2),pval(2));
legend(legtxt)

% Plot change in response vs change in fano factor
d_v1=v1(:,2)-v1(:,1);
d_v2=v2(:,2)-v2(:,1);
[d_rho,d_pval]=corr(d_v1,d_v2);
d_pfits=polyfit(d_v1,d_v2,1);
figure
plot (d_v1,d_v2,'o')
hold on
if d_pval<.05
plot ([min(d_v1),max(d_v1)],d_pfits*[min(d_v1),max(d_v1);1,1],':r')
end
title(sprintf('Change in %s vs Change in %s for (%s)-(%s)',tit1,tit2,mt_labels{2},mt_labels{1}))
xlabel(sprintf('delta(%s)',tit1))
ylabel(sprintf('delta(%s)',tit2))
legend(sprintf('d(%s) vs d(%s)\nr=%.2f  p=%.4f',tit1,tit2,d_rho,d_pval))

function     Plot_N2O (var,v_n2o,mt_labels,tit1)
% This function is designed to separate data based on whether N2O was on or
% not, and see if it had any effect on noise correlations

%% First Variable (respnse, nc etc)
% for first type of stimulus

no_gas=v_n2o(:,1)==0;
lit_gas=v_n2o(:,1)>0 & v_n2o(:,1)<1;
full_gas=v_n2o(:,1)>=1;

fprintf ('\n---Investigating Effect of Nitrous ... Var=%s ... Stim=%s\n',tit1,mt_labels{1})
fprintf('n(No Gas)=%.0f\nn(Weak Gas)=%.0f\nn(Full Gas)=%.0f\n',sum(no_gas),sum(lit_gas),sum(full_gas))

legtxt={};
figure
hist(var(full_gas,1))
hold on
yrange=get(gca,'ylim');
plot ([var(lit_gas,1),var(lit_gas,1)]',yrange'*ones(1,sum(lit_gas)),':g')
plot ([var(no_gas,1),var(no_gas,1)]',yrange'*ones(1,sum(no_gas)),'--r')
legtxt{1}=sprintf('Full Gas n=%.0f, mean=%.2f',sum(full_gas),nanmean(var(full_gas),1));
[~,p]=ttest2(var(full_gas,1),var(lit_gas,1));
legtxt{2}=sprintf('Light Gas n=%.0f, mean=%.2f, p(lit==ful)=%.4f',sum(lit_gas),nanmean(var(lit_gas,1)),p);
[~,p]=ttest2(var(full_gas,1),var(no_gas,1));
legtxt{3}=sprintf('No Gas n=%.0f, mean=%.2f, p(no==ful)=%.4f',sum(no_gas),nanmean(var(no_gas,1)),p);
title(sprintf('%s Values Measured with Full, Light (0<gas<1) or No Gas for %s',tit1,mt_labels{1}))
xlabel(sprintf('%s Values',tit1))
ylabel('Counts')
legend(legtxt)

% for second type of stimulus
fprintf ('\n---Investigating Effect of Nitrous ... Var=%s ... Stim=%s\n',tit1,mt_labels{2})
fprintf('n(No Gas)=%.0f\nn(Weak Gas)=%.0f\nn(Full Gas)=%.0f\n',sum(no_gas),sum(lit_gas),sum(full_gas))

legtxt={};
figure
hist(var(full_gas,2))
hold on
yrange=get(gca,'ylim');
plot ([var(lit_gas,2),var(lit_gas,2)]',yrange'*ones(1,sum(lit_gas)),':g')
plot ([var(no_gas,2),var(no_gas,2)]',yrange'*ones(1,sum(no_gas)),'--r')
legtxt{1}=sprintf('Full Gas n=%.0f, mean=%.2f',sum(full_gas),nanmean(var(full_gas,2)));
[~,p]=ttest2(var(full_gas,2),var(lit_gas,2));
legtxt{2}=sprintf('Light Gas n=%.0f, mean=%.2f, p(lit==ful)=%.4f',sum(lit_gas),nanmean(var(lit_gas,2)),p);
[~,p]=ttest2(var(full_gas,2),var(no_gas,2));
legtxt{3}=sprintf('No Gas n=%.0f, mean=%.2f, p(no==ful)=%.4f',sum(no_gas),nanmean(var(no_gas,2)),p);
title(sprintf('%s Values Measured with Full, Light (0<gas<1) or No Gas for %s',tit1,mt_labels{2}))
xlabel(sprintf('%s Values',tit1))
ylabel('Counts')
legend(legtxt)

