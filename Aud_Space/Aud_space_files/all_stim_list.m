 function    all_stim_list()

        global snd
        var1_array=[snd.Var1min:snd.Var1step:snd.Var1max];
        var2_array=[snd.Var2min:snd.Var2step:snd.Var2max];
      
        if snd.Var2==7
            snd.stim_list=[1:length(var1_array)];
          else
            snd.stim_list=[1:(length(var1_array)*length(var2_array))];
        end


           close
        show_stim_grid


return;