function NoiseCorr1D_Run (spikes,corrtype)
global chan_select

'WARNING: This is outdated compared to NoiseCorr2D_run.  entering keyboard mode'
keyboard

chan_choices=find(chan_select==1);

%% Build pre, post, and response matrices, and the z-score matrix
pair_count=(length(chan_choices)*(length(chan_choices)-1))/2; %number of comparisons
%Blank cell arrays
post_cell={};
pre_cell={};
resp_cell={};
zscore_cell={};

for chan=chan_choices
        for i=1:length(spikes.Var1array)
            var=spikes.Var1array(i);
            for rep= 1:spikes.reps
                find_post= spikes.dataVar1==var & spikes.datachan==chan & spikes.datarep==rep & spikes.datatime>0 & spikes.datatime<spikes.post;
                find_pre= spikes.dataVar1==var & spikes.datachan==chan & spikes.datarep==rep & spikes.datatime<0;
                post_cell{chan}(rep,i)=sum(find_post);
                pre_cell {chan}(rep,i)=sum(find_pre);
            end
        end
        %Subtract duration-corrected pre from post
        resp_cell{chan}=post_cell{chan}-pre_cell{chan}*spikes.post/spikes.pre;
        channel_means=mean(resp_cell{chan}); %Calculate the mean response for each variable
        %Subtract the mean
        mean_subtract=resp_cell{chan}-channel_means(ones(size(resp_cell{chan},1),1),:);
        channel_std=std(resp_cell{chan}); % Calculate the response standard deviation for each variable
        %Divide by the standard deviation
        zscore_cell{chan}=mean_subtract./(channel_std(ones(size(mean_subtract,1),1),:));
%         zscore_cell{chan}=zscore_cell{chan}(:); %Collapse across dimensions to make this 1D
    end
clear i;
%these cell arrays have the following structure: There will be a cell for
%each channel, and then within that cell there will be a 2D array where
%each column is a stimulus variable, and each row the individual trials for
%that variable, converted to a z-score relative to the distribution of
%responses to that variable

%% Run the correlation
var_corr_array=nan(length(spikes.Var1array),length(spikes.Var1array),length(chan_choices)*(length(chan_choices)-1)/2);
var_pval_array=nan(length(spikes.Var1array),length(spikes.Var1array),length(chan_choices)*(length(chan_choices)-1)/2);
counter=0;
fig_array=nan(1,pair_count);
subplot_array=nan(2,pair_count);
for j=1:length(chan_choices);
    chan1=chan_choices(j);
    for k=j+1:length(chan_choices);
        chan2=chan_choices(k);
        counter=counter+1;
        x=zscore_cell{chan1};
        y=zscore_cell{chan2};
        [var_corr_array(:,:,counter),var_pval_array(:,:,counter)]=corr(x,y);
        %The diagonal is where the same variable values are compared.  Off the
        %diagonal compares trials with separate variables.  We want the diagonal.
        r=mean(diag(var_corr_array(:,:,counter)));
        p=mean(diag(var_pval_array(:,:,counter)));
        
        %Display histograms
        fig_array(counter)=figure;
        subplot_array(1,counter)=subplot(2,1,1);
%         fig_array(counter)=gcf; %save the figure handles in an array

        %normalize histograms so that the max for each neuron is 1:
        %find the average response per stim and divide by the max mean response
        norm_cell1=mean(resp_cell{chan1})/max(abs(mean(resp_cell{chan1})));
        norm_cell2=mean(resp_cell{chan2})/max(abs(mean(resp_cell{chan2})));
        %put response vectors together and plot them
        plot_array=[norm_cell1;norm_cell2];
        bar(spikes.Var1array,plot_array');
        xlabel(spikes.Var1_choices(spikes.Var1));
        ylabel('normalized responses');
        set(get(gca,'xlabel'),'fontsize',12);
        set(gca,'xlim',[(spikes.Var1min-(0.5*spikes.Var1step)),(spikes.Var1max+(0.5*spikes.Var1step))]);
        set(get(gca,'ylabel'),'fontsize',12);
        set(gca,'ylim',[min(min(norm_cell1,norm_cell2))-.2,1.3]);
        title(['Noise Correlations by Variable:   Trace= ' num2str(spikes.trace) '        channels= ' num2str(chan1) ' and ' num2str(chan2)]);
        
        %Display scatter plot
        subplot_array(2,counter)=subplot(2,1,2);
        plot (zscore_cell{chan1},zscore_cell{chan2},'o');
        hold on
        vertline=[min(min(zscore_cell{chan2}))-.25,max(max(zscore_cell{chan2}))+.25];
        plot ([0 0],vertline,'--k')
        horizline=[min(min(zscore_cell{chan1}))-.25,max(max(zscore_cell{chan1}))+.25];
        plot (horizline,[0 0],'--k')
        
        %Calculate and plot the best fit line to this scatter
        fit_line=polyfit(x,y,1);
        fit_handle=plot ([-3 3],([-3,3]*fit_line(1)+fit_line(2)),':g','LineWidth',4);
        legend (fit_handle,strcat('slope=',num2str(fit_line(1),2),'  r= ',num2str(r,3),' p= ',num2str(p,3)));
        
        xlabel(strcat('Ch ', num2str(chan1), ' trial standard scores') );
        ylabel(strcat('Ch ', num2str(chan2), ' trial standard scores'));
        set(get(gca,'xlabel'),'fontsize',12);
        set(get(gca,'ylabel'),'fontsize',12);
        set (gca, 'xlim',horizline);
        set (gca, 'ylim',vertline);
        if nargin>1
            title(['LOOMER Noise Corr Trial by Trial Scatter:   Trace= ' num2str(spikes.trace) '        channels= ' num2str(chan1) ' and ' num2str(chan2)]);
        else
            title(['Noise Corr Trial by Trial Scatter:   Trace= ' num2str(spikes.trace) '        channels= ' num2str(chan1) ' and ' num2str(chan2)]);
        end
        hold off

    end
end

% This outputs a 3D array, where each value is a correlation between all
% the trials for a variable.  Columns are variable values from neuron 1
% (column1=variable 1 from neuron 1), rows are variable values for number
% 2. The 3rd dimension are neuron pairs (1X2, 1X3 etc).

%This nifty bit of code puts a r and p value above each point on the
%histogram
var_corr_diag=nan(length(spikes.Var1array),pair_count);
var_pval_diag=nan(length(spikes.Var1array),pair_count);
for m=1:pair_count
    var_corr_diag(:,m)=diag(var_corr_array(:,:,m));
    var_pval_diag(:,m)=diag(var_pval_array(:,:,m));
    
    %Plot it!
    set (0,'currentfigure',fig_array(m));
    subplot(subplot_array(1,m));
    for i=1:length(spikes.Var1array)
        text(spikes.Var1array(i)-spikes.Var1step/3,1.2,strcat('r=',num2str(round(var_corr_diag(i,m)*100)/100)))
        text(spikes.Var1array(i)-spikes.Var1step/3,1.1,strcat('p=',num2str(round(var_pval_diag(i,m)*1000)/1000)))
    end  
end

end
