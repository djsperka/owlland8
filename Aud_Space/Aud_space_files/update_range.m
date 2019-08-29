function update_range
    global snd;
    snd.rangemax=str2num(get(findobj(gcf,'tag','rangemax'),'string'));
    snd.rangemin=str2num(get(findobj(gcf,'tag','rangemin'),'string'));
    set_range_window;
return