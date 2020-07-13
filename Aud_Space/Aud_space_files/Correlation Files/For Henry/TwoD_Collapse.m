function [spikes]=TwoD_Collapse (spikes, Var2Range)
%Select a variable range for the second dimension and collapse around that
%range

%% Constrain around 1 dimension
VarTag2=find(spikes.dataVar2>=Var2Range(1) & spikes.dataVar2<=Var2Range(2));
spikes.datachan=spikes.datachan(VarTag2);
spikes.datatime=spikes.datatime(VarTag2);
spikes.datarep=spikes.datarep(VarTag2);
spikes.dataVar1=spikes.dataVar1(VarTag2);
spikes.dataVar2=spikes.dataVar2(VarTag2);
spikes.Var2array=spikes.Var2array(spikes.Var2array>=Var2Range(1) & spikes.Var2array<=Var2Range(2));

%re-assign Var1_pres_order and Var2_pres_order
var2_tagger= spikes.Var2_pres_order>=Var2Range(1) & spikes.Var2_pres_order<=Var2Range(2);
spikes.Var1_pres_order=spikes.Var1_pres_order(var2_tagger);
spikes.Var2_pres_order=spikes.Var2_pres_order(var2_tagger);

if spikes.interleave_alone
    %repeat for arr1_ and arr2_ structures
    found_arr2=find(spikes.dataVar2_arr2>=Var2Range(1) & spikes.dataVar2.arr2<=Var2Range(2));
    spikes.datachan_arr2=spikes.datachan_arr2(found_arr2);
    spikes.datatime_arr2=spikes.datatime_arr2(found_arr2);
    spikes.datarep_arr2=spikes.datarep_arr2(found_arr2);
    %     spikes.dataVar1_arr2=spikes.dataVar1_arr2(found_arr2); %used in Raster
    spikes.dataVar2_arr2=spikes.dataVar2_arr2(found_arr2);
end

% if spikes.inter_loom
%     %repeat for arr1_ structures
%     found_arr1=find(spikes.dataVar2_arr1>=Var2Range(1) & spikes.dataVar2_arr1<=Var2Range(2));
%     spikes.datachan_arr1=spikes.datachan_arr1(found_arr1);
%     spikes.datatime_arr1=spikes.datatime_arr1(found_arr1);
%     spikes.datarep_arr1=spikes.datarep_arr1(found_arr1);
%     spikes.dataVar1_arr1=spikes.dataVar1_arr1(found_arr1); %used in Raster
%     spikes.dataVar2_arr1=spikes.dataVar2_arr1(found_arr1);
% end

end
