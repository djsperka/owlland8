function Pop_Analysis_Run_Competition(hObject, eventdata, handles)

% This is the function that runs when you press Plot it! in the
% Pop_Analysis_GUI_competition. It starts by reading in all of the
% different settings that are initialized in the GUI.  Then it loops
% through every site ite the site_cell and tags the data that will be
% processed (based on the selected settings)from each single unit and each
% pair of units using the unit_tagger and pair_tagger variables
% respectively.  Once these tags are assigned, concatenate the tagged data
% from this site onto the concatenated data vectors acrossed all sites.  If
% plotting mtrace data, separate it based on the type of analysisEnd the
% site loop
% 
% Once all the data is concatenated, it is processed graph it. 


global site_cell site_names var1_choice var2_choice
global do_competition do_bimodal do_prism

addpath ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Correlation Files\Competition Scripts');

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
    weak_x_weak=[]; %zeros(size(var2_comp,1),1); 
    strong_x_strong=weak_x_weak;
    neith_x_neith=weak_x_weak;
    weak_x_strong=weak_x_weak;
    weak_x_neith=weak_x_weak;
    strong_x_neith=weak_x_weak;
    
end

% if you are directly comparing two conditions
compare2=get(handles.comp2,'Value');
angular_sep_2var=[];

compare2_comp=0;
compare2_bim=0;
compare2_prism=0;
if compare2
    
    plotme=nan(1,2);
    
    plotme(1)=get(handles.comp_cond_1,'Value');
    plotme(2)=get(handles.comp_cond_2,'Value');
    
% % %     if plotme(1)<9 && plotme(2)<9
% % %         compare2_comp=1;
% % %     end
% % %     if plotme(1)==12 || plotme(2)==12
% % %         compare2_prism=1;
% % %     end
% % %     if ((plotme(1)==10 && plotme(2)==11) || (plotme(1)==11 && plotme(2)==10)) && do_prism
% % %         compare2_prism=1;
% % %     end
% % %     if plotme(1)>13 || plotme(2)>13
% % %         compare2_bim=1;
% % %     end
% % %     if ((plotme(1)==10 && plotme(2)==11) || (plotme(1)==11 && plotme(2)==10)) && do_bimodal %A_in vs A_out
% % %         compare2_bim=1;
% % %     end
% % %     if (plotme(1)==2 && plotme(2)==10) || (plotme(1)==10 && plotme(2)==2) && do_bimodal %Vw_I vs A_in
% % %         compare2_bim=1;
% % %     end
% % %     if (compare2_comp+compare2_prism+compare2_bim)~=1
% % %         fprintf('\n\n!!!Logic Failure.  One and only one of your comparison switches needs to be on.  Check "Read In Settings" part of your Pop_Analysis_Run_Competition script\n')
% % %         keyboard
% % %     end
% % %     if plotme(1)>3 && plotme(1)<9
% % %         %competition conditions
% % %         plotme(1)=plotme(1)-1;
% % %     elseif plotme(1) >9 && plotme (1) < 13
% % %         %prism adaptation
% % %         plotme(1)=plotme(1)-7;
% % %     elseif plotme(1)>13
% % %         %bimodal
% % %         plotme(1)=plotme(1)-9;
% % %     end
% % %     
% % %     if plotme(2)>3 && plotme(2)<9
% % %         %competition conditions
% % %         plotme(2)=plotme(2)-1;
% % %     elseif plotme(2) >9 && plotme (2) < 13
% % %         %prism adaptation
% % %         plotme(2)=plotme(2)-7;
% % %     elseif plotme(2) > 13
% % %         %bimodal
% % %         plotme(2)=plotme(2)-9;
% % %     end
% % %     
% % %     if plotme(1)<3 && plotme(2)<3
% % %         compare2_comp=1;
% % %     end
    
    if plotme(1)<8 && plotme(2)<8
        compare2_comp=1;
    end
    if plotme(1)==11 || plotme(2)==11
        compare2_prism=1;
    end
    if ((plotme(1)==9 && plotme(2)==10) || (plotme(1)==10 && plotme(2)==9)) && do_prism
        compare2_prism=1;
    end
    if plotme(1)>12 || plotme(2)>12
        compare2_bim=1;
    end
    if ((plotme(1)==9 && plotme(2)==10) || (plotme(1)==10 && plotme(2)==9)) && do_bimodal %A_in vs A_out
        compare2_bim=1;
    end
    if (plotme(1)==1 && plotme(2)==9) || (plotme(1)==9 && plotme(2)==1) && do_bimodal %Vw_I vs A_in
        compare2_bim=1;
    end
    if (compare2_comp+compare2_prism+compare2_bim)~=1
        fprintf('\n\n!!!Logic Failure.  One and only one of your comparison switches needs to be on.  Check "Read In Settings" part of your Pop_Analysis_Run_Competition script\n')
        keyboard
    end
    if plotme(1)>3 && plotme(1)<8
        %competition conditions
        plotme(1)=plotme(1)-1;
    elseif plotme(1) >8 && plotme (1) < 12
        %prism adaptation
        plotme(1)=plotme(1)-6;
    elseif plotme(1)>12
        %bimodal
        plotme(1)=plotme(1)-8;
    end
    
    if plotme(2)>3 && plotme(2)<8
        %competition conditions
        plotme(2)=plotme(2)-1;
    elseif plotme(2) >8 && plotme (2) < 12
        %prism adaptation
        plotme(2)=plotme(2)-6;
    elseif plotme(2) > 12
        %bimodal
        plotme(2)=plotme(2)-8;
    end
    
    if plotme(1)<3 && plotme(2)<3
        compare2_comp=1;
    end
    
end

changesameway=[];

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
v1_is_mt= (var1_choice==7 || var1_choice==8 || var1_choice==9 || var1_choice==10);
v2_is_mt= (var2_choice==7 || var2_choice==8 || var2_choice==9 || var2_choice==10);

combined_chans=[];
site_source=[];

%if either variable is signal or noise correlation
if var1_choice==1 ||var1_choice==4  ||var2_choice==1 ||var2_choice==4 
    combined_p=[];
end

% if v1_is_mt
    var1_comp=[];
    var1_bim=[];
    var1_norm=[]; %norm for prism analysis
    var1_prism=[];
    
    tuning_corr_comp=[];
    tuning_ang_comp=[];
    tuning_dp_comp=[];
    
    tuning_corr_bim=[];
    tuning_ang_bim=[];
    tuning_dp_bim=[];
    
    tuning_corr_prism=[];
    tuning_ang_prism=[];
    tuning_dp_prism=[];
    
    tuning_corr_norm=[];
    tuning_ang_norm=[];
    tuning_dp_norm=[];
% else
%     combined_var1=[];
% end
if v2_is_mt
    var2_comp=[];
    var2_bim=[];
    var2_prism=[];
    var2_norm=[];
    if var2_choice==7
        tuning_corr_comp=[];
        tuning_ang_comp=[];
        tuning_dp_comp=[];
        
        tuning_corr_bim=[];
        tuning_ang_bim=[];
        tuning_dp_bim=[];
        
        tuning_corr_prism=[];
        tuning_ang_prism=[];
        tuning_dp_prism=[];
        
        tuning_corr_norm=[];
        tuning_ang_norm=[];
        tuning_dp_norm=[];
    end
else
    combined_var2=[];
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

%% Loop through all the datasets, select appropriate data and concatenate it
for i=1:length(analysis_cell)
    site_data=analysis_cell{i};
    site_combo=length(site_data.data_chans);
    pair_tagger=ones(site_combo,1);
    unit_tagger=ones(length(site_data.id_chan),1);
    
    %% Tag all of the pairs to be analyzed   
    % Isolate single or multi units
    [pair_tagger,unit_tagger]=SU_Selector(unit_type,site_data,pair_tagger,unit_tagger);
    
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
    end
    
%     if ~v1_is_mt %not mtrace data
%         combined_var1=[combined_var1;site_var1];
%     end
%     if ~v2_is_mt %not mtrace data
%         combined_var2=[combined_var2;site_var2];
%     end

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
    if (v1_is_mt || v2_is_mt) && ~isempty(site_var1)
        
        if do_competition
            % first put data in the correct order and calculate tuning
            % correlations
            if site_data.site_shift==0 || ~no_prism %if this isn't prism data OR you don't care if it is or not
                mt_labels_comp{1}='Vw_I  ';
                mt_labels_comp{2}='Vw_O  ';
                mt_labels_comp{3}='Vs_I  ';
                mt_labels_comp{4}='Vs_O  ';
                mt_labels_comp{5}='Vs_O  Vw_I';
                mt_labels_comp{6}='Vw_O  Vs_I';
                alt_labels_comp{5}='Vw_I  Vs_O';
                alt_labels_comp{6}='Vs_I  Vw_O';
                
                order=nan(size(mt_labels_comp));
                for j=1:length(mt_labels_comp)
                    if ~isempty(find(strcmp(mt_labels_comp{j},site_data.id_mt_labels), 1))
                        order(j)=find(strcmp(mt_labels_comp{j},site_data.id_mt_labels));
                    elseif ~isempty (find(strcmp(alt_labels_comp{j},site_data.id_mt_labels), 1))
                        order(j)=find(strcmp(alt_labels_comp{j},site_data.id_mt_labels));
                    else
                        fprintf ('\n\nCrap! Didn''t find the appropriate label.  Pausing script so you can check it out.')
                        fprintf('\nIf the data is just missing, continue script and it will ignore this site')
                        fprintf('\nSite Date:  %s\nSite ID:  %s\n',site_data.site_date,site_data.site_id)
                        fprintf(' Looking for ::  %s\nMtrace labels available: \n',mt_labels_comp{j})
                        fprintf(': %s :',site_data.id_mt_labels{:})
                        fprintf('\n')
                        if ~get(handles.no_pause,'Value')
                            keyboard
                        end
                        drop_site=1;
                        break
                    end
                end
                if v1_is_mt
                    ordered_sv1=site_var1(:,order);
                    var1_comp=[var1_comp;ordered_sv1];
                    if var1_choice==7
                        
                        [tuning_corr,tuning_dp,tuning_ang]=Calc_Tuning_Corr(ordered_sv1);
                        
                        tuning_corr_comp=[tuning_corr_comp;tuning_corr'];
                        tuning_ang_comp=[tuning_ang_comp;tuning_ang'];
                        tuning_dp_comp=[tuning_dp_comp;tuning_dp'];
                    end
                else
                    var1_comp=[var1_comp;site_var1];
                end
                if v2_is_mt
                    
                    ordered_sv2=site_var2(:,order);
                    var2_comp=[var2_comp;ordered_sv2];
                    if var2_choice==7
                        
                        [tuning_corr,tuning_dp,tuning_ang]=Calc_Tuning_Corr(ordered_sv2);
                        
                        tuning_corr_comp=[tuning_corr_comp;tuning_corr'];
                        tuning_ang_comp=[tuning_ang_comp;tuning_ang'];
                        tuning_dp_comp=[tuning_dp_comp;tuning_dp'];
                    end
                else
                    var2_comp=[var2_comp;ordered_sv2];
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
                    
                % If binning based on competitor responses
                if bin_CR
                    
                    cut_range=ordered_sv1(:,5)*cutoff;
                    pref_weak=ordered_sv1(:,6)<(ordered_sv1(:,5)-cut_range);
                    pref_strong=ordered_sv1(:,6)>(ordered_sv1(:,5)+cut_range);
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
                
                %if comparing 2 variables
                if compare2_comp
                    site_ang_sep=Calc_Ang_Sep(ordered_sv1,plotme);
                    angular_sep_2var=[angular_sep_2var,site_ang_sep];
                end
            end
            
        end
        
        if do_bimodal
            if site_data.site_shift==0 || ~no_prism %if this isn't prism data OR you don't care if it is or not
                mt_labels_bim{1}='Vw_I  ';
                mt_labels_bim{2}='Vw_O  ';
                mt_labels_bim{3}='A_I  ';
                mt_labels_bim{4}='A_O  ';
                mt_labels_bim{5}='A_I  Vw_I';
                mt_labels_bim{6}='A_O  Vw_I';
                mt_labels_bim{7}='A_I  Vw_O';
                mt_labels_bim{8}='A_O  Vw_O';
                alt_labels_bim{5}='Vw_I  A_I';
                alt_labels_bim{6}='Vw_I  A_O';
                alt_labels_bim{7}='Vw_O  A_I';
                alt_labels_bim{8}='Vw_O  A_O';
                
                drop_site=0;
                order=nan(size(mt_labels_bim));
                for j=1:length(mt_labels_bim)
                    if ~isempty(find(strcmp(mt_labels_bim{j},site_data.id_mt_labels), 1))
                        order(j)=find(strcmp(mt_labels_bim{j},site_data.id_mt_labels));
                    elseif ~isempty(find(strcmp(alt_labels_bim{j},site_data.id_mt_labels), 1))
                        order(j)=find(strcmp(alt_labels_bim{j},site_data.id_mt_labels));
                    else
                        fprintf ('\n\nCrap! Didn''t find the appropriate label.  Pausing script so you can check it out.')
                        fprintf('\nIf the data is just missing, continue script and it will ignore this site')
                        fprintf('\nSite Date:  %s\nSite ID:  %s\n',site_data.site_date,site_data.site_id)
                        fprintf(' Looking for ::  %s\nMtrace labels available: \n',mt_labels_bim{j})
                        fprintf(': %s :',site_data.id_mt_labels{:})
                        fprintf('\n')
                        if ~get(handles.no_pause,'Value')
                            keyboard
                        end
                        drop_site=1;
                        break
                    end
                end
                
                if ~drop_site
                    if v1_is_mt
                        ordered_sv1=site_var1(:,order);
                        var1_bim=[var1_bim;ordered_sv1];
                        if var1_choice==7
                            
                            [tuning_corr,tuning_dp,tuning_ang]=Calc_Tuning_Corr(ordered_sv1);
                            
                            tuning_corr_bim=[tuning_corr_bim;tuning_corr'];
                            tuning_ang_bim=[tuning_ang_bim;tuning_ang'];
                            tuning_dp_bim=[tuning_dp_bim;tuning_dp'];
                        end
                    else
                        var1_bim=[var1_bim;site_var1];
                    end
                    
                    if v2_is_mt
                        ordered_sv2=site_var2(:,order);
                        var2_bim=[var2_bim;ordered_sv2];
                        if var2_choice==7
                            
                            [tuning_corr,tuning_dp,tuning_ang]=Calc_Tuning_Corr(ordered_sv2);
                            
                            tuning_corr_bim=[tuning_corr_bim;tuning_corr'];
                            tuning_ang_bim=[tuning_ang_bim;tuning_ang'];
                            tuning_dp_bim=[tuning_dp_bim;tuning_dp'];
                        end
                    else 
                        var2_bim=[var2_bim;site_var2];
                    end
                    
                    %if comparing 2 variables
                    if compare2_bim
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
                end
            end
        end
        
        if do_prism
            if site_data.site_shift==0 % this is control data
                mt_labels_norm{1}='Vw_I  ';
                mt_labels_norm{2}='Vw_O  ';
                mt_labels_norm{3}='A_I  ';
                mt_labels_norm{4}='A_O  ';
                
                drop_site=0;
                order=nan(size(mt_labels_norm));
                for j=1:length(mt_labels_norm)
                    locater=find(strcmp(mt_labels_norm{j},site_data.id_mt_labels));
                    if isempty(locater)
                        fprintf ('\n\nCrap! Didn''t find the appropriate label.  Pausing script so you can check it out.')
                        fprintf('\nIf the data is just missing, continue script and it will ignore this site')
                        fprintf('\nSite Date:  %s\nSite ID:  %s\n',site_data.site_date,site_data.site_id)
                        fprintf(' Looking for ::  %s\nMtrace labels available: \n',mt_labels_norm{j})
                        fprintf(': %s :',site_data.id_mt_labels{:})
                        fprintf('\n')
                        if ~get(handles.no_pause,'Value')
                            keyboard
                        end
                        drop_site=1;
                        break
                    else
                        order(j)=locater;
                    end
                end
                
                if ~drop_site
                    if v1_is_mt
                        ordered_sv1=site_var1(:,order);
                        var1_norm=[var1_norm;ordered_sv1];
                        if var1_choice==7
                            
                            [tuning_corr,tuning_dp,tuning_ang]=Calc_Tuning_Corr(ordered_sv1);
                            
                            tuning_corr_norm=[tuning_corr_norm;tuning_corr'];
                            tuning_ang_norm=[tuning_ang_norm;tuning_ang'];
                            tuning_dp_norm=[tuning_dp_norm;tuning_dp'];
                        end
                    else
                        var1_norm=[var1_norm;site_var1];
                    end
                    if v2_is_mt
                        ordered_sv2=site_var2(:,order);
                        var2_norm=[var2_norm;ordered_sv2];
                        if var2_choice==7
                            
                            [tuning_corr,tuning_dp,tuning_ang]=Calc_Tuning_Corr(ordered_sv2);
                            
                            tuning_corr_norm=[tuning_corr_norm;tuning_corr'];
                            tuning_ang_norm=[tuning_ang_norm;tuning_ang'];
                            tuning_dp_norm=[tuning_dp_norm;tuning_dp'];
                        end
                    else
                        var2_norm=[var2_norm;site_var2];
                    end
                    
                    %if comparing 2 variables
                    if compare2_prism
                        site_ang_sep=Calc_Ang_Sep(ordered_sv1,plotme);
                        angular_sep_2var=[angular_sep_2var,site_ang_sep];
                    end
                    
                end
            else %make prism data
                mt_labels_prism{1}='Vw_I  ';
                mt_labels_prism{2}='Vw_O  ';
                mt_labels_prism{3}='A_I  ';
                mt_labels_prism{4}='A_O  ';
                mt_labels_prism{5}='A_S  ';
                
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
                    if compare2_prism
                        site_ang_sep=Calc_Ang_Sep(ordered_sv1,plotme);
                        angular_sep_2var=[angular_sep_2var,site_ang_sep];
                    end
                end
            end
            
        end
    end
    
end %end site_cell loop
angular_sep_2var=angular_sep_2var';

%% Generate Plots and Perform Statistical Comparisons

% Decide on a similarity metric
tuning_similarity_comp=[];
tuning_similarity_bim=[];
tuning_similarity_prism=[];
if get(handles.show_scat,'Value') && (var1_choice==7 || var2_choice==7);
    sim_type=get(handles.sim_metric_type,'Value');
    switch sim_type
        case 1
            tuning_similarity_comp=tuning_ang_comp;
            tuning_similarity_bim=tuning_ang_bim;
            tuning_similarity_prism=tuning_ang_prism;
            
        case 2
            tuning_similarity_comp=tuning_dp_comp;
            tuning_similarity_bim=tuning_dp_bim;
            tuning_similarity_prism=tuning_dp_prism;
        case 3
            tuning_similarity_comp=tuning_corr_comp;
            tuning_similarity_bim=tuning_corr_bim;
            tuning_similarity_prism=tuning_corr_prism;
    end
end
if ~v1_is_mt
    if do_competition
        tuning_similarity_comp=var1_comp;
    end
    if do_bimodal
        tuning_similarity_bim=var1_bim;
    end
    if do_prism
        tuning_similarity_prism=var1_prism;
    end
end

changesameway=logical(changesameway);

% if v1_is_mt && v2_is_mt
if do_bimodal
    fprintf ('\nHave %.0f single units and %.0f pairs\n',size(var1_bim,1),size(var2_bim,1))
    [hb1,hb2]=Plot_Corr_2MT (var1_bim,var2_bim,tuning_similarity_bim,angular_sep_2var,cutoff,changesameway,mt_labels_bim,handles,'Bimodal');
    fprintf ('\nFor Bimodal Data:\nNum cells = %.0f\nNum pairs = %.0f\n',size(var1_bim,1),size(var2_bim,1))
end
if do_competition && ~bin_CR %you aren't binning by competition response
    
    fprintf ('\nHave %.0f single units and %.0f pairs\n',size(var1_comp,1),size(var2_comp,1))
    [hc1,hc2]=Plot_Corr_2MT (var1_comp,var2_comp,tuning_similarity_comp,angular_sep_2var,cutoff,changesameway,mt_labels_comp,handles,'Competition');
    fprintf ('\nFor Competition Data:\nNum cells = %.0f\nNum pairs = %.0f\n',size(var1_comp,1),size(var2_comp,1))
    
    %     elseif do_competition && comp2
    %         [hc1,hc2]=Plot_Corr_2MT (var1_comp,var2_comp,[],angular_sep_pop,cutoff,mt_labels_comp,handles,'Competition');
    %         fprintf ('\nFor Competition Data:\nNum cells = %.0f\nNum pairs = %.0f\n',size(var1_comp,1),size(var2_comp,1))
    
elseif do_competition && bin_CR
    
    % Plot weak vs weak
    [hc1,hc2]=Plot_Corr_2MT (var1_comp(logical(pref_weak_comb),:),var2_comp(logical(weak_x_weak),:),[],[],nan,[],mt_labels_comp,handles,'Competition');
    figure (hc1);
    htit=get(gca,'Title');
    titstr=get(htit,'String');
    title(strcat(titstr,' (Vw_I Vs_O) > (Vw_O Vs_I)'));
    figure (hc2);
    htit=get(gca,'Title');
    titstr=get(htit,'String');
    title(strcat(titstr,' (Vw_I Vs_O) > (Vw_O Vs_I)'));
    
    % Plot strong vs strong
    [hc1,hc2]=Plot_Corr_2MT (var1_comp(logical(pref_strong_comb),:),var2_comp(logical(strong_x_strong),:),[],[],nan,[],mt_labels_comp,handles,'Competition');
    figure (hc1);
    htit=get(gca,'Title');
    titstr=get(htit,'String');
    title(strcat(titstr,' (Vw_O Vs_I) > (Vw_I Vs_O)'));
    figure (hc2);
    htit=get(gca,'Title');
    titstr=get(htit,'String');
    title(strcat(titstr,' (Vw_O Vs_I) > (Vw_I Vs_O)'));
    
    % Plot neith vs neith
    [hc1,hc2]=Plot_Corr_2MT (var1_comp(logical(pref_neith_comb),:),var2_comp(logical(neith_x_neith),:),[],[],nan,[],mt_labels_comp,handles,'Competition');
    figure (hc1);
    htit=get(gca,'Title');
    titstr=get(htit,'String');
    title(strcat(titstr,' (Vw_O Vs_I) = (Vw_I Vs_O)'));
    figure (hc2);
    htit=get(gca,'Title');
    titstr=get(htit,'String');
    title(strcat(titstr,' (Vw_O Vs_I) = (Vw_I Vs_O)'));
    
    % Plot weak vs strong
    [hc1,hc2]=Plot_Corr_2MT (var1_comp((logical(pref_weak_comb) | logical(pref_strong_comb)),:),var2_comp(logical(weak_x_strong),:),[],[],nan,[],mt_labels_comp,handles,'Competition');
    figure (hc1);
    close;
    figure (hc2);
    htit=get(gca,'Title');
    titstr=get(htit,'String');
    title(strcat(titstr,' [(Vw_O Vs_I) > (Vw_I Vs_O)] X [(Vw_O Vs_I) < (Vw_I Vs_O)]'));
    
end
if do_prism
    
    [hc1,hc2]=Plot_Corr_2MT (var1_prism,var2_prism,tuning_similarity_prism,angular_sep_2var,cutoff,changesameway,mt_labels_prism,handles,'Prism');
    
    if get(handles.prism_vs_normal,'Value')
        [hp1,hp2]=Plot_Corr_2MT_Prism(var1_norm,var1_prism,var2_norm,var2_prism,tuning_similarity_prism,angular_sep_2var,cutoff,mt_labels_prism,handles,'Prism')  ;
    end
    fprintf ('\nFor Prism Data:\nNum cells = %.0f\nNum pairs = %.0f\n',size(var1_prism,1),size(var2_prism,1))
end
% end


% if ~v1_is_mt && v2_is_mt
%     if var2_choice==7
%         plot_var2=tuning_corr_comp;
%     else
%         plot_var2=var2_comp;
%     end
%
%     if do_bimodal
%         keyboard
%     end
%     if do_competition
%         dome=~logical(sum(isnan(plot_var2),2));
%
%         Plot_Corr_1MT (combined_var1(dome),tit1,plot_var2(dome,:),tit2,handles,mt_labels_comp);
%
%
%     end
%     if do_prism
%         keyboard
%     end
% end
% fprintf ('\n~~~ Script Complete.  Type "return" to close figures ~~~\n')
% keyboard
% if exist(hb1,'var')
%     close (hb1,hb2);
% end
% if exist (hc1,'var')
%     close (hc1,hc2);
% end
% if exist (hp1,'var')
%     close (hp1,hp2);
% end

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

