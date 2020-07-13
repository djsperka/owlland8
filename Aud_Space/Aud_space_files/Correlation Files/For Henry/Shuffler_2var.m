
function [SpikeShuff]=Shuffler_2var (spikes)

%Take in OwlLand style arrays of data and shuffle them so that all of the
%spikes from a specific set of parameters (ie ITD=15, ILD=5) in rep n+1
%become rep n.  Rep#1 gets shuffled to be the max rep.  

%DJT
%Last modifications 8/6/2013

% keyboard

%Populate Shuffle array and clear contents of vectors that will be used
SpikeShuff=spikes;
SpikeShuff.datachan=[];
SpikeShuff.datarep=[];
SpikeShuff.datatrial=[];
SpikeShuff.datatime=[];
SpikeShuff.dataVar1=[];
SpikeShuff.dataVar2=[];

trials_per_rep=length(spikes.Var1array)*length(spikes.Var2array);
trial_counter=0; 

for j=1:(spikes.reps) %For each rep

    for k=1:trials_per_rep; %For each trial
        trial_counter=trial_counter+1; %keep track of what trial this is
        %and use trial to extract the variables from this trial
        var1=spikes.Var1_pres_order(trial_counter);
        var2=spikes.Var2_pres_order(trial_counter);        
        
        %tag all the spikes in the n+1 rep with these variable values
        if j==spikes.reps %if this is the last rep, loop back to the first rep
            tagger=find(spikes.datarep==1 & spikes.dataVar1==var1 & spikes.dataVar2==var2);
        else
            %otherwise just look to the next rep
            tagger=find(spikes.datarep==(j+1) & spikes.dataVar1==var1 & spikes.dataVar2==var2);
        end
        %extract tagged times, channels and variables
        SpikeShuff.datatime=[SpikeShuff.datatime,spikes.datatime(tagger)];
        SpikeShuff.datachan=[SpikeShuff.datachan,spikes.datachan(tagger)];
        SpikeShuff.dataVar1=[SpikeShuff.dataVar1, spikes.dataVar1(tagger)];
        SpikeShuff.dataVar2=[SpikeShuff.dataVar2,spikes.dataVar2(tagger)];
        %assign reps and trials used to ID tags
        SpikeShuff.datarep=[SpikeShuff.datarep,ones(size(tagger))*j];
        SpikeShuff.datatrial=[SpikeShuff.datatrial,ones(size(tagger))*k];
       
    end
end

end