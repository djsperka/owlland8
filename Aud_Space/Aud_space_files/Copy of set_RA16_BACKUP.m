function set_RA16()
    global rec RA_16 snd;
% %         invoke(RA_16,'halt');
        %% Set General parameters

        % this tag gets used to check if RA16_four is loaded to RA16
        if invoke(RA_16,'SetTagVal','RA16four_loaded',1);
            else
            'unable to set RA16four_loaded'
        end
        
        % KM: note- once NumSamples is set on the RA16, it can only be
        % decreased, never increased.  If you want to increase it, need to
        % reload RA16four.rco so more memory can be allocated.
        if invoke(RA_16,'SetTagVal','WaveSamples',rec.wavesamples/2);  
            else
            'unable to set WaveSamples'
        end        
        
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
        if invoke(RA_16,'SetTagVal','ChID2',rec.ChID2);
            else
            'unable to set tag value'
        end
        if invoke(RA_16,'SetTagVal','ChID3',rec.ChID3);
            else
            'unable to set tag value'
        end
        if invoke(RA_16,'SetTagVal','ChID4',rec.ChID4);
            else
            'unable to set tag value'
        end
       
        
        %%  Set Threshhold levels
        if invoke(RA_16,'SetTagVal','thresh1',rec.thresh1);
            else
            'unable to set tag value'
        end
        if invoke(RA_16,'SetTagVal','thresh2',rec.thresh2);
            else
            'unable to set tag value'
        end
        if invoke(RA_16,'SetTagVal','thresh3',rec.thresh3);
            else
            'unable to set tag value'
        end
        if invoke(RA_16,'SetTagVal','thresh4',rec.thresh4);
            else
            'unable to set tag value'
        end
        % KM: removed this because new way of grabbing spikes (SnipStore)
        % doesn't need it.
%         if invoke(RA_16,'SetTagVal','ThreshSign',rec.ThreshSign);
%             else
%             'unable to set ThreshSign'
%         end
        %%  End set Threshhold levels
        
        
        %%  Set the parameters for the Oscilloscope

        OscChSet=(rec.OscCh-1);
        if invoke(RA_16,'SetTagVal','OscCh',OscChSet);
            else
            'unable to set tag value'
        end
        switch rec.OscCh
            case 1
                if invoke(RA_16,'SetTagVal','ThreshOsc',rec.thresh1);
                    else
                    'unable to set tag value'
                end
            case 2
                if invoke(RA_16,'SetTagVal','ThreshOsc',rec.thresh2);
                    else
                    'unable to set tag value'
                end
           case 3
                if invoke(RA_16,'SetTagVal','ThreshOsc',rec.thresh3);
                    else
                    'unable to set tag value'
                end
            case 4
                if invoke(RA_16,'SetTagVal','ThreshOsc',rec.thresh4);
                    else
                    'unable to set tag value'
                end
        end;
        %%  End set the parameters for the Oscilloscope
        
        
        %%  Set the Oscilloscope Output Channels
        if invoke(RA_16,'SetTagVal','UnFiltCh',rec.UnFiltCh);
            else
                'unable to set tag value'
        end
% % %         if invoke(RA_16,'SetTagVal','FiltCh',rec.FiltCh);
% % %             else
% % %                 'unable to set tag value'
% % %         end
        if invoke(RA_16,'SetTagVal','FiltChTrig',rec.FiltChTrig);
            else
                'unable to set tag value'
        end
        if invoke(RA_16,'SetTagVal','volume',snd.volume/100);
            else
                'unable to set tag value'
        end

    invoke(RA_16,'run');        
return;
    