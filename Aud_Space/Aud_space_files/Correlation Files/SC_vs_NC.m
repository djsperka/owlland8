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
if save_figs
    start_cd=cd;
%     cd ('C:\Users\debellolab\Box Sync\Dougs DeBello Dump\Publications')
    save_cd=uigetdir;
    cd (start_cd);
end

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
    case 3
        sc_label='Geometric Mean';
    case 4
        sc_label='SRF Derivative';
end

% set size of saved plots
notes_x_width=4; notes_y_width=3.5;
paper_x_width=3 ;paper_y_width=2.5;
rez='300'; %dpi ... needs to be a string

% set data sizes
unity_width=1;
dotsize=4;
reg_width=.5;

dome_cell=Resp_Property_Filter (handles);
% This will read all the settings from the intro-GUI and return a
% cell-array where each cohort is a column, the first row is the single-site
% mask, and the second row is the pair-wise mask

% Plot static in
if use_vwi
    stim_label='Vw_I  ';
    [pop_sc,pop_nc]=Data_Grabber (handles,dome_cell,nc_choice,sc_choice,stim_label);
    global stat_ps stat_dp stat_gm stat_nc
    legtxt=Plot_XvsY(pop_sc,pop_nc,0,unity_width,dotsize,reg_width);
    title (sprintf('%s vs %s for Static In',sc_label,nc_label))
    xlabel(sprintf('VRF %s',sc_label))
    ylabel('Static Noise Correlation')
    legend (legtxt);
    
    if save_figs
        cd(save_cd)
        fig_name=sprintf('%s_v_NC_Stat',sc_label);
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
        fig_name=sprintf('%s_v_NC_Stat_OUT',sc_label);
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
        fig_name=sprintf('%s_v_NC_Loom',sc_label);
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
        fig_name=sprintf('%s_v_NC_Loom_OUT',sc_label);
        Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width,paper_y_width,rez)
        cd (start_cd)
    end
end

% Plot Auditory In
if use_ai
    stim_label='A_I  ';
    [pop_sc,pop_nc]=Data_Grabber (handles,dome_cell,nc_choice,sc_choice+4,stim_label);
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
    [pop_sc,pop_nc]=Data_Grabber (handles,dome_cell,nc_choice,sc_choice+4,stim_label);
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

%%% Perform ANCOVA
if stat_loom_anc
    
    stim_label='Vw_I  ';
    [stat_sc,stat_nc]=Data_Grabber (handles,dome_cell,nc_choice,sc_choice,stim_label);
    dropme=isnan(stat_nc) | isnan(stat_sc);
    stat_sc=stat_sc(~dropme);
    stat_nc=stat_nc(~dropme);
    [stat_corr,stat_corr_p]=corr(stat_sc,stat_nc);
    linfit_stat=polyfit(stat_sc,stat_nc,1);
    
    stim_label='Vs_I  ';
    [loom_sc,loom_nc]=Data_Grabber (handles,dome_cell,nc_choice,sc_choice,stim_label);
    dropme=isnan(loom_nc) | isnan(loom_sc);
    loom_nc=loom_nc(~dropme);
    loom_sc=loom_sc(~dropme);
    [loom_corr,loom_corr_p]=corr(loom_sc,loom_nc);
    linfit_loom=polyfit(loom_sc,loom_nc,1);
    
    aoc_x=[stat_sc;loom_sc];
    aoc_y=[stat_nc;loom_nc];
    group=[ones(size(stat_sc),1);2*ones(size(loom_sc),1)];
    aoctool(aoc_x,aoc_y,group)
    
    figure
    hold on
    legtxt={};
    plot (stat_sc,stat_nc,'bo','MarkerSize',3)
    legtxt{1}=sprintf('Static(n=%.0f): [%.2f %.2f]\nNC=%.2f*SC+%.2f  :  rho%.2f, p=%.4f',length(stat_sc),mean(stat_sc),mean(stat_nc),linfit_stat(1),linfit_stat(2),stat_corr,stat_corr_p);
    plot (loom_sc,loom_nc,'rs','MarkerSize',3)
    legtxt{2}=sprintf('Looming(n=%.0f): [%.2f %.2f]\nNC=%.2f*SC+%.2f  :  rho%.2f, p=%.4f',length(loom_sc),mean(loom_sc),mean(loom_nc),linfit_loom(1),linfit_loom(2),loom_corr,loom_corr_p);
    linx=[-.5 1];
    plot (linx,linfit_stat*[linx;1,1],'b--')
    plot (linx,linfit_loom*[linx;1,1],'r--')
    plot (mean(stat_sc),mean(stat_nc),'bo','MarkerFace','b','MarkerSize',8,'LineWidth',.1)
    plot (mean(loom_sc),mean(loom_nc),'rs','MarkerFace','r','MarkerSize',7,'LineWidth',.1)
    
    set(gca,'xlim',[min([stat_sc(:);loom_sc(:)])-.1, 1]);
    title (sprintf('%s vs %s for Static and Looming',sc_label,nc_label))
    xlabel(sprintf('VRF %s',sc_label))
    ylabel('Noise Correlation')
    legend (legtxt);
    
%     legtxt=Plot_XvsY(aoc_x,aoc_y,0,unity_width,dotsize,reg_width);
%     title (sprintf('%s vs %s for Combined Static and Looming',sc_label,nc_label))
%     xlabel(sprintf('VRF %s',sc_label))
%     ylabel('Noise Correlation')
%     legend (legtxt);
    
    if save_figs
        cd(save_cd)
        fig_name=sprintf('%s_vs_NC',sc_label);
        Save_This_Fig(fig_name,notes_x_width,notes_y_width,paper_x_width,paper_y_width,rez)
        cd (start_cd)
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [pop_sc,pop_nc]=Data_Grabber(handles,dome_cell,nc_type,sc_type,stim_label)
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
    
    % Find MultiTrace index
    mt_pointer=strcmp(stim_label,site.id_mt_labels);
    
    %%% Use Geometric mean from mt-stim
    %     stim_resp_post=nan(size(site.id_chan));
    %     for j=1:length(site.id_chan)
    %         stim_resp_post(j)=mean(site.id_mt_data.post_cell{j}(:,mt_pointer) ); %%% Do I need geometric mean of the average response of the average geometric mean of the response?
    %     end
    %     gm_mat=log2((stim_resp_post*stim_resp_post').^.5);
    
    %%% Use Geometric mean from position along receptive field
    if strcmp(stim_label,'Vs_I  ') % if this is vis strong in
        if isfield(site,'data_stim_pos_on_tc_loom')
            gm_mat=(site.data_stim_pos_on_tc_loom'*site.data_stim_pos_on_tc_loom) .^.5;
        else
            gm_mat=nan(length(dome));
        end
    else
        gm_mat=(site.data_stim_pos_on_tc_stat'*site.data_stim_pos_on_tc_stat) .^.5;
    end
    
    geo_means=gm_mat(tril(true(size(gm_mat)),-1));
    
    %%% NOTE: You get NaNs for 2 sites, because on those two sites the
    %%% mapping only went to -27 elevation, but the noise-charactization
    %%% stimulus was positioned at -30 elevation
    if sum(isnan(geo_means))>0
        fprintf('\nGot Geo-Mean NaNs on %s  %s\n',site.site_date,site.site_id)
    end
    
%     geo_means(geo_means==0)=nan; %drop zero means
    
    % if this site had the data you are after
    if sum(mt_pointer)~=0
        
        % Grab Dot Product Data
        switch sc_type
            case 1
                if strcmp(stim_label,'Vw_I  ') % if this is vis weak in
                    % did you map with both static and looming?
                    if isfield(site,'data_dp_vis_stat') && isfield(site,'data_dp_vis_loom')
                        pop_sc=[pop_sc;site.data_dp_vis_stat(dome)];
                    else
                        %                         pop_sc=[pop_sc;nan(sum(dome),1)]; % this is
                        %                         useful if you only want paired data
                        pop_sc=[pop_sc;site.data_dp_vis(dome)];
                    end
                elseif strcmp(stim_label,'Vs_I  ')
                    % did you map with both static and looming?
                    if isfield(site,'data_dp_vis_stat') && isfield(site,'data_dp_vis_loom')
                        pop_sc=[pop_sc;site.data_dp_vis_loom(dome)];
                    else %if you didn't then don't use this site
                        pop_sc=[pop_sc;nan(sum(dome),1)];
                    end
                else %if this isn't an "in" stim, just use the static dp_vis
                    pop_sc=[pop_sc;site.data_dp_vis(dome)];
                end
                
            case 2
                if strcmp(stim_label,'Vw_I  ') % if this is vis weak in
                    % did you map with both static and looming?
                    if isfield(site,'data_wap_sep_vis_stat') && isfield(site,'data_wap_sep_vis_loom')
                        pop_sc=[pop_sc;site.data_wap_sep_vis_stat(dome)];
                    else
                        %                         pop_sc=[pop_sc;nan(sum(dome),1)]; % this is
                        %                         useful if you only want paired data
                        pop_sc=[pop_sc;site.data_wap_sep_vis(dome)];
                    end
                elseif strcmp(stim_label,'Vs_I  ')
                    % did you map with both static and looming?
                    if isfield(site,'data_wap_sep_vis_stat') && isfield(site,'data_wap_sep_vis_loom')
                        pop_sc=[pop_sc;site.data_wap_sep_vis_loom(dome)];
                    else %if you didn't then don't use this site
                        pop_sc=[pop_sc;nan(sum(dome),1)];
                    end
                else %if this isn't an "in" stim, just use the static wap_sep_vis
                    pop_sc=[pop_sc;site.data_wap_sep_vis(dome)];
                end
                
                
%                 fprintf('\nYO!\nYou haven''t coded to separately calculate the wap_sep for the vis and loom mapping.  You need to do that before using this function\n')
%                 % IF you are trying to implement this functionality, use
%                 % the dot-product (case1) as a template
%                 dbstack
%                 keyboard
%                 pop_sc=[pop_sc;site.data_wap_sep_vis(dome)];
                
            case 3
                pop_sc=[pop_sc;geo_means(dome)];
                
            case 4 % Derivative of the spatial receptive fields
               pop_sc=[pop_sc;site.data_deriv_sig_corr_vis(dome)];                             
                
            case 5
                pop_sc=[pop_sc;site.data_dp_aud(dome)];
            case 6
                pop_sc=[pop_sc;site.data_wap_sep_aud(dome)];
            case 7
                pop_sc=[pop_sc;geo_means(dome)];
                
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

if max(x)<1
my_xlims=[-.5 1];
else
    my_xlims=[0 max(x)*1.1];
end

my_ylims=[-.5 1];

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
% [rho,p]=corr(x,y,'type','Spearman');

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
    plot (log2(plotfit_x+1),log2(plotfit_y+1),'-k','LineWidth',reg_width)
else
%     plot (x,y,'.','MarkerSize',dotsize,'Color',lincols(1,:))
%     plot (mean(x),mean(y),'rd','MarkerSize',10,'LineWidth',2,'Color',lincols(2,:))
%     plot (xminmax,[xminmax',ones(size(xminmax'))]*pfits','--','LineWidth',reg_width,'Color',lincols(2,:))
    plot (x,y,'ok','MarkerSize',dotsize)
    plot (mean(x),mean(y),'dk','MarkerSize',10,'LineWidth',2)
    plot (xminmax,[xminmax',ones(size(xminmax'))]*pfits','-k','LineWidth',reg_width)
end

set (gca,'xlim',my_xlims);
set(gca,'ylim',my_ylims);

plotlimx=get(gca,'xlim');
if max(x)>1
    plot (plotlimx,[0 0],'-k')
else
    plot (plotlimx,plotlimx,':k','LineWidth',unity_width)
end
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
        
        