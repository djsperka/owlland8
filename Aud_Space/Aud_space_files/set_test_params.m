function set_test_params()
    global snd rec
    snd.play_sound1=0;
    snd.play_sound2=0;
    snd.play_vis1=0;
    snd.play_vis2=0;
    
    
    
    
    
    
    snd.test_param_matrix(1,snd.Var1,:)=[snd.Var1min,snd.Var1max,snd.Var1step]; %%save the last run test values
    snd.test_param_matrix(2,snd.Var2,:)=[snd.Var2min,snd.Var2max,snd.Var2step];

    
    old_var1=snd.Var1;
    old_var2=snd.Var2;
    snd.Var1=get(findobj(gcf,'tag','Var1'),'value');
    snd.Var2=get(findobj(gcf,'tag','Var2'),'value');
    
%     test_string=get(gcf,'tag');
    set(findobj(gcf,'tag','Var1min'),'enable','on');
    set(findobj(gcf,'tag','Var1max'),'enable','on');
    set(findobj(gcf,'tag','Var1step'),'enable','on');
  


    snd.Var1min=snd.test_param_matrix(1,snd.Var1,1);
    snd.Var1max=snd.test_param_matrix(1,snd.Var1,2);
    snd.Var1step=snd.test_param_matrix(1,snd.Var1,3);

    
    set(findobj(gcf,'tag','Var2min'),'enable','on');
    set(findobj(gcf,'tag','Var2max'),'enable','on');
    set(findobj(gcf,'tag','Var2step'),'enable','on');
    set(findobj(gcf,'tag','Var2_min_label'),'enable','on');
    set(findobj(gcf,'tag','Var2_max_label'),'enable','on');
    set(findobj(gcf,'tag','Var2_step_label'),'enable','on');

    
    
    if snd.Var2==7  %%case none
            set(findobj(gcf,'tag','Var2min'),'enable','off');
            set(findobj(gcf,'tag','Var2max'),'enable','off');
            set(findobj(gcf,'tag','Var2step'),'enable','off');
            set(findobj(gcf,'tag','Var2_min_label'),'enable','off');
            set(findobj(gcf,'tag','Var2_max_label'),'enable','off');
            set(findobj(gcf,'tag','Var2_step_label'),'enable','off');
            
        else
            snd.Var2min=snd.test_param_matrix(2,snd.Var2,1);
            snd.Var2max=snd.test_param_matrix(2,snd.Var2,2);
            snd.Var2step=snd.test_param_matrix(2,snd.Var2,3);
    end
    
    refresh_range_params
    
    if snd.Var2==7||snd.Var1==19||snd.Var1==12||snd.Var1==15 %%%%%%%  for none & ITD/AVflank we don't want to interleave alones
        snd.interleave_alone=0;
        set(findobj(gcf,'tag','interleave_alone'),'value',snd.interleave_alone);
        set(findobj(gcf,'tag','interleave_alone'),'enable','off');
      else
        set(findobj(gcf,'tag','interleave_alone'),'enable','on');
    end
    
    if snd.Var2==7
        snd.stim_list=[1:length([snd.Var1min:snd.Var1step:snd.Var1max])];
      else
        snd.stim_list=[1:(length([snd.Var1min:snd.Var1step:snd.Var1max])*length([snd.Var2min:snd.Var2step:snd.Var2max]))];
    end

    
%     %% these list the tuning curves that use a particular visual or auditory stimuli
%     aud1_array1=[1:5,12,19];  %% aud1 curve in array1
%     aud2_array1=[16:18]; %% aud2 curves in array1
%     vis1_array1=[8:12]; %%
%     vis2_array1=[13:14]; %%
%     
%     aud1_array2=[1:3];  %% aud1 curve in array2
%     aud2_array2=[16:18]; %% aud2 curves in array2
%     vis1_array2=[8:12];
%     vis2_array2=[13:14]; %%
%     %%%
    














    if or(ismember(snd.Var1,snd.present_stimuli{1}.aud1),ismember(snd.Var2,snd.present_stimuli{2}.aud1))
        snd.play_sound1=1;
    end
    if or(ismember(snd.Var1,snd.present_stimuli{1}.aud2),ismember(snd.Var2,snd.present_stimuli{2}.aud2))
        snd.play_sound2=1;
    end
    
    if or(ismember(snd.Var1,snd.present_stimuli{1}.vis1),ismember(snd.Var2,snd.present_stimuli{2}.vis1))
        snd.play_vis1=1;
    end
    if or(ismember(snd.Var1,snd.present_stimuli{1}.vis2),ismember(snd.Var2,snd.present_stimuli{2}.vis2))
        snd.play_vis2=1;
    end
   


    if findobj(0,'tag','JoeSound_win')>=1
        figure(findobj(0,'tag','JoeSound_win'));     %% set the first window as active
        set(findobj(gcf,'tag','play_sound1'), 'value',snd.play_sound1);
        set(findobj(gcf,'tag','play_sound2'), 'value',snd.play_sound2);
        set(findobj(gcf,'tag','play_vis1'), 'value',snd.play_vis1);
        set(findobj(gcf,'tag','play_vis2'), 'value',snd.play_vis2);
            
        
        enable_on_off;
        
    end
    figure(findobj(0,'tag','Aud_Space_win'));     %% set the first window as active


%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
    

return;