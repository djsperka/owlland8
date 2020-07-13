function spikes=Select_Time_Window (spikes, TWin)

WinTags = find(spikes.datatime>TWin(1) & spikes.datatime<TWin(2)); %Tag spikes in that time window
spikes.datachan=spikes.datachan(WinTags);
spikes.datatime=spikes.datatime(WinTags);
% spikes.datatrial=spikes.datatrial(WinTags);
spikes.datarep=spikes.datarep(WinTags);
spikes.dataVar1=spikes.dataVar1(WinTags);
spikes.dataVar2=spikes.dataVar2(WinTags);

if spikes.interleave_alone
    
    WinTag1=find(spikes.datatime_arr1>TWin(1) & spikes.datatime_arr1<TWin(2));
    spikes.datachan_arr1=spikes.datachan_arr1(WinTag1);
    spikes.datatime_arr1=spikes.datatime_arr1(WinTag1);
%     spikes.datatrial_arr1=spikes.datatrial_arr1(WinTag1);
    spikes.datarep_arr1=spikes.datarep_arr1(WinTag1);
    spikes.dataVar1_arr1=spikes.dataVar1_arr1(WinTag1);
    
    WinTag2=find(spikes.datatime_arr2>TWin(1) & spikes.datatime_arr2<TWin(2));
    spikes.datachan_arr2=spikes.datachan_arr2(WinTag2);
    spikes.datatime_arr2=spikes.datatime_arr2(WinTag2);
%     spikes.datatrial_arr2=spikes.datatrial_arr2(WinTag2);
    spikes.datarep_arr2=spikes.datarep_arr2(WinTag2);
    spikes.dataVar2_arr2=spikes.dataVar2_arr2(WinTag2);
    
end

end
