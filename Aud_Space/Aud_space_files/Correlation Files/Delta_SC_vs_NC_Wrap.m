function Delta_SC_vs_NC_Wrap (handles)
% This is the wrapper for investigating whether dot products change when
% mapping with looming vs static stimuli, and if they do, if there is any
% relationship between the dot product change and a change in noise
% correlation

% Select sites based on response properties
% Retrieve data from sites and concatenate it
% Feed data to processing scripts

dome_cell=Resp_Property_Filter (handles);
% This will read all the settings from the intro-GUI and return a
% cell-array where each cohort is a column, the first row is the single-site
% mask, and the second row is the pair-wise mask


[pair_data]=Data_Grabber (handles);
% This script you will input the file list, a cell containing the list of
% variables/structures you want to retreive from each site

dp_stat=[];
dp_loom=[];
nc_stat=[];
nc_loom=[];
for i=1:length(pair_data);
    if isstruct(pair_data{i})
        dp_stat=[dp_stat;pair_data{i}.dp_stat(dome_cell{2,i})];
        dp_loom=[dp_loom;pair_data{i}.dp_loom(dome_cell{2,i})];
        nc_stat=[nc_stat;pair_data{i}.nc_stat(dome_cell{2,i})];
        nc_loom=[nc_loom;pair_data{i}.nc_loom(dome_cell{2,i})];
    end
end   

Delta_SC_vs_NC_Run (dp_stat,dp_loom,nc_stat,nc_loom); % this will actually compare signal correlations and noise correlations across sites
% The SCvsNC math requires the following information; 
% Signal correlations measured under static and looming conditions
% Noise correlations measured under static and looming conditions

function [pair_data]=Data_Grabber(handles)
% This script is specifically designed to be run with the SC_vs_NC_Wrap
% function.  It grabs static and looming noise correlation and dot product
% data
global site_cell

if isfield(handles,'for_Brian')
    % When being run by Brian's GUI
    var1_choice=3; %visual dot product
    var2_choice=9; %post period noise correlations
else
    % For use with Doug's complete GUI
    var1_choice=get(handles.variable_1,'Value');
    var2_choice=get(handles.variable_2,'Value');
end

if var1_choice==8 || var2_choice==8 %baseline subtracted NC
    %     data_fields{3}='data_mt_resp_corr';
    nc_type=1;
end
if var1_choice==9 || var2_choice==9 %post-NC
    %     data_fields{end+1}='data_mt_post_corr';
    nc_type=2;
end
if var1_choice==10 || var2_choice==10 %pre-NC
    %     data_fields{end+1}='data_mt_pre_corr';
    nc_type=3;
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

% Go through each site and make sure that it has all the fields
for i=1:length(analysis_cell);
    site=analysis_cell{i};
    site_data=[];
    useme=1;
    
    if isfield(site,'data_dp_vis_stat') && isfield(site,'data_dp_vis_loom')
        site_data.dp_stat=site.data_dp_vis_stat;
        site_data.dp_loom=site.data_dp_vis_loom;
        
    else
        useme=0;
    end
    
    stat_pointer=strcmp('Vw_I  ',site.id_mt_labels);
    loom_pointer=strcmp('Vs_I  ',site.id_mt_labels);
    switch nc_type
        case 1
            site_data.nc_stat=site.data_mt_resp_corr(:,stat_pointer);
            site_data.nc_loom=site.data_mt_resp_corr(:,loom_pointer);
        case 2
            site_data.nc_stat=site.data_mt_post_corr(:,stat_pointer);
            site_data.nc_loom=site.data_mt_post_corr(:,loom_pointer);
        case 3
            site_data.nc_stat=site.data_mt_pre_corr(:,stat_pointer);
            site_data.nc_loom=site.data_mt_pre_corr(:,loom_pointer);
    end
    
    if useme
        pair_data{i}=site_data;
    else
        pair_data{i}=nan;
    end
end


        


