function set_RA16_moving_snd()
    global rec RA_16 snd;
% %         invoke(RA_16,'halt');
        %% Set General parameters
        if invoke(RA_16,'SetTagVal','filtcent',rec.filtcent);
            else
            'unable to set tag value'
        end

        if invoke(RA_16,'SetTagVal','filtwidth',rec.filtwidth);
            else
            'unable to set tag value'
        end

        if invoke(RA_16,'SetTagVal','collecttime',rec.collecttime);
            else
            'unable to set tag value'
        end

        if invoke(RA_16,'SetTagVal','shift',rec.shift);
            else
            'unable to set tag value'
        end

        if invoke(RA_16,'SetTagVal','gain',rec.gain);
            else
            'unable to set tag value'
        end
        %% End set General parameters
        
        
        %%  Set the channels to record from
        if invoke(RA_16,'SetTagVal','ChID1',rec.ChID1);
            else
            'unable to set tag value'
        end
       
        
        %%  Set Threshhold levels
        if invoke(RA_16,'SetTagVal','thresh1',rec.thresh1);
            else
            'unable to set tag value'
        end
        if invoke(RA_16,'SetTagVal','ThreshSign',rec.ThreshSign);
            else
            'unable to set tag value'
        end
        %%  End set Threshhold levels
        
        
        %%  Set the parameters for the Oscilloscope

        
        if invoke(RA_16,'SetTagVal','volume',snd.volume/100);
            else
                'unable to set tag value'
        end

    invoke(RA_16,'run');        
return;
    