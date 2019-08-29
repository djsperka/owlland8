function browse_file_cont()
    global cont;
    [cont.filename cont.path]=uiputfile('*.*');
    set(findobj(get(gco,'parent'),'tag','path'),'string',cont.path);
    set(findobj(get(gco,'parent'),'tag','file'),'string',cont.filename);
return;
    