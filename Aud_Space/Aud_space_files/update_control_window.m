function update_control_window()
    global snd rec
        figure(findobj(0,'tag','disp_win_1'));     %% set disp 1 and recreate menu
        fa = uimenu('Label','background');
            uimenu(fa,'Label','Black','Callback','set(gcf,''color'',[0,0,0])');
            uimenu(fa,'Label','White','Callback','set(gcf,''color'',[1,1,1])');
            uimenu(fa,'Label','Cream','Callback','set(gcf,''color'',[.95, .95, .7])');
            uimenu(fa,'Label','Green','Callback','set(gcf,''color'',[.4,.6,.4])');
            uimenu(fa,'Label','Burgundy','Callback','set(gcf,''color'',[.6 .2 .2])');
            uimenu(fa,'Label','');
            uimenu(fa,'Label','Other','Callback','set_color');

        figure(findobj(0,'tag','disp_win_2'));          %% set disp 2 and recreate menu
        fa = uimenu('Label','background');
            uimenu(fa,'Label','Black','Callback','set(gcf,''color'',[0,0,0])');
            uimenu(fa,'Label','White','Callback','set(gcf,''color'',[1,1,1])');
            uimenu(fa,'Label','Cream','Callback','set(gcf,''color'',[.95, .95, .7])');
            uimenu(fa,'Label','Green','Callback','set(gcf,''color'',[.4,.6,.4])');
            uimenu(fa,'Label','Burgundy','Callback','set(gcf,''color'',[.6 .2 .2])');
            uimenu(fa,'Label','');
            uimenu(fa,'Label','Other','Callback','set_color');

        figure(findobj(0,'tag','Aud_Space_win'));     %% set the control window as active

        %% set all of the variables.
        set(findobj(gcf,'tag','Var1min'),'string',snd.Var1min);
        set(findobj(gcf,'tag','Var1max'),'string',snd.Var1max);
        set(findobj(gcf,'tag','Var1step'),'string',snd.Var1step);
        set(findobj(gcf,'tag','Var2max'),'string',snd.Var2max);
        set(findobj(gcf,'tag','Var2min'),'string',snd.Var2min);
        set(findobj(gcf,'tag','Var2step'),'string',snd.Var2step);
        set(findobj(gcf,'tag','reps'),'string',snd.reps);

        set(findobj(gcf,'tag','filename'),'string',snd.filename);
        
        path_slash=findstr(snd.path,'\');
        disp_path=snd.path(path_slash(length(path_slash)-1):length(snd.path));

        
        set(findobj(gcf,'tag','Print_rep'),'string',disp_path);

        set(findobj(gcf,'tag','Var1'),'value',snd.Var1);
        set(findobj(gcf,'tag','Var2'),'value',snd.Var2);
        

        if or(snd.play_sound1,snd.play_sound2)
            set(findobj(gcf,'tag','sound_on'), 'string','sound1 on');
           else
            set(findobj(gcf,'tag','sound_on'), 'string','sound1 off');
        end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         rec.dispch=1;

        snd.Var1array=[snd.Var1min:snd.Var1step:snd.Var1max];
        snd.Var2array=[snd.Var2min:snd.Var2step:snd.Var2max];
        
        if ~snd.collect_rawwave  % don't display max trace when have raw (looks confusing b/c max is temporarily less than current)
            set(findobj(gcf,'tag','Print_trace'),'string',['Trace ',num2str(snd.trace),'  of ',num2str(snd.maxtrace)]);
        end
    set(findobj(gcf,'tag','Var2min'),'enable','on');
    set(findobj(gcf,'tag','Var2max'),'enable','on');
    set(findobj(gcf,'tag','Var2step'),'enable','on');
    set(findobj(gcf,'tag','Var2_min_label'),'enable','on');
    set(findobj(gcf,'tag','Var2_max_label'),'enable','on');
    set(findobj(gcf,'tag','Var2_step_label'),'enable','on');
    set(findobj(gcf,'tag','interleave_alone'),'enable','on');

    if or(snd.Var1==7,snd.Var2==7)
            set(findobj(gcf,'tag','Var2min'),'enable','off');
            set(findobj(gcf,'tag','Var2max'),'enable','off');
            set(findobj(gcf,'tag','Var2step'),'enable','off');
            set(findobj(gcf,'tag','Var2_min_label'),'enable','off');
            set(findobj(gcf,'tag','Var2_max_label'),'enable','off');
            set(findobj(gcf,'tag','Var2_step_label'),'enable','off');
            set(findobj(gcf,'tag','interleave_alone'),'enable','off');
    end;
    
    set(findobj(gcf,'tag','interleave_alone'),'value',snd.interleave_alone);
    
    
            

return;
