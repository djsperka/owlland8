function Pop_Analysis_Run_interloom(hObject, eventdata, handles)
global site_cell site_names var1_choice var2_choice

%read in setting
unit_type=get(handles.unit_type,'Value');
supe=get(handles.layer_supe,'Value');
inter=get(handles.layer_inter,'Value');
deep=get(handles.layer_deep,'Value');
layer_combo=get(handles.layer_combo,'Value');
stat_loom_type=get(handles.stat_loom_type,'Value');
% lose_weight=get(handles.weight_ave_type,'Value');
same_trode=get(handles.same_trode_type,'Value');
var1_choice=get(handles.variable_1,'Value');
var2_choice=get(handles.variable_2,'Value');
statloomcomp=get(handles.statloomcomp,'Value');

%Initialize assembly vectors
combined_var1_stat=[];
combined_var2_stat=[];
combined_var1_loom=[];
combined_var2_loom=[];
combined_chans=[];
combined_siteids=[];
%if either variable is signal or noise correlation
if var1_choice==1 ||var1_choice==5 ||var1_choice==6 ||var2_choice==1 ||var2_choice==5 ||var2_choice==6
    combined_p_stat=[];
    combined_p_loom=[];
end

%Initialize statistics outputs
p_v1S_v1L=NaN; %p value for comparing static to looming for variable 1
p_v2S_v2L=NaN; %p value for comparing static to looming for variable 2
p_stat_v1xv2=NaN; %p value for comparing static r(v1,v2)
p_loom_v1xv2=NaN; %p value for comparing looming r(v1,v2)
p_SvL_v1v2r=NaN; %p value for comparing static r(v1,v2) to looming r(v1,v2)

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

%Loop through all the datasets
site_ids=cell(size(analysis_cell));
for i=1:length(analysis_cell)
    
    site_data=analysis_cell{i};
    site_ids{i}=strcat(site_data.site_date,' :: ',site_data.site_id);
    site_combo=length(site_data.data_chans);
    pair_tagger=ones(site_combo,1);
    var1=Var_Builder_interloom(var1_choice,site_data);
    var2=Var_Builder_interloom(var2_choice,site_data);
    
    %% Tag all of the pairs to be analyzed
    % Isolate single or multi units
    
    
    pair_tagger=SU_Selector(unit_type,site_data,pair_tagger);
    fprintf('\nERROR:  Last time you were messing with this (on 4/19/15) you noticed\n',...
    ' that your after running through the SU_Selector you channel combinations were\n',...
    ' messed up.  There seemed to be an impossible set of combinations.  Look into it!')
dbstack
keyboard
    
    % Sort by layers
    
    if ~supe
        %if superficial layers aren't selected, drop all pairs w/ superficial
        %units
        pair_tagger=Layer_Selector (1,site_data,pair_tagger);
    end
    
    if ~inter
        pair_tagger=Layer_Selector (2,site_data,pair_tagger);
    end
    
    if ~deep
        pair_tagger=Layer_Selector (3,site_data,pair_tagger);
    end
    
    % Sort by layer combination (ie. supeXsupe, supeXdeep etc)
    
    pair_tagger=Layer_Combo_Selector (layer_combo,site_data,pair_tagger);
    
    % Remove pairs that are from the same electrode
    if same_trode
        pair_tagger=Same_Trode_Dropper(site_data,pair_tagger);
    end
    
    % Remove sites that did not generate clean weighted average values
    % if lose_weight
    % %     [stat_tagger,loom_tagger]=Bad_Weight_Dropper(site_data,pair_tagger);
    %      [pair_tagger]=Bad_Weight_Dropper(site_data,pair_tagger);
    % % else
    % %     stat_tagger=pair_tagger;
    % %     loom_tagger=pair_tagger;
    % end
    
    % stat_pairs=find(stat_tagger==1);
    % loom_pairs=find(loom_tagger==1);
    pairs=find(pair_tagger==1);
    
    %% Assemble the tagged pairs into concatinated vectors
    %Assemble both static and looming
    if stat_loom_type==1
        
        %     site_var1_stat=var1{1}(stat_pairs);
        %     site_var2_stat=var2{1}(stat_pairs);
        %     site_var1_loom=var1{2}(loom_pairs);
        %     site_var2_loom=var2{2}(loom_pairs);
        site_var1_stat=var1{1}(pairs);
        site_var2_stat=var2{1}(pairs);
        site_var1_loom=var1{2}(pairs);
        site_var2_loom=var2{2}(pairs);
        chan_pairs=site_data.data_chans(pairs,:);
        
        combined_var1_stat=[combined_var1_stat;site_var1_stat];
        combined_var2_stat=[combined_var2_stat;site_var2_stat];
        combined_var1_loom=[combined_var1_loom;site_var1_loom];
        combined_var2_loom=[combined_var2_loom;site_var2_loom];
        combined_chans=[combined_chans;chan_pairs];
        combined_siteids=[combined_siteids;ones(size(pairs))*i];
        
        if length(var1)>2
            %         site_p_stat=var1{3}(stat_pairs);
            %         site_p_loom=var1{4}(loom_pairs);
            site_p_stat=var1{3}(pairs);
            site_p_loom=var1{4}(pairs);
            combined_p_stat=[combined_p_stat;site_p_stat];
            combined_p_loom=[combined_p_loom;site_p_loom];
        elseif length(var2)>2
            %         site_p_stat=var2{3}(stat_pairs);
            %         site_p_loom=var2{4}(loom_pairs);
            site_p_stat=var2{3}(pairs);
            site_p_loom=var2{4}(pairs);
            combined_p_stat=[combined_p_stat;site_p_stat];
            combined_p_loom=[combined_p_loom;site_p_loom];
        end
        
        %just static
    elseif stat_loom_type==2
        
        %     site_var1_stat=var1{1}(stat_pairs);
        %     site_var2_stat=var2{1}(stat_pairs);
        site_var1_stat=var1{1}(pairs);
        site_var2_stat=var2{1}(pairs);
        
        combined_var1_stat=[combined_var1_stat;site_var1_stat];
        combined_var2_stat=[combined_var2_stat;site_var2_stat];
        
        if length(var1)>2
            %         site_p_stat=var1{3}(stat_pairs);
            site_p_stat=var1{3}(pairs);
            combined_p_stat=[combined_p_stat;site_p_stat];
        elseif length(var2)>2
            %         site_p_stat=var2{3}(stat_pairs);
            site_p_stat=var2{3}(pairs);
            combined_p_stat=[combined_p_stat;site_p_stat];
        end
        
        %just looming
    elseif stat_loom_type==3
        
        %     site_var1_loom=var1{2}(loom_pairs);
        %     site_var2_loom=var2{2}(loom_pairs);
        site_var1_loom=var1{2}(pairs);
        site_var2_loom=var2{2}(pairs);
        
        combined_var1_loom=[combined_var1_loom;site_var1_loom];
        combined_var2_loom=[combined_var2_loom;site_var2_loom];
        
        if length(var1)>2
            %         site_p_loom=var1{4}(loom_pairs);
            site_p_loom=var1{4}(pairs);
            combined_p_loom=[combined_p_loom;site_p_loom];
        elseif length(var2)>2
            %         site_p_loom=var2{4}(loom_pairs);
            site_p_loom=var2{4}(pairs);
            combined_p_loom=[combined_p_loom;site_p_loom];
        end
        
    end %end static/looming selection loop
    
end %end site_cell loop

%% Test for Normality

v1S_norm=~jbtest(combined_var1_stat);
v1L_norm=~jbtest(combined_var1_loom);
v2S_norm=~jbtest(combined_var2_stat);
v2L_norm=~jbtest(combined_var2_loom);

if get(handles.show_norm_check_on,'Value')
    %Plot Normality
    figure
    hist(combined_var1_stat);
    if v1S_norm; normtit=''; else normtit=' NOT'; end
    title (strcat('V1 Static Distribution -',normtit,' normal'))
    figure
    hist(combined_var1_loom);
    if v1L_norm; normtit=''; else normtit=' NOT'; end
    title (strcat('V1 Loom Distribution -',normtit,' normal'))
    figure
    hist(combined_var2_stat);
    if v2S_norm; normtit=''; else normtit=' NOT'; end
    title (strcat('V2 Static Distribution -',normtit,' normal'))
    figure
    hist(combined_var2_loom);
    if v2L_norm; normtit=''; else normtit=' NOT'; end
    title (strcat('V2 Loom Distribution -',normtit,' normal'))
end

%% Generate Plots and Perform Statistical Comparisons
dp_cutoff=str2num(get(handles.DP_cutoff,'String'));
sep_cutoff=str2num(get(handles.sep_cutoff,'String'));
grouped=0;
grouped=0;
%Get correct titles
switch var1_choice
    case 1; tit1='Noise Correlation (r)';
    case 2; tit1='Peak COM Seperation (degrees)';
        if get(handles.bin_sep,'Value')
            group1=find(combined_var1_stat>sep_cutoff);
            group2=find(combined_var1_stat<=sep_cutoff);
            gtype=' Sep';cutoff=sep_cutoff; %set labels
            grouped=1;
        end
    case 3; tit1='Global COM Seperation (degrees)';
    case 4; tit1='Dot Product';
        if get(handles.bin_DP,'Value')
            group1=find(combined_var1_stat>dp_cutoff);
            group2=find(combined_var1_stat<=dp_cutoff);
            gtype=' DP'; cutoff=dp_cutoff; %set labels
            grouped=1;
        end
    case 5; tit1='Ongoing NC (r)';
    case 6; tit1='Raw NC (r)';
end

switch var2_choice
    case 1; tit2='Noise Correlation (r)';
    case 2; tit2='Peak COM Seperation (degrees)';
        if get(handles.bin_sep,'Value')
            group1=find(combined_var2_stat>sep_cutoff);
            group2=find(combined_var2_stat<=sep_cutoff);
            gtype=' Sep';cutoff=sep_cutoff; %set labels
            grouped=1;
        end
    case 3; tit2='Global COM Seperation (degrees)';
    case 4; tit2='Dot Product';
        if get(handles.bin_DP,'Value')
            group1=find(combined_var2_stat>dp_cutoff);
            group2=find(combined_var2_stat<=dp_cutoff);
            gtype=' DP'; cutoff=dp_cutoff; %set labels
            grouped=1;
        end
    case 5; tit2='Ongoing NC(r)';
    case 6; tit2='Raw NC (r)';
end

%% STATIC vs LOOM
if get(handles.sing_var_stat_on,'Value')
    %Var1 comparison
    if v1S_norm && v1L_norm
        v1_norm=1;
    else
        v1_norm=0;
    end
    
    if ~grouped
        [t_out,p_disp1]=SvL_OneDim(combined_var1_stat,combined_var1_loom,v1_norm);
        title(strcat('Static vs Looming :: ',t_out))
        set (handles.v1S_v1L_disp,'String',num2str(p_disp1,3));
        ylabel (tit1)
    else
        [t_out,p_disp1]=SvL_OneDim(combined_var1_stat(group1),combined_var1_loom(group1),v1_norm);
        title(strcat('Static vs Looming :: Static',gtype,'>',num2str(cutoff),t_out))
        ylabel (tit1)
        [t_out,p_disp1]=SvL_OneDim(combined_var1_stat(group2),combined_var1_loom(group2),v1_norm);
        title(strcat('Static vs Looming :: Static',gtype,'<=',num2str(cutoff),t_out))
        ylabel (tit1)
    end
    
    
    %Var2 Comparison
    if v2S_norm && v2L_norm %if v1 static and loom both normally distributed
        v2_norm=1;
    else
        v2_norm=0;
    end
    
    if ~grouped
        [t_out,p_disp2]=SvL_OneDim(combined_var2_stat,combined_var2_loom,v2_norm);
        title(strcat('Static vs Looming :: ',t_out))
        set (handles.v2S_v2L_disp,'String',num2str(p_disp2,3));
        ylabel(tit2)
    else
        [t_out,p_disp2]=SvL_OneDim(combined_var2_stat(group1),combined_var2_loom(group1),v2_norm);
        title(strcat('Static vs Looming :: Static',gtype,'>',num2str(cutoff),t_out))
        ylabel(tit2)
        [t_out,p_disp2]=SvL_OneDim(combined_var2_stat(group2),combined_var2_loom(group2),v2_norm);
        title(strcat('Static vs Looming :: Static',gtype,'<=',num2str(cutoff),t_out))
        ylabel(tit2)
    end
    
    %Show how many units/pairs were in each analysis
    if ~grouped
        fprintf('\n\n-------------Ungrouped Units and Pairs for Analyse-------------\n')
        for i=1:length(analysis_cell)
            this_site=combined_siteids==i;
            site_chan_combos=combined_chans(this_site,:);
            fprintf('%s  \t%.0funits,\t%.0fpairs\n',site_ids{i},length(unique(site_chan_combos(:))),sum(this_site))
        end
    else
        
        fprintf('\n\n-------------Group 1 (Positive SigCorr) Units and Pairs for Analyse-------------\n')
        for i=1:length(analysis_cell)
            this_site=combined_siteids==i;
            this_site(group2)=0;
            site_chan_combos=combined_chans(this_site,:);
            fprintf('%s  \t%.0funits,\t%.0fpairs\n',site_ids{i},length(unique(site_chan_combos(:))),sum(this_site))
        end
        
        fprintf('\n\n-------------Group 2 (Negative SigCorr) Units and Pairs for Analyse-------------\n')
        for i=1:length(analysis_cell)
            this_site=combined_siteids==i;
            this_site(group1)=0;
            site_chan_combos=combined_chans(this_site,:);
            fprintf('%s  \t%.0funits,\t%.0fpairs\n',site_ids{i},length(unique(site_chan_combos(:))),sum(this_site))
        end
        
    end
    keyboard
    
    % %%% Display Statistics
    % set (handles.v1S_v1L,'String',num2str(p_v1S_v1L,3));
    % set (handles.v2S_v2L,'String',num2str(p_v2S_v2L,3));
    
end

%% VAR1 VAR2 Interactions
if get(handles.two_var_stat_on,'Value')
    %if there are p-values
    if length(var1)>2 || length(var2)>2
        if stat_loom_type==1
            %VAR1 vs VAR2 - Correlation and Scatter Plot
            [p_stat_v1xv2,r_stat_v1xv2]=Corr_Scatter(combined_var1_stat,combined_var2_stat,combined_p_stat);
            title('Static')
            [p_loom_v1xv2,r_loom_v1xv2]=Corr_Scatter(combined_var1_loom,combined_var2_loom,combined_p_loom);
            title('Loom')
            
            %STAT vs LOOM - V1xV2 Correlation
            p_SvL_v1v2r=CorrComp(r_stat_v1xv2,r_loom_v1xv2,length(combined_var1_stat),length(combined_var1_loom));
            
        elseif stat_loom_type==2
            %VAR1 vs VAR2 - Correlation and Scatter Plot
            [p_stat_v1xv2,r_stat_v1xv2]=Corr_Scatter(combined_var1_stat,combined_var2_stat,combined_p_stat);
            title('Static')
        elseif stat_loom_type==3
            %VAR1 vs VAR2 - Correlation and Scatter Plot
            [p_loom_v1xv2,r_loom_v1xv2]=Corr_Scatter(combined_var1_loom,combined_var2_loom,combined_p_loom);
            title('Loom')
        end
        
        %there aren't p values
    else
        if stat_loom_type==1
            [p_stat_v1xv2,r_stat_v1xv2]=Corr_Scatter(combined_var1_stat,combined_var2_stat);
            title('Static')
            [p_loom_v1xv2,r_loom_v1xv2]=Corr_Scatter(combined_var1_loom,combined_var2_loom);
            title('Loom')
            
            p_SvL_v1v2r=CorrComp(r_stat_v1xv2,r_loom_v1xv2,length(combined_var1_stat),length(combined_var1_loom));
            
        elseif stat_loom_type==2
            [p_stat_v1xv2,r_stat_v1xv2]=Corr_Scatter(combined_var1_stat,combined_var2_stat);
            title('Static')
        elseif stat_loom_type==3
            [p_loom_v1xv2,r_loom_v1xv2]=Corr_Scatter(combined_var1_loom,combined_var2_loom);
            title('Loom')
        end
    end
    %%% Display Statistics
    set (handles.rstat,'String',num2str(p_stat_v1xv2,3));
    set (handles.rloom,'String',num2str(p_loom_v1xv2,3));
    set (handles.rS_rL,'String',num2str(p_SvL_v1v2r,3));
end


%% %%%%%%%%%%%%%%%%CODE DUMP
%% I don't think this code was actually doing anything useful.  Scubbed it for now
% if statloomcomp==1 && stat_loom_type==1
%
% %     r_junk=Corr_Scatter(combined_var1_stat,combined_var1_loom);
%     title(tit1)
%     xlabel('Static')
%     ylabel('Loom')
% %     r_junk=Corr_Scatter(combined_var2_stat,combined_var2_loom);
%     title(tit2)
%     xlabel('Static')
%     ylabel('Loom')
%
% elseif statloomcomp==1 && ~stat_loom_type==1
% fprintf ('\n\nERROR! can''t select *both* for static/loom if trying to do a stat:loom comparison\n')
% end
