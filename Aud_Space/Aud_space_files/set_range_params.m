function set_range_params()
    global snd rec;
    
    snd.Var1min=str2num(get(findobj(gcf,'tag','Var1min'),'string'));
    snd.Var1max=str2num(get(findobj(gcf,'tag','Var1max'),'string'));
    snd.Var1step=str2num(get(findobj(gcf,'tag','Var1step'),'string'));
    snd.Var2min=str2num(get(findobj(gcf,'tag','Var2min'),'string'));
    snd.Var2max=str2num(get(findobj(gcf,'tag','Var2max'),'string'));
    snd.Var2step=str2num(get(findobj(gcf,'tag','Var2step'),'string'));
    snd.reps=str2num(get(findobj(gcf,'tag','reps'),'string'));
    snd.interleave_alone=get(findobj(gcf,'tag','interleave_alone'), 'value');
    snd.save_sound=get(findobj(gcf,'tag','save_sound'), 'value');
    snd.save_spikes=get(findobj(gcf,'tag','save_spikes'), 'value');
    %%Added djt 9/13/2012
    if snd.save_spikes==1
        snd.save_spikes=0;
        fprintf('\nI can''t let you do that Dave.  Use your CED board to save spikes!\n')
    end
    
    
    if snd.Var2==7
        snd.stim_list=[1:length([snd.Var1min:snd.Var1step:snd.Var1max])];
      else
        snd.stim_list=[1:(length([snd.Var1min:snd.Var1step:snd.Var1max])*length([snd.Var2min:snd.Var2step:snd.Var2max]))];
    end
    
    snd.Var1max=max(snd.Var1max,snd.Var1min);
    snd.Var2max=max(snd.Var2max,snd.Var2min);
    set(findobj(gcf,'tag','Var1min'),'string',snd.Var1min);
    set(findobj(gcf,'tag','Var1max'),'string',snd.Var1max);
    set(findobj(gcf,'tag','Var1step'),'string',snd.Var1step);
    set(findobj(gcf,'tag','Var2min'),'string',snd.Var2min);
    set(findobj(gcf,'tag','Var2max'),'string',snd.Var2max);
    set(findobj(gcf,'tag','Var2step'),'string',snd.Var2step);
    set(findobj(gcf,'tag','reps'),'string',snd.reps);
    
    

    
return;
