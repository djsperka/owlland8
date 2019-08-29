function Update_Set_WA_map()
global snd wap_on wag_on %wa_map_trace

snd.ba_cutoff=str2double(get(findobj(gcf,'tag','cut'),'string'));
wap_on=get(findobj(gcf,'tag','wap_on'),'value');
wag_on=get(findobj(gcf,'tag','wag_on'),'value');
% wa_map_trace=str2double(get(findobj(gcf,'tag','trace'),'string'));
% maxlag=str2double(get(findobj(gcf,'tag','mlag'),'string'));
% full_var=get(findobj(gcf,'tag','full_var'),'value');
