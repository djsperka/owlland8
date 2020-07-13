function Pop_Anal_Unpaired_TTest (handles)
% runs with Pop_Anal_GUI_competition 
% Loop through the Pop_Analaysis_Run_Competition script twice for its data
% selection utility, bailing each time before any actual analysis.  
global  criteria_handles stopper

criteria_handles=handles;

set (handles.UTT_running,'String','YES');
v1=get(handles.comp_cond_1,'Value');
v2=get(handles.comp_cond_2,'Value');

temp_rrc_vwi=get(handles.rrc_vwi,'Value'); %Vw.I>0
temp_rrc_vwo=get(handles.rrc_vwo,'Value'); %Vw.O~>0
temp_rrc_vwi_vwo=get(handles.rrc_vwi_and_vwo,'Value'); %Vw.I>Vw.O
temp_rrc_ai=get(handles.rrc_ai,'Value'); %A.I>0
temp_rrc_ao=get(handles.rrc_ao,'Value'); %A.O~>0
temp_rrc_as=get (handles.rrc_as,'Value'); %A.S~>0

set(handles.comp2,'Value',1)

%% Get Population Data
set(handles.comp_cond_2,'Value',v1);
stopper=1;
while stopper==1;
UTT_Criteria_GUI
end
close
[pop1,mt_labels1,measurement]=Pop_Analysis_Run_Competition(handles);

set(handles.comp_cond_1,'Value',v2);
set(handles.comp_cond_2,'Value',v2);
stopper=1;
while stopper==1;
UTT_Criteria_GUI
end
close
[pop2,mt_labels2,~]=Pop_Analysis_Run_Competition(handles);

mt_labels{1}=mt_labels1{1};
mt_labels{2}=mt_labels2{1};

%% Return Settings
set(handles.comp_cond_1,'Value',v1);
set(handles.comp_cond_2,'Value',v2);
set(handles.UTT_running,'String','NO');

set(handles.rrc_vwi,'Value',temp_rrc_vwi); %Vw.I>0
set(handles.rrc_vwo,'Value',temp_rrc_vwo); %Vw.O~>0
set(handles.rrc_vwi_and_vwo,'Value',temp_rrc_vwi_vwo); %Vw.I>Vw.O
set(handles.rrc_ai,'Value',temp_rrc_ai); %A.I>0
set(handles.rrc_ao,'Value',temp_rrc_ao); %A.O~>0
set (handles.rrc_as,'Value',temp_rrc_as); %A.S~>0

%% Perform Stats and Make Plots
figure
[h1,x1]=hist(pop1(:,1));
w1=(max(pop1(:,1))-min(pop1(:,1)))/10;
[h2,x2]=hist(pop2(:,1));
w2=(max(pop2(:,2))-min(pop2(:,2)))/10;
h1=h1/sum(h1); %scale to make percentages
h2=h2/sum(h2);

b1=bar(x1,h1,1);
set(b1,'EdgeColor','w')
hold on

m1=mean(pop1(:,1));
plot([m1,m1],[0,max([h1,h2])+.1],':b','LineWidth',2)

b2=bar(x2,h2,1);
ch2=get(b2,'child');
set(ch2,'facea',0)
set(b2,'EdgeColor','r')
set(b2,'FaceColor','w')
set(b2,'LineWidth',2)

m2=mean(pop2(:,1));
plot([m2,m2],[0,max([h1,h2])+.1],':r','LineWidth',2)

title (sprintf('Unpaired %s vs %s for %s',mt_labels{1},mt_labels{2},measurement))
xlabel(sprintf('%s',measurement))
ylabel('Percent in Bin')

[~,p]=ttest2(pop1(:,1),pop2(:,1));
legtxt{1}=sprintf('%s n=%.0f',mt_labels{1},size(pop1,1));
legtxt{2}=sprintf('%s mean=%.2f',mt_labels{1},m1);
legtxt{3}=sprintf('%s n=%.0f',mt_labels{2},size(pop2,1));
legtxt{4}=sprintf('%s mean=%.2f\np(%s==%s)=%.4f',mt_labels{2},m2,mt_labels{1},mt_labels{2},p);
legend(legtxt)