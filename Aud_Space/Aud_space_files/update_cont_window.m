function update_cont_window()
    global cont rec savecont
    figure(findobj(0,'tag','cont_disp_1'))
    clf
    figure(findobj(0,'tag','cont_disp_2'))
    clf
    figure(findobj(0,'tag','set_cont_win'));     %% set control window as active
    
% % %     cont.ITD_min
% % %     %%%fix for early ITD vis waves being made from each other
% % %     if length(cont.ITD_pos)
% % %         if length(cont.ITD_pos{1})
% % %             ITD_min=cont.ITD_min;
% % %             ITD_max=cont.ITD_max;
% % %             for i=1:cont.reps
% % %                ITD_min=min(ITD_min,min(cont.ITD_pos{1}));
% % %                ITD_max=max(ITD_min,min(cont.ITD_pos{1}));
% % %             end
% % %             if ITD_min<cont.ITD_min
% % %                 cont.ITD_min=floor(ITD_min);
% % %             end
% % %             if ITD_max>cont.ITD_max
% % %                 cont.ITD_max=ceil(ITD_max);
% % %             end
% % %         end
% % %     end
% % %     cont.ITD_min
% % %     %%%%%%%%%%%%%%%%%%%%%%%%
    
    
    set(findobj(gcf,'tag','az_min'),'string',cont.az_min);
    set(findobj(gcf,'tag','az_max'),'string',cont.az_max);
    set(findobj(gcf,'tag','ITD_min'),'string',cont.ITD_min);
    set(findobj(gcf,'tag','ITD_max'),'string',cont.ITD_max);
    set(findobj(gcf,'tag','ILD'),'string',cont.ILD);
    set(findobj(gcf,'tag','vis_el'),'string',cont.vis_el);
    set(findobj(gcf,'tag','fore'),'string',cont.fore);
    set(findobj(gcf,'tag','back'),'string',cont.back);
    set(findobj(gcf,'tag','abi'),'string',cont.abi);
    set(findobj(gcf,'tag','time'),'string',cont.time);
    set(findobj(gcf,'tag','vis_radius_v'),'string',cont.vis_radius_v);
    set(findobj(gcf,'tag','vis_radius_h'),'string',cont.vis_radius_h);
    set(findobj(gcf,'tag','noise_hz'),'string',cont.noise_hz);
    set(findobj(gcf,'tag','ITD_offset'),'string',cont.ITD_offset);
    set(findobj(gcf,'tag','reps'),'string',cont.reps);
    
    set(findobj(gcf,'tag','display_chan'),'value',1)
    set(findobj(gcf,'tag','display_chan'),'string',[1:rec.numch])
    set(findobj(gcf,'tag','display_chan'),'value',rec.dispch)
    
    
    set(findobj(gcf,'tag','param_set_wrong'),'value', 0);
    if cont.trace
        if isfield(savecont{cont.trace}, 'param_set_wrong')  %% if param_set_wrong exists, use it to determine if the checkbox is down 
            set(findobj(gcf,'tag','param_set_wrong'),'value', savecont{cont.trace}.param_set_wrong);
        end
    end
    
    if ISFIELD(cont,'startpause')
        set(findobj(gcf,'tag','startpause'),'string',cont.startpause);
    end
    if ISFIELD(cont,'isi')
        set(findobj(gcf,'tag','isi'),'string',cont.isi);
    end
    set(findobj(gcf,'tag','filename'),'string',cont.filename);
    set(findobj(gcf,'tag','trace'),'string',cont.trace);
    set(findobj(gcf,'tag','present_aud'),'value',cont.present_aud);
    set(findobj(gcf,'tag','present_vis'),'value',cont.present_vis);
    set(findobj(gcf,'tag','motion_type'),'value',cont.motion_type);
    set(findobj(gcf,'tag','correlated'),'value',cont.correlated);
    set(findobj(gcf,'tag','dir'),'value',cont.dir);

    set(findobj(gcf,'tag','hist_type'), 'value',1)
    if cont.present_vis==1
        set(findobj(gcf,'tag','hist_type'), 'value',2)
    end
    figure(findobj(0,'tag','set_cont_win'));     %% set the third window as active
return;

   