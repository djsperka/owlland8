function SpikeCorr_Plot_Shuffle (spikes, raw_cell,shuff_cell,chan)
global maxlag fs

% %% Use Shuffle as baseline and print it
% % NormXM=RealXM./ShufXM-1; %Divides by shuffle
% shuffsub_mean1=raw_cell{1,1}-shuff_cell{1,1};   %Subtracts by shuffle
% shuffsub_mean2=raw_cell{1,2}-shuff_cell{1,2};
% shuffsub_sem1=(raw_cell{2,1}.^2+shuff_cell{2,1}.^2).^(1/2); 
% shuffsub_sem2=(raw_cell{2,2}.^2+shuff_cell{2,2}.^2).^(1/2); 
% 
% %Set figure names
% if ~spikes.interleave_alone  
%     name='Raw Minus Shuffle';
% else
%     if  ~spikes.Var2array
%         name='Raw Minus Shuffle; Var1';
%     elseif ~spikes.Var1array
%         name='Raw Minus Shuffle; Var2';
%     else
%         name='Raw Minus Shuffle; Both';
%     end 
% end
%     
% 
% %Set figure position
% MyScreen=get(0,'ScreenSize');
% p3=MyScreen(3)/K;
% p4=MyScreen(4)/K;
% % if ~spikes.interleave_alone
% %     p1=0;
% %     p2=(MyScreen(4)/2); %Put it Halfway up
% %     p4=MyScreen(4)/2-85;
% %     p3=MyScreen(3);
% % else
% %     if strcmp(name(end-4:end),' Both')
% %         p2=(MyScreen(4)*(1-1/8)-50); 
% %     elseif strcmp(name(end-4:end),' Var1')
% %         p2=(MyScreen(4)*(1-2/8)-50); 
% %     elseif strcmp(name(end-4:end),' Var2')
% %         p2=(MyScreen(4)*(1-3/8)-50);
% %     end
% %     p1=MyScreen(3)/2;
% %     p3=MyScreen(3)/2;
% %     p4=MyScreen(4)/8;
% % end
% 
% K = length(chan);
% num_corr=K*(K+1)/2; %number of correlations that will take place
% lags=(-maxlag:1/fs:maxlag);
% fig_hands=zeros(num_corr);
% 
% plot_count=0;
% for r = 1:K
%     for c = r:K  % upper right triangle only (b/c symmetric)
%         plot_count=plot_count+1;
%         p1=p3*(r-1);
%         p4=MyScreen(4)-p4*c;
%         fig_hands(plot_count)=figure ('position',[p1 p2 p3 4]);
% 
% % Plot Normalized (Raw minus shuffle)
%         bar (lags,shuffsub_mean1(plot_count,:),1.0);
%         shadedErrorBar(lags, shuffsub_mean1(plot_count,:), shuffsub_sem1(:,:,plot_count), '-r', 1); 
%         set(gca, 'XLim', [-maxlag, maxlag]); 
%         title(strcat(name,'   ',r,'X',c))
% %         if (r == c),  ylabel(sprintf('#%d %s', chan(r),name));  end;
% %         if (r == 1),  title(sprintf('#%d %s', chan(c),name));  end;
% %         if (r==length(chan) && (c==floor(length(chan)/2) || length(chan)<2)),
% %             xlabel (sprintf('%s Data',name));
% %         end;
%     end
% end
% % gcf
% fprintf ('figure #%d is %s data\n', gcf,name)


%% Plot Raw and Shuffle on top of eachother
K = length(chan); 

%Set figure name
if ~spikes.interleave_alone
    name='Raw N Shuffle';
else
    if  ~spikes.Var2array
        name='Raw N Shuffle: Var1';
    elseif ~spikes.Var1array
        name='Raw N Shuffle: Var2';
    else
        name='Raw N Shuffle: Both';
    end
end

%Set figure position
MyScreen=get(0,'ScreenSize');
p3=MyScreen(3)/K;
p4=MyScreen(4)/K;
% if ~spikes.interleave_alone
%     p1=0;
%     p3=MyScreen(3);
%     p2=0; %Put it at bottom
%     p4=MyScreen(4)/2-85;
% else
%     if strcmp(name(end-4:end),' Both')
%         p2=MyScreen(4)*2/8; 
%     elseif strcmp(name(end-4:end),' Var1')
%         p2=MyScreen(4)*1/8; 
%     elseif strcmp(name(end-4:end),' Var2')
%         p2=0;
%     end
%     p1=MyScreen(3)/2;
%     p3=MyScreen(3)/2;
%     p4=MyScreen(4)/8;
% end
num_corr=K*(K+1)/2; %number of correlations that will take place
lags=(-maxlag:1/fs:maxlag);
fig_hands=zeros(num_corr,1);

plot_count=0;
for r = 1:K
    for c = r:K  % upper right triangle only (b/c symmetric)
        plot_count=plot_count+1;
        p1=p3*(c-1);
        p2=MyScreen(4)-p4*r;
        fig_hands(plot_count)=figure ('position',[p1 p2 p3 p4-50]);
        hold
        H(1) = shadedErrorBar(lags, raw_cell{1,1}(plot_count,:), raw_cell{2,1}(:,:,plot_count), '-r', 1); 
        H(2) = shadedErrorBar(lags, shuff_cell{1,1}(plot_count,:), shuff_cell{2,1}(:,:,plot_count), '-b', 1); 
        title (strcat(name,'   ',num2str(chan(r)),'X',num2str(chan(c))));
        set (gcf,'menubar','default');
        set(gca, 'XLim', [-maxlag, maxlag]); 
        ylabel(strcat('ch',num2str(c),' spikes / spikes on ch',num2str(r)))
%         if (r == c),  ylabel(sprintf('#%d %s', chan(r),name));  end;
%         if (r == 1),  title(sprintf('#%d %s', chan(c),name));  end;
%         if (r==length(chan) && (c==floor(length(chan)/2) || length(chan)<2)),
%             xlabel (sprintf('%s Data',name));
%         end;
        hold off
    end
end

keyboard
for i=1:length(fig_hands)
    figure(fig_hands(i))
    close
end
keyboard
'';