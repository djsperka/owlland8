function save_defaults()
    global snd rec;
    %%delete the visual stuff
    if isfield(snd,'screen_pos')
        snd=rmfield(snd,'screen_pos');
        snd=rmfield(snd,'deg');
        snd=rmfield(snd,'psychpixels');
        snd=rmfield(snd,'origin');
        snd=rmfield(snd,'screendistance');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
% % % %     snd.controlwindow=2;
% % % %     snd.runmode=1;
% % % %     snd.rig_room=1;
    uisave; %%save snd and rec to a default file
return
    