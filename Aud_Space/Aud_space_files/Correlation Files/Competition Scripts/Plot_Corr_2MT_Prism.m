
function [h1,h2,hothers]=Plot_Corr_2MT_Prism (resp_norm,resp_prism,ncorr_norm,ncorr_prism,tune_sim,angular_sep,cutoff,mt_labels,handles,type)
% This is the updated version of Plot_Competition DJT 9/30/2014
% -resp = responses for all of the mtraces
% -ncorr = pairwise noise correlations for all the mtraces
% -tune_sim = a pairwise metric for similarity in the resopnse profiles 
% -mt_labels is the cell array of strings identifying the conditions
% -handles is the structure array of handles coming from the GUI
% -type is a title thing so I can know if this was done using bimodal data,
% competition data or whatever

h1=[];
h2=[];
hothers=[];

% xax_label{1}='';
% xax_label(2:1+length(mt_labels))=mt_labels;
% xax_label{end+1}='';
xax_label_prism=mt_labels;
xax_label_norm=mt_labels(1:4);

%% Read in settings
show_resp=get(handles.show_resp,'Value');
show_noise_corr=get(handles.show_nc,'Value');
show_scat=get(handles.show_scat,'Value');
show_nc_hist=get(handles.show_nc_hist,'Value');
comp2=get(handles.comp2,'Value');

if comp2
    conditions=nan(1,2);
    
    conditions(1)=get(handles.comp_cond_1,'Value');
    if conditions(1)>3 && conditions(1)<8
        %competition conditions
        conditions(1)=conditions(1)-1;
    elseif conditions(1) >8 && conditions (1) < 12
        %prism adaptation
        conditions(1)=conditions(1)-6;
    elseif conditions(1)>12
        %bimodal
        conditions(1)=conditions(1)-8;
    end
    
    conditions(2)=get(handles.comp_cond_2,'Value');
    if conditions(2)>3 && conditions(2)<8
        %competition conditions
        conditions(2)=conditions(2)-1;
    elseif conditions(2) >8 && conditions (2) < 12
        %prism adaptation
        conditions(2)=conditions(2)-6;
    elseif conditions(2)>12
        %bimodal
        conditions(2)=conditions(2)-8;
    end
else
    conditions=1:size(resp_prism,2);
end

norm_to_max=get(handles.norm_to_max,'Value');
norm_to_vwi=get(handles.norm_to_vwi,'Value');

show_resp_bar_std=get(handles.resp_bg_std,'Value');
show_resp_bar_sites=get(handles.resp_bg_sites,'Value');
show_nc_bar_std=get(handles.nc_bg_std,'Value');
show_nc_bar_sites=get(handles.nc_bg_sites,'Value');


%% Response Bar Graph
if show_resp
    if norm_to_max
        plot_prism=resp_prism ./ (max(abs(resp_prism),[],2)*ones(1,size(resp_prism,2)));
        plot_norm=resp_norm ./ (max(abs(resp_norm),[],2)*ones(1,size(resp_norm,2)));
    elseif norm_to_vwi %normalize to weak vis in ... although this will be interpreted as Ain
        plot_prism=resp_prism ./ (resp_prism(:,3)*ones(1,size(resp_prism,2)));
        plot_norm=resp_norm ./ (resp_norm(:,3)*ones(1,size(resp_norm,2)));
    else
        plot_prism=resp_prism;
        plot_norm=resp_norm;
    end
    %prism
    var1_mean_prism=mean(plot_prism,1);
    var1_std_prism=std(plot_prism,1);
    v1_std_plot_y_prism=[var1_mean_prism-var1_std_prism;var1_mean_prism+var1_std_prism];
    v1_std_plot_x_prism=ones(2,1)*[1:size(plot_prism,2)];
    v1_scat_x_prism=ones(size(plot_prism,1),1) * (1:size(plot_prism,2));
    %normal
    var1_mean_norm=mean(plot_norm,1);
    var1_std_norm=std(plot_norm,1);
    v1_std_plot_y_norm=[var1_mean_norm-var1_std_norm;var1_mean_norm+var1_std_norm];
    v1_std_plot_x_norm=ones(2,1)*[1:size(plot_norm,2)];
    v1_scat_x_norm=ones(size(plot_norm,1),1) * (1:size(plot_norm,2));
    
    h1=figure;
    subplot(2,1,1)
    hold on;
    bar(var1_mean_prism);
    if show_resp_bar_sites
        plot (v1_scat_x_prism',plot_prism',':*r')
    end
    if show_resp_bar_std
        plot (v1_std_plot_x_prism,v1_std_plot_y_prism,'g','linewidth',1.5)
    end
    t1=strcat(type,' Experiment:  Stimulus Response');
    t2=sprintf(' :: # SUs = %.0f',size(plot_prism,1));
    
    title (strcat(t1,t2))
    set (gca,'XTick',1:size(resp_prism,2))
    set (gca,'XTickLabel',xax_label_prism)
    xlabel('Stimulus Condition')
    ylabel('Responses re. weak stim in RF')
    set (gca,'Ylim',[min(var1_mean_prism)-2,max(var1_mean_prism)+2])
    hold off;
    
    subplot(2,1,2)
    hold on;
    bar(var1_mean_norm);
    if show_resp_bar_sites
        plot (v1_scat_x_norm',plot_norm',':*r')
    end
    if show_resp_bar_std
        plot (v1_std_plot_x_norm,v1_std_plot_y_norm,'g','linewidth',1.5)
    end
    t1=strcat('Norm Experiment:  Stimulus Response');
    t2=sprintf(' :: # SUs = %.0f',size(plot_norm,1));
    
    title (strcat(t1,t2))
    set (gca,'XTick',1:size(resp_norm,2))
    set (gca,'XTickLabel',xax_label_norm)
    xlabel('Stimulus Condition')
    ylabel('Responses re. weak stim in RF')
    set (gca,'Ylim',[min(var1_mean_norm)-2,max(var1_mean_norm)+2])
    hold off;
end

%% Noise Corr Bar Graphs
if show_noise_corr
    if isnan(cutoff) % UNBINNED
        % Prism
        dome=~isnan(ncorr_prism);
        var2_mean=nan(1,size(ncorr_prism,2));
        var2_std=nan(1,size(ncorr_prism,2));
        for i=1:size(ncorr_prism,2);
            var2_mean(i)=mean(ncorr_prism(dome(:,i),i),1);
            var2_std(i)=std(ncorr_prism(dome(:,i),i),1);
        end
        v2_std_plot_y=[var2_mean-var2_std;var2_mean+var2_std];
        v2_std_plot_x=ones(2,1)*[1:size(ncorr_prism,2)];
        
        v2_scat_x=ones(size(ncorr_prism,1),1)*(1:size(ncorr_prism,2));
        
        h2=figure;
        subplot (2,1,1)
        hold on;
        bar(var2_mean);
        if show_nc_bar_sites
            plot (v2_scat_x',ncorr_prism',':*r')
        end
        if show_nc_bar_std
            plot (v2_std_plot_x,v2_std_plot_y,'g','linewidth',1.5)
        end
        t3=strcat(type,' Experiment: Response Covariance');
        t4=sprintf(' :: # Pairs = %.0f',size(ncorr_prism,1));
        title (strcat(t3,t4))
        set (gca,'XTick',1:size(resp_prism,2))
        set (gca,'XTickLabel',xax_label_prism)
        xlabel('Stimulus Condition')
        ylabel('Correlation (r)')
        hold off;
        
        % Normal
        dome=~isnan(ncorr_norm);
        var2_mean=nan(1,size(ncorr_norm,2));
        var2_std=nan(1,size(ncorr_norm,2));
        for i=1:size(ncorr_norm,2);
            var2_mean(i)=mean(ncorr_norm(dome(:,i),i),1);
            var2_std(i)=std(ncorr_norm(dome(:,i),i),1);
        end
        v2_std_plot_y=[var2_mean-var2_std;var2_mean+var2_std];
        v2_std_plot_x=ones(2,1)*[1:size(ncorr_norm,2)];
        
        v2_scat_x=ones(size(ncorr_norm,1),1)*(1:size(ncorr_norm,2));
        
        subplot (2,1,2)
        hold on;
        bar(var2_mean);
        if show_nc_bar_sites
            plot (v2_scat_x',ncorr_norm',':*r')
        end
        if show_nc_bar_std
            plot (v2_std_plot_x,v2_std_plot_y,'g','linewidth',1.5)
        end
        t3=strcat('Normal Experiment: Response Covariance');
        t4=sprintf(' :: # Pairs = %.0f',size(ncorr_norm,1));
        title (strcat(t3,t4))
        set (gca,'XTick',1:size(resp_norm,2))
        set (gca,'XTickLabel',xax_label_norm)
        xlabel('Stimulus Condition')
        ylabel('Correlation (r)')
        hold off;
        
        
        if show_nc_hist            
            figure;
            subplot (2,1,1)
            hist(ncorr_prism(:,6),50);
            title('Noise Correlation Histogram :: PRISM');
            xlabel('Noise Correlation');
            ylabel('Count');
            
            subplot (2,1,2)
            hist(ncorr_norm(:,6),50);
            title('Noise Correlation Histogram :: NORMAL');
            xlabel('Noise Correlation');
            ylabel('Count');
        end
    else % BINNED based on the cutoff
        
        over_cut_col=tune_sim>cutoff;
        over_cut_mat=logical(over_cut_col*ones(1,size(ncorr_prism,2)));
        
        % Over cutoff
        dome=~isnan(ncorr_prism) & over_cut_mat;
        var2_mean=nan(1,size(ncorr_prism,2));
        var2_std=nan(1,size(ncorr_prism,2));
        for i=1:size(ncorr_prism,2);
            var2_mean(i)=mean(ncorr_prism(dome(:,i),i),1);
            var2_std(i)=std(ncorr_prism(dome(:,i),i),1);
        end
        v2_std_plot_y=[var2_mean-var2_std;var2_mean+var2_std];
        v2_std_plot_x=ones(2,1)*[1:size(ncorr_prism,2)];
        v2_scat_x=ones(size(ncorr_prism(over_cut_col,:),1),1)*(1:size(ncorr_prism(over_cut_col,:),2));
        
        h2=figure;
        hold on;
        bar(var2_mean);
        if show_nc_bar_sites
            plot (v2_scat_x',ncorr_prism(over_cut_col,:)',':*r')
        end
        if show_nc_bar_std
            plot (v2_std_plot_x,v2_std_plot_y,'g','linewidth',1.5)
        end
        t3=strcat(type,' Experiment: Response Covariance ');
        t4=sprintf(' TuneCorr > %.2f :: # Pairs = %.0f',cutoff,size(ncorr_prism(over_cut_col,:),1));
        title (strcat(t3,t4))
        set (gca,'XTickLabel',xax_label)
        xlabel('Stimulus Condition')
        ylabel('Correlation (r)')
        hold off;
        
        %Under cutoff
        dome=~isnan(ncorr_prism) & ~over_cut_mat;
        var2_mean=nan(1,size(ncorr_prism,2));
        var2_std=nan(1,size(ncorr_prism,2));
        for i=1:size(ncorr_prism,2);
            var2_mean(i)=mean(ncorr_prism(dome(:,i),i),1);
            var2_std(i)=std(ncorr_prism(dome(:,i),i),1);
        end
        v2_std_plot_y=[var2_mean-var2_std;var2_mean+var2_std];
        v2_std_plot_x=ones(2,1)*[1:size(ncorr_prism,2)];
        v2_scat_x=ones(size(ncorr_prism(~over_cut_col,:),1),1)*(1:size(ncorr_prism(~over_cut_col,:),2));
        
        h2=figure;
        hold on;
        bar(var2_mean);
        if show_nc_bar_sites
            plot (v2_scat_x',ncorr_prism(~over_cut_col,:)',':*r')
        end
        if show_nc_bar_std
            plot (v2_std_plot_x,v2_std_plot_y,'g','linewidth',1.5)
        end
        t3=strcat(type,' Experiment: Response Covariance ');
        t4=sprintf(' TuneCorr < %.2f :: # Pairs = %.0f',cutoff,size(ncorr_prism(~over_cut_col,:),1));
        title (strcat(t3,t4))
        set (gca,'XTickLabel',xax_label)
        xlabel('Stimulus Condition')
        ylabel('Correlation (r)')
        hold off;
 
    end
end

myscreen =get(0,'screensize');
columns=ceil(size(ncorr_prism,2)/2);
width=floor(myscreen(3)/columns);
height=floor(myscreen(4)/2);

%% Tuning corr, DP or Pre corr vs noise corr scatters - UNBINNED
if show_scat 
    
    if get(handles.variable_1,'Value') == 10 %this was a pre-corr
        tune_sim=resp_prism (:,1);
    end
    % plot first row
    for i=1:columns
        do_me=~isnan(ncorr_prism(:,i)) & ~isnan(tune_sim);
        coef=polyfit(tune_sim(do_me),ncorr_prism(do_me,i),1);
        rho=corr(tune_sim(do_me),ncorr_prism(do_me,i));
        showfit=[-1 1;1 1]*coef';
        
        hothers(i)=figure ('Position',[(i-1)*width,height,width,height-100]);
        hold on;
        scatter (tune_sim,ncorr_prism(:,i))
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
    for i=1:size(ncorr_prism,2)-columns        
        do_me=~isnan(ncorr_prism(:,i+columns)) & ~isnan(tune_sim);
        coef=polyfit(tune_sim(do_me),ncorr_prism(do_me,i+columns),1);
        rho=corr(tune_sim(do_me),ncorr_prism(do_me,i+columns));
        showfit=[-1 1;1 1]*coef';
        
        hothers(i+columns)=figure ('Position',[(i-1)*width,1,width,height-100]);
        hold on;
        scatter (tune_sim(do_me),ncorr_prism(do_me,i+columns))
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
    
end

%% Plot comparison between 2 conditions
if comp2    
    
    do_me=~isnan(angular_sep) & ~isnan(ncorr_prism(:,conditions(1))) & ~isnan(ncorr_prism(:,conditions(2)));
    
    % statistics for resp(cond1) == resp (cond2)
    kst1=kstest(resp_prism(:,conditions(1)));
    kst2=kstest(resp_prism(:,conditions(2)));
    alpha=.05;
    if kst1 && kst2 %both distributions are normal
        %do paired ttest
        [h,p]=ttest(resp_prism(:,conditions(1)),resp_prism(:,conditions(2)),'alpha',alpha);
    else
        %do paired non-para test
        [p,h]=signrank(resp_prism(:,conditions(1)),resp_prism(:,conditions(2)),'alpha',alpha);
    end
       
    % plot resp (cond 1) vs resp (cond 2)
    hothers(end+1)=figure;    
    hold on;
    plot (resp_prism(:,conditions(1))',resp_prism(:,conditions(2))','or')
    plot (mean(resp_prism(:,conditions(1))),mean(resp_prism(:,conditions(2))),'xb','MarkerSize',15,'LineWidth',2)
    unity=[min( [resp_prism(:,conditions(1));resp_prism(:,conditions(2))] ) , max( [resp_prism(:,conditions(1));resp_prism(:,conditions(2)) ])];
    plot (unity,unity,'--k');   
    legtxt={};
    legtxt{1}=sprintf('p (%s = %s) = %.4f',mt_labels{conditions(1)},mt_labels{conditions(2)},p);
    legtxt{2}='Mean';
    legend(legtxt);
    tittxt=sprintf('Paired Responses %s vs %s',mt_labels{conditions(1)},mt_labels{conditions(2)});
    title(tittxt);
    xlabel(sprintf('response to %s',mt_labels{conditions(1)}));
    ylabel(sprintf('response to %s',mt_labels{conditions(2)}));
    
    % statistics for nc(cond1) == nc (cond2)
    kst1=kstest(ncorr_prism(:,conditions(1)));
    kst2=kstest(ncorr_prism(:,conditions(2)));
    alpha=.05;
    if kst1 && kst2 %both distributions are normal
        %do paired ttest
        [h,p]=ttest(ncorr_prism(:,conditions(1)),ncorr_prism(:,conditions(2)),'alpha',alpha);
    else
        %do paired non-para test
        [p,h]=signrank(ncorr_prism(:,conditions(1)),ncorr_prism(:,conditions(2)),'alpha',alpha);
    end
    
    % plot noise corr (cond 1) vs noise corr (cond 2)
    hothers(end+1)=figure;    
    hold on;
    plot (ncorr_prism(:,conditions(1))',ncorr_prism(:,conditions(2))','or')
    plot (mean(ncorr_prism(do_me,conditions(1))),mean(ncorr_prism(do_me,conditions(2))),'xb','MarkerSize',15,'LineWidth',2)% add the means
    unity=[min( [ncorr_prism(:,conditions(1));ncorr_prism(:,conditions(2))] ) , max( [ncorr_prism(:,conditions(1));ncorr_prism(:,conditions(2)) ])];
    plot (unity,unity,'--k');   
    legtxt={};
    legtxt{1}=sprintf('p (%s = %s) = %.4f',mt_labels{conditions(1)},mt_labels{conditions(2)},p);
    legtxt{2}='Mean';
    legend(legtxt);
    tittxt=sprintf('Paired Noise Correlations %s vs %s',mt_labels{conditions(1)},mt_labels{conditions(2)});
    title(tittxt);
    xlabel(sprintf('Noise Corr for %s (R)',mt_labels{conditions(1)}));
    ylabel(sprintf('Noise Corr for %s (R)',mt_labels{conditions(2)}));    
    hold off;
    
    %plot ang sep vs noise corr (cond 1)
    linreg=polyfit(angular_sep(do_me),ncorr_prism(do_me,conditions(1)),1);
    rho=corr(angular_sep(do_me),ncorr_prism(do_me,conditions(1)));
    hothers(end+1)=figure;
    hold on;
    plot (angular_sep(do_me),ncorr_prism(do_me,conditions(1)),'o')
    plot ([0 180],[linreg(2) 180*linreg(1)+linreg(2)],'--k')
    legtxt=sprintf('y=%.4fx+%.2f \nR=%.3f',linreg(1),linreg(2),rho);
    legend(legtxt);
    tittxt=sprintf('Angular seperation between %s and %s vs Noise Corr (%s)',mt_labels{conditions(1)},mt_labels{conditions(2)},mt_labels{conditions(1)});
    title(tittxt);  
    xlabel('Angular Seperation (deg)')
    ylabel('Noise Corr (R)')
    hold off;    
    
    %plot ang sep vs noise corr(cond 2)
    linreg=polyfit(angular_sep(do_me),ncorr_prism(do_me,conditions(2)),1);
    rho=corr(angular_sep(do_me),ncorr_prism(do_me,conditions(2)));
    hothers(end+1)=figure;
    hold on;
    plot (angular_sep(do_me),ncorr_prism(do_me,conditions(2)),'o')
    plot ([0 180],[linreg(2) 180*linreg(1)+linreg(2)],'--k')
    legtxt=sprintf('y=%.4fx+%.2f \nR=%.3f',linreg(1),linreg(2),rho);
    legend(legtxt);
    tittxt=sprintf('Angular seperation between %s and %s vs Noise Corr (%s)',mt_labels{conditions(1)},mt_labels{conditions(2)},mt_labels{conditions(2)});
    title(tittxt);
    xlabel('Angular Seperation (deg)')
    ylabel('Noise Corr (R)')
    hold off
    
end

    
end
