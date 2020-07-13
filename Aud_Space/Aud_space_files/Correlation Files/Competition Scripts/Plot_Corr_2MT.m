
function [h1,h2,hothers]=Plot_Corr_2MT (var1,var2,tune_sim,angular_sep,cutoff,changesameway,mt_labels,handles,type,conditions,tit1,tit2)
% This is the updated version of Plot_Competition DJT 9/30/2014
% -resp = responses for all of the mtraces
% -ncorr = pairwise noise correlations for all the mtraces
% -tune_sim = a pairwise metric for similarity in the resopnse profiles 
% -mt_labels is the cell array of strings identifying the conditions
% -handles is the structure array of handles coming from the GUI
% -type is a title thing so I can know if this was done using bimodal data,
% competition data or whatever

% Modified on 8/7/2015 to use jbtest instead of kstest for normality.
% kstest tests for a standard normal ditribution; mean of zero and std of
% 1. jbtest tests for a normal distribution with unknown mean and std.

% Fixed on 8/7/2015 : Logic error for statistical tests!  Was ONLY doing a
% parametric test if both distributions were non-parametric.  Crap!  This
% means that for my parametric conditions like noise-corr I probably had
% lowered sensitivity

h1=[];
h2=[];
hothers=[];

% xax_label{1}='';
% xax_label(2:1+length(mt_labels))=mt_labels;
% xax_label{end+1}='';\
xax_label=mt_labels;

%% Read in settings
show_resp=get(handles.show_resp,'Value');
show_noise_corr=get(handles.show_nc,'Value');
show_scat=get(handles.show_scat,'Value');
show_nc_hist=get(handles.show_nc_hist,'Value');
comp2=get(handles.comp2,'Value');

norm_to_max=get(handles.norm_to_max,'Value');
norm_to_vwi=get(handles.norm_to_vwi,'Value');

show_resp_bar_std=get(handles.resp_bg_std,'Value');
show_resp_bar_sites=get(handles.resp_bg_sites,'Value');
show_nc_bar_std=get(handles.nc_bg_std,'Value');
show_nc_bar_sites=get(handles.nc_bg_sites,'Value');

%% Response Bar Graph
if show_resp
    if norm_to_max
        resp_norm=var1 ./ (max(abs(var1),[],2)*ones(1,size(var1,2)));
        %below 2 lines makes some large negative numbers on occasion
%         has_pos=max(resp,[],2)>0;
%         resp_norm=nan(size(resp));
%         resp_norm(has_pos,:)=resp(has_pos,:) ./ (max(resp(has_pos,:),[],2)*ones(1,size(resp(has_pos,:),2)));
%         resp_norm(~has_pos,:)=resp(~has_pos,:) ./ (max(abs(resp(~has_pos,:)),[],2)*ones(1,size(resp(~has_pos,:),2)));
    elseif norm_to_vwi %normalize to weak vis in
        resp_norm=var1 ./ (var1(:,1)*ones(1,size(var1,2)));
    else
        resp_norm=var1;
    end
    %(:,[1 5])
    var1_mean=mean(resp_norm,1);
    var1_std=std(resp_norm,1);
    v1_std_plot_y=[var1_mean-var1_std;var1_mean+var1_std];
    v1_std_plot_x=ones(2,1)*[1:size(resp_norm,2)];
    v1_scat_x=ones(size(resp_norm,1),1) * (1:size(resp_norm,2));
    
    h1=figure;
    hold on;
    bar(var1_mean);
    if show_resp_bar_sites
        plot (v1_scat_x',resp_norm',':*r')
    end
    if show_resp_bar_std
        plot (v1_std_plot_x,v1_std_plot_y,'g','linewidth',1.5)
    end
    t1=strcat(type,' Experiment:  Stimulus Response');
    t2=sprintf(' :: # SUs = %.0f',size(resp_norm,1));
    
    title (strcat(t1,t2))
    set (gca,'Xtick',1:size(var1,2))
    set (gca,'XTickLabel',xax_label)
    xlabel('Stimulus Condition')
    ylabel('Responses re. weak stim in RF')
    hold off;
end

%% Noise Corr Bar Graphs
if show_noise_corr
    if isnan(cutoff) % UNBINNED
        % var2=var2 ./ (var2(:,1)*ones(1,size(var2,2)));
        dome=~isnan(var2);
        var2_mean=nan(1,size(var2,2));
        var2_std=nan(1,size(var2,2));
        for i=1:size(var2,2);
            var2_mean(i)=mean(var2(dome(:,i),i),1);
            var2_std(i)=std(var2(dome(:,i),i),1);
        end
        v2_std_plot_y=[var2_mean-var2_std;var2_mean+var2_std];
        v2_std_plot_x=ones(2,1)*[1:size(var2,2)];
        
        v2_scat_x=ones(size(var2,1),1)*(1:size(var2,2));
        
        h2=figure;
        hold on;
        bar(var2_mean);
        if show_nc_bar_sites
            plot (v2_scat_x',var2',':*r')
        end
        if show_nc_bar_std
            plot (v2_std_plot_x,v2_std_plot_y,'g','linewidth',1.5)
        end
        t3=strcat(type,' Experiment: Response Covariance');
        t4=sprintf(' :: # Pairs = %.0f',size(var2,1));
        title (strcat(t3,t4))
        set (gca,'Xtick',1:size(var2,2))
        set (gca,'XTickLabel',xax_label)
        xlabel('Stimulus Condition')
        ylabel('Correlation (r)')
        hold off;
        
        if show_nc_hist            
            figure;
            hist(var2(:,6),50);
            title('Noise Correlation Histogram');
            xlabel('Noise Correlation');
            ylabel('Count');
        end
        
    else % BINNED based on the cutoff
        
        over_cut_col=tune_sim>cutoff;
        over_cut_mat=logical(over_cut_col*ones(1,size(var2,2)));
        
        % Over cutoff
        dome=~isnan(var2) & over_cut_mat;
        var2_mean=nan(1,size(var2,2));
        var2_std=nan(1,size(var2,2));
        for i=1:size(var2,2);
            var2_mean(i)=mean(var2(dome(:,i),i),1);
            var2_std(i)=std(var2(dome(:,i),i),1);
        end
        v2_std_plot_y=[var2_mean-var2_std;var2_mean+var2_std];
        v2_std_plot_x=ones(2,1)*[1:size(var2,2)];
        v2_scat_x=ones(size(var2(over_cut_col,:),1),1)*(1:size(var2(over_cut_col,:),2));
        
        h2=figure;
        hold on;
        bar(var2_mean);
        if show_nc_bar_sites
            plot (v2_scat_x',var2(over_cut_col,:)',':*r')
        end
        if show_nc_bar_std
            plot (v2_std_plot_x,v2_std_plot_y,'g','linewidth',1.5)
        end
        t3=strcat(type,' Experiment: Response Covariance ');
        t4=sprintf(' TuneCorr > %.2f :: # Pairs = %.0f',cutoff,size(var2(over_cut_col,:),1));
        title (strcat(t3,t4))
        set (gca,'Xtick',1:size(var2,2))
        set (gca,'XTickLabel',xax_label)
        xlabel('Stimulus Condition')
        ylabel('Correlation (r)')
        hold off;
        
        %Under cutoff
        dome=~isnan(var2) & ~over_cut_mat;
        var2_mean=nan(1,size(var2,2));
        var2_std=nan(1,size(var2,2));
        for i=1:size(var2,2);
            var2_mean(i)=mean(var2(dome(:,i),i),1);
            var2_std(i)=std(var2(dome(:,i),i),1);
        end
        v2_std_plot_y=[var2_mean-var2_std;var2_mean+var2_std];
        v2_std_plot_x=ones(2,1)*[1:size(var2,2)];
        v2_scat_x=ones(size(var2(~over_cut_col,:),1),1)*(1:size(var2(~over_cut_col,:),2));
        
        h2=figure;
        hold on;
        bar(var2_mean);
        if show_nc_bar_sites
            plot (v2_scat_x',var2(~over_cut_col,:)',':*r')
        end
        if show_nc_bar_std
            plot (v2_std_plot_x,v2_std_plot_y,'g','linewidth',1.5)
        end
        t3=strcat(type,' Experiment: Response Covariance ');
        t4=sprintf(' TuneCorr < %.2f :: # Pairs = %.0f',cutoff,size(var2(~over_cut_col,:),1));
        title (strcat(t3,t4))
        set (gca,'Xtick',1:size(var2,2))
        set (gca,'XTickLabel',xax_label)
        xlabel('Stimulus Condition')
        ylabel('Correlation (r)')
        hold off;
 
    end
end

myscreen =get(0,'screensize');
columns=ceil(size(var2,2)/2);
width=floor(myscreen(3)/columns);
height=floor(myscreen(4)/2);

%% Tuning corr, DP or Pre corr vs noise corr scatters - UNBINNED
if show_scat 
    savetxt_sim=cell(1,size(var2,2));
    
    if get(handles.variable_1,'Value') == 10 %this was a pre-corr
        tune_sim=var1 (:,1);
    end
    % plot first row
    for i=1:columns
        do_me=~isnan(var2(:,i)) & ~isnan(tune_sim);
        coef=polyfit(tune_sim(do_me),var2(do_me,i),1);
        rho=corr(tune_sim(do_me),var2(do_me,i));
        showfit=[-1 1;1 1]*coef';
        
        hothers(i)=figure ('Position',[(i-1)*width,height,width,height-100]);
        hold on;
        scatter (tune_sim,var2(:,i))
        hlin=plot ([-1 1],showfit','--r');
        plot ([0 0],[-1 1],':k')
        plot ([-1 1],[0 0],':k')
        
        legtxt=sprintf('y=%.2f*x+%.2f\nR^2=%.2f',coef(1),coef(2),rho);
        legend (hlin,legtxt)
        
        tittxt=sprintf('Condition =  %s',mt_labels{i});
        title(tittxt)
        
        xlabel('Tuning Correlation')
        ylabel('Noise Correlation')
        
        hold off;
        
        
    end
    
    %% plot second row
    for i=1:size(var2,2)-columns        
        do_me=~isnan(var2(:,i+columns)) & ~isnan(tune_sim);
        coef=polyfit(tune_sim(do_me),var2(do_me,i+columns),1);
        rho=corr(tune_sim(do_me),var2(do_me,i+columns));
        showfit=[-1 1;1 1]*coef';
        
        hothers(i+columns)=figure ('Position',[(i-1)*width,1,width,height-100]);
        hold on;
        scatter (tune_sim(do_me),var2(do_me,i+columns))
        hlin=plot ([-1 1],showfit','--r');
        plot ([0 0],[-1 1],':k')
        plot ([-1 1],[0 0],':k')
        
        legtxt=sprintf('y=%.2f*x+%.2f\nR^2=%.2f',coef(1),coef(2),rho);
        legend (hlin,legtxt)
        
        tittxt=sprintf('Condition =  %s',mt_labels{i+columns});
        title(tittxt)
        
        xlabel('Tuning Correlation')
        ylabel('Noise Correlation')
        
        hold off;
    end
    
    % If Save and Close is activated
    if get(handles.save_n_close,'Value')
        
        switch get(handles.variable_1,'Value') 
            case 2
                sim_type='euc_sep';
            case 3
                sim_type='vmap_dp';
            case 7
                switch get(handles.sim_metric_type,'Value') 
                    case 1
                        sim_type='resp_ang';
                    case 2
                        sim_type='resp_dp';
                    case 3
                        sim_type='resp_corr';
                end
            case 10
                sim_type='pre_corr';
        end
        if get(handles.variable_2,'Value')==8
            nc_type='resp';
        end
        if get(handles.variable_2,'Value')==9
            nc_type='post';
        end
        
        for i=1:size(var2,2)
            savetxt_sim{i}=sprintf('%s vs nc_%s %s',sim_type,nc_type,mt_labels{i});
            print(hothers(i),savetxt_sim{i},'-dmeta')
        end
        close (hothers)
    end
    
end

%% Plot comparison between 2 conditions
if comp2    
    do_me= ~isnan(var2(:,conditions(1))) & ~isnan(var2(:,conditions(2)));
    
    log_ax=get(handles.resp_scat_log,'Value'); %log-scale axes
    
    fprintf('\n')
    comp_means=input('Would you like to see if the mean values changed between conditions?(1/0)  :  ');
    while comp_means~=1 && comp_means~=0
        fprintf('\nSorry, you must select 1 or 0\n')
        comp_means=input('Would you like to see if the mean values changed between conditions?(1/0)  :  ');
    end
    
    if comp_means

        % statistics for resp(cond1) == resp (cond2)
        jbt1=jbtest(var1(:,conditions(1)));
        jbt2=jbtest(var1(:,conditions(2)));
        alpha=.05;
        if ~jbt1 && ~jbt2 %both distributions are normal
            %do paired ttest
            [~,p]=ttest(var1(:,conditions(1)),var1(:,conditions(2)),'alpha',alpha);
            fprintf('\n%s used parametric test',tit1)
            
            % see if standard deviations are different w/ ftest
            [~,p_std]=vartest2(var1(:,conditions(1)),var1(:,conditions(2)));
            fprintf('\n%s parametric dispersion F-test: std1=%.2f :: std2=%.2f :: p(std1=std2)=%.4f\n',tit1,std(var1(:,conditions(1))),std(var1(:,conditions(2))),p_std)
        else
            %do paired non-para test
            [p,~]=signrank(var1(:,conditions(1)),var1(:,conditions(2)),'alpha',alpha);
            fprintf('\n%s used non-parametric test',tit1)
            
            % see if standard deviations are different w/ ansari bradley
            % test
            [~, p_std]=ansaribradley(var1(:,conditions(1)),var1(:,conditions(2)));
            fprintf('\n%s non-parametric dispersion Ansari-Bradley test: std1=%.2f :: std2=%.2f :: p(std1=std2)=%.4f\n',tit1,std(var1(:,conditions(1))),std(var1(:,conditions(2))),p_std)
        end
        
        % Fit regression line
        [rho,rpval]=corr(var1(:,1),var1(:,2));
        pfit=polyfit(var1(:,1),var1(:,2),1);
        pfitx=[min(var1(:,1)):1:max(var1(:,1))];
        pfity=[pfitx',ones(size(pfitx'))]*pfit';
        
        comp2_hs=length(hothers)+1;
        
        % plot resp (cond 1) vs resp (cond 2)
        hothers(end+1)=figure;
        hold on;
        if log_ax %display on log-scale axes

            legtxt={};
            
            %plot units
            logresp=log10(var1+1);
            plot(logresp(:,1),logresp(:,2),'or')
            legtxt{end+1}=sprintf('Units ... n=%.0f',size(var1,1));
            
            %plot mean
            plot (log10(mean(var1(:,1))+1),log10(mean(var1(:,2))+1),'xb','MarkerSize',15,'LineWidth',2)
            legtxt{end+1}=sprintf('Mean(%.2f %.2f) \np(%s=%s)=%.4f',mean(var1(:,1)),mean(var1(:,2)),mt_labels{1},mt_labels{2},p);
            
            %plot fit line
            plot(log10(pfitx+1),log10(pfity+1),'--r')
            legtxt{end+1}=sprintf('rho=%.2f, p(rho)=%.4f\ny=%.2f*x+%.2f',rho,rpval,pfit);
            
            unity=[min( [get(gca,'xlim'),get(gca,'ylim')] ) , max( [get(gca,'xlim'),get(gca,'ylim')]  )];
           
            xlabel(sprintf('%s log (%s + 1)',mt_labels{1},tit1));
            ylabel(sprintf('%s log (%s + 1)',mt_labels{2},tit1));
            legend(legtxt);
            
        else %use normal axes
            
            % plot units
            plot (var1(:,conditions(1))',var1(:,conditions(2))','or')
            
            % plot means
            plot (mean(var1(:,conditions(1))),mean(var1(:,conditions(2))),'xb','MarkerSize',15,'LineWidth',2)
            
            % plot fit line
            plot(pfitx,pfity,'--r')
            unity=[min( [var1(:,conditions(1));var1(:,conditions(2))] ) , max( [var1(:,conditions(1));var1(:,conditions(2)) ])];
            
            legtxt={};
            legtxt{1}=sprintf('Units ... n=%.0f',size(var1,1));
            legtxt{2}=sprintf('Mean (%.2f %.2f) \np (%s = %s) = %.4f',mean(var1(:,conditions(1))),mean(var1(:,conditions(2))),mt_labels{conditions(1)},mt_labels{conditions(2)},p);
            legtxt{end+1}=sprintf('rho=%.2f, p(rho)=%.4f\ny=%.2f*x+%.2f',rho,rpval,pfit);
            xlabel(sprintf('%s %s',mt_labels{conditions(1)},tit1));
            ylabel(sprintf('%s %s',mt_labels{conditions(2)},tit1));
            legend(legtxt);
            
        end
        plot (unity,unity,'--k');
        tittxt=sprintf('%s for %s vs %s',tit1,mt_labels{conditions(1)},mt_labels{conditions(2)});
        title(tittxt);
        
        if ~get(handles.bin_2way,'Value')
            %Don't bin based on responses
            
            % statistics for nc(cond1) == nc (cond2)
        jbt1=jbtest(var1(:,conditions(1)));
        jbt2=jbtest(var1(:,conditions(2)));
            alpha=.05;
            if ~jbt1 && ~jbt2 %both distributions are normal
                %do paired ttest
                [~,p]=ttest(var2(:,conditions(1)),var2(:,conditions(2)),'alpha',alpha);
                fprintf('\n%s used parametric test',tit2)
            
            % see if standard deviations are different w/ ftest
            [~, p_std]=vartest2(var2(:,conditions(1)),var2(:,conditions(2)));
            fprintf('\n%s parametric dispersion F-test: std1=%.2f :: std2=%.2f :: p(std1=std2)=%.4f\n',tit2,std(var2(:,conditions(1))),std(var2(:,conditions(2))),p_std)

            else
                %do paired non-para test
                [p,~]=signrank(var2(:,conditions(1)),var2(:,conditions(2)),'alpha',alpha);
                fprintf('\n%s used non-parametric test',tit2)
                
                % see if standard deviations are different w/ ansari bradley
                % test
                [~, p_std]=ansaribradley(var2(:,conditions(1)),var2(:,conditions(2)));
                fprintf('\n%s non-parametric dispersion Ansari-Bradley test: std1=%.2f :: std2=%.2f :: p(std1=std2)=%.4f\n',tit2,std(var2(:,conditions(1))),std(var2(:,conditions(2))),p_std)
                
            end
            
            % plot var1 (cond 1) vs var2 (cond 2)
            hothers(end+1)=figure;
            hold on;
            plot (var2(:,conditions(1))',var2(:,conditions(2))','or')
            plot (mean(var2(do_me,conditions(1))),mean(var2(do_me,conditions(2))),'xb','MarkerSize',15,'LineWidth',2)% add the means
            unity=[min( [var2(:,conditions(1));var2(:,conditions(2))] ) , max( [var2(:,conditions(1));var2(:,conditions(2)) ])];
            
%             plot (log(var2(:,conditions(1)))',log(var2(:,conditions(2)))','or')
%             plot (log(mean(var2(do_me,conditions(1)))),log(mean(var2(do_me,conditions(2)))),'xb','MarkerSize',15,'LineWidth',2)% add the means
%             unity=[min( log([var2(:,conditions(1));var2(:,conditions(2))]) ) , log(max( [var2(:,conditions(1));var2(:,conditions(2)) ]))];
            
            [rho,pval]=corr(var2(:,conditions(1)),var2(:,conditions(2)));
            pfit=polyfit(var2(:,conditions(1)),var2(:,conditions(2)),1);
            
            x1=min(var2(:,conditions(1)));
            x2=max(var2(:,conditions(1)));
            plot([x1 x2],pfit*[x1 x2;1 1],':r')
            plot (unity,unity,'--k');
            
            legtxt={};
            legtxt{1}=sprintf('p (%s = %s) = %.4f',mt_labels{conditions(1)},mt_labels{conditions(2)},p);
            legtxt{2}=sprintf('Mean (%.2f %.2f)',mean(var2(do_me,conditions(1))),mean(var2(do_me,conditions(2))) );
            legtxt{3}=sprintf('y=%.2fx+%.2f\nrho=%.2f  p=%.4f',pfit(1),pfit(2),rho,pval);
            legend(legtxt);
            tittxt=sprintf('Paired %s %s vs %s',tit2,mt_labels{conditions(1)},mt_labels{conditions(2)});
            title(tittxt);
            xlabel(sprintf('%s for %s (R)',tit2, mt_labels{conditions(1)}));
            ylabel(sprintf('%s for %s (R)',tit2, mt_labels{conditions(2)}));
            hold off;
            
        else
            %Bin based on response differences
            
            %same tuning
            ncorr_same=var2((do_me & changesameway),:);
        jbt1=jbtest(var1(:,conditions(1)));
        jbt2=jbtest(var1(:,conditions(2)));
            alpha=.05;
            if ~jbt1 && ~jbt2 %both distributions are normal
                %do paired ttest
                [h,p]=ttest(ncorr_same(:,conditions(1)),ncorr_same(:,conditions(2)),'alpha',alpha);
            else
                %do paired non-para test
                [p,h]=signrank(ncorr_same(:,conditions(1)),ncorr_same(:,conditions(2)),'alpha',alpha);
            end
            
            % plot noise corr (cond 1) vs noise corr (cond 2)
            hothers(end+1)=figure;
            hold on;
            plot (ncorr_same(:,conditions(1))',ncorr_same(:,conditions(2))','or')
            plot (mean(ncorr_same(:,conditions(1))),mean(ncorr_same(:,conditions(2))),'xb','MarkerSize',15,'LineWidth',2)% add the means
            unity=[min( [ncorr_same(:,conditions(1));ncorr_same(:,conditions(2))] ) , max( [ncorr_same(:,conditions(1));ncorr_same(:,conditions(2)) ])];
            plot (unity,unity,'--k');
            legtxt={};
            legtxt{1}=sprintf('p (%s = %s) = %.4f',mt_labels{conditions(1)},mt_labels{conditions(2)},p);
            legtxt{2}=sprintf('Mean (%.2f %.2f)',mean(ncorr_same(:,conditions(1))),mean(ncorr_same(:,conditions(2))));
            legend(legtxt);
            tittxt=sprintf('Paired Noise Correlations from SAME TUNING %s vs %s',mt_labels{conditions(1)},mt_labels{conditions(2)});
            title(tittxt);
            xlabel(sprintf('Noise Corr for %s (R)',mt_labels{conditions(1)}));
            ylabel(sprintf('Noise Corr for %s (R)',mt_labels{conditions(2)}));
            hold off;
            
            %opposite tuning
            ncorr_oppo=var2(do_me & ~changesameway,:);
        jbt1=jbtest(var1(:,conditions(1)));
        jbt2=jbtest(var1(:,conditions(2)));
            alpha=.05;
            if ~jbt1 && ~jbt2 %both distributions are normal
                %do paired ttest
                [h,p]=ttest(ncorr_oppo(:,conditions(1)),ncorr_oppo(:,conditions(2)),'alpha',alpha);
            else
                %do paired non-para test
                [p,h]=signrank(ncorr_oppo(:,conditions(1)),ncorr_oppo(:,conditions(2)),'alpha',alpha);
            end
            
            % plot noise corr (cond 1) vs noise corr (cond 2)
            hothers(end+1)=figure;
            hold on;
            plot (ncorr_oppo(:,conditions(1))',ncorr_oppo(:,conditions(2))','or')
            plot (mean(ncorr_oppo(:,conditions(1))),mean(ncorr_oppo(:,conditions(2))),'xb','MarkerSize',15,'LineWidth',2)% add the means
            unity=[min( [ncorr_oppo(:,conditions(1));ncorr_oppo(:,conditions(2))] ) , max( [ncorr_oppo(:,conditions(1));ncorr_oppo(:,conditions(2)) ])];
            plot (unity,unity,'--k');
            legtxt={};
            legtxt{1}=sprintf('p (%s = %s) = %.4f',mt_labels{conditions(1)},mt_labels{conditions(2)},p);
            legtxt{2}=sprintf('Mean (%.2f %.2f)',mean(ncorr_oppo(:,conditions(1))),mean(ncorr_oppo(:,conditions(2))));
            legend(legtxt);
            tittxt=sprintf('Paired Noise Correlations from OPPOSITE TUNING %s vs %s',mt_labels{conditions(1)},mt_labels{conditions(2)});
            title(tittxt);
            xlabel(sprintf('Noise Corr for %s (R)',mt_labels{conditions(1)}));
            ylabel(sprintf('Noise Corr for %s (R)',mt_labels{conditions(2)}));
            hold off;
            
        end
        
    end
    
    if get(handles.plot_ang_sep,'Value')
        %plot ang sep vs noise corr (cond 1)
        linreg=polyfit(angular_sep(do_me),var2(do_me,conditions(1)),1);
        rho=corr(angular_sep(do_me),var2(do_me,conditions(1)));
        hothers(end+1)=figure;
        hold on;
        plot (angular_sep(do_me),var2(do_me,conditions(1)),'o')
        plot ([0 180],[linreg(2) 180*linreg(1)+linreg(2)],'--k')
        legtxt=sprintf('y=%.4fx+%.2f \nR=%.3f',linreg(1),linreg(2),rho);
        legend(legtxt);
        tittxt=sprintf('Angular seperation between %s and %s vs Noise Corr (%s)',mt_labels{conditions(1)},mt_labels{conditions(2)},mt_labels{conditions(1)});
        title(tittxt);
        xlabel('Angular Seperation (deg)')
        ylabel('Noise Corr (R)')
        hold off;
        
        %plot ang sep vs noise corr(cond 2)
        linreg=polyfit(angular_sep(do_me),var2(do_me,conditions(2)),1);
        rho=corr(angular_sep(do_me),var2(do_me,conditions(2)));
        hothers(end+1)=figure;
        hold on;
        plot (angular_sep(do_me),var2(do_me,conditions(2)),'o')
        plot ([0 180],[linreg(2) 180*linreg(1)+linreg(2)],'--k')
        legtxt=sprintf('y=%.4fx+%.2f \nR=%.3f',linreg(1),linreg(2),rho);
        legend(legtxt);
        tittxt=sprintf('Angular seperation between %s and %s vs Noise Corr (%s)',mt_labels{conditions(1)},mt_labels{conditions(2)},mt_labels{conditions(2)});
        title(tittxt);
        xlabel('Angular Seperation (deg)')
        ylabel('Noise Corr (R)')
        hold off
    end
    
    if get(handles.save_n_close,'Value')
        
        if get(handles.variable_2,'Value')==8
            nc_type='resp';
        end
        if get(handles.variable_2,'Value')==9
            nc_type='post';
        end
        savetxt{1}=sprintf('resp change %s vs %s',mt_labels{conditions(1)},mt_labels{conditions(2)});
        savetxt{2}=sprintf('nc_%s change %s vs %s',nc_type,mt_labels{conditions(1)},mt_labels{conditions(2)});
        savetxt{3}=sprintf('ang_sep %s and %s vs nc_%s %s',mt_labels{conditions(1)},mt_labels{conditions(2)},nc_type,mt_labels{conditions(1)});
        savetxt{4}=sprintf('ang_sep %s and %s vs nc_%s %s',mt_labels{conditions(1)},mt_labels{conditions(2)},nc_type,mt_labels{conditions(2)});
        print(hothers(comp2_hs),savetxt{1},'-dmeta')
        print(hothers(comp2_hs+1),savetxt{2},'-dmeta')
        print(hothers(comp2_hs+2),savetxt{3},'-dmeta')
        print(hothers(comp2_hs+3),savetxt{4},'-dmeta')
        close (hothers(comp2_hs:end))        
    end
    
end

    
end
