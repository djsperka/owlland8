function Update_Set_Spikecorr
global fs maxlag full_var full_time
fs=1/str2double(get(findobj(gcf,'tag','freq'),'string'));
maxlag=str2double(get(findobj(gcf,'tag','mlag'),'string'));
full_var=get(findobj(gcf,'tag','full_var'),'value');
full_time=get(findobj(gcf,'tag','full_time'),'value');

'';