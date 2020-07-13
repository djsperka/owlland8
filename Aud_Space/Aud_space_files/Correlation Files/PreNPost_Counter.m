function spikes=PreNPost_Counter (spikes)
% This function wipes the pre and post arrays, then re-calculates
% them. Designed for use with S2_Converter DJT 7/1/2013

%% Initialize arrays
spikes.datamat_pre=NaN(length(spikes.Var2array),length(spikes.Var1array),max(spikes.datachan));
spikes.datamat_post=spikes.datamat_pre;

if exist('spikes.inter_loom')
if spikes.inter_loom
    spikes.data_arr1_pre=spikes.datamat_pre;
    spikes.data_arr1_post=spikes.datamat_pre;
end
elseif spikes.interleave_alone
    spikes.data_arr1_pre=spikes.datamat_pre;
    spikes.data_arr2_pre=spikes.datamat_pre;
    spikes.data_arr1_post=spikes.datamat_pre;
    spikes.data_arr2_post=spikes.datamat_pre;
end

%% Populate arrays
for chan=1:max(spikes.datachan)
    v1_count=0;
    for var1=spikes.Var1array
        v1_count=v1_count+1;
        v2_count=0;
        
        for var2=spikes.Var2array
            v2_count=v2_count+1;
            pre_tag=length(find(spikes.datachan==chan & spikes.dataVar1==var1 & spikes.dataVar2==var2 & spikes.datatime<0));
            spikes.datamat_pre(v2_count,v1_count,chan)=pre_tag;
            post_tag=length(find(spikes.datachan==chan & spikes.dataVar1==var1 & spikes.dataVar2==var2 & spikes.datatime>0 & spikes.datatime<spikes.post));
            spikes.datamat_post(v2_count,v1_count,chan)=post_tag;
        end
    end
end

if exist('spikes.inter_loom')
if spikes.inter_loom
    for chan=1:max(spikes.datachan_arr1)
        v1_count=0;
        for var1=spikes.Var1array
            v1_count=v1_count+1;
            v2_count=0;
            for var2=spikes.Var2array
                v2_count=v2_count+1;
                pre_tag=length(find(spikes.datachan_arr1==chan & spikes.dataVar1_arr1==var1 & spikes.dataVar2_arr1==var2 & spikes.datatime_arr1<0));
                spikes.data_arr1_pre(v2_count,v1_count,chan)=pre_tag;
                post_tag=length(find(spikes.datachan_arr1==chan & spikes.dataVar1_arr1==var1 & spikes.dataVar2_arr1==var2 & spikes.datatime_arr1>0 & spikes.datatime_arr1<spikes.post));
                spikes.data_arr1_post(v2_count,v1_count,chan)=post_tag;
            end
        end
    end
end
end

if spikes.interleave_alone
for chan=1:max(spikes.datachan_arr1)
        v1_count=0;
        for var1=spikes.Var1array
            v1_count=v1_count+1;
            
            pre_tag=length(find(spikes.datachan_arr1==chan & spikes.dataVar1_arr1==var1 & spikes.datatime_arr1<0));
            spikes.data_arr1_pre(v2_count,v1_count,chan)=pre_tag;
            post_tag=length(find(spikes.datachan_arr1==chan & spikes.dataVar1_arr1==var1 & spikes.datatime_arr1>0 & spikes.datatime_arr1<spikes.post));
            spikes.data_arr1_post(v2_count,v1_count,chan)=post_tag;
        end
        v2_count=0;
        for var2=spikes.Var2array
            v2_count=v2_count+1;
            pre_tag=length(find(spikes.datachan_arr2==chan & spikes.dataVar2_arr2==var2 & spikes.datatime_arr2<0));
            spikes.data_arr2_pre(v2_count,v1_count,chan)=pre_tag;
            post_tag=length(find(spikes.datachan_arr2==chan & spikes.dataVar2_arr2==var2 & spikes.datatime_arr2>0 & spikes.datatime_arr2<spikes.post));
            spikes.data_arr2_post(v2_count,v1_count,chan)=post_tag;
        end
end
end


 