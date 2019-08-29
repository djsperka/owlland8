function set_other_params()
    global snd
    snd.screenblank=(2-get(findobj(gcf,'tag','screenblank'),'value'));
    snd.startpause=str2num(get(findobj(gcf,'tag','startpause'),'string'));
    snd.pause_return=str2num(get(findobj(gcf,'tag','pause_return'),'string'));
    
return