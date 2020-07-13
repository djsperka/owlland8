function Check_High_NC(handles)
global site_cell

fprintf('\n')
save_figs=1;
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

% set size of saved plots
notes_x_width=4.5; notes_y_width=3.5;
paper_x_width=2.5 ;paper_y_width=2;
rez='300'; %dpi ... needs to be a string

unity_width=1;
circlesize=5;
regression_width=2;
mean_size=10; %marker size of mean marker
mean_width=2; %line width of mean marker

nc_stat=[];
nc_loom=[];
nc_chans=[];
nc_trodes=[];
site_id=[];

dome_cell=Resp_Property_Filter(handles);

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
    
    site_id=[site_id; ones(sum(use_pair_stat(:)),1)*i];
   
    nc_stat=[nc_stat;site.data_mt_post_corr(use_pair_stat)];
    nc_loom=[nc_loom;site.data_mt_post_corr(use_pair_loom)];
    
    these_chans=site.data_chans(logical(responds_pair),:);
    nc_chans=[nc_chans;these_chans];
    
    nc_trodes=[nc_trodes;[site.id_trode(these_chans(:,1)),site.id_trode(these_chans(:,2))]];
end

sum(~isnan(nc_stat))
sum(~isnan(nc_loom))
sum(~isnan(nc_stat) & ~isnan(nc_loom))
% dbstack
% keyboard

% dropme=isnan(nc_stat) | isnan(nc_loom);
% nc_stat(dropme)=[];
% nc_loom(dropme)=[];

%% Noise Correlation Plots
logger=0;
x=nc_stat;
y=nc_loom;
h=figure;
hold on
legtxt(1:3)=Plot_XvsY_thisfun (x,y,logger,circlesize,regression_width,mean_size,mean_width);

% Plot high NC examples
tagme=x>0.9 | y>0.9;
plot (x(tagme),y(tagme),'or');
fprintf ('\nNC: [%.2f %.2f] ... Trodes: %i and %i',[x(tagme) y(tagme) nc_trodes(tagme,:)]');

minmax=get(gca,'xlim');
plot (minmax,minmax,'--k','LineWidth',unity_width)
% legend(legtxt)
if logger
    title ('NC : Log_2')
else
    title ('NC')
end
xlabel('Static')
ylabel('Looming')

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
    
    close (h)
end

%% Show cross correlograms for high NC examples

high_nc_sites=site_id(tagme);
pair_inds=find(tagme);

for i=1:length(high_nc_sites)
    site_num=high_nc_sites(i);
    site=site_cell{site_num};
    if x(pair_inds(i))>y(pair_inds(i))
        stim_type='Vw_I  ';
    else
        stim_type='Vs_I  ';
    end
    mt_pointer=strcmp(site.id_mt_labels,stim_type);
    
    chan1_times=site.id_mt_data.data_time{nc_chans(pair_inds(i),1),mt_pointer};
    chan1_trials=site.id_mt_data.data_trial{nc_chans(pair_inds(i),1),mt_pointer};
    chan1_reps=site.id_mt_data.data_rep{nc_chans(pair_inds(i),1),mt_pointer};
    chan2_times=site.id_mt_data.data_time{nc_chans(pair_inds(i),2),mt_pointer};
    chan2_trials=site.id_mt_data.data_trial{nc_chans(pair_inds(i),2),mt_pointer};
    chan2_reps=site.id_mt_data.data_rep{nc_chans(pair_inds(i),2),mt_pointer};
    
    nreps=max([max(chan1_reps) max(chan2_reps)]);
    
    max_lag=20;
    count_lags=zeros(1,max_lag*2);
    lags=-max_lag:max_lag;
    
    for hh=1:nreps
        reptimes1=chan1_times(chan1_reps==hh);
        reptimes2=chan2_times(chan2_reps==hh);
        chan1_repmat{hh}=reptimes1;
        chan2_repmat{hh}=reptimes2;
        for ii=1:length(reptimes1)
            time_diffs=reptimes2-reptimes1(ii);
            for jj=1:max_lag*2
                window=[lags(jj) lags(jj+1)];
                count_lags(jj)=count_lags(jj)+sum(time_diffs>window(1) & time_diffs<=window(2));
            end
        end
        
    end
    
    h1=figure;
    plot (lags(1:end-1)+.5,count_lags,'-k')
    bar (lags(1:end-1)+.5,count_lags,1,'EdgeColor','k','FaceColor','w')
    hold on
    bar (lags(end/2-1:end/2)+.5,count_lags(end/2:end/2+1),1,'EdgeColor','k','FaceColor',[.8 .8 .8])
    ylims=get(gca,'ylim');
    plot ([-1 -1;1 1]', [ylims;ylims]','--k')
    xlabel ('lag (ms)')
    ylabel ('count')
    title (sprintf ('Cross Correlogram %s %s units %i and %i',site_cell{site_num}.site_date, site_cell{site_num}.site_id,nc_chans(pair_inds(i),1),nc_chans(pair_inds(i),2)))


% % %     t1=site_cell{site_num}.id_mt_data.data_time{nc_chans(pair_inds(i),1),mt_pointer};
% % %     t2=site_cell{site_num}.id_mt_data.data_time{nc_chans(pair_inds(i),2),mt_pointer};
% % %     rep1=site_cell{site_num}.id_mt_data.data_rep{nc_chans(pair_inds(i),1),mt_pointer};
% % %     rep2=site_cell{site_num}.id_mt_data.data_rep{nc_chans(pair_inds(i),2),mt_pointer};
% % %     t1=t1+(rep1-1)*10000; % add 10 seconds per rep
% % %     t2=t2+(rep2-1)*10000; % add 10 seconds per rep
% % %     [r,lags]=xcorr(t1,t2, 50);
% % 
% % %     h=figure;
% % %     plot (lags,r)
% % %     xlabel ('Lag')
% % %     ylabel ('Count')
% % %     title (sprintf ('%s %s units %i and %i',site_cell{site_num}.site_date, site_cell{site_num}.site_id,nc_chans(pair_inds(i),1),nc_chans(pair_inds(i),2)))
    
    if save_figs
        cd(save_dir)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        saveas(h1,sprintf('Notes_pair%i.png',i)) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
        saveas(h1,sprintf('Paper_pair%i.png',i)) %Save it!
        cd (start_dir)
        close (h1)
    end

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
    plot (log2(1+x),log2(1+y),'.k','MarkerSize',circlesize)
    plot (log2(1+exp_x),log2(1+exp_y),'xr','MarkerSize',mean_size,'LineWidth',mean_width)
    plot (log2(1+plotfit_x),log2(1+plotfit_y),'--r','LineWidth',regression_width)
else
    plot (x,y,'.k','MarkerSize',circlesize)
    plot (exp_x,exp_y,'xr','MarkerSize',mean_size,'LineWidth',mean_width)
    plot (plotfit_x,plotfit_y,'--r','LineWidth',regression_width)
end

legtxt{1}=sprintf('n=%.0f p(x==y)=%.2e : %s',sum(~dropper),p_mean, test);
legtxt{2}=sprintf('%s = [%.2f %.2f]',exp_type,exp_x,exp_y);
legtxt{3}=sprintf('y= %.2f*x + %.2f \n r= %.2f, p=%.4f',pfits(1),pfits(2),rho,p_corr);
