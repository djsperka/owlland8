function set_cont_defaults()
    global cont snd rec
    
    
    if ~isstruct(snd)
        JoeSoundDefault
    end
    if ~isstruct(rec)
        AS_rec_defaults
    end
    
    %%%  import values from snd to cont variable
    if isfield(snd,'runmode')
        cont.runmode=snd.runmode;
    else
        cont.runmode=0;
    end
    cont.ITD_min=snd.test_param_matrix(1,1,1);
    cont.ITD_max=snd.test_param_matrix(1,1,2);
    cont.az_min=snd.test_param_matrix(1,8,1);
    cont.az_max=snd.test_param_matrix(1,8,2);   
    cont.vis_el=snd.el;
    cont.ILD=snd.ild1;
    cont.fore=snd.foreground;
    cont.back=snd.background;
    cont.abi=snd.abi1;
    cont.present_aud=1;
    cont.present_vis=1;
    cont.motion_type_array={'Noise', 'Single sweep'};
    cont.motion_type=2; %%1= rand selected
    cont.correlated=0;  %%1 = correlated aud and vis
    cont.vis_radius_v=1;  %% radius of the visual stimulus
    cont.vis_radius_h=1;  %% radius of the visual stimulus
    cont.amplitude=1.5;  %% radius of the visual stimulus
    cont.ITD_offset=0;  %% radius of the visual stimulus
    cont.reps=1;    %%number of times to repeat the stimulus
    cont.dir=1;    %%direction of motion when applicable
    cont.isi=1;     %%number of seconds between each stim rep
    cont.startpause=5;  %%number of seconds after screen blanking before presentation of stimuli
    cont.save_snips=0;       %%logical for deciding whether to save snips
    cont.snip_filename='none';   %%names where snips are saved
    cont.rise=snd.rise;     %%rise time for stimuli
    
    cont.path=snd.path;
    cont.filename=[snd.filename,'_cont'];
    if findstr(snd.filename,'.')
        h=findstr(snd.filename,'.');
        cont.filename=[snd.filename(1:h(1)-1),'_cont.mat'];
    end
    
    cont.error_flag=[];  %%flag to note is there has been an error 
    cont.trace=0;
    cont.noise_hz=10;  %% sampling rate for stimuli 
    cont.time=1;  %%      time of stimuli in seconds
    
    
    
    %%%data/stimulus structures;
    cont.vis_pos_array={};
    cont.ITD_pos={};
    cont.spike_times={};
    %%%%%

    

    return;
    