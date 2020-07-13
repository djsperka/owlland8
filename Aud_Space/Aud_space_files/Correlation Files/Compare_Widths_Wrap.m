function Compare_Widths_Wrap(handles)
% This script is designed to compare the tuning widths measured with static
% and looming stimuli respectively
global site_cell

[save_figs,mod_script,plot_heat,plot_widths,plot_peaks]=Compare_Widths_Bim_Start;

if mod_script
    dbstack
    keyboard
end

dome_cell=Resp_Property_Filter (handles);
% This will read all the settings from the intro-GUI and return a
% cell-array where each cohort is a column, the first row is the single-site
% mask, and the second row is the pair-wise mask

% Set Paths
start_dir=cd;
this_name=mfilename;
this_full_path=mfilename('fullpath');
this_path=this_full_path(1:strfind(this_full_path,'Dougs DeBello Dump')-1);
cd (this_path)
% cd ('C:\Users\debellolab\Box Sync\Dougs DeBello Dump\Publications')
if save_figs
    save_dir=uigetdir;
else
    save_dir='';
end
cd (start_dir);

% Set figure sizes for saving
x_width_notes=3.5 ;y_width_notes=3;
x_width=2.5 ;y_width=2;

% line colors and sizes
set_line_width=1; % width for printed lines for relative contr plot
unity_line_width=1;
circle_size=5; %marker size of data points
mean_size=10; %marker size of mean marker
mean_width=2; %line width of mean marker

%% Loom/Stat Map
if plot_heat
    Stat_vs_Loom_VRF(handles,save_figs,save_dir,start_dir);
end

%% Initiate tuning measurement vectors
az_hmw_stat=[];
el_hmw_stat=[];
az_hmw_loom=[];
el_hmw_loom=[];

az_com_stat=[];
el_com_stat=[];
az_com_loom=[];
el_com_loom=[];

site_tags=[];
unit_tags=[];
for i=1:length(site_cell);
    if isfield(site_cell{i},'data_az_hmw_loom')
        
        if ~isfield(site_cell{i},'id_vis_map_loom')
            keyboard
        end
        az_hmw_stat=[az_hmw_stat;site_cell{i}.data_az_hmw_stat(dome_cell{1,i})];
        el_hmw_stat=[el_hmw_stat;site_cell{i}.data_el_hmw_stat(dome_cell{1,i})];
        az_hmw_loom=[az_hmw_loom;site_cell{i}.data_az_hmw_loom(dome_cell{1,i})];
        el_hmw_loom=[el_hmw_loom;site_cell{i}.data_el_hmw_loom(dome_cell{1,i})];
        
        az_com_stat=[az_com_stat;site_cell{i}.data_az_com_stat(dome_cell{1,i})];
        el_com_stat=[el_com_stat;site_cell{i}.data_el_com_stat(dome_cell{1,i})];
        az_com_loom=[az_com_loom;site_cell{i}.data_az_com_loom(dome_cell{1,i})];
        el_com_loom=[el_com_loom;site_cell{i}.data_el_com_loom(dome_cell{1,i})];
        
        site_tags=[site_tags;ones(sum(dome_cell{1,i}),1)*i];
        unit_tags=[unit_tags;find(dome_cell{1,i}==1)];
    end
end

%% compare azimuth width
if plot_widths
    stat=az_hmw_stat;
    loom=az_hmw_loom;
    
    dome=~isnan(stat) & ~isnan(loom);
    x=stat(dome);
    y=loom(dome);
    
    h=figure;
    hold on
    plot (x,y,'o','MarkerSize',circle_size);
    if jbtest(x) || jbtest(y)
        p=signrank(x,y);
        fprintf('\nRan signrank test for az widths')
    else
        [~,p]=ttest(x,y);
        fprintf('\nRan ttest test for az widths')
    end
    plot (mean(x),mean(y),'xr','markersize',mean_size,'linewidth',mean_width)
    pfits=polyfit(x,y,1);
    [rho,rpval]=corr(x,y);
    plot([min(x),max(x)],pfits*[min(x),max(x);1,1],'--r','LineWidth',set_line_width)
    bl=min([get(gca,'xlim'),get(gca,'ylim')]); %bottom left
    tr=max([get(gca,'xlim'),get(gca,'ylim')]); %top right
    plot([bl,tr],[bl,tr],'--k','LineWidth',unity_line_width)
    legtxt{1}=sprintf('n=%.0f',sum(dome));
    legtxt{2}=sprintf('mean=[%.2f,%.2f] :: p=%.4f',mean(x),mean(y),p);
    legtxt{3}=sprintf('y=%.2fx+%.2f\nrho=%.2f :: p_corr=%.4f',pfits(1),pfits(2),rho,rpval);
    legtxt{4}='unity';
    legend(legtxt);
    title('Azimuth Looming vs Static Half-Max Widths')
    xlabel ('Static Width(degrees)')
    ylabel('Looming Width (degrees)')
    
    chld=get(gca,'Children');
    set(gca,'Children',chld([3,2,4,1]));
    
    %%% Strip Labels and Save figures
    if save_figs
        figure (h)
        cd (save_dir)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 x_width_notes y_width_notes]);
        saveas(h,'Notes_HMW_Az.png') %Save it!
        %     set(gca,'xticklabel','')
        %     set(gca,'yticklabel','')
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 x_width y_width]);
        saveas(h,'Poster_HMW_Az.png') %Save it!
        cd(start_dir);
    end
    
    % % % % Used this for finding sites with inconsistant widths between static and
    % % % % looming %%%%%%%%%%%%%%%
    % keyboard
    % sites=site_tags(dome);
    % units=unit_tags(dome);
    % ind=9;
    % site_cell{sites(ind)}.site_date
    % site_cell{sites(ind)}.site_id
    % units(ind)
    
    %% compare elevations width
    stat=el_hmw_stat;
    loom=el_hmw_loom;
    
    dome=~isnan(stat) & ~isnan(loom);
    x=stat(dome);
    y=loom(dome);
    
    h=figure;
    hold on
    plot (x,y,'o','MarkerSize',circle_size);
    if jbtest(x) || jbtest(y)
        p=signrank(x,y);
        fprintf('\nRan signrank test for el widths')
    else
        [~,p]=ttest(x,y);
        fprintf('\nRan ttest test for el widths')
    end
    plot (mean(x),mean(y),'xr','markersize',mean_size,'linewidth',mean_width)
    pfits=polyfit(x,y,1);
    [rho,rpval]=corr(x,y);
    plot([min(x),max(x)],pfits*[min(x),max(x);1,1],'--r','LineWidth',set_line_width)
    bl=min([get(gca,'xlim'),get(gca,'ylim')]); %bottom left
    tr=max([get(gca,'xlim'),get(gca,'ylim')]); %top right
    plot([bl,tr],[bl,tr],'--k','LineWidth',unity_line_width)
    legtxt{1}=sprintf('n=%.0f',sum(dome));
    legtxt{2}=sprintf('mean=[%.2f,%.2f] :: p=%.4f',mean(x),mean(y),p);
    legtxt{3}=sprintf('y=%.2fx+%.2f\nrho=%.2f :: p_corr=%.4f',pfits(1),pfits(2),rho,rpval);
    legtxt{4}='unity';
    legend(legtxt);
    title('Elevation Looming vs Static Half-Max Widths')
    xlabel ('Static Width(degrees)')
    ylabel('Looming Width (degrees)')
    
    chld=get(gca,'Children');
    set(gca,'Children',chld([3,2,4,1]));
    
    %%% Strip Labels and Save figures
    if save_figs
        figure (h)
        cd (save_dir)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 x_width_notes y_width_notes]);
        saveas(h,'Notes_HMW_El.png') %Save it!
        %     set(gca,'xticklabel','')
        %     set(gca,'yticklabel','')
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 x_width y_width]);
        saveas(h,'Poster_HMW_El.png') %Save it!
        cd(start_dir);
    end
    
end
%% Repeat for Weighted Average
%% compare azimuths WA
if plot_peaks
    stat=az_com_stat;
    loom=az_com_loom;
    
    dome=~isnan(stat) & ~isnan(loom);
    x=stat(dome);
    y=loom(dome);
    
    h=figure;
    hold on
    plot (x,y,'o','MarkerSize',circle_size);
    if jbtest(x) || jbtest(y)
        p=signrank(x,y);
        fprintf('\nRan signrank test for az coms')
    else
        [~,p]=ttest(x,y);
        fprintf('\nRan ttest test for az coms')
    end
    plot (mean(x),mean(y),'xr','markersize',mean_size,'linewidth',mean_width)
    pfits=polyfit(x,y,1);
    [rho,rpval]=corr(x,y);
    plot([min(x),max(x)],pfits*[min(x),max(x);1,1],'--r','LineWidth',set_line_width)
    bl=min([get(gca,'xlim'),get(gca,'ylim')]); %bottom left
    tr=max([get(gca,'xlim'),get(gca,'ylim')]); %top right
    plot([bl,tr],[bl,tr],'--k','LineWidth',unity_line_width)
    legtxt{1}=sprintf('n=%.0f',sum(dome));
    legtxt{2}=sprintf('mean=[%.2f,%.2f] :: p=%.4f',mean(x),mean(y),p);
    legtxt{3}=sprintf('y=%.2fx+%.2f\nrho=%.2f :: p_corr=%.4f',pfits(1),pfits(2),rho,rpval);
    legtxt{4}='unity';
    legend(legtxt);
    title('Azimuth Looming vs Static Weighted Average')
    xlabel ('Static WA(degrees)')
    ylabel('Looming WA (degrees)')
    
    chld=get(gca,'Children');
    set(gca,'Children',chld([3,2,4,1]));
    
    %%% Strip Labels and Save figures
    if save_figs
        figure (h)
        cd (save_dir)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 x_width_notes y_width_notes]);
        saveas(h,'Notes_WA_Az.png') %Save it!
        %     set(gca,'xticklabel','')
        %     set(gca,'yticklabel','')
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 x_width y_width]);
        saveas(h,'Poster_WA_Az.png') %Save it!
        cd(start_dir);
    end
    
    %% compare elevations WA
    stat=el_com_stat;
    loom=el_com_loom;
    
    dome=~isnan(stat) & ~isnan(loom);
    x=stat(dome);
    y=loom(dome);
    
    h=figure;
    hold on
    plot (x,y,'o','MarkerSize',circle_size);
    if jbtest(x) || jbtest(y)
        p=signrank(x,y);
        fprintf('\nRan signrank test for el coms')
    else
        [~,p]=ttest(x,y);
        fprintf('\nRan ttest test for el coms')
    end
    plot (mean(x),mean(y),'xr','markersize',mean_size,'linewidth',mean_width)
    pfits=polyfit(x,y,1);
    [rho,rpval]=corr(x,y);
    plot([min(x),max(x)],pfits*[min(x),max(x);1,1],'--r','LineWidth',set_line_width)
    bl=min([get(gca,'xlim'),get(gca,'ylim')]); %bottom left
    tr=max([get(gca,'xlim'),get(gca,'ylim')]); %top right
    plot([bl,tr],[bl,tr],'--k','LineWidth',unity_line_width)
    legtxt{1}=sprintf('n=%.0f',sum(dome));
    legtxt{2}=sprintf('mean=[%.2f,%.2f] :: p=%.4f',mean(x),mean(y),p);
    legtxt{3}=sprintf('y=%.2fx+%.2f\nrho=%.2f :: p_corr=%.4f',pfits(1),pfits(2),rho,rpval);
    legtxt{4}='unity';
    legend(legtxt);
    title('Elevation Looming vs Static Weighted Average')
    xlabel ('Static WA(degrees)')
    ylabel('Looming WA (degrees)')
    chld=get(gca,'Children');
    set(gca,'Children',chld([3,2,4,1]));
    
    %%% Strip Labels and Save figures
    if save_figs
        figure (h)
        cd (save_dir)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 x_width_notes y_width_notes]);
        saveas(h,'Notes_WA_El.png') %Save it!
        %     set(gca,'xticklabel','')
        %     set(gca,'yticklabel','')
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 x_width y_width]);
        saveas(h,'Poster_WA_El.png') %Save it!
        cd(start_dir);
    end
end
