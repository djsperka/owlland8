function load_seg_curves()
    global cont

    max=str2num(get(findobj('tag','max'),'string'));
    min=str2num(get(findobj('tag','min'),'string'));

    step=str2num(get(findobj('tag','step'),'string'));
    speed=str2num(get(findobj('tag','speed'),'string'));
    size=str2num(get(findobj('tag','size'),'string'));
    
    p_aud=get(findobj('tag','aud'),'value');
    p_vis=get(findobj('tag','vis'),'value');
    p_bim=get(findobj('tag','bim'),'value');

    dir=get(findobj('tag','pred_dir'),'value');

    close;
    
    cont.noise_hz=1;
    cont.time=size/speed;
    cont.isi=1;
    cont.reps=15;  %%CHANGE SO IT"S USER CONTROLED
    if findstr(cont.filename,'_cont')
        cont.filename=cont.filename(1:findstr(cont.filename,'_cont')+4);
        cont.filename=[cont.filename,'_s'];
        figure(findobj(0,'tag','set_cont_win'));     %% set control window as active
        set(findobj(gcf,'tag','filename'),'string',cont.filename);
    end
    
    if p_aud    %%if present aud alone
        cont.present_aud=1;
        cont.present_vis=0;
        if dir==1 | dir ==3
           cont.dir=1;    
           for middle=min:step:max
                cont.ITD_min = (middle-size/2)*2.5;
                cont.ITD_max = (middle+size/2)*2.5;
                figure(findobj(0,'tag','set_cont_win'));     %% set control window as active
                add_cont_cb;           
           end
       end
       if dir==2 | dir==3
           cont.dir=2
           for middle=min:step:max
                cont.ITD_min = (middle-size/2)*2.5;
                cont.ITD_max = (middle+size/2)*2.5;
                figure(findobj(0,'tag','set_cont_win'));     %% set control window as active
                add_cont_cb;
           end
       end
    end
    
    if p_vis    %%if present vis alone
        cont.present_aud=0;
        cont.present_vis=1;
        if dir==1 | dir ==3
           cont.dir=1;    
           for middle=min:step:max
                cont.az_min = (middle-size/2);
                cont.az_max = (middle+size/2);
                figure(findobj(0,'tag','set_cont_win'));     %% set control window as active
                add_cont_cb;           
           end
       end
       if dir==2 | dir==3
           cont.dir=2
           for middle=min:step:max
                cont.az_min = (middle-size/2);
                cont.az_max = (middle+size/2);
                figure(findobj(0,'tag','set_cont_win'));     %% set control window as active
                add_cont_cb;
           end
       end
    end
 
   if p_bim    %%if present bim
        cont.present_aud=1;
        cont.present_vis=1;
        if dir==1 | dir ==3
           cont.dir=1;    
           for middle=min:step:max
                cont.az_min = (middle-size/2);
                cont.az_max = (middle+size/2);
                cont.ITD_min = (middle-size/2)*2.5;
                cont.ITD_max = (middle+size/2)*2.5;
                figure(findobj(0,'tag','set_cont_win'));     %% set control window as active
                add_cont_cb;           
           end
       end
       if dir==2 | dir==3
           cont.dir=2
           for middle=min:step:max
                cont.az_min = (middle-size/2);
                cont.az_max = (middle+size/2);                
                cont.ITD_min = (middle-size/2)*2.5;
                cont.ITD_max = (middle+size/2)*2.5;
                figure(findobj(0,'tag','set_cont_win'));     %% set control window as active
                add_cont_cb;
           end
       end
    end
    update_cont_window
return;
