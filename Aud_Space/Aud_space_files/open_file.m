function open_file()
     global snd rec;

    [filename path]=uiputfile('*.*');
    set(findobj(get(gco,'parent'),'tag','path'),'string',path);
    set(findobj(get(gco,'parent'),'tag','file'),'string',filename);
    
    if length(filename)>=1
		get_trace(1,filename,path)     %%open the first trace          
		set_disp_params
		update_control_window
    end
    
    
return;