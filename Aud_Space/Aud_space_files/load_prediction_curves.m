function load_prediction_curves()
    global cont
    
    cont.time=(cont.az_max-cont.az_min)*2;
    cont.reps=2;
    cont.motion_type=2;
    cont.isi=30;
    cont.startpause=15;

    
    
    p_aud=get(findobj('tag','aud'),'value');
    p_vis=get(findobj('tag','vis'),'value');
    p_bim=get(findobj('tag','bim'),'value');
    dir=get(findobj('tag','pred_dir'),'value');
    
    hzlist=zeros(1,5);
    hzlist(1)=get(findobj('tag','hz1'),'value');
    hzlist(2)=get(findobj('tag','hz2'),'value');
    hzlist(3)=get(findobj('tag','hz4'),'value');
    hzlist(4)=get(findobj('tag','hz8'),'value');
    hzlist(5)=get(findobj('tag','hz16'),'value');
    close
    if findstr(cont.filename,'_cont')
        cont.filename=cont.filename(1:findstr(cont.filename,'_cont')+4);
        cont.filename=[cont.filename,'_p'];
    end

    
    if p_aud    %%if present aud alone
        cont.present_aud=1;
        cont.present_vis=0;

        for i=[0:4]
            if hzlist(i+1)
                if or(dir==1,dir==3)    %%right or both
                    cont.dir=1;
                    cont.noise_hz=(2^(i+1));
                    figure(findobj(0,'tag','set_cont_win'));     %% set control window as active
                    add_cont_cb;
                end
                if or(dir==2,dir==3)    %%left or both
                    cont.dir=2;    
                    cont.noise_hz=(2^(i+1));
                    figure(findobj(0,'tag','set_cont_win'));     %% set control window as active
                    add_cont_cb;
                end
            end
        end
    end
    
    if p_vis    %%if present vis alone
        cont.present_aud=0;
        cont.present_vis=1;
        for i=[0:4]
            if hzlist(i+1)
                if or(dir==1,dir==3)    %%right or both
                    cont.dir=1;
                    cont.noise_hz=(2^(i+1));
                    figure(findobj(0,'tag','set_cont_win'));     %% set control window as active
                    add_cont_cb;
                end
                if or(dir==2,dir==3)    %%left or both
                    cont.dir=2;    
                    cont.noise_hz=(2^(i+1));
                    figure(findobj(0,'tag','set_cont_win'));     %% set control window as active
                    add_cont_cb;
                end
            end
        end
    end
    
    if p_bim    %%if present bimodal
        cont.present_aud=1;
        cont.present_vis=1;
        for i=[0:4]
            if hzlist(i+1)
                if or(dir==1,dir==3)    %%right or both
                    cont.dir=1;
                    cont.noise_hz=(2^(i+1));
                    figure(findobj(0,'tag','set_cont_win'));     %% set control window as active
                    add_cont_cb;
                end
                if or(dir==2,dir==3)    %%left or both
                    cont.dir=2;    
                    cont.noise_hz=(2^(i+1));
                    figure(findobj(0,'tag','set_cont_win'));     %% set control window as active
                    add_cont_cb;
                end
            end
        end
    end
    update_cont_window
    return;
    
    