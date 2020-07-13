function data_dp=DotProduct_Run (data_matrix)
global chan_select 
chan_choices=find(chan_select==1);

num_chan=length(chan_select);
potential_pairs=num_chan*(num_chan-1)/2;
data_dp=NaN(potential_pairs,1);

%Normalize the matrix for each channel such that the dot product with
%itself equals 1.  For proof, see 8/27/13 notes DJT
norm_matrix=NaN(size(data_matrix));
for i=1:num_chan
    scale_factor=(sum(sum(dot(data_matrix(:,:,i),data_matrix(:,:,i)))))^.5;
    norm_matrix(:,:,i)=data_matrix(:,:,i)/scale_factor;
%     sum(dot(norm_matrix(:,:,i),norm_matrix(:,:,i))) %%% This line proves that
%     it always equals 1
end
    

for j=1:length(chan_choices); %for each channel
    chan1=chan_choices(j);
    for k=j+1:length(chan_choices); %for all channels this hasn't been paired with yet
        %% Build inputs
        chan2=chan_choices(k);
%         counter=counter+1;
        store_position=potential_pairs-((num_chan-chan1)*(num_chan-chan1-1)/2)-(num_chan-chan2);
        %(num_chan-chan1)*(num_chan-chan1-1)/2) = number of pairs left once
        %channel 1 is complete
        %num_chan - chan2) = number pairs left to complete filling out
        %channel 1 pairs
        norm_dp=sum(dot(norm_matrix(:,:,chan1),norm_matrix(:,:,chan2)));
        if isnan(norm_dp)
            fprintf('\nGettin a NaN for your dot product calculation.  Probably due to a NaN on the inputs, which will choke this function.  Check it yo\n')
            keyboard
        end
        data_dp(store_position)=norm_dp;
    end
end