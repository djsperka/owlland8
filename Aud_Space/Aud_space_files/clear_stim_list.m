 function    clear_stim_list()
        global snd
        var1_array=[snd.Var1min:snd.Var1step:snd.Var1max];
        var2_array=[snd.Var2min:snd.Var2step:snd.Var2max];

        snd.stim_list=[];
        close
        show_stim_grid
        
return;