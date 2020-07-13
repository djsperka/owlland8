function Pop_Analysis_Run(hObject, eventdata, handles)
global site_cell site_names var1_choice var2_choice

%read in settinga
unit_type=get(handles.unit_type,'Value');
supe=get(handles.layer_supe,'Value');
inter=get(handles.layer_inter,'Value');
deep=get(handles.layer_deep,'Value');
layer_combo=get(handles.layer_combo,'Value');
% stat_loom_type=get(handles.stat_loom_type,'Value');
% lose_weight=get(handles.weight_ave_type,'Value');
same_trode=get(handles.same_trode_type,'Value');
var1_choice=get(handles.variable_1,'Value');
var2_choice=get(handles.variable_2,'Value');
% statloomcomp=get(handles.statloomcomp,'Value');
do_competition=get(handles.do_competition,'Value');
do_bimodal=get(handles.do_bimodal,'Value');

%Initialize assembly vectors
combined_var1=[];
combined_var2=[];
combined_chans=[];
%if either variable is signal or noise correlation
if var1_choice==1 ||var1_choice==4  ||var2_choice==1 ||var2_choice==4 
    combined_p=[];
end

%Initialize statistics outputs
% % p_v1S_v1L=NaN; %p value for comparing static to looming for variable 1
% % p_v2S_v2L=NaN; %p value for comparing static to looming for variable 2
% % p_stat_v1xv2=NaN; %p value for comparing static r(v1,v2)
% % p_loom_v1xv2=NaN; %p value for comparing looming r(v1,v2)
% % p_SvL_v1v2r=NaN; %p value for comparing static r(v1,v2) to looming r(v1,v2)

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
    
    %Remove units that don't have tuning
    bim_ut=unit_tagger;
    vis_ut=unit_tagger;
    aud_ut=unit_tagger;
    bim_ut(~site_data.id_tuned_vis | ~site_data.id_tuned_aud)=0;
    vis_ut(~site_data.id_tuned_vis)=0;
    aud_ut(~site_data.id_tuned_aud)=0;
    
    counter=0;
    bim_pt=pair_tagger;
    vis_pt=pair_tagger;
    aud_pt=pair_tagger;
    for i=1:size(unit_tagger,1)-1
        for j=i+1:size(unit_tagger,1)
            counter=counter+1;
            if bim_ut(i)==0 || bim_ut(j)==0
                bim_pt(counter)=0;
            end
            if vis_ut(i)==0 || vis_ut(j)==0
                vis_pt(counter)=0;
            end
            if aud_ut(i)==0 || aud_ut(j)==0
                aud_pt(counter)=0;
            end
        end
    end
        
    
    %Remove pairs that don't have tuning
    bim_pairs=find(bim_pt==1);
    vis_pairs=find(vis_pt==1);
    aud_pairs=find(aud_pt==1);
    
    bim_units=find(bim_ut==1);
    vis_units=find(vis_ut==1);
    aud_units=find(aud_ut==1);
    
    
    %% Assemble tagged pairs into concatinated vectors
    %%%% Right now this is just programmed to take bimodal units. After SfN
    %%%% adapt to handle any of them
    
    pairflag=[1,1]; % if variable applies to unit pairs, pairflag=1, otherwise =0
    [var1,tit1,pairflag(1)]=Var_Builder(var1_choice,site_data);
    [var2,tit2,pairflag(2)]=Var_Builder(var2_choice,site_data);
    
    if ~pairflag(1)
        site_var1=var1{1}(bim_units,:);
    else
        site_var1=var1{1}(bim_pairs);
    end
    if ~pairflag(2)
        site_var2=var2{1}(bim_units);
    else
        site_var2=var2{1}(bim_pairs);
    end
    chan_pairs=site_data.data_chans(bim_pairs,:);
    
    combined_var1=[combined_var1;site_var1];
    combined_var2=[combined_var2;site_var2];
    combined_chans=[combined_chans;chan_pairs];
    
    %if this was NC data, get the p-values
    if length(var1)>1
        site_p=var1{2}(bim_pairs);
        combined_p=[combined_p;site_p];
    elseif length(var2)>1
        site_p=var2{2}(bim_pairs);
        combined_p=[combined_p;site_p];
    end
    
    
end %end site_cell loop

%% Test for Normality - may want to continue to make use of this
%%%% Just turned this off for now.  Address after SfN

% v1S_norm=~jbtest(combined_var1);
% v2S_norm=~jbtest(combined_var2);

% if get(handles.show_norm_check_on,'Value')
% %Plot Normality
% figure
% hist(combined_var1);
% if v1S_norm; normtit=''; else normtit=' NOT'; end
% title (strcat('V1 Static Distribution -',normtit,' normal'))
% 
% figure
% hist(combined_var2);
% if v2S_norm; normtit=''; else normtit=' NOT'; end
% title (strcat('V2 Static Distribution -',normtit,' normal'))
% 
% end

%% Bin by Dot Product or Seperation
grouped=0;
if (var1_choice==2 || var1_choice==5 || var2_choice==2 || var2_choice==5) && get(handles.bin_sep,'Value')
sep_cutoff=str2num(get(handles.sep_cutoff,'String'));
    group1=find(combined_var1>sep_cutoff);
    group2=find(combined_var1<=sep_cutoff);
    gtype=' Sep';cutoff=sep_cutoff; %set labels
    grouped=1;
end

if (var1_choice==3 || var1_choice==6 || var2_choice==3 || var2_choice==6) && get(handles.bin_DP,'Value')
    dp_cutoff=str2num(get(handles.DP_cutoff,'String'));
    group1=find(combined_var1>dp_cutoff);
    group2=find(combined_var1<=dp_cutoff);
    gtype=' DP'; cutoff=dp_cutoff; %set labels
    grouped=1;
end

%% Generate Plots and Perform Statistical Comparisons
''

%%%%%%% START HERE WHEN YOU RETURN ... don't just delet the static vs loom
%%%%%%% stuff ... there may be some useful title-changing that you can
%%%%%%% recycle. Glance through it first, then start trying to code up the
%%%%%%% different analyses you have listed on your ppt document. 
%% STATIC vs LOOM
% if get(handles.sing_var_stat_on,'Value')
% %Var1 comparison
% if v1S_norm && v1L_norm
%     v1_norm=1;
% else
%     v1_norm=0;
% end
% 
% if ~grouped
%     [t_out,p_disp1]=SvL_OneDim(combined_var1,combined_var1_loom,v1_norm);
%     title(strcat('Static vs Looming :: ',t_out))
%     set (handles.v1S_v1L_disp,'String',num2str(p_disp1,3)); 
%     ylabel (tit1)
% else
%     [t_out,p_disp1]=SvL_OneDim(combined_var1(group1),combined_var1_loom(group1),v1_norm);
%     title(strcat('Static vs Looming :: Static',gtype,'>',num2str(cutoff),t_out))
%     ylabel (tit1)
%     [t_out,p_disp1]=SvL_OneDim(combined_var1(group2),combined_var1_loom(group2),v1_norm);
%     title(strcat('Static vs Looming :: Static',gtype,'<=',num2str(cutoff),t_out))
%     ylabel (tit1)
% end
% 
% 
% %Var2 Comparison
% if v2S_norm && v2L_norm %if v1 static and loom both normally distributed
%     v2_norm=1;
% else
%     v2_norm=0;
% end
% 
% if ~grouped
%     [t_out,p_disp2]=SvL_OneDim(combined_var2,combined_var2_loom,v2_norm);
%     title(strcat('Static vs Looming :: ',t_out))
%     set (handles.v2S_v2L_disp,'String',num2str(p_disp2,3));
%     ylabel(tit2)
% else
%     [t_out,p_disp2]=SvL_OneDim(combined_var2(group1),combined_var2_loom(group1),v2_norm);
%     title(strcat('Static vs Looming :: Static',gtype,'>',num2str(cutoff),t_out))
%     ylabel(tit2)
%     [t_out,p_disp2]=SvL_OneDim(combined_var2(group2),combined_var2_loom(group2),v2_norm);
%     title(strcat('Static vs Looming :: Static',gtype,'<=',num2str(cutoff),t_out))
%     ylabel(tit2)
% end
% 
% 
% % %%% Display Statistics
% % set (handles.v1S_v1L,'String',num2str(p_v1S_v1L,3));
% % set (handles.v2S_v2L,'String',num2str(p_v2S_v2L,3));
% 
% end

%% VAR1 VAR2 Interactions
if get(handles.two_var_stat_on,'Value')
%if there are p-values
if length(var1)>2 || length(var2)>2 
%     if stat_loom_type==1
%         %VAR1 vs VAR2 - Correlation and Scatter Plot
%         [p_stat_v1xv2,r_stat_v1xv2]=Corr_Scatter(combined_var1_stat,combined_var2_stat,combined_p_stat);
%         title('Static')
%         [p_loom_v1xv2,r_loom_v1xv2]=Corr_Scatter(combined_var1_loom,combined_var2_loom,combined_p_loom);
%         title('Loom')
% 
%         %STAT vs LOOM - V1xV2 Correlation 
%         p_SvL_v1v2r=CorrComp(r_stat_v1xv2,r_loom_v1xv2,length(combined_var1_stat),length(combined_var1_loom));
% 
%     elseif stat_loom_type==2
%         %VAR1 vs VAR2 - Correlation and Scatter Plot
%         [p_stat_v1xv2,r_stat_v1xv2]=Corr_Scatter(combined_var1_stat,combined_var2_stat,combined_p_stat);
%         title('Static')
%     elseif stat_loom_type==3
%         %VAR1 vs VAR2 - Correlation and Scatter Plot
%         [p_loom_v1xv2,r_loom_v1xv2]=Corr_Scatter(combined_var1_loom,combined_var2_loom,combined_p_loom);
%         title('Loom')
%     end

%there aren't p values
else 
%     if stat_loom_type==1
%         [p_stat_v1xv2,r_stat_v1xv2]=Corr_Scatter(combined_var1_stat,combined_var2_stat);
%         title('Static')
%         [p_loom_v1xv2,r_loom_v1xv2]=Corr_Scatter(combined_var1_loom,combined_var2_loom);
%         title('Loom')
%                 
%         p_SvL_v1v2r=CorrComp(r_stat_v1xv2,r_loom_v1xv2,length(combined_var1_stat),length(combined_var1_loom));
% 
%     elseif stat_loom_type==2
%         [p_stat_v1xv2,r_stat_v1xv2]=Corr_Scatter(combined_var1_stat,combined_var2_stat);
%         title('Static')
%     elseif stat_loom_type==3
%         [p_loom_v1xv2,r_loom_v1xv2]=Corr_Scatter(combined_var1_loom,combined_var2_loom);
%         title('Loom')
%     end
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


% 

    