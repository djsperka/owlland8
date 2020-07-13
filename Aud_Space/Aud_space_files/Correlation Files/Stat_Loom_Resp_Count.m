function Stat_Loom_Resp_Count(handles)
global site_cell

fprintf('\n')
save_figs=input('Wanna save your figures?  1/0  : ');
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

n_resp_stat=[];
n_resp_loom=[];
for i=1:length(site_cell)
    
    site=site_cell{i};
    % Find MultiTrace index
    stim_label='Vw_I  ';
    mt_pointer_stat=strcmp(stim_label,site.id_mt_labels);
    stim_label='Vs_I  ';
    mt_pointer_loom=strcmp(stim_label,site.id_mt_labels);
    
    if (sum(mt_pointer_stat) + sum(mt_pointer_loom) ) ==2
        n_resp_stat(end+1)=sum(site.data_responds(:,mt_pointer_stat));
        n_resp_loom(end+1)=sum(site.data_responds(:,mt_pointer_loom));
    end
end

%% Plot it
x=n_resp_stat';
y=n_resp_loom';
logger=0;

pfits=polyfit(x,y,1);
xminmax= [min(x),max(x)];
[rho,p_corr]=corr(x,y);

if jbtest(x) || jbtest(y) %either distribution is not normal
    %do paired non-para test
    [p_exp,~]=signrank(x,y);
    exp_x=median(x);
    exp_y=median(y);
    exp_type='Median';
    data_type='Non-para';
else
    %do paired ttest
    [~,p_exp]=ttest(x,y);
    exp_x=mean(x);
    exp_y=mean(y);
    exp_type='Median';
    data_type='Normal';
end

h=figure;
hold on
if logger
    plot (log2(x+1),log2(y+1),'o','MarkerSize',circlesize)
    plot (log2(exp_x+1),log2(exp_y+1),'rx','MarkerSize',mean_size,'LineWidth',mean_width)
    plotfit_x=xminmax(1):.01:xminmax(2);
    plotfit_y=[plotfit_x',ones(size(plotfit_x'))]*pfits';
    plot (log2(plotfit_x+1),log2(plotfit_y+1),'--r','LineWidth',regression_width)
else
    plot (x,y,'o','MarkerSize',circlesize)
    plot (exp_x,exp_y,'rx','MarkerSize',mean_size,'LineWidth',mean_width)
    plot (xminmax,[xminmax',ones(size(xminmax'))]*pfits','--r','LineWidth',regression_width)
end

plotlimx=get(gca,'xlim');
plot (plotlimx,plotlimx,'--k','LineWidth',unity_width)
legtxt{1}=sprintf('%s Data : n=%.0f',data_type,length(x));
legtxt{2}=sprintf('%s = [%.2f %.2f] : p=%.4f',exp_type,exp_x,exp_y,p_exp);
legtxt{3}=sprintf('y= %.2f*x + %.2f \n r= %.2f, p=%.4f',pfits(1),pfits(2),rho,p_corr);

legend (legtxt)
title ('Static vs Looming Response Counts')
xlabel ('Static Count')
ylabel ('Looming Count')

if save_figs
    cd(save_dir)
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
    saveas(h,'Notes_Resp_Count.png') %Save it!
    xlabel('')
    ylabel('')
    legend('off')
    title('')
    set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
    saveas(h,'Paper_Resp_Count.png') %Save it!
    cd (start_dir)
end


% 
%         set(gcf, 'PaperUnits', 'inches');
%         set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
%         print(gcf,sprintf('Notes_%s',fig_name),'-dpng',['-r',rez]) %Save it!
%         xlabel('')
%         ylabel('')
%         legend('off')
%         title('')
%         set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
%         print(gcf,sprintf('Paper_%s',fig_name),'-dpng',['-r',rez]) %Save it!
%         