rep1arr1=find(snd.datarep_arr1==1);
datachan_arr1=snd.datachan_arr1(rep1arr1);
datatime_arr1=snd.datatime_arr1(rep1arr1);
datarep_arr1=snd.datarep_arr1(rep1arr1);
datavar1_arr1=snd.dataVar1_arr1(rep1arr1);
datavar2_arr1=snd.dataVar2_arr1(rep1arr1);

trials_per_rep=length(snd.Var1array)*length(snd.Var2array)*2;
Inter_loom_store=snd.Inter_loom_store(1:trials_per_rep);

for i=2:snd.reps
    datachan_arr1=[datachan_arr1,snd.datachan_arr1(rep1arr1)];
    datatime_arr1=[datatime_arr1,snd.datatime_arr1(rep1arr1)];
    datarep_arr1=[datarep_arr1,i*ones(size(snd.datarep_arr1(rep1arr1)))];
    datavar1_arr1=[datavar1_arr1,snd.dataVar1_arr1(rep1arr1)];
    datavar2_arr1=[datavar2_arr1,snd.dataVar2_arr1(rep1arr1)];
    
    Inter_loom_store=[Inter_loom_store,snd.Inter_loom_store(1:trials_per_rep)];
end

length(rep1arr1)*13

snd.datachan_arr1=datachan_arr1;
snd.datatime_arr1=datatime_arr1;
snd.datarep_arr1=datarep_arr1;
snd.dataVar1_arr1=datavar1_arr1;
snd.dataVar2_arr1=datavar2_arr1;
snd.Inter_loom_store=Inter_loom_store;