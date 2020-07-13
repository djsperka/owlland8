function Bimodal_Integration_Wrap(handles)
global site_cell
% This function is designed to test whether response magnitude, fano
% factor and noise correlations for the bimodal data match what would be
% predicted by just summing the unimodal counterparts on a trial-by-trial
% basis
% Fanos and NCs need to be calculated from post-period only spikes, but
% response magnitudes should be calculated from baseline-subtracted
% If I sum the same trial number then there will still be some temporal
% correlation between the unimodal aud and vis, so it hasn't fully
% disrupted the internal correlations.  Better to shuffle the trials 1000
% times, recalculate the FF and NC each shuffle and take the average values
% from that

[save_figs,mod_script,do_fct]=BImodal_Integration_Start();

if mod_script
    dbstack
    keyboard
end

show_shuffle_independence=0;

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

if save_figs
    start_cd=cd;
    thispath=mfilename('fullpath');
    root_path=strcat(thispath(1:end-length(mfilename)));
    cd (strcat(root_path,'..\Dougs_Data\Correlation Summary Workspaces\Competition'))
    %     cd ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition')
    save_cd=uigetdir;
    cd(start_cd);
end

% Function Controls
n_shuff=100; % how many times do you want to shuffle unimodal responses?

% Figure Dimensions
notes_x_width=4; notes_y_width=3.5;
poster_x_width=2.5 ;poster_y_width=2;
rez='300'; %DPI ... needs to be a string

% Data colors and sizes
lincols=linspecer(2);
unity_width=1;
regression_width=.5;
dotsize=4;

% Initialize population assembly vectors
pop_bim_resp=[]; %these are baseline subtracted, to be used for the response analysis
pop_sum_resp=[];
pop_bim_post=[]; %these are post-period only, to be used for the fano and NCs
pop_sum_post=[];
pop_imbalance=[]; %this is vis-aud / vis+aud
pop_imb_p=[]; % the p-value for comparing unisensory response magnitudes
pop_addativity=[]; %this is bim-sum / sum * 100
pop_p_linear=[];
pop_plin_param=[];
pop_bim_ff=[];
pop_sum_ff=[];
pop_bim_nc=[];
pop_sum_nc=[];

vis_post_noshuff_pop=[];
aud_post_noshuff_pop=[];
vis_post_shuff_pop=[];
aud_post_shuff_pop=[];

%% Grab data
for i=1:length(site_cell);
    site=site_cell{i};
    
    %find the correct columnd of your multitrace data
    vis_ind=strcmp(site.id_mt_labels,'Vw_I  ');
    aud_ind=strcmp(site.id_mt_labels,'A_I  ');
    bim_ind=strcmp(site.id_mt_labels,'A_I  Vw_I');
    
    if sum(bim_ind)~=0 % If there was bimodal data we will use this site
        site_dome=dome_cell{1,i};
        num_cells=sum(site_dome);
        
        % grab the baseline-subtracted responses for each cell
        site_resp=site.id_mt_data.resp_cell(site_dome);
        
        
        vis_resp=nan(50,num_cells);
        aud_resp=vis_resp;
        bim_resp=vis_resp;
        p_linear=nan(1,num_cells);
        p_lin_test_isparametric=nan(1,num_cells);
        
        for j=1:num_cells
            vis_resp(:,j)=site_resp{j}(:,vis_ind);
            aud_resp(:,j)=site_resp{j}(:,aud_ind);
            bim_resp(:,j)=site_resp{j}(:,bim_ind);
            
            %%% Calculate whether bimodal responses are significantly
            %%% different from summed unimodal responses
            n_bootstrap=1000;
            bs_sum=nan(1,n_bootstrap);
            for k=1:n_bootstrap
                bs_sum(k)=vis_resp(randi(50),j)+aud_resp(randi(50),j);
            end
            
            x=bs_sum;
            y=bim_resp(:,j);
            if jbtest(x) || jbtest(y) %either distribution is not normal
                %do unpaired non-para test
                [p_mean,~]=ranksum(x,y);
                parametric=0;
            else
                %do unpaired ttest
                [~,p_mean]=ttest2(x,y);
                parametric=1;
            end
            
            p_linear(j)=p_mean;
            p_lin_test_isparametric(j)=parametric;
            
        end
        bim_resp_mu=mean(bim_resp);
        pop_bim_resp=[pop_bim_resp,bim_resp_mu];
        sum_resp_mu=mean(vis_resp+aud_resp);
        pop_sum_resp=[pop_sum_resp,sum_resp_mu];
        pop_p_linear=[pop_p_linear,p_linear];
        pop_plin_param=[pop_plin_param,p_lin_test_isparametric];
        
        
        % unisensory imbalance
        %             unisensory_imbalance= (mean(vis_resp)-mean(aud_resp)) ./ (mean(vis_resp)+mean(aud_resp));
        site_ui=site.data_uni_imb(site_dome); % calculated the same way, but now just done in Calc_Unisensory_Imbalance
        site_ui_p=site.data_uni_imb_p(site_dome);
        pop_imbalance=[pop_imbalance,site_ui'];
        pop_imb_p=[pop_imb_p,site_ui_p'];
        
        % addativity
        site_add=(bim_resp_mu-sum_resp_mu )*100 ./ sum_resp_mu;
        pop_addativity=[pop_addativity,site_add];
        
        
        % grab post-period responses for each cell
        site_post=site.id_mt_data.post_cell(site_dome);
        
        vis_post=nan(50,num_cells);
        aud_post=vis_post;
        bim_post=vis_post;
        
        for j=1:num_cells
            vis_post(:,j)=site_post{j}(:,vis_ind);
            aud_post(:,j)=site_post{j}(:,aud_ind);
            bim_post(:,j)=site_post{j}(:,bim_ind);
        end
        
        %%%% compile bimiodal response data
        % Post
        bim_post_mu=mean(bim_post);
        pop_bim_post=[pop_bim_post,bim_post_mu];
        % Fano
        bim_ff=std(bim_post).^2./bim_post_mu;
        pop_bim_ff=[pop_bim_ff,bim_ff];
        % Noise corrs
        if num_cells>1
            temp_corr=corr(bim_post);
            bim_nc=temp_corr(triu ( true(num_cells,num_cells),1 ));
            pop_bim_nc=[pop_bim_nc,bim_nc'];
        end
        
        %%% Shuffle aud relative to vis
        %  keep units associated with eachother
        shuff_mu=nan(n_shuff,num_cells);
        shuff_ff=shuff_mu;
        shuff_nc=nan(n_shuff,num_cells*(num_cells-1)/2);
        
        %%% Look for correlations before your shuffle
        vis_post_noshuff_pop=[vis_post_noshuff_pop,vis_post];
        aud_post_noshuff_pop=[aud_post_noshuff_pop,aud_post];
        
        
        for j=1:n_shuff
            % Shuffle - data is in n_resp x n_cell matrix
            shuff_aud=aud_post(randperm(50),:);
            sum_av_post=vis_post+shuff_aud;
            
            %%% Store values for a correlation analysis later
            vis_post_shuff_pop=[vis_post_shuff_pop,vis_post];
            aud_post_shuff_pop=[aud_post_shuff_pop,shuff_aud];
            
            % Mean
            shuff_mu(j,:)=mean(sum_av_post);
            
            % Fano
            shuff_ff(j,:)=std(sum_av_post).^2./shuff_mu(j,:);
            
            % Noise corrs
            if num_cells>1
                temp_corr=corr(sum_av_post);
                shuff_nc(j,:)=temp_corr(triu ( true(num_cells,num_cells),1 ));
            end
            
        end
        
        %%% Compile unimodal sum response data
        sum_mu=mean(shuff_mu,1);
        sum_ff=mean(shuff_ff,1);
        sum_nc=mean(shuff_nc,1);
        pop_sum_post=[pop_sum_post,sum_mu];
        pop_sum_ff=[pop_sum_ff,sum_ff];
        pop_sum_nc=[pop_sum_nc,sum_nc];
        
    end
end

%% look for correlations in aud and vis on the same trial vs after shuffle
if show_shuffle_independence
    h1=figure;
    plot (vis_post_noshuff_pop(:),aud_post_noshuff_pop(:),'ok','Markersize',dotsize)
    xlabel('Vis Post')
    ylabel('Aud Post')
    [rho,p]=corr(vis_post_noshuff_pop,aud_post_noshuff_pop);
    legend(sprintf('rho=%.2f,p=%.2e',mean(diag(rho)),mean(diag(p)) ))
    title ('No Shuffle')
    
    h2=figure;
    plot (vis_post_shuff_pop(:),aud_post_shuff_pop(:),'ok','Markersize',dotsize)
    xlabel('Vis Post')
    ylabel('Aud Post')
    rho=nan(size(vis_post_shuff_pop,2),1);
    p=rho;
    for i=1:size(vis_post_shuff_pop,2)
        [rho(i),p(i)]=corr(vis_post_shuff_pop(:,i),aud_post_shuff_pop(:,i));
    end
    legend(sprintf('rho=%.2f,p=%.2e',mean(rho),mean(p) ))
    title ('Shuffle')
    
    if save_figs
        cd(save_cd)
        
        figure (h1)
        set(h1, 'PaperUnits', 'inches');
        set(h1, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(h1,'Notes_Int_SUMvsBIM_Corr_NoShuff','-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(h1, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        print(h1,'Paper_Int_SUMvsBIM_Corr_NoShuff','-dpng',['-r',rez]) %Save it!
        
        figure (h2)
        set(h2, 'PaperUnits', 'inches');
        set(h2, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(h2,'Notes_Int_SUMvsBIM_Corr_Shuff','-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(h2, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        print(h2,'Paper_Int_SUMvsBIM_Corr_Shuff','-dpng',['-r',rez]) %Save it!
        
        cd (start_cd)
    end
end

%% Plot response

if(do_fct.respSum_vs_respBim)
    
    %%% Combined
    logger=1;
    
    h1=figure;
    hold on
    % Use baseline subtracted for response plots
    x1=pop_bim_resp';
    y1=pop_sum_resp';
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,dotsize,regression_width);
    minmax=get(gca,'xlim');
    
    if logger
        title ('Resp : Log_2')
        set(gca,'Yscale','log')
        set(gca,'XScale','log')
        
        if minmax(1)<1 % need this because log of 0 DNE
            minmax(1)=1;
        end
    else
        title ('Resp')
    end
    
    plot (minmax,minmax,':k','LineWidth',unity_width)
    legend(legtxt)
    
    xlabel('Resp(Vis+Aud)')
    ylabel('Resp(Vis)+Resp(Aud)')
    
    chld=get(gca,'children');
    set(gca,'children',chld([2,3,4,1]));
    
    sig_diff=pop_p_linear<0.05;
    plot (x1(sig_diff),y1(sig_diff),'ok','MarkerSize',dotsize,'MarkerFace','k')
    
    set (gca,'xlim',minmax)
    set (gca,'ylim',minmax)
    legtxt{1}=sprintf('%s :: n(p<.05)=%.0i',legtxt{1},sum(sig_diff));
    legend (legtxt)
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(h1,'Notes_Int_SUMvsBIM_Resp','-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        print(h1,'Paper_Int_SUMvsBIM_Resp','-dpng',['-r',rez]) %Save it!
        cd (start_cd)
    end
end

%% Plot adativity index vs bimodal response magnitude
if(do_fct.respBim_vs_add)
    
    logger=1;
    h1=figure;
    hold on
    
    x1=pop_bim_resp';
    y1=pop_addativity';
    sig_diff=pop_p_linear'<.05;
%     legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,dotsize,0);
%     legend(legtxt)
    xlabel('Bimodal Response(hz)')
    ylabel('Addativity Index [(bim-sum) *100 / sum]')
    
%     chld=get(gca,'children');
%     set(gca,'children',chld([2,1]));
    
    plot (x1,y1,'ok','MarkerSize',dotsize);
    plot (x1(sig_diff),y1(sig_diff),'ok','MarkerFaceColor','k','MarkerSize',dotsize);
    legtxt{1}=sprintf('DATA: n=%i',length(x1));
    legtxt{1}=sprintf('%s :: n(p<.05)=%.0i',legtxt{1},sum(sig_diff));
    
    plot ([1 140],[0 0],':k','LineWidth',unity_width)
    
    if logger
        title ('Bimodal vs Addativity : Log_2')
        xlimits=get (gca,'xlim');
        set(gca,'XScale','log')
        set (gca,'xlim',xlimits);
        
    else
        title ('Bimodal vs Addativity')
    end
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(h1,'Notes_Int_Bim_vs_Additivity','-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        print(h1,'Paper_Int_Bim_vs_Additivity','-dpng',['-r',rez]) %Save it!
        cd (start_cd)
    end
    
end

%% Compare addativity to response imbalance ... NOT absolute  mag
if(do_fct.uniImb_vs_add)
    logger=0;
    
    h1=figure;
    hold on
    
    x1=pop_imbalance';
    sig_diff=pop_imb_p'<.05;
    y1=pop_addativity';
    
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,dotsize,regression_width);
    plot (x1(sig_diff),y1(sig_diff),'ok','MarkerSize',dotsize,'MarkerFaceColor','k')
    legtxt{1}=sprintf('%s :: n(p[ui]<.05=%.0i',legtxt{1},sum(sig_diff));
    legend(legtxt)
    if logger
        title ('Imbalance vs Addativity : Log_2')
        set(gca,'Yscale','log')
        set(gca,'XScale','log')
    else
        title ('Imbalance vs Addativity')
    end
    xlabel('Unisensory Imbalance [vis-aud / vis+aud]')
    ylabel('Addativity Index [(bim-sum) *100 / sum]')
    
    chld=get(gca,'children');
    set(gca,'children',chld([3,4,2,1]));
    % delete(chld(1));
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(h1,'Notes_Int_IMBvsADD','-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        print(h1,'Paper_Int_IMBvsADD','-dpng',['-r',rez]) %Save it!
        cd (start_cd)
    end
end

%% Compare addativity to response imbalance ... WITH absolute  mag
if(do_fct.absUniImb_vs_add)
    logger=0;
    
    h1=figure;
    hold on
    
    x1=abs(pop_imbalance');
    sig_diff=pop_p_linear'<.05;
    y1=pop_addativity';
    
%     legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,dotsize,0);
    plot (x1,y1,'ok','MarkerSize',dotsize)
    plot (x1(sig_diff),y1(sig_diff),'ok','MarkerSize',dotsize,'MarkerFaceColor','k')
    legtxt{1}=sprintf('DATA: n=%i',length(x1));
    legtxt{1}=sprintf('%s :: n(p[ui]<.05=%.0i',legtxt{1},sum(sig_diff));
    legend(legtxt)
    
    minmax=get(gca,'xlim');
    plot (minmax,[0 0],':k','LineWidth',unity_width)
    
    if logger
        title ('Imbalance vs Addativity : Log_2')
        set(gca,'Yscale','log')
        set(gca,'XScale','log')
    else
        title ('Imbalance vs Addativity')
    end
    xlabel('abs(Unisensory Imbalance [vis-aud / vis+aud])')
    ylabel('Addativity Index [(bim-sum) *100 / sum]')
    
    chld=get(gca,'children');
    set(gca,'children',chld([2,3,1]));
    % delete(chld(1));
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(h1,'Notes_Int_IMBvsADD_abs','-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        print(h1,'Paper_Int_IMBvsADD_abs','-dpng',['-r',rez]) %Save it!
        cd (start_cd)
    end
end

%% Bimodal FF
if(do_fct.ffSum_vs_ffBim)
    logger=0;
    
    h1=figure;
    hold on
    x1=pop_bim_ff';
    y1=pop_sum_ff';
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,dotsize,regression_width);
    
    minmax=get(gca,'xlim');
    plot (minmax,minmax,':k','LineWidth',unity_width)
    legend(legtxt)
    if logger
        title ('FF : Log_2')
    else
        title ('FF')
    end
    xlabel('FF(Bimodal)')
    ylabel('FF(Sum of Unimodal)')
    
    chld=get(gca,'children');
    set(gca,'children',chld([2,3,4,1]));
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(h1,'Notes_Int_SUMvsBIM_FF','-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        print(h1,'Paper_Int_SUMvsBIM_FF','-dpng',['-r',rez]) %Save it!
        cd (start_cd)
    end
end

%% Plot Noise Correlations
if(do_fct.ncSum_vs_ncBim)
    logger=0;
    
    h1=figure;
    hold on
    x1=pop_bim_nc';
    y1=pop_sum_nc';
    legtxt(1:3)=Plot_XvsY_thisfun (x1,y1,lincols,logger,dotsize,regression_width);
    
    set (gca,'xlim',[-.5 1]);
    set (gca,'ylim',[-.5 1]);
    minmax=get(gca,'xlim');
    plot (minmax,minmax,':k','LineWidth',unity_width)
    legend(legtxt)
    if logger
        title ('NC : Log_2')
    else
        title ('NC')
    end
    xlabel('NC(Bimodal)')
    ylabel('NC(Sum of Unimodal)')
    
    chld=get(gca,'children');
    set(gca,'children',chld([2,3,4,1]));
    
    if save_figs
        cd(save_cd)
        set(gcf, 'PaperUnits', 'inches');
        set(gcf, 'PaperPosition', [0 0 notes_x_width notes_y_width]);
        print(h1,'Notes_Int_SUMvsBIM_NC','-dpng',['-r',rez]) %Save it!
        xlabel('')
        ylabel('')
        legend('off')
        title('')
        set(gcf, 'PaperPosition', [0 0 poster_x_width poster_y_width]);
        print(h1,'Paper_Int_SUMvsBIM_NC','-dpng',['-r',rez]) %Save it!
        cd (start_cd)
    end
    
end
function legtxt=Plot_XvsY_thisfun (x,y,lincol,logger,dotsize,regression_width)

dropper=isnan(x) | isnan(y);
x(dropper)=[];
y(dropper)=[];

% outliers=x>(mean(x)+3*std(x)) | x<(mean(x)-3*std(x)) ;
% x(outliers)=[];
% y(outliers)=[];

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

% if logger
%     %     plot (log2(1+x),log2(1+y),'.','MarkerSize',dotsize,'Color',lincol(1,:))
%     %     plot (log2(1+mean(x)),log2(1+mean(y)),'d','MarkerSize',10,'LineWidth',2,'Color',lincol(2,:))
%     %     plot (log2(1+plotfit_x),log2(1+plotfit_y),'--','Color',lincol(2,:),'LineWidth',regression_width)
%     plot (log2(1+x),log2(1+y),'ok','MarkerSize',dotsize)
%     plot (log2(1+mean(x)),log2(1+mean(y)),'dk','MarkerSize',10,'LineWidth',2)
%     plot (log2(1+plotfit_x),log2(1+plotfit_y),'--k','LineWidth',regression_width)
% else
%     %     plot (x,y,'.','MarkerSize',dotsize,'Color',lincol(1,:))
%     %     plot (mean(x),mean(y),'d','MarkerSize',10,'LineWidth',2,'Color',lincol(2,:))
%     %     plot (plotfit_x,plotfit_y,'--','Color',lincol(2,:),'LineWidth',regression_width)
%     plot (x,y,'ok','MarkerSize',dotsize)
%     plot (mean(x),mean(y),'dk','MarkerSize',10,'LineWidth',2)
%     if regression_width>0
%         plot (plotfit_x,plotfit_y,'--k','LineWidth',regression_width)
%     end
% end

plot (x,y,'ok','MarkerSize',dotsize)
plot (mean(x),mean(y),'dk','MarkerSize',10,'LineWidth',2)
if regression_width>0
    plot (plotfit_x,plotfit_y,'-k','LineWidth',regression_width)
end


legtxt{1}=sprintf('DATA: n=%i',length(x));
legtxt{2}=sprintf('Mean = [%.2f %.2f], p(x==y)=%.2e : %s',mean(x),mean(y),p_mean, test);
legtxt{3}=sprintf('y= %.2f*x + %.2f \n r= %.2f, p=%.4f',pfits(1),pfits(2),rho,p_corr);
