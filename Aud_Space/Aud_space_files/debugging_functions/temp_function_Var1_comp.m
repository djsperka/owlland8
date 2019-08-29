%these lines will let you take the snd.dataVar1 and put it in order that
%the variables were played for comparison to snd.Var1_pres_order

dataVar1=[];
currentVar1=nan;
for i=1:length(snd.dataVar1)
%  snd.dataVar1(i)
if snd.dataVar1(i)~=currentVar1;
    currentVar1=snd.dataVar1(i);
    dataVar1=[dataVar1,currentVar1];
end
end