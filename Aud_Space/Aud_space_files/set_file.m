function set_file()
    global snd rec;
    
    snd.path=get(findobj(gcf,'tag','path'),'string');
    snd.filename=get(findobj(gcf,'tag','file'),'string');
return;
    
