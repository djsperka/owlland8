function estimate_time()
    global snd;
    
    
    if snd.interleave_alone==0
        stimuli_conditions=length(snd.stim_list);
      else
        stimuli_conditions=length(snd.stim_list)+length([snd.Var1min:snd.Var1step:snd.Var1max])+length([snd.Var2min:snd.Var2step:snd.Var2max]);
    end
    curve_time=(snd.isi/1000)*stimuli_conditions*snd.reps;
    hours=floor(curve_time/3600);
    curve_time=curve_time-(hours*3600);
    minutes=floor(curve_time/60);
    seconds=curve_time-(minutes*60);
    
    ['The estimated time for this tuning curve is ',num2str(hours),' hours, ',num2str(minutes),' minutes, and ',num2str(seconds),' seconds.']
    
    
return;