function [post_mat,pre_mat]=PreNPost_NoiseCorr (spikes,chan)

for i=1:length(spikes.Var1array)
    var1=spikes.Var1array(i);
    for j=1:length(spikes.Var2array)
        var2=spikes.Var2array(j);
        for rep=1:spikes.reps
            find_post= spikes.dataVar1==var1 & spikes.dataVar2==var2 & spikes.datachan==chan & spikes.datarep==rep & spikes.datatime>0 & spikes.datatime<spikes.post;
            find_pre= spikes.dataVar1==var1 & spikes.dataVar2==var2 & spikes.datachan==chan & spikes.datarep==rep & spikes.datatime<0 & spikes.datatime>(spikes.pre*(-1));

                post_mat(rep,i,j)=sum(find_post);
                pre_mat (rep,i,j)=sum(find_pre);
                if sum(isnan(post_mat))
                    keyboard
                elseif sum(isnan(pre_mat))
                    keyboard
                end
            
        end
    end
end