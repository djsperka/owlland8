function load_snips()
    global multsnip
    [filename path]=uiputfile('*.*');
    set(findobj(get(gco,'parent'),'tag','path'),'string',path);
    set(findobj(get(gco,'parent'),'tag','file'),'string',filename);

    load([path,filename])
    
return
    
    
    