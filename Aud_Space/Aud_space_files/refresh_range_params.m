function refresh_range_params()
    global snd rec;
        %%  update the strings in the interface
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