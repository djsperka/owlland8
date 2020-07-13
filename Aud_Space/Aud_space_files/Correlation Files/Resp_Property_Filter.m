function dome_cell=Resp_Property_Filter(handles)
% This will read all the settings from the intro-GUI and return a
% cell-array where each cohort is a column, the first row is the single-site
% mask, and the second row is the pair-wise mask
global site_cell

dome_cell={};

%% Read in Setting
if isfield(handles,'for_Brian')
    % When being run by Brian's GUI
    unit_type=2;
    supe=0;
    inter=0;
    deep=1;
    layer_combo=1;
    same_trode=0;
    
    %required response characteristics
    rrc_vis_tune=0;
    rrc_aud_tune=0;
    rrc_vwi_vwo=0;
    rrc_as=0;
    
else
    % For use with Doug's complete GUI
    unit_type=get(handles.unit_type,'Value');
    supe=get(handles.layer_supe,'Value');
    inter=get(handles.layer_inter,'Value');
    deep=get(handles.layer_deep,'Value');
    layer_combo=get(handles.layer_combo,'Value');
    same_trode=get(handles.same_trode_type,'Value');    
    
    %required response characteristics
    rrc_vis_tune=get(handles.rrc_vis_resp,'Value'); %responds to vis stim
    rrc_aud_tune=get(handles.rrc_aud_resp,'Value'); %responds to aud stim
    rrc_vwi_vwo=get(handles.rrc_vwi_and_vwo,'Value'); %Vw.I>Vw.O
    rrc_as=get (handles.rrc_as,'Value'); %A.S~>0
    
end

%required response characteristics
rrc_vwi=get(handles.rrc_vwi,'Value'); %Vw.I>0
rrc_vwo=get(handles.rrc_vwo,'Value'); %Vw.O~>0
rrc_ai=get(handles.rrc_ai,'Value'); %A.I>0
rrc_ao=get(handles.rrc_ao,'Value'); %A.O~>0

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

for i=1:length(analysis_cell)
    site_data=analysis_cell{i};
    site_combo=length(site_data.data_chans);
    pair_tagger=ones(site_combo,1);
    unit_tagger=ones(length(site_data.id_chan),1);
    
    %% Tag all of the pairs to be analyzed
    % Isolate single or multi units
    [pair_tagger,unit_tagger]=SU_Selector(unit_type,site_data,pair_tagger,unit_tagger);
    if sum(site_data.id_su~=1)>0
        fprintf('\nYou were having trouble with the SU_Selector on 4/19/15 when you ran it with your "interloom" scripts')
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
    
    dome_cell{1,i}=logical(unit_tagger);
    dome_cell{2,i}=logical(pair_tagger);
end
