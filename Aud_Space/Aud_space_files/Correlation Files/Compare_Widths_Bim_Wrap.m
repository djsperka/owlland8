function Compare_Widths_Bim_Wrap(handles)
% This script is designed to compare the tuning widths measured with static
% and looming stimuli respectively
global site_cell

[save_figs,mod_script]=Compare_Widths_Bim_Start;

if mod_script
    dbstack
    keyboard
end

use_peak=0; % if you aren't using peak, use COM

%set the required response characteristics to just vis in and aud in
set(handles.rrc_vwi,'Value',1);
set(handles.rrc_ai,'Value',1);
set(handles.rrc_vwo,'Value',0);
set(handles.rrc_ao,'Value',0);
set(handles.rrc_vwi_and_vwo,'Value',0);
set(handles.rrc_as,'Value',0);

dome_cell=Resp_Property_Filter (handles);
% This will read all the settings from the intro-GUI and return a
% cell-array where each cohort is a column, the first row is the single-site
% mask, and the second row is the pair-wise mask


% set paths
start_cd=cd;

fullpath=mfilename('fullpath');
fname=mfilename;
startname=strfind(fullpath,fname);
fpath=fullpath(1:startname-1);
targ_path=strcat(fpath,'..\Dougs_Data\Correlation Summary Workspaces\Competition');
cd(targ_path);

if save_figs
    save_cd=uigetdir;
end
cd (start_cd);

% figure sizes for saving
notes_x_width=4; notes_y_width=3.5;
poster_x_width=2.5 ;poster_y_width=2;
rez='300';% DPI ... needs to be a string

% line colors and sizes
lincols=linspecer(2);
unity_width=1;
regression_width=1.5;
dotsize=4;

az_hmw_vis=[];
el_hmw_vis=[];
az_hmw_aud=[];
el_hmw_aud=[];

az_com_vis=[];
el_com_vis=[];
az_com_aud=[];
el_com_aud=[];

az_peak_vis=[];
el_peak_vis=[];
az_peak_aud=[];
el_peak_aud=[];

dp_aud=[];
dp_vis=[];

site_tags=[];
unit_tags=[];

for i=1:length(site_cell);
    if isfield(site_cell{i},'data_az_hmw_aud') && isfield(site_cell{i},'data_az_hmw_stat')
        az_hmw_vis=[az_hmw_vis;site_cell{i}.data_az_hmw_stat(dome_cell{1,i})];
        el_hmw_vis=[el_hmw_vis;site_cell{i}.data_el_hmw_stat(dome_cell{1,i})];
        az_hmw_aud=[az_hmw_aud;site_cell{i}.data_az_hmw_aud(dome_cell{1,i})];
        el_hmw_aud=[el_hmw_aud;site_cell{i}.data_el_hmw_aud(dome_cell{1,i})];
        
        az_com_vis=[az_com_vis;site_cell{i}.data_az_com_stat(dome_cell{1,i})];
        el_com_vis=[el_com_vis;site_cell{i}.data_el_com_stat(dome_cell{1,i})];
        az_com_aud=[az_com_aud;site_cell{i}.data_az_com_aud(dome_cell{1,i})];
        el_com_aud=[el_com_aud;site_cell{i}.data_el_com_aud(dome_cell{1,i})];
        
        units=find(dome_cell{1,i});
        for j=1:length(units)
            unit=units(j);
            vismap=site_cell{i}.id_vis_map.resp(:,:,unit);
            [~,ind]=max(vismap(:));
            [y_ind,x_ind]=ind2sub(size(vismap),ind);
            az_peak_vis=[az_peak_vis;site_cell{i}.id_vis_map.Var1array(x_ind)];
            el_peak_vis=[el_peak_vis;site_cell{i}.id_vis_map.Var2array(y_ind)];
            
            audmap=site_cell{i}.id_aud_map.resp(:,:,unit);
            [~,ind]=max(audmap(:));
            [y_ind,x_ind]=ind2sub(size(audmap),ind);
            az_peak_aud=[az_peak_aud;site_cell{i}.id_aud_map.Var1array(x_ind)];
            el_peak_aud=[el_peak_aud;site_cell{i}.id_aud_map.Var2array(y_ind)];
            
        end
        
        dp_aud=[dp_aud;site_cell{i}.data_dp_aud];
        dp_vis=[dp_vis;site_cell{i}.data_dp_vis];
        
        site_tags=[site_tags;ones(sum(dome_cell{1,i}),1)*i];
        unit_tags=[unit_tags;find(dome_cell{1,i}==1)];
    end
end   

%% WIDTHS compare azimuths
visual=az_hmw_vis;
auditory=az_hmw_aud;

dome=~isnan(visual) & ~isnan(auditory);
x=visual(dome);
y=auditory(dome)/2.5;

h1=figure;
fprintf('\nFor Az Widths ')
Plot_XvY_ThisFun(x,y,dotsize,regression_width,unity_width);

title('Azimuth Auditory vs Visual Half-Max Widths')
xlabel ('Visual Width(degrees)')
ylabel('Auditory Width (uS/2.5)')
        
if save_figs
    cd(save_cd)
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
   print(h1,'Notes_TC_Width_Az','-dpng',['-r',rez]) %Save it!
    xlabel('')
    ylabel('')
    legend('off')
    title('')
    set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
   print(h1,'Paper_TC_Width_Az','-dpng',['-r',rez]) %Save it!
    cd (start_cd)
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

%% WIDTHS compare elevations
visual=el_hmw_vis;
auditory=el_hmw_aud;

dome=~isnan(visual) & ~isnan(auditory);
x=visual(dome);
y=auditory(dome)*3;

h1=figure;

fprintf('\nFor El Widths ')
Plot_XvY_ThisFun(x,y,dotsize,regression_width,unity_width);

title('Elevation Auditory vs Visual Half-Max Widths')
xlabel ('Visual Width(degrees)')
ylabel('Auditory Width (ILD*3)')

if save_figs
    cd(save_cd)
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
   print(h1,'Notes_TC_Width_El','-dpng',['-r',rez]) %Save it!
    xlabel('')
    ylabel('')
    legend('off')
    title('')
    set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
   print(h1,'Paper_TC_Width_El','-dpng',['-r',rez]) %Save it!
    cd (start_cd)
end

%% Repeat for Center of Mass
%% compare azimuths
if use_peak
    visual=az_peak_vis;
    auditory=az_peak_aud;
    type='Peak';
else
    visual=az_com_vis;
    auditory=az_com_aud;
    type='COM';
end

dome=~isnan(visual) & ~isnan(auditory);
x=visual(dome);
y=auditory(dome)/2.5;

h1=figure;

fprintf('\nFor Az %s ',type)
Plot_XvY_ThisFun(x,y,dotsize,regression_width,unity_width); 

title(sprintf('Azimuth Auditory vs Visual %s',type))
xlabel (sprintf('Visual %s(degrees)',type))
ylabel(sprintf('Auditory %s (uS/2.5)',type))
        
if save_figs
    cd(save_cd)
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
   print(h1,'Notes_TC_COM_Az','-dpng',['-r',rez]) %Save it!
    xlabel('')
    ylabel('')
    legend('off')
    title('')
    set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
   print(h1,'Paper_TC_COM_Az','-dpng',['-r',rez]) %Save it!
    cd (start_cd)
end

%% compare elevations
if use_peak
    visual=el_peak_vis;
    auditory=el_peak_aud;
    type='Peak';
else
    visual=el_com_vis;
    auditory=el_com_aud;
    type='COM';
end
dome=~isnan(visual) & ~isnan(auditory);
x=visual(dome);
y=auditory(dome)*3;

h1=figure;

fprintf('\nFor El COM ')
Plot_XvY_ThisFun(x,y,dotsize,regression_width,unity_width);

title(sprintf('Elevation Auditory vs Visual %s',type))
xlabel (sprintf('Visual %s(degrees)',type))
ylabel(sprintf('Auditory %s (uS/2.5)',type))

if save_figs
    cd(save_cd)
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
   print(h1,'Notes_TC_COM_El','-dpng',['-r',rez]) %Save it!
    xlabel('')
    ylabel('')
    legend('off')
    title('')
    set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
   print(h1,'Paper_TC_COM_El','-dpng',['-r',rez]) %Save it!
    cd (start_cd)
end

%% Compare Dot Products
visual=dp_vis;
auditory=dp_aud;

dome=~isnan(visual) & ~isnan(auditory);
x=visual(dome);
y=auditory(dome);

h1=figure;
hold on
plot (x,y,'ok','markersize',dotsize);
if jbtest(x) || jbtest(y)
    p=signrank(x,y);
    fprintf('\nRan signrank test for DPs')
else
    [~,p]=ttest(x,y);
    fprintf('\nRan ttest test for eDPs')
end
plot (mean(x),mean(y),'dk','markersize',10,'linewidth',3)
pfits=polyfit(x,y,1);
[rho,rpval]=corr(x,y);
plot([min(x),max(x)],pfits*[min(x),max(x);1,1],'--k','linewidth',regression_width)

bl=min([get(gca,'xlim'),get(gca,'ylim')]); %bottom left
tr=max([get(gca,'xlim'),get(gca,'ylim')]); %top right
plot([bl,tr],[bl,tr],':k','linewidth',unity_width)

legtxt{1}=sprintf('n=%.0f',sum(dome));
legtxt{2}=sprintf('mean=[%.2f,%.2f] :: p=%.2e',mean(x),mean(y),p);
legtxt{3}=sprintf('y=%.2fx+%.2f\nrho=%.2f :: p_{corr}=%.2e',pfits(1),pfits(2),rho,rpval);
legtxt{4}='unity';
legend(legtxt);
title('Auditory vs Visual Dot Product')
xlabel ('Visual DP')
ylabel('Auditory DP')

if save_figs
    cd(save_cd)
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
   print(h1,'Notes_TC_DP','-dpng',['-r',rez]) %Save it!
    xlabel('')
    ylabel('')
    legend('off')
    title('')
    set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
   print(h1,'Paper_TC_DP','-dpng',['-r',rez]) %Save it!
    cd (start_cd)
end


function Plot_XvY_ThisFun(x,y,dotsize,regression_width,unity_width)

% drop things outside of 3 standard deviations
dropme=abs(x-mean(x))>3*std(x) | abs(y-mean(y))>3*std(y);
x(dropme)=[]; y(dropme)=[];

hold on
% plot (x,y,'.','markersize',dotsize,'Color',lincols(1,:));
plot (x,y,'ok','markersize',dotsize);
if jbtest(x) || jbtest(y)
    p=signrank(x,y);
    test_type='SR';
else
    [~,p]=ttest(x,y);
    test_type='TT';
end
% plot (mean(x),mean(y),'d','Color',lincols(2,:),'markersize',10,'linewidth',2)
plot (mean(x),mean(y),'dk','markersize',10,'linewidth',2)
pfits=polyfit(x,y,1);
[rho,rpval]=corr(x,y);
% plot([min(x),max(x)],pfits*[min(x),max(x);1,1],'--','Color',lincols(2,:),'linewidth',regression_width)
if rpval<.05
    plot([min(x),max(x)],pfits*[min(x),max(x);1,1],'--k','linewidth',regression_width)
else
    plot([min(x),max(x)],pfits*[min(x),max(x);1,1],'--k','LineStyle','none','Marker','none')
end

bl=min([get(gca,'xlim'),get(gca,'ylim')]); %bottom left
tr=max([get(gca,'xlim'),get(gca,'ylim')]); %top right
plot([bl,tr],[bl,tr],':k','linewidth',unity_width)

legtxt{1}=sprintf('n=%.0f',length(x));
legtxt{2}=sprintf('mean=[%.2f,%.2f] :: p=%.2e :: %s',mean(x),mean(y),p, test_type);
legtxt{3}=sprintf('y=%.2fx+%.2f\nrho=%.2f :: p_{corr}=%.2e',pfits(1),pfits(2),rho,rpval);
legtxt{4}='unity';
legend(legtxt);
