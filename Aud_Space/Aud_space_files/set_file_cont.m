function set_file_cont()
    global cont rec;
    
    cont.path=get(findobj(gcf,'tag','path'),'string');
    cont.filename=get(findobj(gcf,'tag','file'),'string');
return;
    
