 function [spikes] = Add_Trials (spikes)
% This  serves to re-order the trial tags following variable range
% limiting.  The problem is that once you drop a handful of the variables,
% there will be gaps in the trials.  Not entirely sure, but this may be
% causing troubles down the line with generating correlograms (like when we
% try to make absolute spike times). 

if spikes.interleave_alone==1 %Figure out how many trials there are for each repetition
    trials_per_rep=length(spikes.Var1array)*length(spikes.Var2array)+length(spikes.Var1array)+length(spikes.Var2array);
else
    trials_per_rep=length(spikes.Var1array)*length(spikes.Var2array);
end  %added if statement 4/28/2013
% if spikes.inter_loom
%     trials_per_rep=trials_per_rep*2;
% end
spikes.datatrial=[];
spikes.datatrial_arr1=[];
spikes.datatrial_arr2=[];
variable_counter=1;

if spikes.interleave_alone %interleaved data
for j=1:(spikes.reps) %For each rep
    both_trial=0;
    arr1_trial=0;
    arr2_trial=0;
    for k=1:trials_per_rep; %For each trial 
        %find the next variables for this rep
        trial_var1=spikes.Var1_pres_order(variable_counter); %find Var1 value
        trial_var2=spikes.Var2_pres_order(variable_counter); %find Var2 value
        
        %find all spikes from this rep with this Var1 and Var2 combination 
        if isnan(trial_var1) %means that this was var2 alone trial
            arr2_trial=arr2_trial+1;
            tagger = find(spikes.dataVar2_arr2==trial_var2 & spikes.datarep_arr2==j);
            spikes.datatrial_arr2=[spikes.datatrial_arr2,ones(1,length(tagger))*arr2_trial];
        elseif isnan(trial_var2) %means that this var1 alone trial
            arr1_trial=arr1_trial+1;
            tagger = find(spikes.dataVar1_arr1==trial_var1 & spikes.datarep_arr1==j);
            spikes.datatrial_arr1=[spikes.datatrial_arr1,ones(1,length(tagger))*arr1_trial];
        else %means that this was a both trial
            both_trial=both_trial+1;
            tagger = find(spikes.dataVar1==trial_var1 & spikes.dataVar2==trial_var2 & spikes.datarep==j);
            spikes.datatrial=[spikes.datatrial,ones(1,length(tagger))*both_trial];
        end
        variable_counter=variable_counter+1;
    end
end

%%Found the problem; Var1_pres_order is not specific to one data structure,
%%it encompasses both loom and static trials
    
% elseif  spikes.inter_loom %inter loom data
%     for j=1:(spikes.reps) %For each rep
%         for k=1:trials_per_rep; %For each trial
%             
%             %find the next variables for this rep
%             trial_var1=spikes.Var1_pres_order(variable_counter); %find Var1 value
%             trial_var2=spikes.Var2_pres_order(variable_counter); %find Var2 value
%             if spikes.Inter_loom_store(variable_counter) %if this was a looming trial
%              
%                 tagger = find (spikes_loom.dataVar1==trial_var1 & spikes_loom.dataVar2==trial_var2 & spikes_loom.datarep==j);
%                 spikes_loom.datatrial=[spikes_loom.datatrial,ones(1,length(tagger))*k];
% 
%             else
%             %find all spikes from this rep with this Var1 and Var2 combination
%             tagger = find(spikes.dataVar1==trial_var1 & spikes.dataVar2==trial_var2 & spikes.datarep==j);
%             spikes.datatrial=[spikes.datatrial,ones(1,length(tagger))*k];
%             end
%             variable_counter=variable_counter+1;
%             
%         end
%     end
%     

else %no interleaves
    for j=1:(spikes.reps) %For each rep
        for k=1:trials_per_rep; %For each trial
            
            %find the next variables for this rep
            trial_var1=spikes.Var1_pres_order(variable_counter); %find Var1 value
            trial_var2=spikes.Var2_pres_order(variable_counter); %find Var2 value
            %find all spikes from this rep with this Var1 and Var2 combination
            tagger = find(spikes.dataVar1==trial_var1 & spikes.dataVar2==trial_var2 & spikes.datarep==j);
            spikes.datatrial=[spikes.datatrial,ones(1,length(tagger))*k];
            variable_counter=variable_counter+1;
        end
    end
end

end

 

