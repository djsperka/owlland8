function Run_SigCorr_Interloom
global snd chan_select

chan_choices=find(chan_select==1);

%grab static responses
for i=1:length(chan_choices)
    chan=chan_choices(i);
    response_average=(snd.datamat_post(:,:,chan)-((snd.posttime/snd.pre)*(snd.datamat_pre(:,:,chan))));
    if length(snd.Var2array)>1 %If this is a 2D trace
        temp_ra=[];
        for j=1:length(snd.Var2array)
            temp_ra=[temp_ra,response_average(j,:)];
        end
        response_average=temp_ra;
    end
    response_matrix(:,i)=response_average';
end
clear i
clear j

[stim_corr,pval]=corr(response_matrix);


%% Display it!
my_screen=get(0,'ScreenSize');
counter=0;
for j=1:length(chan_choices);
    chan1=chan_choices(j);
    for k=j+1:length(chan_choices);
        chan2=chan_choices(k);
        
        x=response_matrix(:,j)';
        y=response_matrix(:,k)';
        
        counter=counter+1;
        ho_split=length(chan_choices)*(length(chan_choices)-1)/2;
        p1=(counter-1)*my_screen(3)/ho_split; %Save room for correlograms!
        p2=(my_screen(4)/2); %Put it Halfway up
        p3=my_screen(3)/ho_split;
        p4=my_screen(4)/2-85;  
        figure ('position', [p1 p2 p3 p4]);

        scatter (x,y);
        set (gcf,'menubar','default');
        hold on        
      
        %
        fit_line=polyfit(x,y,1);
        fit_handle=plot ([min(x) max(x)],([min(x),max(x)]*fit_line(1)+fit_line(2)),':g','LineWidth',4);
        legend (fit_handle,strcat('slope=',num2str(fit_line(1),2),'  r= ',num2str(stim_corr(j,k),3),' p= ',num2str(pval(j,k),3)));
        %
        
        vertline=[min(min(y))-.25,max(max(y))+.25];
        plot ([0 0],vertline,'--k')
        horizline=[min(min(x))-.25,max(max(x))+.25];
        plot (horizline,[0 0],'--k')
        xlabel(strcat('Ch ', num2str(chan1), ' Response') );
        ylabel(strcat('Ch ', num2str(chan2), ' Response'));
        set(get(gca,'xlabel'),'fontsize',12);
        set(get(gca,'ylabel'),'fontsize',12);
        set (gca, 'xlim',horizline);
        set (gca, 'ylim',vertline);
%         if nargin>1;
%             title(['LOOMING Noise Corr Trial by Trial Scatter:   Trace= ' num2str(spikes.trace) '        channels= ' num2str(chan1) ' and ' num2str(chan2)]);
%         else
            title(['Signal Corr Trial by Trial Scatter:   Trace= ' num2str(snd.trace) '        channels= ' num2str(chan1) ' and ' num2str(chan2)]);
        hold off
        
    end
    
end

if snd.inter_loom
    %% repeat for loom
    
for i=1:length(chan_choices)
    chan=chan_choices(i);
    response_average=(snd.data_arr1_post(:,:,chan)-((snd.posttime/snd.pre)*(snd.data_arr1_pre(:,:,chan))));
    if length(snd.Var2array)>1 %If this is a 2D trace
        temp_ra=[];
        for j=1:length(snd.Var2array)
            temp_ra=[temp_ra,response_average(j,:)];
            
        end
        response_average=temp_ra;
    end
    loom_response_matrix(:,i)=response_average';
end
clear i
clear j

[stim_corr_loom,pval_loom]=corr(loom_response_matrix);

counter=0;
for j=1:length(chan_choices);
    chan1=chan_choices(j);
    for k=j+1:length(chan_choices);
        chan2=chan_choices(k);
        
        x=loom_response_matrix(:,j)';
        y=loom_response_matrix(:,k)';
               
        counter=counter+1;
        p1=(counter-1)*my_screen(3)/ho_split; %Save room for correlograms!
        p2=0; %Put it at the bottom
        p3=my_screen(3)/ho_split;
        p4=my_screen(4)/2-85;  
        figure ('position', [p1 p2 p3 p4]);

        scatter (x,y);
        set (gcf,'menubar','default');
        hold on        
      
        %
        fit_line=polyfit(x,y,1);
        fit_handle=plot ([min(x) max(x)],([min(x),max(x)]*fit_line(1)+fit_line(2)),':g','LineWidth',4);
        legend (fit_handle,strcat('slope=',num2str(fit_line(1),2),'  r= ',num2str(stim_corr_loom(j,k),3),' p= ',num2str(pval_loom(j,k),3)));
        %
        
        vertline=[min(min(y))-.25,max(max(y))+.25];
        plot ([0 0],vertline,'--k')
        horizline=[min(min(x))-.25,max(max(x))+.25];
        plot (horizline,[0 0],'--k')
        xlabel(strcat('Ch ', num2str(chan1), ' Response') );
        ylabel(strcat('Ch ', num2str(chan2), ' Response'));
        set(get(gca,'xlabel'),'fontsize',12);
        set(get(gca,'ylabel'),'fontsize',12);
        set (gca, 'xlim',horizline);
        set (gca, 'ylim',vertline);
        title(['LOOMER: Signal Noise Corr Trial by Trial Scatter:   Trace= ' num2str(snd.trace) '        channels= ' num2str(chan1) ' and ' num2str(chan2)]);

        hold off
        
    end
    
end
end

%% Below is the old way of doing it, including  optional histogram plots.  


% 
% %% Display it!
% graphsize=((get(0,'screensize')-[0,0,0,32])/2);
% x_offset=mod(snd.graph_num-1,2);
% y_offset=floor(mod(((snd.graph_num-1)/2),2));
% x_inc=graphsize(3);
% y_inc=graphsize(4);
% graphlocation=graphsize+(x_offset*[x_inc,0,0,0])+(y_offset*[0,y_inc,0,0])+[-20,-20,0,0];
% 
% %% Display static results
% figure('menubar','none','position',graphlocation);
% if length(snd.Var2array)>1
%     %Display regression
%     x_zscore=(response_matrix(:,1)-mean(response_matrix(:,1)))/std(response_matrix(:,1));
%     y_zscore=(response_matrix(:,2)-mean(response_matrix(:,2)))/std(response_matrix(:,2));
%     scatter (x_zscore,y_zscore)
%     hold
%     x=[min(x_zscore),max(y_zscore)];
%     y=stim_corr(1,2)*x;
%     plot (x,y)
%     hold off
%     % set(gca,'xlim',[x(1)-.5,x(2)+.5])
%     % set(gca,'ylim',[y(1)-.5,y(2)+.5])
%     title (['STATIC Channel ' num2str(chan_select(1)) ' vs ' num2str(chan_select(2)) ' r= ' num2str(stim_corr(2,1)) ' p= ' num2str(pval(2,1))]);
%     xlabel('chan 1 response z-score');
%     ylabel('chan 2 response z-score');
%     set (gcf,'menubar','default')
% else
%     %Display histograms
%     subplot (1,2,1);
%     normal_matrix=response_matrix(:,1)*100/max(response_matrix(:,1));
%     normal_matrix(:,2)=response_matrix(:,2)*100/max(response_matrix(:,2));
% %     keyboard
%     bar(snd.Var1array,normal_matrix);
%     xlabel(snd.Var1_choices(snd.Var1));
%     ylabel('spikes');
%     set(get(gca,'xlabel'),'fontsize',14);
%     set(gca,'xlim',[(snd.Var1min-(0.5*snd.Var1step)),(snd.Var1max+(0.5*snd.Var1step))]);
%     set(get(gca,'ylabel'),'fontsize',14);
%     title(['Trace= ' num2str(snd.trace) '        channels= ' num2str(chan_select(1)) ' and ' num2str(chan_select(2))]);
%     
%     %Display regression
%     subplot(1,2,2)
%     x_zscore=(response_matrix(:,1)-mean(response_matrix(:,1)))/std(response_matrix(:,1));
%     y_zscore=(response_matrix(:,2)-mean(response_matrix(:,2)))/std(response_matrix(:,2));
%     scatter (x_zscore,y_zscore)
%     hold
%     x=[min(x_zscore),max(y_zscore)];
%     y=stim_corr(1,2)*x;
%     plot (x,y)
%     hold off
%     % set(gca,'xlim',[x(1)-.5,x(2)+.5])
%     % set(gca,'ylim',[y(1)-.5,y(2)+.5])
%     title (['STATIC Sig Corr: Channel ' num2str(chan_select(1)) ' vs ' num2str(chan_select(2)) ' r= ' num2str(stim_corr(2,1)) ' p= ' num2str(pval(2,1))]);
%     xlabel('chan 1 response z-score');
%     ylabel('chan 2 response z-score');
%     set (gcf,'menubar','default')
%     
% end
% 
% %% Display looming results
% figure('menubar','none','position',graphlocation);
% if length(snd.Var2array)>1
%     %Display regression
%     x_zscore=(loom_response_matrix(:,1)-mean(loom_response_matrix(:,1)))/std(loom_response_matrix(:,1));
%     y_zscore=(loom_response_matrix(:,2)-mean(loom_response_matrix(:,2)))/std(loom_response_matrix(:,2));
%     scatter (x_zscore,y_zscore)
%     hold
%     x=[min(x_zscore),max(y_zscore)];
%     y=stim_corr_loom(1,2)*x;
%     plot (x,y)
%     hold off
%     % set(gca,'xlim',[x(1)-.5,x(2)+.5])
%     % set(gca,'ylim',[y(1)-.5,y(2)+.5])
%     title (['LOOMING Channel ' num2str(chan_select(1)) ' vs ' num2str(chan_select(2)) ' r= ' num2str(stim_corr_loom(2,1)) ' p= ' num2str(pval_loom(2,1))]);
%     xlabel('chan 1 response z-score');
%     ylabel('chan 2 response z-score');
%     set (gcf,'menubar','default')
% else
%     %Display histograms
%     subplot (1,2,1);
%     normal_matrix=loom_response_matrix(:,1)*100/max(loom_response_matrix(:,1));
%     normal_matrix(:,2)=loom_response_matrix(:,2)*100/max(loom_response_matrix(:,2));
% %     keyboard
%     bar(snd.Var1array,normal_matrix);
%     xlabel(snd.Var1_choices(snd.Var1));
%     ylabel('spikes');
%     set(get(gca,'xlabel'),'fontsize',14);
%     set(gca,'xlim',[(snd.Var1min-(0.5*snd.Var1step)),(snd.Var1max+(0.5*snd.Var1step))]);
%     set(get(gca,'ylabel'),'fontsize',14);
%     title(['Trace= ' num2str(snd.trace) '        channels= ' num2str(chan_select(1)) ' and ' num2str(chan_select(2))]);
%     
%     %Display regression
%     subplot(1,2,2)
%     x_zscore=(loom_response_matrix(:,1)-mean(loom_response_matrix(:,1)))/std(loom_response_matrix(:,1));
%     y_zscore=(loom_response_matrix(:,2)-mean(loom_response_matrix(:,2)))/std(loom_response_matrix(:,2));
%     scatter (x_zscore,y_zscore)
%     hold
%     x=[min(x_zscore),max(y_zscore)];
%     y=stim_corr_loom(1,2)*x;
%     plot (x,y)
%     hold off
%     % set(gca,'xlim',[x(1)-.5,x(2)+.5])
%     % set(gca,'ylim',[y(1)-.5,y(2)+.5])
%     title (['LOOMING Sig Corr: Channel ' num2str(chan_select(1)) ' vs ' num2str(chan_select(2)) ' r= ' num2str(stim_corr_loom(2,1)) ' p= ' num2str(pval_loom(2,1))]);
%     xlabel('chan 1 response z-score');
%     ylabel('chan 2 response z-score');
%     set (gcf,'menubar','default')
%     
% end

end