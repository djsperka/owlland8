function Stat_Loom_Resp_FF_NC(handles)
global site_cell

fprintf('\n')
save_figs=0;
% save_figs=input('Wanna save your figures?  1/0  : ');
fprintf('\n')
start_dir=cd;
fullpath=mfilename('fullpath');
root_path=fullpath(1:strfind(fullpath,'Dougs DeBello Dump')-1);
new_path=strcat(root_path,'Dougs DeBello Dump\Publications\Visual Localization Simulation');
cd(new_path)
if save_figs
    fprintf('\nSelect Directory to Save to\n')
    save_dir=uigetdir;
end
cd(start_dir);
notes_x_width=3.5;

% set size of saved plots
notes_x_width=4.5; notes_y_width=3.5;
paper_x_width=2.5 ;paper_y_width=2;
rez='300'; %dpi ... needs to be a string

unity_width=1;
circlesize=5;
regression_width=2;
mean_size=10; %marker size of mean marker
mean_width=2; %line width of mean marker

resp_stat=[];
resp_loom=[];
ff_stat=[];
ff_loom=[];
nc_stat=[];
nc_loom=[];
nc_chans=[];
site_id=[];

%% Concatinate Data
dome_cell=Resp_Property_Filter(handles);

for i=1:length(site_cell)
%     if i==27
%         dbstack
%         keyboard
%     end
    site=site_cell{i};
    % Find MultiTrace index
    stim_label='Vw_I  ';
    mt_pointer_stat=strcmp(stim_label,site.id_mt_labels);
    stim_label='Vs_I  ';
    mt_pointer_loom=strcmp(stim_label,site.id_mt_labels);
    
%     responds=site.data_responds(:,mt_pointer_stat); 
    responds=double(site.data_responds(:,mt_pointer_stat)& site.id_layer==3); % added the layer bit to  make this agree with other code
    use_chan_stat=logical(double(dome_cell{1,i})*mt_pointer_stat);
    use_chan_loom=logical(double(dome_cell{1,i})*mt_pointer_loom);
    
    responds_pair=responds*responds';
    responds_pair=responds_pair(logical(triu(ones(size(responds_pair)),1)));
    use_pair_stat=logical(double(dome_cell{2,i})*mt_pointer_stat);
    use_pair_loom=logical(double(dome_cell{2,i})*mt_pointer_loom);
    
    resp_stat=[resp_stat;site.data_mt_resp(use_chan_stat)];
    resp_loom=[resp_loom;site.data_mt_resp(use_chan_loom)];
    
    site_id=[site_id; ones(sum(use_chan_stat(:)),1)*i];
    
    ff_stat=[ff_stat;site.data_fano(use_chan_stat)];
    ff_loom=[ff_loom;site.data_fano(use_chan_loom)];
    
    nc_stat=[nc_stat;site.data_mt_post_corr(use_pair_stat)];
    nc_loom=[nc_loom;site.data_mt_post_corr(use_pair_loom)];
%     nc_stat=[nc_stat;site.data_mt_resp_corr(use_pair_stat)];
%     nc_loom=[nc_loom;site.data_mt_resp_corr(use_pair_loom)];
    nc_chans=[nc_chans;site.data_chans(logical(responds_pair),:)];
end

sum(~isnan(nc_stat))
sum(~isnan(nc_loom))
sum(~isnan(nc_stat) & ~isnan(nc_loom))
% dbstack
% keyboard

%% Response Plots
logger=1;
x=resp_stat;
y=resp_loom;
h=figure;
hold on
legtxt(1:3)=Plot_XvsY_thisfun (x,y,logger,circlesize,regression_width,mean_size,mean_width);


minmax=get(gca,'xlim');
plot (minmax,minmax,'--k','LineWidth',unity_width)
legend(legtxt)
if logger
    title ('Resp : Log_2')
else
    title ('Resp')
end
xlabel('Static')
ylabel('Looming')

chld=get(gca,'children');
set(gca,'children',chld([2,3,4,1]));

if save_figs
    cd(save_dir)
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
    saveas(h,'Notes_Resp.png') %Save it!
    xlabel('')
    ylabel('')
    legend('off')
    title('')
    set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
    saveas(h,'Paper_Resp.png') %Save it!
    cd (start_dir)
end

%% Fano Factor Plots
logger=1;
x=ff_stat;
y=ff_loom;
h=figure;
hold on
legtxt(1:3)=Plot_XvsY_thisfun (x,y,logger,circlesize,regression_width,mean_size,mean_width);


minmax=get(gca,'xlim');
plot (minmax,minmax,'--k','LineWidth',unity_width)
legend(legtxt)
if logger
    title ('FF : Log_2')
else
    title ('FF')
end
xlabel('Static')
ylabel('Looming')

chld=get(gca,'children');
set(gca,'children',chld([2,3,4,1]));

if save_figs
    cd(save_dir)
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
    saveas(h,'Notes_FF.png') %Save it!
    xlabel('')
    ylabel('')
    legend('off')
    title('')
    set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
    saveas(h,'Paper_FF.png') %Save it!
    cd (start_dir)
end

%% Noise Correlation Plots
logger=0;
x=nc_stat;
y=nc_loom;
h=figure;
hold on
legtxt(1:3)=Plot_XvsY_thisfun (x,y,logger,circlesize,regression_width,mean_size,mean_width);


minmax=get(gca,'xlim');
plot (minmax,minmax,'--k','LineWidth',unity_width)
legend(legtxt)
if logger
    title ('NC : Log_2')
else
    title ('NC')
end
xlabel('Static')
ylabel('Looming')

chld=get(gca,'children');
set(gca,'children',chld([2,3,4,1]));

if save_figs
    cd(save_dir)
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
    saveas(h,'Notes_NC.png') %Save it!
    xlabel('')
    ylabel('')
    legend('off')
    title('')
    set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
    saveas(h,'Paper_NC.png') %Save it!
    cd (start_dir)
end


function legtxt=Plot_XvsY_thisfun (x,y,logger,circlesize,regression_width,mean_size,mean_width)

dropper=isnan(x) | isnan(y);
x=x(~dropper); y=y(~dropper);

pfits=polyfit(x,y,1);
xminmax= [min(x),max(x)];

if jbtest(x) || jbtest(y) %either distribution is not normal
    %do paired non-para test
    [p_mean,~]=signrank(x,y);
    exp_x=median(x);
    exp_y=median(y);
    exp_type='Median';
    test='SR';
else
    %do paired ttest
    [~,p_mean]=ttest(x,y);
    exp_x=mean(x);
    exp_y=mean(y);
    exp_type='Median';
    test='TT';
end

[rho,p_corr]=corr(x,y);
plotfit_x=xminmax(1):.01:xminmax(2);
plotfit_y=[plotfit_x',ones(size(plotfit_x'))]*pfits';

if logger
    plot (log2(1+x),log2(1+y),'o','MarkerSize',circlesize)
    plot (log2(1+exp_x),log2(1+exp_y),'xr','MarkerSize',mean_size,'LineWidth',mean_width)
    plot (log2(1+plotfit_x),log2(1+plotfit_y),'--r','LineWidth',regression_width)
else
    plot (x,y,'o','MarkerSize',circlesize)
    plot (exp_x,exp_y,'xr','MarkerSize',mean_size,'LineWidth',mean_width)
    plot (plotfit_x,plotfit_y,'--r','LineWidth',regression_width)
end

legtxt{1}=sprintf('n=%.0f p(x==y)=%.2e : %s',sum(~dropper),p_mean, test);
legtxt{2}=sprintf('%s = [%.2f %.2f]',exp_type,exp_x,exp_y);
legtxt{3}=sprintf('y= %.2f*x + %.2f \n r= %.2f, p=%.4f',pfits(1),pfits(2),rho,p_corr);
