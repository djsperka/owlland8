function spikes=Chan_Selector (spikes, chan)
% rebuild arrays so they ONLY contain spikes from the channels you have
% selected

chan_builder=[];
for i= 1:length(chan)
    found=find(spikes.datachan==chan(i));
    chan_builder=[chan_builder,found];
end
sorted_chan=sort(chan_builder);
spikes.datachan=spikes.datachan(sorted_chan);
spikes.datatime=spikes.datatime(sorted_chan);
spikes.datarep=spikes.datarep(sorted_chan);
spikes.dataVar1=spikes.dataVar1(sorted_chan); %used in Raster
spikes.dataVar2=spikes.dataVar2(sorted_chan);

if spikes.interleave_alone
    %repeat for arr1_ and arr2_ structures
    chan_builder_arr1=[];
    chan_builder_arr2=[];
    for i=1:length(chan)
        found_arr1=find(spikes.datachan_arr1==chan(i));
        chan_builder_arr1=[chan_builder_arr1,found_arr1];
        found_arr2=find(spikes.datachan_arr2==chan(i));
        chan_builder_arr2=[chan_builder_arr2,found_arr2];
    end
    sorted_chan_arr1=sort(chan_builder_arr1);
    spikes.datachan_arr1=spikes.datachan_arr1(sorted_chan_arr1);
    spikes.datatime_arr1=spikes.datatime_arr1(sorted_chan_arr1);
    spikes.datarep_arr1=spikes.datarep_arr1(sorted_chan_arr1);
    spikes.dataVar1_arr1=spikes.dataVar1_arr1(sorted_chan_arr1); %used in Raster
%     spikes.dataVar2_arr1=spikes.dataVar2_arr1(sorted_chan_arr1);
    
    sorted_chan_arr2=sort(chan_builder_arr2);
    spikes.datachan_arr2=spikes.datachan_arr2(sorted_chan_arr2);
    spikes.datatime_arr2=spikes.datatime_arr2(sorted_chan_arr2);
    spikes.datarep_arr2=spikes.datarep_arr2(sorted_chan_arr2);
%     spikes.dataVar1_arr2=spikes.dataVar1_arr2(sorted_chan_arr2); %used in Raster
    spikes.dataVar2_arr2=spikes.dataVar2_arr2(sorted_chan_arr2);
end
% if spikes.inter_loom
%      %repeat for arr1_ structures
%     chan_builder_arr1=[];
%     for i=1:length(chan)
%         found_arr1=find(spikes.datachan_arr1==chan(i));
%         chan_builder_arr1=[chan_builder_arr1,found_arr1];
%     end
%     sorted_chan_arr1=sort(chan_builder_arr1);
%     spikes.datachan_arr1=spikes.datachan_arr1(sorted_chan_arr1);
%     spikes.datatime_arr1=spikes.datatime_arr1(sorted_chan_arr1);
%     spikes.datarep_arr1=spikes.datarep_arr1(sorted_chan_arr1);
%     spikes.dataVar1_arr1=spikes.dataVar1_arr1(sorted_chan_arr1); %used in Raster
%     spikes.dataVar2_arr1=spikes.dataVar2_arr1(sorted_chan_arr1);
% end
end