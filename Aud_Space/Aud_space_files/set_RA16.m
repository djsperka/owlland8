function set_RA16()
    global rec RA_16 snd;
% %         invoke(RA_16,'halt');
        %% Set General parameters

        % this tag gets used to check if RA16_eight is loaded to RA16
        %%changed to RA16eight djt 9/13/2012
        
        if invoke(RA_16,'SetTagVal','RA16eight_loaded',1);
            else
            'unable to set RA16eight_loaded'
        end
        
        % KM: note- once NumSamples is set on the RA16, it can only be
        % decreased, never increased.  If you want to increase it, need to
        % reload RA16four.rco so more memory can be allocated.
        
        %%removed because we aint got none wavesamples!! djt 9/13/2012
%         if invoke(RA_16,'SetTagVal','WaveSamples',rec.wavesamples/2);  
%             else
%             'unable to set WaveSamples'
%         end        
        
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
        %%Added 4 channels djt 9/13/2012
        if invoke(RA_16,'SetTagVal','ChID5',rec.ChID5);
            else
            'unable to set tag value ChID5'
        end
        if invoke(RA_16,'SetTagVal','ChID6',rec.ChID6);
            else
            'unable to set tag value ChID6'
        end
        if invoke(RA_16,'SetTagVal','ChID7',rec.ChID7);
            else
            'unable to set tag value ChID7'
        end
        if invoke(RA_16,'SetTagVal','ChID8',rec.ChID8);
            else
            'unable to set tag value ChID8'
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
        %%Added 4 channels djt 9/13/2012
        if invoke(RA_16,'SetTagVal','thresh5',rec.thresh5);
            else
            'unable to set tag value thresh5'
        end
        if invoke(RA_16,'SetTagVal','thresh6',rec.thresh6);
            else
            'unable to set tag value thresh6'
        end
        if invoke(RA_16,'SetTagVal','thresh7',rec.thresh7);
            else
            'unable to set tag value thresh 7'
        end
        if invoke(RA_16,'SetTagVal','thresh8',rec.thresh8);
            else
            'unable to set tag value thresh 8'
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
        %%Modified to accomodate 8 channels w/ paired MuxIn functions in
        %%RPvds djt 9/13/2012
        if rec.OscCh<5
            if invoke(RA_16,'SetTagVal','OscCh1',OscChSet);
            else
                'unable to set tag value OscCh1'
            end
            if invoke(RA_16,'SetTagVal','OscCh2',OscChSet);
            else
                'unable to set tag value OscCh2'
            end
            if invoke(RA_16,'SetTagVal','OscChMaster',0);
            else
                'unable to set tag value OscChMaster'
            end
        else 
            if invoke(RA_16,'SetTagVal','OscCh1',OscChSet-4);
            else
                'unable to set tag value OscCh1'
            end
            if invoke(RA_16,'SetTagVal','OscCh2',OscChSet-4);
            else
                'unable to set tag value OscCh2'
            end
            if invoke(RA_16,'SetTagVal','OscChMaster',1);
            else
                'unable to set tag value OscChMaster'
            end
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
                %%ADDED 4 CHANNELS djt 9/13
            case 5
                if invoke(RA_16,'SetTagVal','ThreshOsc',rec.thresh5);
                    else
                    'unable to set tag value'
                end
            case 6
                if invoke(RA_16,'SetTagVal','ThreshOsc',rec.thresh6);
                    else
                    'unable to set tag value'
                end
           case 7
                if invoke(RA_16,'SetTagVal','ThreshOsc',rec.thresh7);
                    else
                    'unable to set tag value'
                end
            case 8
                if invoke(RA_16,'SetTagVal','ThreshOsc',rec.thresh8);
                    else
                    'unable to set tag value'
                end
        end;
        %%  End set the parameters for the Oscilloscope
        
        %%  Set the Oscilloscope Output Channels
        if invoke(RA_16,'SetTagVal','UnFiltCh',rec.UnFiltCh);
            else
                'unable to set tag value. REMOVED UnFiltCh tag from RPVds file 12/4/2012 DJT'
        end
% % %         if invoke(RA_16,'SetTagVal','FiltCh',rec.FiltCh);
% % %             else
% % %                 'unable to set tag value'
% % %         end
        if invoke(RA_16,'SetTagVal','FiltChTrig',rec.FiltChTrig);
            else
                'unable to set tag value. REMOVED FiltChTrig tag from RPVds file 12/4/2012 DJT'
        end
        if invoke(RA_16,'SetTagVal','volume',snd.volume/100);
            else
                'unable to set tag value. REMOVED volume tag from RPVds file 12/4/2012 DJT'
        end

    invoke(RA_16,'run');   
    
return;
    