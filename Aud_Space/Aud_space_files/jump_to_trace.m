function jump_to_trace()
    global snd

    snd.trace=str2num(get(findobj(gcf,'tag','Print_trace'),'string'));

    if snd.trace<=snd.maxtrace & snd.trace>0
        get_trace(snd.trace,snd.filename,snd.path)     %%open the first trace          
        set_disp_params        
        update_control_window
    end;
    
return;
    