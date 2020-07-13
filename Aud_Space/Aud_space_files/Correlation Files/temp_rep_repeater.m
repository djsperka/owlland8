rep1=find(snd.datarep==1);
datachan=snd.datachan(rep1);
datatime=snd.datatime(rep1);
datarep=snd.datarep(rep1);
datavar1=snd.dataVar1(rep1);
datavar2=snd.dataVar2(rep1);

trials_per_rep=length(snd.Var1array)*length(snd.Var2array)*2;
Var1_pres_order=snd.Var1_pres_order(1:trials_per_rep);
Var2_pres_order=snd.Var2_pres_order(1:trials_per_rep);

for i=2:snd.reps
    datachan=[datachan,snd.datachan(rep1)];
    datatime=[datatime,snd.datatime(rep1)];
    datarep=[datarep,i*ones(size(snd.datarep(rep1)))];
    datavar1=[datavar1,snd.dataVar1(rep1)];
    datavar2=[datavar2,snd.dataVar2(rep1)];
    
    Var1_pres_order=[Var1_pres_order,snd.Var1_pres_order(1:trials_per_rep)];
    Var2_pres_order=[Var2_pres_order,snd.Var2_pres_order(1:trials_per_rep)];
end

length(rep1)*13

snd.datachan=datachan;
snd.datatime=datatime;
snd.datarep=datarep;
snd.dataVar1=datavar1;
snd.dataVar2=datavar2;
snd.Var1_pres_order=Var1_pres_order;
snd.Var2_pres_order=Var2_pres_order;