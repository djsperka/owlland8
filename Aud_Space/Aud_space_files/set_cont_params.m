function set_cont_params()
    global cont
    figure(findobj(0,'tag','set_cont_win'));     %% set the third window as active

    cont.az_min=str2num(get(findobj(gcf,'tag','az_min'),'string'));
    cont.az_max=str2num(get(findobj(gcf,'tag','az_max'),'string'));
    cont.ITD_min=str2num(get(findobj(gcf,'tag','ITD_min'),'string'));
    cont.ITD_max=str2num(get(findobj(gcf,'tag','ITD_max'),'string'));
    cont.ILD=str2num(get(findobj(gcf,'tag','ILD'),'string'));
    cont.vis_el=str2num(get(findobj(gcf,'tag','vis_el'),'string'));
    cont.fore=str2num(get(findobj(gcf,'tag','fore'),'string'));
    cont.back=str2num(get(findobj(gcf,'tag','back'),'string'));
    cont.time=str2num(get(findobj(gcf,'tag','time'),'string'));
    cont.vis_radius_v=str2num(get(findobj(gcf,'tag','vis_radius_v'),'string'));
    cont.vis_radius_h=str2num(get(findobj(gcf,'tag','vis_radius_h'),'string'));
    cont.noise_hz=str2num(get(findobj(gcf,'tag','noise_hz'),'string'));
    cont.ITD_offset=str2num(get(findobj(gcf,'tag','ITD_offset'),'string'));
    cont.reps=str2num(get(findobj(gcf,'tag','reps'),'string'));
    cont.startpause=str2num(get(findobj(gcf,'tag','startpause'),'string'));
    cont.isi=str2num(get(findobj(gcf,'tag','isi'),'string'));
    cont.abi=str2num(get(findobj(gcf,'tag','abi'),'string'));
    cont.rise=str2num(get(findobj(gcf,'tag','rise'),'string'));
    cont.filename=get(findobj(gcf,'tag','filename'),'string');

    
    
    cont.save_snips=get(findobj(gcf,'tag','save_snips'), 'value');
    cont.present_aud=get(findobj(gcf,'tag','present_aud'), 'value');    
    cont.present_vis=get(findobj(gcf,'tag','present_vis'), 'value');    
    cont.motion_type=get(findobj(gcf,'tag','motion_type'), 'value');    
    cont.correlated=get(findobj(gcf,'tag','correlated'), 'value');    
    cont.dir=get(findobj(gcf,'tag','dir'), 'value');    
return;

   