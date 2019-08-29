function update_timecourse()
    % gets called when someone types a new start/end time into the
    % make_course window.  it just updates the time (x) axis on display.
		time_start=str2num(get(findobj(gcf,'tag','time_start'),'string'));
		time_end=str2num(get(findobj(gcf,'tag','time_end'),'string'));
		set(gca,'XLimMode','manual','XLim',[time_start,time_end]);  

return;
