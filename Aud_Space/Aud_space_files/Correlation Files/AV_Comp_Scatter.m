function AV_Comp_Scatter(handles)
global site_cell
% This script will mostly disregard handles, and set the selection filters
% according to what is needed for each specific condition
% Must respond to In stim
% Must not respond to Out stim

%this initiation GUI was made for AVB_Plot_Scatter but it works for this
%script too
[do_resp,do_ff,do_nc,save_figs,mod_script]=AVB_Scatter_Start(); 

if mod_script
    dbstack
    keyboard
end

start_cd=cd;
% cd ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition')
if save_figs
    save_cd=uigetdir;
end
cd(start_cd);

% set size of saved plots
notes_x_width=4; notes_y_width=3.5;
paper_x_width=2.5 ;paper_y_width=2;
rez='300'; %dpi ... needs to be a string

% set data sizes
unity_width=1;
dotsize=4;
reg_width=1.5;

% Set Colors
lincols=linspecer(2);

% Do unpaired ttest?
unpaired_tt=1;

%% Grab unimodal visual data
set(handles.rrc_vwi,'value',1);
set(handles.rrc_vwo,'value',1);
set(handles.rrc_ai,'value',0);
set(handles.rrc_ao,'value',0);
dome_cell=Resp_Property_Filter (handles);
driver='Vw_I  ';
competitor='Vw_O  Vw_I';
competitor_alt='Vw_I  Vw_O';

[resp_vis_uni,sigcomp_vis_uni,ff_vis_uni,nc_vis_uni]=This_Data_Grabber(dome_cell,driver,competitor,competitor_alt);


%% Grab Unimodal Auditory Data
set(handles.rrc_vwi,'value',0);
set(handles.rrc_vwo,'value',0);
set(handles.rrc_ai,'value',1);
set(handles.rrc_ao,'value',1);
dome_cell=Resp_Property_Filter (handles);
driver='A_I  ';
competitor='A_O  A_I';
competitor_alt='A_I  A_O';

[resp_aud_uni,sigcomp_aud_uni,ff_aud_uni,nc_aud_uni]=This_Data_Grabber(dome_cell,driver,competitor,competitor_alt);

%% Grab crossmodal visual data
set(handles.rrc_vwi,'value',1);
set(handles.rrc_vwo,'value',0);
set(handles.rrc_ai,'value',0);
set(handles.rrc_ao,'value',1);
dome_cell=Resp_Property_Filter (handles);
driver='Vw_I  ';
competitor='A_O  Vw_I';
competitor_alt='Vw_I  A_O';

[resp_vis_cross,sigcomp_vis_cross,ff_vis_cross,nc_vis_cross]=This_Data_Grabber(dome_cell,driver,competitor,competitor_alt);

%% Grab crossmodal Auditory data
set(handles.rrc_vwi,'value',0);
set(handles.rrc_vwo,'value',1);
set(handles.rrc_ai,'value',1);
set(handles.rrc_ao,'value',0);
dome_cell=Resp_Property_Filter (handles);
driver='A_I  ';
competitor='Vw_O  A_I';
competitor_alt='A_I  Vw_O';

[resp_aud_cross,sigcomp_aud_cross,ff_aud_cross,nc_aud_cross]=This_Data_Grabber(dome_cell,driver,competitor,competitor_alt);

%% Vis Response
if do_resp
    logger=0;
    h1=figure;
    hold on
    x1=resp_vis_uni(:,1);
    y1=resp_vis_uni(:,2);   
    pval1=sigcomp_vis_uni;
    x2=resp_vis_cross(:,1);
    y2=resp_vis_cross(:,2);
    pval2=sigcomp_vis_cross;
    
    
    %%%% Plot X vs Y
%     legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols(1,:),logger,1,reg_width,dotsize);
%     legtxt(4:6)=Plot_XvsY_thisfun (x2,y2,lincols(2,:),logger,2,reg_width,dotsize);
%     minmax=get(gca,'xlim');
%     plot (minmax,minmax,'--k','LineWidth',unity_width)
%     chld=get(gca,'children');
%     set(gca,'children',chld([3,6,5,2,7,4,1])); %set mean markers on top, then regression lines, then data points, then unity line

%%%% Plot Y relative to X

    [legtxt([1,2,3]), xp1, yp1, xp1_alt, yp1_alt] = Plot_Rel_Change_thisfun(x1,y1,pval1,1,lincols(1,:),dotsize);
    [legtxt([4,5,6]), xp2, yp2, xp2_alt, yp2_alt] = Plot_Rel_Change_thisfun(x2,y2,pval2,2,lincols(2,:),dotsize);
    
    plot ([-.5 .5],[1 1],'k:','LineWidth',unity_width)
    plot ([-.5 .5],[0 0 ], ':k')

    legend(legtxt)
    chld=get(gca,'children');
    set(gca,'children',chld([1 4 2 5 3 6 7 8])) %set significant on top, then non-sig, then mean, then axes
    
    if logger
        title ('Resp : Vis : Log_2')
    else
        title ('Resp : Vis')
    end
    xlabel('Driver')
    ylabel('w/ Competitor')
    
    if unpaired_tt
        [~,p]=ttest2(y1,y2);
        fprintf('\nVis Resp:\t%.2e',p)
    end
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(h1,'Notes_Comp_Vis_Resp','-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gca,'XTickLabel','')
        set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
        print(h1,'Paper_Comp_Vis_Resp','-dpng',['-r',rez]) %Save it!
        
        % write vidresp-1/2.txt
        writeWillXY(x1, y1, 'vidresp-1.txt');
        writeWillXY(x2, y2, 'vidresp-2.txt');
        writeWillXY(xp1', yp1, 'vidresp-1-plotted.txt');
        writeWillXY(xp2', yp2, 'vidresp-2-plotted.txt');
        writeWillXY(xp1_alt', yp1_alt, 'vidresp-1-plotted-alt.txt');
        writeWillXY(xp2_alt', yp2_alt, 'vidresp-2-plotted-alt.txt');

        cd (start_cd)
    end
    %% Aud Response
   logger=0;
    h1=figure;
    hold on
    x1=resp_aud_uni(:,1);
    y1=resp_aud_uni(:,2);    
    pval1=sigcomp_aud_uni;
    x2=resp_aud_cross(:,1);
    y2=resp_aud_cross(:,2);
    pval2=sigcomp_aud_cross;
    
    %%%% Plot X vs Y
%     legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols(1,:),logger,1,reg_width,dotsize);
%     legtxt(4:6)=Plot_XvsY_thisfun (x2,y2,lincols(2,:),logger,2,reg_width,dotsize);
%     minmax=get(gca,'xlim');
%     plot (minmax,minmax,'--k','LineWidth',unity_width)
%     chld=get(gca,'children');
%     set(gca,'children',chld([3,6,5,2,7,4,1])); %set mean markers on top, then regression lines, then data points, then unity line

%%%% Plot Y relative to X
    [legtxt([1,2,3]), xp1, yp1, xp1_alt, yp1_alt]=Plot_Rel_Change_thisfun(x1,y1,pval1,1,lincols(1,:),dotsize);
    [legtxt([4,5,6]), xp2, yp2, xp2_alt, yp2_alt]=Plot_Rel_Change_thisfun(x2,y2,pval2,2,lincols(2,:),dotsize);
    
    plot ([-.5 .5],[1 1],'k:','LineWidth',unity_width)
    plot ([-.5 .5],[0 0 ], ':k')

    legend(legtxt)
    chld=get(gca,'children');
    set(gca,'children',chld([1 4 2 5 3 6 7 8])) %set significant on top, then non-sig, then mean, then axes
    
    if logger
        title ('Resp : Aud : Log_2')
    else
        title ('Resp : Aud')
    end
    xlabel('Driver')
    ylabel('w/ Competitor')
    if unpaired_tt
        [~,p]=ttest2(y1,y2);
        fprintf('\nAud Resp:\t%.2e',p)
    end
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(h1,'Notes_Comp_Aud_Resp','-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gca,'XTickLabel','')
        set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
        print(h1,'Paper_Comp_Aud_Resp','-dpng',['-r',rez]) %Save it!
                
        % write audresp-1/2.txt
        writeWillXY(x1, y1, 'audresp-1.txt');
        writeWillXY(x2, y2, 'audresp-2.txt');
        writeWillXY(xp1', yp1, 'audresp-1-plotted.txt');
        writeWillXY(xp2', yp2, 'audresp-2-plotted.txt');
        writeWillXY(xp1_alt', yp1_alt, 'audresp-1-plotted-alt.txt');
        writeWillXY(xp2_alt', yp2_alt, 'audresp-2-plotted-alt.txt');


        cd (start_cd)
    end
    
end

%% Vis FF
if do_ff
    logger=0;
    h1=figure;
    hold on
    
    x1=ff_vis_uni(:,1);
    y1=ff_vis_uni(:,2);
    num=1;
    
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols(1,:),logger,num,reg_width,dotsize);
    
    x2=ff_vis_cross(:,1);
    y2=ff_vis_cross(:,2);
    num=2;
    legtxt(4:6)=Plot_XvsY_thisfun (x2,y2,lincols(2,:),logger,num,reg_width,dotsize);
    
    % Plot Unity
    minmax=get(gca,'xlim');
    plot (minmax,minmax,':k','LineWidth',unity_width)
    
%     chld=get(gca,'children');
%     set(gca,'children',chld([3,6,5,2,7,4,1]));
    legend(legtxt)
    if logger
        title ('Fano : Vis : Log_2')
        set(gca,'Yscale','log')
        set(gca,'XScale','log')
    if logger
        title ('Resp : Log_2')
    else
        title ('Resp')
    end
    else
        title ('Fano : Vis')
    end
    xlabel('Driver')
    ylabel('w/ Competitor')
    
    if unpaired_tt
        [~,p]=ttest2(y1,y2);
        fprintf('\nVis FF:\t%.2e',p)
    end
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(h1,'Notes_Comp_Vis_FF','-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
        print(h1,'Paper_Comp_Vis_FF','-dpng',['-r',rez]) %Save it!
                
        % write visff-1/2.txt
        writeWillXY(x1, y1, 'visff-1.txt');
        writeWillXY(x2, y2, 'visff-2.txt');


        cd (start_cd)
    end
    %% Aud FF
    logger=0;
    h1=figure;
    hold on
    
    x1=ff_aud_uni(:,1);
    y1=ff_aud_uni(:,2);
    num=1;
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols(1,:),logger,num,reg_width,dotsize);
    
    x2=ff_aud_cross(:,1);
    y2=ff_aud_cross(:,2);
    num=2;
    legtxt(4:6)=Plot_XvsY_thisfun (x2,y2,lincols(2,:),logger,num,reg_width,dotsize);
    
    set (gca,'xlim',[0 5]);
    set (gca,'ylim',[0 10]);
    
    minmax=get(gca,'xlim');
    plot (minmax,minmax,':k','LineWidth',unity_width)
    
    
%     chld=get(gca,'children');
%     set(gca,'children',chld([3,6,5,2,7,4,1]));
    legend(legtxt)
    if logger
        title ('Fano : Aud : Log_2')
        set(gca,'Yscale','log')
        set(gca,'XScale','log')
    else
        title ('Fano : Aud')
    end
    xlabel('Driver')
    ylabel('w/ Competitor')
    
    if unpaired_tt
        [~,p]=ttest2(y1,y2);
        fprintf('\nAud FF:\t%.2e',p)
    end
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(h1,'Notes_Comp_Aud_FF','-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
        print(h1,'Paper_Comp_Aud_FF','-dpng',['-r',rez]) %Save it!
                
        % write audff-1/2.txt
        writeWillXY(x1, y1, 'audff-1.txt');
        writeWillXY(x2, y2, 'audff-2.txt');


        cd (start_cd)
    end
    
    
end

%% Vis NC
if do_nc
    logger=0;
    h1=figure;
    hold on
    
    x1=nc_vis_uni(:,1);
    y1=nc_vis_uni(:,2);
    num=1;
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols(1,:),logger,num,reg_width,dotsize);
    
    x2=nc_vis_cross(:,1);
    y2=nc_vis_cross(:,2);
    num=2;
    legtxt(4:6)=Plot_XvsY_thisfun (x2,y2,lincols(2,:),logger,num,reg_width,dotsize);
    
    set (gca,'xlim',[-.5 1]);
    set (gca,'ylim',[-.5 1]);
    minmax=get(gca,'xlim');
    plot (minmax,minmax,':k','LineWidth',unity_width)
    
%     chld=get(gca,'children');
%     set(gca,'children',chld([3,6,5,2,7,4,1]));
    legend(legtxt)
    if logger
        title ('NC : Vis : Log_2')
    else
        title ('NC : Vis')
    end
    xlabel('Driver')
    ylabel('w/ Competitor')
    
    if unpaired_tt
        [~,p]=ttest2(y1,y2);
        fprintf('\nVis NC:\t%.2e',p)
    end
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(h1,'Notes_Comp_Vis_NC','-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
        print(h1,'Paper_Comp_Vis_NC','-dpng',['-r',rez]) %Save it!
                
        % write visnc-1/2.txt
        writeWillXY(x1, y1, 'visnc-1.txt');
        writeWillXY(x2, y2, 'visnc-2.txt');


        cd (start_cd)
    end
    %% Aud NC
    logger=0;
    h1=figure;
    hold on
    
    x1=nc_aud_uni(:,1);
    y1=nc_aud_uni(:,2);
    num=1;
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols(1,:),logger,num,reg_width,dotsize);
    
    x2=nc_aud_cross(:,1);
    y2=nc_aud_cross(:,2);
    num=2;
    legtxt(4:6)=Plot_XvsY_thisfun (x2,y2,lincols(2,:),logger,num,reg_width,dotsize);
    
    set (gca,'xlim',[-.5 1]);
    set (gca,'ylim',[-.5 1]);
    minmax=get(gca,'xlim');
    plot (minmax,minmax,':k','LineWidth',unity_width)
    
%     chld=get(gca,'children');
%     set(gca,'children',chld([1:7]));
    legend(legtxt)
    if logger
        title ('NC : Aud : Log_2')
    else
        title ('NC : Aud')
    end
    xlabel('Driver')
    ylabel('w/ Competitor')
    
    if unpaired_tt
        [~,p]=ttest2(y1,y2);
        fprintf('\nAud NC:\t%.2e\n',p)
    end
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(h1,'Notes_Comp_Aud_NC','-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 paper_x_width paper_y_width]);
        print(h1,'Paper_Comp_Aud_NC','-dpng',['-r',rez]) %Save it!
                
        % write audnc-1/2.txt
        writeWillXY(x1, y1, 'audnc-1.txt');
        writeWillXY(x2, y2, 'audnc-2.txt');


        cd (start_cd)
    end
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function legtxt=Plot_XvsY_thisfun (x,y,lincol,logger,num,reg_width,dotsize)
pfits=polyfit(x,y,1);
xminmax= [min(x),max(x)];
if jbtest(x) || jbtest(y) %either distribution is not normal
    %do paired non-para test
    [p_exp,~]=signrank(x,y);
    exp_type='Median';
%     exp_val_x=median(x);
%     exp_val_y=median(y);
    exp_val_x=mean(x);
    exp_val_y=mean(y);
    test='SR';
else
    %do paired ttest
    [~,p_exp]=ttest(x,y);
    exp_type='Mean';
    exp_val_x=mean(x);
    exp_val_y=mean(y);
    test='TT';
end

[rho,p_corr]=corr(x,y);
plotfit_x=xminmax(1):.01:xminmax(2);
plotfit_y=[plotfit_x',ones(size(plotfit_x'))]*pfits';

% if logger
%     if num==1
%         plot (log2(1+x),log2(1+y),'d','MarkerSize',dotsize,'Color',lincol)
%         plot (log2(1+exp_val_x),log2(1+exp_val_y),'d','MarkerSize',10,'LineWidth',2,'Color',lincol)
%     else
%         plot (log2(1+x),log2(1+y),'o','MarkerSize',dotsize,'Color',lincol)
%         plot (log2(1+exp_val_x),log2(1+exp_val_y),'o','MarkerSize',7,'LineWidth',2,'Color',lincol)
%     end
%     plot (log2(1+plotfit_x),log2(1+plotfit_y),'LineWidth',reg_width,'Color',lincol)
% else
    if num==1
        plot (x,y,'d','MarkerSize',dotsize,'Color',lincol)
        plot (exp_val_x,exp_val_y,'d','MarkerSize',10,'LineWidth',2,'Color',lincol)
    else
        plot (x,y,'o','MarkerSize',dotsize,'Color',lincol)
        plot (exp_val_x,exp_val_y,'o','MarkerSize',7,'LineWidth',2,'Color',lincol)
    end
    plot (plotfit_x,plotfit_y,'LineWidth',reg_width,'Color',lincol)
% end

if num==1
    legtxt{1}=sprintf('UNI: n=%i',length(x));
else
    legtxt{1}=sprintf('CROSS: n=%i',length(x));
end
legtxt{2}=sprintf('%s = [%.2f %.2f] : p(x==y)=%.2e : %s',exp_type,exp_val_x,exp_val_y,p_exp,test');

legtxt{3}=sprintf('y= %.2f*x + %.2f \n r= %.2f, p=%.4f',pfits(1),pfits(2),rho,p_corr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% djs - change return values to include x,y arrays that were plotted.

function [legtxt, x_plotted, y_plotted, x_plotted_alt, y_plotted_alt]=Plot_Rel_Change_thisfun(x,y,pval,num,lincols,dotsize)
y_rel=y./x;
sig_change=pval<.05;

%there was one big outlier ... droping anything more than 3 standard deviations below mean
dropper=find(y_rel<(mean(y_rel)-3*std(y_rel)) | y_rel>(mean(y_rel)+3*std(y_rel)) );
y_rel(dropper)=[];
x(dropper)=[];
plot_x=-.5:1/(length(x)-1):.5;
y(dropper)=[];
sig_change(dropper)=[];

% %there was one big outlier ... droping anything more than 3 standard deviations below mean
% dropper1=find(y<(mean(y)-3*std(y)) | y>(mean(y)+3*std(y)) );
% dropper2=find(x<(mean(x)-3*std(x)) | x>(mean(x)+3*std(x)) );
% dropper=dropper1 | dropper2;
% x(dropper)=[];
% y(dropper)=[];
% 
% y_rel=y./x;

if jbtest(x) || jbtest(y) %either distribution is not normal
    %do paired non-para test
    [p_exp,~]=signrank(x,y,'tail','right');
    exp_type='Median';
    exp_val=median(y_rel);
    test='SR';
else
    %do paired ttest
    [~,p_exp]=ttest(x,y);
    exp_type='Mean';
    exp_val=mean(y_rel);
    test='TT';
end

x_plotted = plot_x(sig_change);
y_plotted = y_rel(sig_change);
x_plotted_alt = plot_x(~sig_change);
y_plotted_alt = y_rel(~sig_change);

if num==1
    plot (plot_x(sig_change),y_rel(sig_change),'d','MarkerSize',dotsize,'Color',lincols,'LineWidth',1.5)
    plot (plot_x(~sig_change),y_rel(~sig_change),'d','MarkerSize',dotsize,'Color',lincols,'LineWidth',.5)
    plot (0,exp_val,'d','MarkerSize',10,'Color',lincols,'LineWidth',2)
else
    plot (plot_x(sig_change),y_rel(sig_change),'o','MarkerSize',dotsize,'Color',lincols,'LineWidth',1.5)
    plot (plot_x(~sig_change),y_rel(~sig_change),'o','MarkerSize',dotsize,'Color',lincols,'LineWidth',.5)
    plot (0,exp_val,'o','MarkerSize',7,'Color',lincols,'LineWidth',2)
end

if num==1
    legtxt{1}=sprintf('UNI sig: n=%i',sum(sig_change));
    legtxt{2}=sprintf('UNI non-sig: n=%i',sum(~sig_change));
else
    legtxt{1}=sprintf('CROSS sig: n=%i',sum(sig_change));
    legtxt{2}=sprintf('CROSS non-sig: n=%i',sum(~sig_change));
end
legtxt{3}=sprintf('%s = [%.2f] : p(x==y)=%.2e : %s',exp_type,exp_val,p_exp,test');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pop_resp,pop_sig_comp,pop_ff,pop_nc]=This_Data_Grabber(dome_cell,driver,competitor,competitor_alt)
global site_cell
pop_resp=[];
pop_sig_comp=[];
pop_ff=[];
pop_nc=[];
for i=1:length(site_cell)
    site=site_cell{i};
    driv_ind=strcmp(site.id_mt_labels,driver);
    comp_ind=strcmp(site.id_mt_labels,competitor);
    
    % sometimes the driver-competitor order gets messed up
    if sum(comp_ind)==0
        comp_ind=strcmp(site.id_mt_labels,competitor_alt);
    end
    
    %if two competitor conditions were the same (happens with unimodal vis
    %sometimes) only use the first one
    if sum(comp_ind)>1 
        both_inds=find(comp_ind==1);
        comp_ind(both_inds(2))=0;
    end
    
    if sum(driv_ind)==1 && sum(comp_ind)==1%if all classes existed
        %%% Assemble Responses
        driv_resp=site.data_mt_resp(dome_cell{1,i},driv_ind);
        comp_resp=site.data_mt_resp(dome_cell{1,i},comp_ind);
        
        pop_resp=[pop_resp;[driv_resp,comp_resp]];
        
        %%% Assemble Significant Competitors
        pop_sig_comp=[pop_sig_comp;site.sig_comp(dome_cell{1,i},comp_ind)];
        
        %%% Assemble Fanos
        driv_ff=site.data_fano(dome_cell{1,i},driv_ind);
        comp_ff=site.data_fano(dome_cell{1,i},comp_ind);
        
        pop_ff=[pop_ff;[driv_ff,comp_ff]];
        
        %%% Assemble NCs
        driv_nc=site.data_mt_post_corr(dome_cell{2,i},driv_ind);
        comp_nc=site.data_mt_post_corr(dome_cell{2,i},comp_ind);
        
        pop_nc=[pop_nc;[driv_nc,comp_nc]];
        
    end
    
end
