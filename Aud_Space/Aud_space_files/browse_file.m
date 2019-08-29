function browse_file()
    global snd;
    [snd.filename snd.path]=uiputfile('*.*');
    set(findobj(get(gco,'parent'),'tag','path'),'string',snd.path);
    set(findobj(get(gco,'parent'),'tag','file'),'string',snd.filename);
return;
    