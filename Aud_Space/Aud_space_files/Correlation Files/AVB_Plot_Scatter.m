function AVB_Plot_Scatter(pop_resp,pop_ff,pop_nc)
% This plots unimodal visual, unimodal auditory and bimodal vs eachother as
% scatter plots.  It used to do bimodal intergration vs sum of unimodal
% components also, but now that is done with the Bimodal_Integration_Wrap
% button

[do_resp,do_ff,do_nc,save_figs,mod_script]=AVB_Scatter_Start();

if mod_script
    dbstack
    keyboard
end

resp_ai=pop_resp(:,1);
resp_vi=pop_resp(:,2);
resp_vi_ai=pop_resp(:,3);

ff_ai=pop_ff(:,1);
ff_vi=pop_ff(:,2);
ff_vi_ai=pop_ff(:,3);

nc_ai=pop_nc(:,1);
nc_vi=pop_nc(:,2);
nc_vi_ai=pop_nc(:,3);

if save_figs
    start_cd=cd;
%     cd ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition')
    save_cd=uigetdir;
    cd(start_cd);
end

% set size of saved plots
notes_x_width=4; notes_y_width=3.5;
poster_x_width=2.5 ;poster_y_width=2;

% set data sizes
unity_width=1;
dotsize=10;
regression_width=1.5;

% Set Colors
all_blue=0; %if you activate this all your lines and dots will be blue
lincols=linspecer(2);
if all_blue
    lincols(2,:)=lincols(1,:);
end

if do_resp
    %% Unimodal Response
    logger=1;
    h1=figure;
    hold on
    x1=resp_vi;
    y1=resp_ai;
    num=1;
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,num,dotsize,regression_width);
    
    minmax=get(gca,'xlim');
    plot (minmax,minmax,'--k','LineWidth',unity_width)
    legend(legtxt)
    if logger
        title ('Resp : Log_2')
    else
        title ('Resp')
    end
    xlabel('Vis')
    ylabel('Aud')
    
    chld=get(gca,'children');
    set(gca,'children',chld([2,3,4,1]));
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        saveas(h1,'Notes_Int_Resp_Uni.png') %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        saveas(h1,'Paper_Int_Resp_Uni.png') %Save it!
        cd (start_cd)
    end
    
    %% Bimodal Response
    %%% Visual
    logger=1;
    h1=figure;
    hold on
    x1=resp_vi;
    y1=resp_vi_ai;
    num=1;
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,num,dotsize,regression_width);
    
    minmax=get(gca,'xlim');
    plot (minmax,minmax,'--k','LineWidth',unity_width)
    legend(legtxt)
    if logger
        title ('Resp : Log_2')
    else
        title ('Resp')
    end
    xlabel('Resp(Vis)')
    ylabel('Resp(Vis+Aud)')
    
    chld=get(gca,'children');
    set(gca,'children',chld([2,3,4,1]));
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        saveas(h1,'Notes_Int_Resp_Bim_Vis.png') %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        saveas(h1,'Paper_Int_Resp_Bim_Vis.png') %Save it!
        cd (start_cd)
    end
    
    %%% Auditory
    
    h1=figure;
    hold on
    x1=resp_ai;
    y1=resp_vi_ai;
    num=1;
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,num,dotsize,regression_width);
    
    minmax=get(gca,'xlim');
    plot (minmax,minmax,'--k','LineWidth',unity_width)
    legend(legtxt)
    if logger
        title ('Resp : Log_2')
    else
        title ('Resp')
    end
    xlabel('Resp(Aud)')
    ylabel('Resp(Vis+Aud)')
    
    chld=get(gca,'children');
    set(gca,'children',chld([2,3,4,1]));
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        saveas(h1,'Notes_Int_Resp_Bim_Aud.png') %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        saveas(h1,'Paper_Int_Resp_Bim_Aud.png') %Save it!
        cd (start_cd)
    end
    
%     %%% Combined
%     logger=1;
%     
%     h1=figure;
%     hold on
%     x1=resp_vi_ai;
%     y1=resp_vi+resp_ai;
%     num=1;
%     legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,num,dotsize,regression_width);
%     
%     minmax=get(gca,'xlim');
%     plot (minmax,minmax,'--k','LineWidth',unity_width)
%     legend(legtxt)
%     if logger
%         title ('Resp : Log_2')
%     else
%         title ('Resp')
%     end
%     xlabel('Resp(Vis+Aud)')
%     ylabel('Resp(Vis)+Resp(Aud)')
%     
%     chld=get(gca,'children');
%     set(gca,'children',chld([2,3,4,1]));
%     
%     if save_figs
%         cd(save_cd)
%         set(gcf, 'PaperUnits', 'inches');
%         set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
%         saveas(h1,'Notes_Int_Resp_Int.png') %Save it!
%         xlabel('')
%         ylabel('')
%         legend('off')
%         title('')
%         set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
%         saveas(h1,'Paper_Int_Resp_Int.png') %Save it!
%         cd (start_cd)
%     end
end

if do_ff
    %% Unimodal FF
    logger=1;
    
    h1=figure;
    hold on
    x1=ff_vi;
    y1=ff_ai;
    num=1;
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,num,dotsize,regression_width);
    
    minmax=get(gca,'xlim');
    plot (minmax,minmax,'--k','LineWidth',unity_width)
    legend(legtxt)
    if logger
        title ('FF : Log_2')
    else
        title ('FF')
    end
    xlabel('Vis')
    ylabel('Aud')
    
    chld=get(gca,'children');
    set(gca,'children',chld([2,3,4,1]));
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        saveas(h1,'Notes_Int_FF_Uni.png') %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        saveas(h1,'Paper_Int_FF_Uni.png') %Save it!
        cd (start_cd)
    end
    
    %% Bimodal FF
    %%% Visual
    
    h1=figure;
    hold on
    x1=ff_vi;
    y1=ff_vi_ai;
    num=1;
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,num,dotsize,regression_width);
    
    minmax=get(gca,'xlim');
    plot (minmax,minmax,'--k','LineWidth',unity_width)
    legend(legtxt)
    if logger
        title ('FF : Log_2')
    else
        title ('FF')
    end
    xlabel('Vis')
    ylabel('Bimodal')
    
    chld=get(gca,'children');
    set(gca,'children',chld([2,3,4,1]));
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        saveas(h1,'Notes_Int_FF_Bim_Vis.png') %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        saveas(h1,'Paper_Int_FF_Bim_Vis.png') %Save it!
        cd (start_cd)
    end
    
    %%% Auditory
    
    h1=figure;
    hold on
    x1=ff_ai;
    y1=ff_vi_ai;
    num=1;
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,num,dotsize,regression_width);
    
    minmax=get(gca,'xlim');
    plot (minmax,minmax,'--k','LineWidth',unity_width)
    legend(legtxt)
    if logger
        title ('FF : Log_2')
    else
        title ('FF')
    end
    xlabel('Aud')
    ylabel('Bimodal')
    
    chld=get(gca,'children');
    set(gca,'children',chld([2,3,4,1]));
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        saveas(h1,'Notes_Int_FF_Bim_Aud.png') %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        saveas(h1,'Paper_Int_FF_Bim_Aud.png') %Save it!
        cd (start_cd)
    end
    
%     %% Bimodal FF ... FF(Ai Vi) vs FF(Ai) + FF(Vi) etc
%     logger=1;
%     
%     h1=figure;
%     hold on
%     x1=ff_vi_ai;
%     % y1=ff_ai+ff_vi;
%     y1=mean([ff_vi,ff_ai],2);
%     % y1=ff_vi.*ff_ai.^.5;
%     % y1=max([ff_vi,ff_ai]')';
%     % y1=min([ff_vi,ff_ai]')';
%     num=1;
%     legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,num,dotsize,regression_width);
%     
%     minmax=get(gca,'xlim');
%     plot (minmax,minmax,'--k','LineWidth',unity_width)
%     legend(legtxt)
%     if logger
%         title ('FF : Log_2')
%     else
%         title ('FF')
%     end
%     xlabel('FF(Vis+Aud)')
%     ylabel('mean(FF(Vis),FF(Aud))')
%     
%     chld=get(gca,'children');
%     set(gca,'children',chld([2,3,4,1]));
%     
%     if save_figs
%         cd(save_cd)
%         set(gcf, 'PaperUnits', 'inches');
%         set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
%         saveas(h1,'Notes_Int_FF_Int.png') %Save it!
%         xlabel('')
%         ylabel('')
%         legend('off')
%         title('')
%         set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
%         saveas(h1,'Paper_Int_FF_Int.png') %Save it!
%         cd (start_cd)
%     end
end

if do_nc
    %% Noise Corr
    
    logger=0;
    
    h1=figure;
    hold on
    x1=nc_vi;
    y1=nc_ai;
    num=1;
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,num,dotsize,regression_width);
    
    set (gca,'xlim',[-1 1]);
    set (gca,'ylim',[-1 1]);
    minmax=get(gca,'xlim');
    plot (minmax,minmax,'--k','LineWidth',unity_width)
    legend(legtxt)
    if logger
        title ('NC : Log_2')
    else
        title ('NC')
    end
    xlabel('Vis')
    ylabel('Aud')
    
    chld=get(gca,'children');
    set(gca,'children',chld([2,3,4,1]));
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        saveas(h1,'Notes_Int_NC_Uni.png') %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        saveas(h1,'Paper_Int_NC_Uni.png') %Save it!
        cd (start_cd)
    end
    
    %% Bimodal NC
    %%% Visual
    
    h1=figure;
    hold on
    x1=nc_vi;
    y1=nc_vi_ai;
    num=1;
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,num,dotsize,regression_width);
    
    set (gca,'xlim',[-1 1]);
    set (gca,'ylim',[-1 1]);
    minmax=get(gca,'xlim');
    plot (minmax,minmax,'--k','LineWidth',unity_width)
    legend(legtxt)
    if logger
        title ('NC : Log_2')
    else
        title ('NC')
    end
    xlabel('Vis')
    ylabel('Bimodal')
    
    chld=get(gca,'children');
    set(gca,'children',chld([2,3,4,1]));
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        saveas(h1,'Notes_Int_NC_Bim_Vis.png') %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        saveas(h1,'Paper_Int_NC_Bim_Vis.png') %Save it!
        cd (start_cd)
    end
    
    %%% Auditory
    
    h1=figure;
    hold on
    x1=nc_ai;
    y1=nc_vi_ai;
    num=1;
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,num,dotsize,regression_width);
    
    set (gca,'xlim',[-1 1]);
    set (gca,'ylim',[-1 1]);
    minmax=get(gca,'xlim');
    plot (minmax,minmax,'--k','LineWidth',unity_width)
    legend(legtxt)
    if logger
        title ('NC : Log_2')
    else
        title ('NC')
    end
    xlabel('Aud')
    ylabel('Bimodal')
    
    chld=get(gca,'children');
    set(gca,'children',chld([2,3,4,1]));
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        saveas(h1,'Notes_Int_NC_Bim_Aud.png') %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        saveas(h1,'Paper_Int_NC_Bim_Aud.png') %Save it!
        cd (start_cd)
    end
    
%     %% Bimodal NC ... NC(Ai Vi) vs NC(Ai) + NC(Vi) etc
%     
%     h1=figure;
%     hold on
%     x1=nc_vi_ai;
%     % y1=nc_ai+nc_vi;
%     y1=mean([nc_vi,nc_ai],2);
%     % y1=abs(nc_vi.*nc_ai).^.5;
%     % y1=max([nc_vi,nc_ai]')';
%     % y1=min([nc_vi,nc_ai]')';
%     num=1;
%     legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,num,dotsize,regression_width);
%     
%     set (gca,'xlim',[-1 1]);
%     set (gca,'ylim',[-1 1]);
%     minmax=get(gca,'xlim');
%     plot (minmax,minmax,'--k','LineWidth',unity_width)
%     legend(legtxt)
%     if logger
%         title ('NC : Log_2')
%     else
%         title ('NC')
%     end
%     xlabel('NC(Vis+Aud)')
%     ylabel('mean(NC(Vis),NC(Aud))')
%     
%     chld=get(gca,'children');
%     set(gca,'children',chld([2,3,4,1]));
%     
%     if save_figs
%         cd(save_cd)
%         set(gcf, 'PaperUnits', 'inches');
%         set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
%         saveas(h1,'Notes_Int_NC_Int.png') %Save it!
%         xlabel('')
%         ylabel('')
%         legend('off')
%         title('')
%         set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
%         saveas(h1,'Paper_Int_NC_Int.png') %Save it!
%         cd (start_cd)
%     end
end

function legtxt=Plot_XvsY_thisfun (x,y,lincol,logger,num,dotsize,regression_width)
pfits=polyfit(x,y,1);
xminmax= [min(x),max(x)];

if jbtest(x) || jbtest(y) %either distribution is not normal
    %do paired non-para test
    [p_mean,~]=signrank(x,y);
    test='SR';
else
    %do paired ttest
    [~,p_mean]=ttest(x,y);
    test='TT';
end

[rho,p_corr]=corr(x,y);
plotfit_x=xminmax(1):.01:xminmax(2);
plotfit_y=[plotfit_x',ones(size(plotfit_x'))]*pfits';

if logger
    plot (log2(1+x),log2(1+y),'.','MarkerSize',dotsize,'Color',lincol(1,:))
    if num==1
        plot (log2(1+mean(x)),log2(1+mean(y)),'d','MarkerSize',10,'LineWidth',2,'Color',lincol(2,:))
    else
        plot (log2(1+mean(x)),log2(1+mean(y)),'o','MarkerSize',7,'LineWidth',2,'Color',lincol(2,:))
    end
    plot (log2(1+plotfit_x),log2(1+plotfit_y),'--','Color',lincol(2,:),'LineWidth',regression_width)
else
    plot (x,y,'.','MarkerSize',dotsize,'Color',lincol(1,:))
    if num==1
        plot (mean(x),mean(y),'d','MarkerSize',10,'LineWidth',2,'Color',lincol(2,:))
    else
        plot (mean(x),mean(y),'o','MarkerSize',7,'LineWidth',2,'Color',lincol(2,:))
    end
    plot (plotfit_x,plotfit_y,'--','Color',lincol(2,:),'LineWidth',regression_width)
end
if num==1
    legtxt{1}=sprintf('VIS: n=%i',length(x));
else
    legtxt{1}=sprintf('AUD:  n=%i',length(x));
end
legtxt{2}=sprintf('Mean = [%.2f %.2f] : p(x==y)=%.2e : %s',mean(x),mean(y),p_mean,test);
legtxt{3}=sprintf('y= %.2f*x + %.2f \n r= %.2f, p=%.4f',pfits(1),pfits(2),rho,p_corr);