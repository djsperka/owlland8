function Update_Set_EucDistance()
global snd wap_on wag_on

snd.ba_cutoff=str2double(get(findobj(gcf,'tag','cut'),'string'));
wap_on=get(findobj(gcf,'tag','wap_on'),'value');
wag_on=get(findobj(gcf,'tag','wag_on'),'value');
% maxlag=str2double(get(findobj(gcf,'tag','mlag'),'string'));
% full_var=get(findobj(gcf,'tag','full_var'),'value');
