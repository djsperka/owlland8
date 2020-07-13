function SC_vs_NC_for_Brian(handles)
% Signal Correlation vs Noise Correlation for Brian
% Intialize function
% Grab appropriate data
% Run analyses

[mod_script,save_figs,nc_choice,sc_choice,use_vwi,use_vwo,use_vsi,use_vso,use_ai,use_ao,stat_loom_anc]=SCvNC_Starter();

if mod_script
    dbstack
    keyboard
end

% Set Paths
start_cd=cd;
cd ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition')
if save_figs
    save_cd=uigetdir;
end
cd (start_cd);

% Make figure labels
switch nc_choice
    case 1
        nc_label='Post NC'; %post period
    case 2
        nc_label='Pre NC'; %pre period
    case 3
        nc_label='Resp NC'; %baseline subtracted
end
switch sc_choice
    case 1
        sc_label='Dot Product';
    case 2
        sc_label='Peak Separation';
end

% set size of saved plots
notes_x_width=4; notes_y_width=3.5;
paper_x_width=2.5 ;paper_y_width=2;
rez='300'; %dpi ... needs to be a string

% set data sizes
unity_width=1;
dotsize=4;
reg_width=1.5;

dome_cell=Resp_Property_Filter (handles);
% This will read all the settings from the intro-GUI and return a
% cell-array where each cohort is a column, the first row is the single-site
% mask, and the second row is the pair-wise mask

% Plot static in
if use_vwi
    stim_label='Vw_I  ';
    [pop_sc,pop_nc]=Data_Grabber (handles,dome_cell,nc_choice,sc_choice,stim_label);
    legtxt=Plot_XvsY(pop_sc,pop_nc,0,unity_width,dotsize,reg_width);
    title (sprintf('%s vs %s for Static In',sc_label,nc_label))
    xlabel(sprintf('VRF %s',sc_label))
    ylabel('Static Noise Correlation')
    legend (legtxt);
    
    if save_figs
        cd(save_cd)
        fig_name='SCvNC_Stat';
        Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width,paper_y_width,rez)
        cd (start_cd)
    end

end

% Plot static out
if use_vwo
    stim_label='Vw_O  ';
    [pop_sc,pop_nc]=Data_Grabber (handles,dome_cell,nc_choice,sc_choice,stim_label);
    legtxt=Plot_XvsY(pop_sc,pop_nc,0,unity_width,dotsize,reg_width);
    title (sprintf('%s vs %s for Static Out',sc_label,nc_label))
    xlabel(sprintf('VRF %s',sc_label))
    ylabel('Static Noise Correlation')
    legend (legtxt);
        
    if save_figs
        cd(save_cd)
        fig_name='SCvNC_Stat_OUT';
        Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width,paper_y_width,rez)
        cd (start_cd)
    end
end

% Plot looming in
if use_vsi
    stim_label='Vs_I  ';
    [pop_sc,pop_nc]=Data_Grabber (handles,dome_cell,nc_choice,sc_choice,stim_label);
    legtxt=Plot_XvsY(pop_sc,pop_nc,0,unity_width,dotsize,reg_width);
    title (sprintf('%s vs %s for Looming In',sc_label,nc_label))
    xlabel(sprintf('VRF %s',sc_label))
    ylabel('Looming Noise Correlation')
    legend (legtxt);
    
    if save_figs
        cd(save_cd)
        fig_name='SCvNC_Loom';
        Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width,paper_y_width,rez)
        cd (start_cd)
    end
end

% Plot looming out
if use_vso
    stim_label='Vs_O  ';
    [pop_sc,pop_nc]=Data_Grabber (handles,dome_cell,nc_choice,sc_choice,stim_label);
    legtxt=Plot_XvsY(pop_sc,pop_nc,0,unity_width,dotsize,reg_width);
    title (sprintf('%s vs %s for Looming Out',sc_label,nc_label))
    xlabel(sprintf('VRF %s',sc_label))
    ylabel('Looming Noise Correlation')
    legend (legtxt);
    
    if save_figs
        cd(save_cd)
        fig_name='SCvNC_Loom_OUT';
        Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width,paper_y_width,rez)
        cd (start_cd)
    end
end

% Plot Auditory In
if use_ai
    stim_label='A_I  ';
    [pop_sc,pop_nc]=Data_Grabber (handles,dome_cell,nc_choice,sc_choice+2,stim_label);
    legtxt=Plot_XvsY(pop_sc,pop_nc,0,unity_width,dotsize,reg_width);
    title (sprintf('%s vs %s for Auditory In',sc_label,nc_label))
    xlabel(sprintf('ARF %s',sc_label))
    ylabel('Aud Noise Correlation')
    legend (legtxt);
        
    if save_figs
        cd(save_cd)
        fig_name='SCvNC_Aud';
        Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width,paper_y_width,rez)
        cd (start_cd)
    end
    
end

% Plot Auditory Out
if use_ao
    stim_label='A_O  ';
    [pop_sc,pop_nc]=Data_Grabber (handles,dome_cell,nc_choice,sc_choice+2,stim_label);
    legtxt=Plot_XvsY(pop_sc,pop_nc,0,unity_width,dotsize,reg_width);
    title (sprintf('%s vs %s for Auditory Out',sc_label,nc_label))
    xlabel(sprintf('ARF %s',sc_label))
    ylabel('Aud Noise Correlation')
    legend (legtxt);
    
    if save_figs
        cd(save_cd)
        fig_name='SCvNC_Aud_OUT';
        Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width,paper_y_width,rez)
        cd (start_cd)
    end
end

if stat_loom_anc
    stim_label='Vw_I  ';
    [stat_sc,stat_nc]=Data_Grabber (handles,dome_cell,nc_choice,sc_choice,stim_label);
    stim_label='Vs_I  ';
    [loom_sc,loom_nc]=Data_Grabber (handles,dome_cell,nc_choice,sc_choice,stim_label);
    dropme=isnan(stat_nc) | isnan(loom_nc);
    sc=stat_sc(~dropme);
    stat_nc=stat_nc(~dropme);
    loom_nc=loom_nc(~dropme);
    aoc_x=[sc;sc];
    aoc_y=[stat_nc;loom_nc];
    group=[ones(size(sc),1);2*ones(size(sc),1)];
    aoctool(aoc_x,aoc_y,group)
    
    dbstack
    keyboard
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [pop_sc,pop_nc]=Data_Grabber(handles,dome_cell,nc_type,dp_type,stim_label)
% This script is specifically designed to be run with the SC_vs_NC_Wrap
% function.  It grabs static and looming noise correlation and dot product
% data
global site_cell

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

pop_sc=[];
pop_nc=[];
% Go through each site and make sure that it has all the fields
for i=1:length(analysis_cell);
    site=analysis_cell{i};
    dome=dome_cell{2,i};
    
    % Grab noise correlations
    mt_pointer=strcmp(stim_label,site.id_mt_labels);
    
    % if this site had the data you are after
    if sum(mt_pointer)~=0
        
        % Grab Dot Product Data
        switch dp_type
            case 1
                pop_sc=[pop_sc;site.data_dp_vis(dome)];
            case 2
                pop_sc=[pop_sc;site.data_wap_sep_vis(dome)];
            case 3
                pop_sc=[pop_sc;site.data_dp_aud(dome)];
            case 4
                pop_sc=[pop_sc;site.data_wap_sep_aud(dome)];
                
        end
        
        % Grab Noise Correlation Data
        switch nc_type
            case 1
                pop_nc=[pop_nc;site.data_mt_post_corr(dome,mt_pointer)];
            case 2
                pop_nc=[pop_nc;site.data_mt_pre_corr(dome,mt_pointer)];
            case 3
                pop_nc=[pop_nc;site.data_mt_resp_corr(dome,mt_pointer)];
        end
        
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%


function legtxt=Plot_XvsY (x,y,logger,unity_width,dotsize,reg_width)
lincols=linspecer(2);

my_xlims=[-.35 1];
my_ylims=[-.4 1];

% drop nans
dropme=isnan(x) | isnan(y);
x(dropme)=[];
y(dropme)=[];

X=[ones(size(x)),x];
[B,~,~,~,S]=regress(y,X);
pfits=fliplr(B');
se=S(4)^.5;
xminmax= [min(x),max(x)];
[rho,p]=corr(x,y);

h=figure;
hold on
if logger
%     plot (log2(x+1),log2(y+1),'.','MarkerSize',dotsize,'Color',lincols(1,:))
%     plot (log2(mean(x)+1),log2(mean(y)+1),'rd','MarkerSize',10,'LineWidth',2,'Color',lincols(2,:))
    plot (log2(x+1),log2(y+1),'ok','MarkerSize',dotsize)
    plot (log2(mean(x)+1),log2(mean(y)+1),'dk','MarkerSize',10,'LineWidth',2)
    plotfit_x=xminmax(1):.01:xminmax(2);
    plotfit_y=[plotfit_x',ones(size(plotfit_x'))]*pfits';
%     plot (log2(plotfit_x+1),log2(plotfit_y+1),'--','LineWidth',reg_width,'Color',lincols(2,:))
    plot (log2(plotfit_x+1),log2(plotfit_y+1),'--k','LineWidth',reg_width)
else
%     plot (x,y,'.','MarkerSize',dotsize,'Color',lincols(1,:))
%     plot (mean(x),mean(y),'rd','MarkerSize',10,'LineWidth',2,'Color',lincols(2,:))
%     plot (xminmax,[xminmax',ones(size(xminmax'))]*pfits','--','LineWidth',reg_width,'Color',lincols(2,:))
    plot (x,y,'ok','MarkerSize',dotsize)
    plot (mean(x),mean(y),'dk','MarkerSize',10,'LineWidth',2)
    plot (xminmax,[xminmax',ones(size(xminmax'))]*pfits','--k','LineWidth',reg_width)
end

set (gca,'xlim',my_xlims);
set(gca,'ylim',my_ylims);

plotlimx=get(gca,'xlim');
plot (plotlimx,plotlimx,':k','LineWidth',unity_width)
legtxt{1}=sprintf('Data; n=%i',length(x));
legtxt{2}=sprintf('Mean = [%.2f %.2f]',mean(x),mean(y));
legtxt{3}=sprintf('y= %.2f*x + %.2f + noise(%.4f)\n r= %.2f, p=%.4f',pfits(1),pfits(2),se,rho,p);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width,paper_y_width,rez)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(gcf,sprintf('Notes_%s',fig_name),'-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
        print(gcf,sprintf('Paper_%s',fig_name),'-dpng',['-r',rez]) %Save it!
        
        