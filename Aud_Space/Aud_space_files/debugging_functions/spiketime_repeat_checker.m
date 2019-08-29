function spiketime_repeat_checker
%made this to check for raster repeating
%for whatever trace you are on, this function will 
global snd

counter=0;
repeat_trial=[];
repeat_rep=[];
for rep=1:max(snd.datarep);
    for i=1:(max(snd.datatrial)-1);
%         for j=(i+1);max(snd.datatrial);
        j=i+1;
        t1=snd.datatime(snd.datatrial==i & snd.datarep==rep);
        t2=snd.datatime(snd.datatrial==j & snd.datarep==rep);
        if ~isempty(t1) && ~isempty(t2)
            if ~isnan(max(t1)) && isequaln(t1,t2) %isequaln compares two arrays containing NaN values
                counter=counter+1;
                repeat_trial=[repeat_trial,i];
                repeat_rep=[repeat_rep,rep];
%                 snd.dataVar1(snd.datatrial==i & snd.datarep==rep)
%                 snd.dataVar1(snd.datatrial==j & snd.datarep==rep)
            end
        end
            
%         end
    end
end

repeat_trial
repeat_rep

length(repeat_trial)