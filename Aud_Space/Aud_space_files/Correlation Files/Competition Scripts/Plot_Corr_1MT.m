function Plot_Corr_1MT (var1,tit1,mt_var,tit2,handles,mt_labels)
% This function is specifically for plotting non-mtrace variables again
% mtrace variables (ie DotProduct vs Noise Correlation)

% dbstack
% keyboard

myscreen =get(0,'screensize');
columns=ceil(size(mt_var,2)/2);
width=floor(myscreen(3)/columns);
height=floor(myscreen(4)/2);

show_noise_corr=get(handles.show_nc,'Value');
show_scat=get(handles.show_scat,'Value');

show_noise_corr=1;
show_scat=1;

% %% Temporary code for showing visual dot product
% fprintf('\n\n------- values for non-Mtrace Variable')
% fprintf ('\nMean\tStd')
% fprintf('\n%.2f\t%.2f',mean(var1),std(var1))
% fprintf('\n')
% pause

%% Plot Scatter Plots

fprintf('\n')
plot_v1v2=input('Would you like to see the scatters for v1 vs v2? (0/1)  :  ');
while plot_v1v2~=1 && plot_v1v2~=0
    fprintf('\nSorry mate, enter a 0 or 1\n')
    plot_v1v2=input('Would you like to see the scatters for v1 vs v2? (0/1)  :  ');
end

fprintf('\n')
corr_type=input('What type of correlation do you want to use?  Pearsons=1  Spearmans=2  :  ');
while corr_type~=1 && corr_type~=2
    fprintf('\nSorry mate, enter a 1 or a 2\n')
    corr_type=input('What type of correlation do you want to use?  Pearsons=1  Spearmans=2  :  ');
end

if plot_v1v2
    h=nan(size(mt_var,2)+1,1);
    % plot first row
    for i=1:columns
        
        var2=mt_var(:,i);
        showme=~isnan(var2) & ~isnan(var1);
        
        y=var2(showme);
        x=var1(showme);
        
        coef=polyfit(x,y,1);
        if corr_type==1
            corr_text='Pearsons';
            [rho,p_rho]=corr(x,y);
        else
            corr_text='Spearmans';
            [rho,p_rho]=corr(x,y,'type','Spearman');
        end
        if max(x)<1 %this was a DP measurement
            x_range=[-1 1];
        else
            x_range=[0 max(x)];
        end
        showfit=[x_range(1) 1;x_range(2) 1]*coef';
        
        %         h(i)=figure ('Position',[(i-1)*width,height,width,height-100]);
        figure
        hold on;
        scatter (x,y)
        hlin=plot (x_range,showfit','--r');
        
        plot ([0 0],get(gca,'ylim'),':k')
        plot (get(gca,'xlim'),[0 0],':k')
        
        legtxt=sprintf('y=%.2f*x+%.2f\nR^2=%.2f p=%.2e',coef(1),coef(2),rho,p_rho);
        legend (hlin,legtxt)
        
        tittxt=sprintf('Condition =  %s ::   Corr=%s :: n=%.0f',mt_labels{i},corr_text,length(x));
        title(tittxt)
        
        xlabel(tit1)
        ylabel(tit2)
        
        hold off;
        
        
    end
    
    % plot second row
    for i=1:size(mt_var,2)-columns
        
        var2=mt_var(:,i+columns);
        showme= ~isnan(var2)& ~isnan(var1);
        
        y=var2(showme);
        x=var1(showme);
        
        coef=polyfit(x,y,1);
        if corr_type==1
            [rho,p_rho]=corr(x,y);
        else
            [rho,p_rho]=corr(x,y,'type','Spearman');
        end
        if max(x)<1 %this was a DP measurement
            x_range=[-1 1];
        else
            x_range=[0 max(x)];
        end
        showfit=[x_range(1) 1;x_range(2) 1]*coef';
        
        %         h(i+columns)=figure ('Position',[(i-1)*width,1,width,height-100]);
        figure
        hold on;
        scatter (x,y)
        hlin=plot (x_range,showfit','--r');
        
        plot ([0 0],get(gca,'ylim'),':k')
        plot (get(gca,'xlim'),[0 0],':k')
        
        legtxt=sprintf('y=%.2f*x+%.2f\nR^2=%.2f p=%.2e',coef(1),coef(2),rho,p_rho);
        legend (hlin,legtxt)
        
        tittxt=sprintf('Condition =  %s ::   Corr=%s :: n=%.0f',mt_labels{i+columns},corr_text,length(x));
        title(tittxt)
        
        xlabel(tit1)
        ylabel(tit2)
        
        hold off;
    end
end

%% Plot DP vs NC for 2 conditions

if get(handles.comp2,'Value') %if you are just comparing two conditions
    if get(handles.bin_DP,'Value')
        bin_cutoff=str2double(get(handles.DP_cutoff,'String'));
        
%         %bin based on DP
%         binvar=tit1;
%         bin1=var1<bin_cutoff;
%         bin2=~bin1;
        %bin based on NC
        binvar=tit2;
        bin1=mt_var(:,1)<bin_cutoff;
        bin2=~bin1;
        
        figure 
        plot(var1(bin1,:),mt_var(bin1,:),'ob');
        hold on
        plot(var1(bin2,:),mt_var(bin2,:),'or');
        xlabel (tit1);
        ylabel (tit2);
        title (sprintf('%s vs %s across conditions',tit1, tit2))
        
        % Plot low bin
        legtxt={};
        figure
        hold on
        x=mt_var(bin1,1);
        y=mt_var(bin1,2);
        plot (x,y,'ob')
        legtxt{end+1}=sprintf('%s < %.2f : n=%.0f',binvar,bin_cutoff,sum(bin1));
        plot(mean(x),mean(y),'xb','markersize',15,'linewidth',5)
        if jbtest(x) || jbtest(y)
            p=signrank(x,y);
            fprintf('\nUsed non-parametric signrank test for low bin\n')
        else
            [~,p]=ttest(x,y);
            fprintf('\nUsed ttest for low bin\n')
        end
        legtxt{end+1}=sprintf('n=%.0f mean(%s)=%.2f :: mean(%s)=%.2f\np(%s=%s)=%.4f',sum(bin1),mt_labels{1},mean(x),mt_labels{2},mean(y),mt_labels{1},mt_labels{2},p);
        nfit=polyfit(x,y,1);
        plot([min(mt_var(:)),max(mt_var(:))],nfit*[min(mt_var(:)),max(mt_var(:));1,1],'--b')
        [rho,p]=corr(x,y);
        legtxt{end+1}=sprintf('y=%.2fx+%.2f :: rho=%.2f p=%.4f',nfit(1),nfit(2),rho,p);
        
        % Plot high bin
        x=mt_var(bin2,1);
        y=mt_var(bin2,2);
        plot (x,y,'or')
        legtxt{end+1}=sprintf('%s > %.2f : n=%.0f',binvar,bin_cutoff,sum(bin2));
        plot(mean(x),mean(y),'xr','markersize',15,'linewidth',5)
        if jbtest(x) || jbtest(y)
            p=signrank(x,y);
            fprintf('\nUsed non-parametric signrank test for high bin\n')
        else
            [~,p]=ttest(x,y);
            fprintf('\nUsed ttest test for high bin\n')
        end
        legtxt{end+1}=sprintf('n=%.0f mean(%s)=%.2f :: mean(%s)=%.2f\np(%s=%s)=%.4f',sum(bin2),mt_labels{1},mean(x),mt_labels{2},mean(y),mt_labels{1},mt_labels{2},p);
        nfit=polyfit(x,y,1);
        plot([min(mt_var(:)),max(mt_var(:))],nfit*[min(mt_var(:)),max(mt_var(:));1,1],'--r')
        [rho,p]=corr(x,y);
        legtxt{end+1}=sprintf('y=%.2fx+%.2f :: rho=%.2f p=%.4f',nfit(1),nfit(2),rho,p);
        
        
        plot([min(mt_var(:)),max(mt_var(:))],[min(mt_var(:)),max(mt_var(:))],':k')
        
        legend(legtxt)
        xlabel(sprintf('%s for %s',tit2,mt_labels{1}));
        ylabel(sprintf('%s for %s',tit2,mt_labels{2}));
        title (sprintf('%s :: %s vs %s :: bin cutoff=%.2f',tit2,mt_labels{1},mt_labels{2},bin_cutoff))
        
        figure
        hold on
        hist(mt_var(:,1))
        plot([bin_cutoff,bin_cutoff],get(gca,'ylim'),':r')
        title(sprintf('Histogram for %s :: %s',tit2,mt_labels{1}))
        xlabel(tit2);
        ylabel('count');
        legend({mt_labels{1},'cutoff'})
        
        bringkeyboard=input('Would you like to open the ''keyboard'' so you can mannually re-run stuff? (0/1) :  ');
        while bringkeyboard~=1 && bringkeyboard~=0
            fprintf('\nSorry mate, must enter 0 or 1\n')
            bringkeyboard=input('Would you like to open the ''keyboard'' so you can mannually re-run stuff? (0/1) :  ');
        end
        if bringkeyboard
            fprintf('\nOpening "Keyboard" so you can re-run this plot with the other binning option if you want\n')
            dbstack
            keyboard
        end
        
    else
        bin_cutoff=0;
    end
    
    
end

%% Plot Binned Noise Correlations - Not sure what this was supposed to be doing but quoted it out 7/30/15
% 
% hbar=nan(2,2);
% 
% % Bar graphs for var1 > 0
% xax_label{1}='';
% xax_label{2}='In';
% xax_label{3}='';
% xax_label{4}='Out';
% xax_label{5}='';
% xax_label{6}='Comp';
% leg_label{1}='weak';
% leg_label{2}='strong';
% 
% if get(handles.bin_DP,'Value')
%     bin_cutoff=str2double(get(handles.DP_cutoff,'String'));  
% else
%     bin_cutoff=0;
% end
% v1_pos=var1>bin_cutoff;
% temp_pos(1,:)=nanmean(mt_var(v1_pos,:),1);
% mt_var_mean_pos(1,:)=temp_pos(1,[1 3]); %vweak in, vstrong in
% mt_var_mean_pos(2,:)=temp_pos(1,[2 4]); %vweak out, vstrong out
% mt_var_mean_pos(3,:)=temp_pos(1,[5 6]); %lose, win
% 
% 
% h(length(mt_var(:))+1)=figure('Position',[myscreen(3),height,2*width,height]);
% hold on
% hbar(1,:)=bar(mt_var_mean_pos);
% shift=.15;
% plot(ones(sum(v1_pos),1)*((1:3)-shift),mt_var(v1_pos,[1 3 5]),'b*')
% plot(ones(sum(v1_pos),1)*((1:3)+shift),mt_var(v1_pos,[2 4 6]),'r*')
% 
% set (gca,'XTickLabel',xax_label)
% xlabel('Stimulus Condition')
% ylabel(tit2)
% legend(hbar(1,:),leg_label)
% bartit=sprintf('%s binned based on %s :: %.0f pairs > %.2f ',tit2,tit1,sum(v1_pos),bin_cutoff);
% title (bartit)
% hold off
% 
% % Bar graphs for var1 < 0
% temp_neg(1,:)=nanmean(mt_var(~v1_pos,:),1);
% mt_var_mean_neg(1,:)=temp_neg(1,1:2);
% mt_var_mean_neg(2,:)=temp_neg(1,3:4);
% mt_var_mean_neg(3,:)=temp_neg(1,5:6);
% 
% h(length(mt_var(:))+1)=figure('Position',[myscreen(3),1,2*width,height]);
% hold on
% hbar(2,:)=bar(mt_var_mean_neg);
% shift=.15;
% plot(ones(sum(~v1_pos),1)*((1:3)-shift),mt_var(~v1_pos,[1 3 5]),'b*')
% plot(ones(sum(~v1_pos),1)*((1:3)+shift),mt_var(~v1_pos,[2 4 6]),'r*')
% 
% set (gca,'XTickLabel',xax_label)
% xlabel('Stimulus Condition')
% ylabel(tit2)
% legend(hbar(2,:),leg_label)
% bartit=sprintf('%s binned based on %s :: %.0f pairs < %.2f',tit2,tit1,sum(~v1_pos),bin_cutoff);
% title (bartit)
% hold off

