%%% -------------Cross Correlation Analysis----------------

%%% This is designed specifically to recieve OwlLand data and generate
%%% cross-correllograms from it.  
%%% Skeleton hacked from corrlations.m, part of the Chronux package

%%% NOTE about reading correlograms: values greater than zero correspond to
%%% spikes from the neuron in the COLUMN preceding spikes from the neuron in
%%% the ROW.  

%%% DJT 8/21/2012

function [raw_cell] =SpikeCorr_Anal (spikes, chan)
global fs maxlag
if spikes.interleave_alone
    
    if  ~spikes.Var2array
        name='arr1 Raw';
    elseif ~spikes.Var1array
        name='arr2 Raw';
    else
        name='Both Raw';
    end
    
else
    name='Raw!';
end

K = length(chan);
trial_total=length(spikes.Var1array)*length(spikes.Var2array); %number of trials/rep
bin_total=2*fs*maxlag+1; %number of time bins
pair_total=K*(K+1)/2; %number of comparisons

spikes.datatime=spikes.datatime+spikes.pre; %Make sure there are no negative spike times

%Initiate output vector.  Dimension1=trial; Dimension2=timebin;
%Dimension3=channelpair. XMatrix (25,10,3) would be the 10th time bin on
%the 25th trial, for channe pair 3.  

XMatrix1=zeros((trial_total*spikes.reps),bin_total,pair_total); 
XMatrix2=zeros((trial_total*spikes.reps),bin_total,pair_total); 
trial_collapse1=zeros(pair_total,bin_total);
trial_collapse2=zeros(pair_total,bin_total);
% ref_spike_array=zeros(
% std_matrix=zeros((K*(K+1)/2),2*fs*maxlag+1); %Variances for each time bin. Each row is a channel pair

%% Start Cross Correlation
paircounter=1;
%r*c = channel pair
for r = 1:K
    for c = r:K  % upper right triangle only (b/c symmetric)
        
        trialcounter=1;
        for reptag=1:spikes.reps;
            for trialtag=1:trial_total;
                %An array of all the spikes occuring on channel Y for this trial
                selectrow = find((spikes.datachan == chan(r)) & (spikes.datatrial==trialtag) & (spikes.datarep==reptag));
                %An array of all the spikes occuring on channel X
                selectcol = find(spikes.datachan == chan(c)& spikes.datatrial==trialtag & spikes.datarep==reptag);
                if ((length(selectrow) > 1) && (length(selectcol) > 1)) %If there are spikes in both channels
                    %Calculate the correlation
                    [cross,lags] = pxcorr(spikes.datatime(selectrow), spikes.datatime(selectcol), fs, maxlag);
                    if (r == c), cross(lags == 0) = 0;  end;  % blank out autocorr peak
                    n1size=length(selectcol)*length(selectrow); %This is for normalizing for firing rates
                    n2size=1;%length(selectrow); 
                    XMatrix1(trialcounter,:,paircounter)=cross/n1size;
                    XMatrix2(trialcounter,:,paircounter)=cross/n2size;
                    trial_collapse1(paircounter,:)=trial_collapse1(paircounter,:)+cross/n1size;
                    trial_collapse2(paircounter,:)=trial_collapse2(paircounter,:)+cross/n2size;
                end;
                trialcounter=trialcounter+1;
                %         keyboard
            end
        end
        % keyboard
%         ref_spike_counter
        paircounter=paircounter+1;
        
    end
end
% keyboard
%the mean coincidences per spike^2 that occur on a trial
% keyboard
mean_matrix1=trial_collapse1/(trial_total*spikes.reps); 
mean_matrix2=trial_collapse2/(trial_total*spikes.reps); 
%%%REVERT THIS BACK LATER - DJT 9/16
std_matrix1=std(XMatrix1,0,1); 
sem_matrix1=std_matrix1/size(XMatrix1,1).^(1/2);
std_matrix2=std(XMatrix2,0,1); 
sem_matrix2=std_matrix2/size(XMatrix2,1).^(1/2);

raw_cell{1,1}=mean_matrix1;
raw_cell{1,2}=mean_matrix2;
raw_cell{2,1}=sem_matrix1;
raw_cell{2,2}=sem_matrix2;
raw_cell{3,1}=XMatrix1;
raw_cell{3,2}=XMatrix2;
%2nd input of 0 sets the flag for the standard deviation that divides by
%n-1.  By comparison, a 1 would compute by dividing by n.  Not sure what
%the difference is.  

%% Plot Correlation

% %Set figure position
% MyScreen=get(0,'ScreenSize');
% p1=0;
% if ~spikes.interleave_alone
%     p2=(MyScreen(4)/2); %Put it Halfway up
%     p4=MyScreen(4)/2-85;
%     p3=MyScreen(3);
% else
%     if strcmp(name(1:4),'Both')
%         p2=(MyScreen(4)*(1-1/8)-50); 
%     elseif strcmp(name(1:4),'arr1')
%         p2=(MyScreen(4)*(1-2/8)-50); 
%     elseif strcmp(name(1:4),'arr2')
%         p2=(MyScreen(4)*(1-3/8)-50);
%     end
%     p3=MyScreen(3)/2;
%     p4=MyScreen(4)/8;
% end
% 
% figure ('position', [p1 p2 p3 p4])
% 
% plotcount=0; %Keep track of which plot is being generated
% for r = 1:K
%     for c = r:K  % upper right triangle only (b/c symmetric)
%         plotcount=plotcount+1;
%         subplot(K,K,c+(r-1)*K);
%         hold;
%             bar(lags,mean_matrix(plotcount,:),1.0);  shading flat; %Plot the correlogram
%             errorbar(lags,mean_matrix(plotcount,:),sem_matrix1(:,:,plotcount),'--r');
%             set(gca, 'XLim', [-maxlag, maxlag]);
%         if (r == c),  ylabel(sprintf('#%d %s', chan(r),name));  end;
%         if (r == 1),  title(sprintf('#%d %s', chan(c),name));  end;
%         if (r==length(chan) && (c==floor(length(chan)/2) || length(chan)<2)),
%             xlabel (sprintf('%s Data',name));
%         end;
%     end
% end
% gcf;
% fprintf ('figure #%d is %s data\n', gcf,name)

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
