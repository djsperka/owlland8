function ChooseTuningCurve()

    %%%
    global snd rec;
    
        if (snd.Var1 == 4) | (snd.Var1== 5) | (snd.Var1== 6) 
            run_tuning_curve_freq;
        else
            run_tuning_curve_cb;
        end
        
    return; 