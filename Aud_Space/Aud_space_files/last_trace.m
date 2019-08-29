function last_trace()
    global snd rec;
    if snd.trace<snd.maxtrace
        snd.trace=snd.maxtrace;
        get_trace(snd.trace,snd.filename,snd.path)     %%open the first trace          
        set_disp_params        
        update_control_window
    end;
return;