function spikes=Select_Variable_Range (spikes, Var1Range)
%Select data
VarTag=find(spikes.dataVar1>=Var1Range(1) & spikes.dataVar1<=Var1Range(2));
%Re-define arrays
spikes.datachan=spikes.datachan(VarTag);
spikes.datatime=spikes.datatime(VarTag);
% spikes.datatrial=spikes.datatrial(VarTag); REMOVED: gets generated later
spikes.datarep=spikes.datarep(VarTag);
spikes.dataVar1=spikes.dataVar1(VarTag);
spikes.dataVar2=spikes.dataVar2(VarTag);
spikes.Var1array=spikes.Var1array(spikes.Var1array>=Var1Range(1) & spikes.Var1array<=Var1Range(2));



%re-assign Var1_pres_order and Var2_pres_order
var1_tagger= find( spikes.Var1_pres_order>=Var1Range(1) & spikes.Var1_pres_order<=Var1Range(2));
if spikes.interleave_alone %account for NaNs in interleaved data
    fprintf ('\nStopping code in Select_Variable_Range to remind you to check exactly what is going on with this isnan dealio\n')
    keyboard
var1_tagger_NaNs=find(isnan(spikes.Var1_pres_order));
var1_tagger=[var1_tagger var1_tagger_NaNs];
var1_tagger=sort(var1_tagger);
end
spikes.Var1_pres_order=spikes.Var1_pres_order(var1_tagger);
spikes.Var2_pres_order=spikes.Var2_pres_order(var1_tagger);

%% If 2D interleaved
if spikes.interleave_alone
    Var1Tag=find(spikes.dataVar1_arr1>=Var1Range(1) & spikes.dataVar1_arr1<=Var1Range(2));
    spikes.datachan_arr1=spikes.datachan_arr1(Var1Tag);
    spikes.datatime_arr1=spikes.datatime_arr1(Var1Tag);
    spikes.datarep_arr1=spikes.datarep_arr1(Var1Tag);
    spikes.dataVar1_arr1=spikes.dataVar1_arr1(Var1Tag);
end

% %% If Interleaved looming stimuli
% if spikes.inter_loom
%     VarTag_arr1=find(spikes.dataVar1_arr1>=Var1Range(1) & spikes.dataVar1_arr1<=Var1Range(2));    
%     spikes.datachan_arr1=spikes.datachan_arr1(VarTag_arr1);
%     spikes.datatime_arr1=spikes.datatime_arr1(VarTag_arr1);
%     spikes.datarep_arr1=spikes.datarep_arr1(VarTag_arr1);
%     spikes.dataVar1_arr1=spikes.dataVar1_arr1(VarTag_arr1);
%     spikes.dataVar2_arr1=spikes.dataVar2_arr1(VarTag_arr1);
% end

end
