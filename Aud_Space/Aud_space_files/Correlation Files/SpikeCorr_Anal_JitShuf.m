%% -------------Cross Correlation JITTER----------------

%% This is designed specifically to recieve OwlLand data and generate
%%cross-correllograms from it.  
%% Skeleton hacked from corrlations.m, part of the Chronux package

%%% NOTE about reading correlograms: values less than zero correspond to
%%% spikes from the neuron in the ROW preceding spikes from the neuron in
%%% the COLUMN.  

%%          DJT 8/21/2012

function [mean_matrix,sem_matrix] =SpikeCorr_Anal_JitShuf (spikes, chan)
global fs maxlag
name='Shuff-Jitt';

K = length(chan);
trial_total=length(spikes.Var1array)*length(spikes.Var2array); %number of trials/rep
bin_total=2*fs*maxlag+1; %number of time bins
pair_total=K*(K+1)/2; %number of comparisons

jitter_length=20; %width of jitter window, centered on the spike time
spikes.datatime=spikes.datatime+spikes.pre+jitter_length/2; %Make sure there are no negative spike times
spike_jitter=spikes;

jitt_iterations=5;
shuff_iterations=spikes.reps-1;

%Initiate output vector.  Dimension1=trial; Dimension2=timebin;
%Dimension3=channelpair. XMatrix (25,10,3) would be the 10th time bin on
%the 25th trial, for channe pair 3. 
XMatrix=zeros((trial_total*spikes.reps*jitt_iterations*shuff_iterations),bin_total,pair_total); 
trial_collapse=zeros(pair_total,bin_total);
spike_shuff=spikes;

%% Start Cross Correlation
fprintf (strcat('\nGoing through :', num2str(jitt_iterations),' jitter iterations. \n'))
tic

for jitt_count=1:jitt_iterations 
    
    fprintf (strcat('\nIteration :', num2str(jitt_count),'\n'))
    
    time_jitter=NaN(1,length(spikes.datatime)); 

    for i=1:length(spikes.datatime)
        time_jitter(i)=spikes.datatime(i)+(rand-1/2)*jitter_length;
    end;
    
    spike_shuff.datatime=time_jitter;

    for shuff_count=1:(shuff_iterations)
        spike_shuff=Shuffler_2var(spike_shuff);

paircounter=1;
%r*c = channel pair
for r = 1:K
    for c = r:K  % upper right triangle only (b/c symmetric)
        
        trialcounter=1; %Needs to be inside of row and column loops
        for reptag=1:spikes.reps;
            for trialtag=1:trial_total;
                %An array of all the spikes occuring on channel Y for this trial
                selectrow = find((spikes.datachan == chan(r)) & (spikes.datatrial==trialtag) & (spikes.datarep==reptag));
                %An array of all the spikes occuring on channel X
                selectcol = find(spike_shuff.datachan == chan(c)& spike_shuff.datatrial==trialtag & spike_shuff.datarep==reptag);
                
                if ((length(selectrow) > 1) && (length(selectcol) > 1)) %If there are spikes in both channels
                    %Calculate the correlation
                    %             keyboard %%GOOD debugging point
                    [cross,lags] = pxcorr(spikes.datatime(selectrow), spike_shuff.datatime(selectcol), fs, maxlag);
                    if (r == c),  cross(lags == 0) = 0;  end;  % blank out autocorr peak
                    spikeproduct=length(selectrow)*length(selectcol); %This is for normalizing for firing rates
                    shuff_trials=trial_total*spikes.reps; %Num trials that pass with each shuffle
                    jitt_trials=shuff_iterations*shuff_trials; %Num trials that pass with each jitter
                    XMatrix(trialcounter+shuff_trials*(shuff_count-1)+jitt_trials*(jitt_count-1),:,paircounter)=cross/spikeproduct;
                    trial_collapse(paircounter,:)=trial_collapse(paircounter,:)+cross/spikeproduct;
                end;
                trialcounter=trialcounter+1;
                %         keyboard
            end
        end
%         keyboard
        paircounter=paircounter+1;
        
    end
end
toc
    end
end
% keyboard
%the mean coincidences per spike^2 that occur on a trial
mean_matrix=trial_collapse/(trial_total*spikes.reps*jitt_iterations*shuff_iterations); 
std_matrix=std(XMatrix,0,1); 
sem_matrix=std_matrix/size(XMatrix,1).^(1/2);
%2nd input of 0 sets the flag for the standard deviation that divides by
%n-1.  By comparison, a 1 would compute by dividing by n.  Not sure what
%the difference is.  

%% Plot Correlation

%Set figure position
MyScreen=get(0,'ScreenSize');
p1=0;
if strcmp(name,'Real')
    p2=(MyScreen(4)/2); %Put it Halfway up
else
    p2=0; %Put it at the bottom
end
p3=MyScreen(3);
p4=MyScreen(4)/2-85;

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
fprintf ('figure #%d is %s data\n', gcf,name)

end

%%DUMP

%% Convert times to include total running time
% TrialsPerRep=length(spikes.Var1array)*length(spikes.Var2array);
% ElapsedTime=(spikes.datatrial-1+(spikes.datarep-1)*TrialsPerRep)*spikes.isi;
% %woo this line is already set to handle 2 dimensions if/when the time comes
% AbsTime=spikes.datatime+ElapsedTime+spikes.pre;

%DON'T NEED THIS ANYMORE.  Doing it trial by trial, so I can do some
%trial-based statistics. -DJT 2/20/2013



        %For each channel pair, build a matrix where each row is the correlogram
        %for a single trial
%         TempChanMatrix=zeros(trial_total*spikes.reps,2*fs*maxlag+1);
