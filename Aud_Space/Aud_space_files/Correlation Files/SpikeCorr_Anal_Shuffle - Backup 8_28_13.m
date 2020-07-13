%% -------------Cross Correlation Shuffle Analysis----------------

%%% This is designed specifically to work with OwlLand data. It is designed
%%% to compute the average shuffle for each pair of channels, by adding up
%%% the shuffles from every repition combination EXCEPT the unshuffled
%%% value and dividing by the number of shuffles
%%% 3 rep example: A1=neuron A, rep 1
%%% ( A1xB2 + A1xB3 +A2xB1 + A2xB3 + A3xB1 + A3xB2 ) / 6

%%% Skeleton hacked from corrlations.m, part of the Chronux package

%%% NOTE about reading correlograms: values less than zero correspond to
%%% spikes from the neuron in the ROW preceding spikes from the neuron in
%%% the COLUMN.  

%%%          DJT 8/21/2012

function [mean_matrix,sem_matrix]=SpikeCorr_Anal_Shuffle (spikes, chan)
global fs maxlag 

if spikes.interleave_alone  
    if  ~spikes.Var2array
        name='arr1 Shuffle';
    elseif ~spikes.Var1array
        name='arr2 Shuffle';
    else
        name='Both Shuffle';
    end   
else
name='Shuffle';
end;

K = length(chan);
trial_total=length(spikes.Var1array)*length(spikes.Var2array); %number of trials/rep
bin_total=2*fs*maxlag+1; %number of time bins
pair_total=K*(K+1)/2; %number of comparisons
shuff_iterations=spikes.reps-1;

spikes.datatime=spikes.datatime+spikes.pre; %Make sure there are no negative spike times

%Initiate output vector.  Dimension1=trial; Dimension2=timebin;
%Dimension3=channelpair. XMatrix (25,10,3) would be the 10th time bin on
%the 25th trial, for channe pair 3.  

XMatrix=zeros((spikes.reps*shuff_iterations),bin_total,pair_total); %Collapsing across trials; keeping reps and shuffles distinct
% XMatrix=zeros((trial_total*spikes.reps*shuff_iterations),bin_total,pair_total); 
% XMatrix=zeros((trial_total*spikes.reps),bin_total,pair_total,shuff_iterations); 
trial_collapse=zeros(pair_total,bin_total);

% ----Compare rep with every other rep ----
SpikeShuff=spikes;

fprintf ('\nStarting Shuffle loop.  This could take a minute \n\n')

%Initiate tools
watch_reps=zeros(shuff_iterations,spikes.reps);
watch_chans=zeros(shuff_iterations,10); %NOTE only watch 10 channels
for i=1:spikes.reps
    start_reps(i)=length(find(spikes.datarep==i));
end
for i=1:10 %NOTE only watch 10 channels
    start_chans(i)=length(find(spikes.datachan==i));
end
rep_change_flag=0;
chan_change_flag=0;
num_iter=0;
for shuff_count=1:(shuff_iterations)
   tic 
    %% Shuffle data
    % keyboard
    SpikeShuff=Shuffler_2var(SpikeShuff);
    num_iter=num_iter+1; %keep track of how many iterations have passed
    
    %% Diagnostics - make sure shuffle went well
%optional raster displays if having trouble
%     if printrasters
%     fprintf ('Drawing bottom raster plots post-shuffle, then stopping.  Called in XCor_Anal_Shuffle\n\n')
%     Raster(SpikeShuff,rec,chan, NAME);
%     keyboard
%     end
    
%make sure the that shuffle reps have the same number of spikes in them as
%the original reps, just moved by 1 rep
for i=1:spikes.reps
    watch_reps(shuff_count,i)=length(find(SpikeShuff.datarep==i));
    if i<=spikes.reps-num_iter
    if watch_reps(shuff_count,i)~=start_reps(i+num_iter)
        rep_change_flag=1;
    end
    else %rounded the corner
    if watch_reps(shuff_count,i)~=start_reps(i+num_iter-spikes.reps)
        rep_change_flag=1;
    end
    end
end

%make sure that each channel has the same number of spikes in it in the
%shuffle and normal data
for i=1:10
    watch_chans(shuff_count,i)=length(find(SpikeShuff.datachan==i));
    if watch_chans(shuff_count,i)~=start_chans(i)
        chan_change_flag=1;
    end
end

%if spikes were lost/misplaced during the shuffle, generate diagnostic
%plots to see which channels/reps were losing/gaining spikes
if rep_change_flag || chan_change_flag
    color='mcrgbmcrgbmcrgbmcrgb';
    
    if rep_change_flag
    figure
    hold on
    x=1:spikes.reps;
    plot (x,start_reps(:),'k')
    for i=1:num_iter
        plot(x,watch_reps(i,:),color(i))
    end
    title ('Rep plot.  black = raw, colors = shuffle')
    hold off
    end
    
    if chan_change_flag
    figure
    hold on
    x=1:10;
    plot (x,start_chans(:),'k')
    for i=1:num_iter
        plot (x,watch_chans(i,:)+max(max(watch_chans))*.25*i,color(i))
    end
    title ('Channel plot.  black= raw, colors = shuffle')
    hold off   
    end
    
    fprintf '\nERROR!\nSpike counts are changing during shuffles.  keyboard called in XCor_Anal_Shuffle.m\n\n')
    keyboard
        
end

%LAST FLAG - one last check to make sure that the total number of spikes is
%the same
if size(spikes.datatime)~=size(SpikeShuff.datatime)
    fprintf('\nspikes.datatime and SpikeShuff.datatime are not equal.  Entering keyboard mode in XCor_Anal_Shuffle\n')
    keyboard
end

%% Correlate raw data with shuffled data
pair_count=1;
%r*c = channel pair
for r = 1:K
    for c = r:K  % upper right triangle only (b/c symmetric)
        
%         trial_count=1; %outside rep-loop so t1rep1 will be separate from t1rep2
rep_count=1;
        for reptag=1:spikes.reps;
            for trialtag=1:trial_total;
                %An array of all the spikes occuring on channel Y for this trial
                selectrow = find((spikes.datachan == chan(r)) & (spikes.datatrial==trialtag) & (spikes.datarep==reptag));
                %An array of all the spikes occuring on Shuffled Channel
                selectcol = find(SpikeShuff.datachan == chan(c)& SpikeShuff.datatrial==trialtag & SpikeShuff.datarep==reptag);
                
%                 keyboard
                if ((length(selectrow) > 1) && (length(selectcol) > 1)) %If there are spikes in both channels
                    %NOTE: must have length greater than 1, because pxcorr
                    %doesn't work for point processes <2.  Not sure why  
                    %Calculate the correlation
                    %             keyboard %%GOOD debugging point
                    [cross,lags] = pxcorr(spikes.datatime(selectrow), SpikeShuff.datatime(selectcol), fs, maxlag);
                    
                    if (r == c),  cross(lags == 0) = 0;  end;  % blank out autocorr peak
                    spikeproduct=length(selectrow)*length(selectcol); %This is for normalizing for firing rates
                    XMatrix(rep_count+(shuff_count-1)*spikes.reps,:,pair_count)=cross/spikeproduct;
%                     % ^ = Collapsed across trials; reps still separate.
%                     NOTE: This collapse did not seem to greatly impact
%                     performance.  DJT 7/14/2013
%                     XMatrix(trial_count+(shuff_count-1)*trial_total*spikes.reps,:,pair_count)=cross/spikeproduct;
%                     % ^ =TRIALS SEPERATE.  Commented out 7/14/2013 DJT
%                     XMatrix(trial_count,:,pair_count,shuff_count)=cross/spikeproduct;
%%% HERE is the problem .. .XMatrix is HUGE!
                    trial_collapse(pair_count,:)=trial_collapse(pair_count,:)+cross/spikeproduct;
                end;
%                 trial_count=trial_count+1; %Commented out 7/14/2013
%                         keyboard
            end
            rep_count=rep_count+1;
        end
        % keyboard
        pair_count=pair_count+1;
        
    end
end
toc
% if loop_timer>40
%  keyboard
% end

end

%the mean coincidences per spike^2 that occur on a trial
mean_matrix=trial_collapse/(trial_total*spikes.reps*shuff_iterations); 
std_matrix=std(XMatrix,0,1); 
sem_matrix=std_matrix/size(XMatrix,1).^(1/2);
%2nd input of 0 sets the flag for the standard deviation that divides by
%n-1.  By comparison, a 1 would compute by dividing by n.  Not sure what
%the difference is.  

% keyboard

%% Plot Correlation

%Set figure position
MyScreen=get(0,'ScreenSize');
p1=0;
if ~spikes.interleave_alone
    p3=MyScreen(3);
    p2=0; %Put it at bottom
    p4=MyScreen(4)/2-85;
else
    if strcmp(name(1:4),'Both')
        p2=MyScreen(4)*2/8; 
    elseif strcmp(name(1:4),'arr1')
        p2=MyScreen(4)*1/8; 
    elseif strcmp(name(1:4),'arr2')
        p2=0;
    end
    p3=MyScreen(3)/2;
    p4=MyScreen(4)/8;
end

figure ('position', [p1 p2 p3 p4])

plotcount=0; %Keep track of which plot is being generated
for r = 1:K
    for c = r:K  % upper right triangle only (b/c symmetric)
        plotcount=plotcount+1;
        subplot(K,K,c+(r-1)*K);
        hold;
            bar(lags,mean_matrix(plotcount,:),1.0);  shading flat; %Plot the correlogram
            errorbar(lags,mean_matrix(plotcount,:),sem_matrix(:,:,plotcount),'--r');
            set(gca, 'XLim', [-maxlag, maxlag]);
        if (r == c),  ylabel(sprintf('#%d %s', chan(r),name));  end;
        if (r == 1),  title(sprintf('#%d %s', chan(c),name));  end;
        if (r==length(chan) && (c==floor(length(chan)/2) || length(chan)<2)),
            xlabel (sprintf('%s Data',name));
        end;
    end
end
gcf;
fprintf ('\nfigure #%d is %s data\n', gcf,name)

end

%% -------------CODE DUMP----------------

         %% Convert times to include total running time
%     TrialsPerRep=length(spikes.Var1array)*length(spikes.Var2array);
%     ElapsedTime=(spikes.datatrial-1+(spikes.datarep-1)*TrialsPerRep)*spikes.isi;
%     AbsTime=spikes.datatime+ElapsedTime+spikes.pre;  
%     ElapsedTimeShuff=(SpikeShuff.datatrial-1+(SpikeShuff.datarep-1)*TrialsPerRep)*spikes.isi;
%     %woo this line is already set to handle 2 dimensions if/when the time comes
%     AbsTimeShuff=SpikeShuff.datatime+ElapsedTimeShuff+spikes.pre;
%    

%% Watch Trial Code - insert in with rest of diagnostics
% watch_trials=zeros(shuff_iterations,trial_total);
% for i=1:trial_total
%     watch_trials(shuff_count,i)=length(find(SpikeShuff.datatrial==i));
% end

%     plot_spikes_per_trial=0; %turn on to plot spikes per trial.  Probably useless
%     if plot_spikes_per_trial
%     figure
%     hold on
%     x=1:trial_total;    
%     for i=1:num_iter
%         plot(x,watch_trials(i,:),color(i))
%     end
%     hold off
%     end