function collect_spike_training_AS()
    global rec snd RP_1 RP_2 pa5_1 pa5_2 pa5_3 pa5_4 RA_16 zbus rawwave
    
    %%%%% This function collects "collect_minutes" amount of full waveform
    %%%%% data, and saves it to a file that has the same file name as
    %%%%% general data with "_raw" appended to filename.  The data is
    %%%%% stored in a structure like this:
    %%%%% saveraw{channel} = waveforms
    %%%%% Waveform data to be used for spike sorting algorithm.
    
    % Variables.  These are hard-coded into RPvds files and are related
    % to each other-- if you change them here also change in RPvds and make
    % sure they are all in register with each other.
    collect_minutes=2;   
    buffer_size=1500000;  % serial buffer size. Collecting for 2 min at 25 kHz, compressed by 2. (2*60*25000/2).
    compression_SF=4681000/rec.gain; 
        % scale factor used for compressing data in RPvds file. amplifier range = 7mV 
        % or 0.007V, and 32767 is TDT SF for 1 V signal.  compression_SF = 32767/.007 = 4681000. Divide this 
        % by the gain factor that the amplifier signal has been multiplied by.
   
    %%% load "RA16four_wave" 
    invoke(RA_16,'halt'); 
    invoke(RA_16,'ClearCOF');  %%remove currently loaded RPVDS 	
    currentdir=pwd;	
    RPVDS_path=strcat(currentdir,'\..\RPVDS');     
    if invoke(RA_16,'loadCOFsf',strcat(RPVDS_path,'\','RA16four_wave'), 2)
        'RA16four_wave loaded on RA16'
    else
        'error in loading RA16'
        return;
    end
    set_RA16_rawwave;
  
    
    % make array of channel IDs for all active channels
    i = 1;
    for currentchan=1:rec.numch            
        chan_id=strcat('ChID',num2str(currentchan));
        channels(i)=invoke(RA_16,'GetTagVal',chan_id);
        i = i + 1;
    end
        
    % strip ".mat" file extension if it's there
    if findstr(snd.filename,'.mat')
        snd.filename=snd.filename(1:findstr(snd.filename,'.mat')-1);
    end    
    
    % set SF
    invoke(RA_16, 'SetTagVal','ScaleFactor',compression_SF);  
    
    % This is a kluge to set iCompare (if you set it within RPvds it gets rounded).
    invoke(RA_16, 'SetTagVal','BufferEnd',buffer_size-1);  
    
    %%% START CONTINUOUS WAVEFORM COLLECTION 
    invoke(RA_16,'SoftTrg',1);
    
    %%% PRESENT 'collect_minutes' OF A/V STIMULI
    snd.collect_rawwave=1;   
    snd.collect_seconds= 60*collect_minutes;       
    run_tuning_curve_cb;   
    
    %%% READ WAVEFORM DATA FROM CHANNEL    
    for j=1:length(channels)
        cycle_usage = invoke (RA_16, 'GetCycUse')
        wave = invoke(RA_16,'ReadTagVEX',strcat('Ch',num2str(channels(j)),'wave'),1,buffer_size*2,'I16','F64',1); % uncompress data
        rawwave{channels(j)} = wave/compression_SF; 
        covariance = cov(rawwave{channels(j)})
    end
    

    save_raw_file_dialog;
    snd.collect_rawwave=0;
    
    %% reload previous RPVDS
    invoke(RA_16,'halt');     
    invoke(RA_16,'ClearCOF');  
    currentdir=pwd;	
    RPVDS_path=strcat(currentdir,'\..\RPVDS');     
    if invoke(RA_16,'loadCOFsf',strcat(RPVDS_path,'\','RA16four'), 2)
        'RA16four loaded on RA16'
    else
        'error in loading RA16'
    end
    set_RA16;
    
    
return;
    


%%%%%%%%%%%%%%%%% This is the old Matlab continuous acquire way that Victor
%%%%%%%%%%%%%%%%% had initially suggested. %%%%%%%    
% %     % Each run through loop gets 50,000 data points (sampling at 25 kHz, 
% %     % so this is 2 seconds of data). Repeat loop until have collect_minutes.
% %     
% %     collect_minutes=0.2;  % just for debugging-- take out!!!!!!!!!!!!!
% %     
% %     collect_samples = 60*collect_minutes*25000;   
% %     for j=1:length(channels)
% %         saveraw{channels(j)}{tag} = zeros(1,collect_samples);
% %     end
% %
% %     % call function to present stimuli (with spike collection turned off)
% %     snd.collect_spikes=0; 
% %     snd.collect_seconds = 60* collect_minutes;
% %     run_tuning_curve_cb;   
% %     
% %     %%%%% Collect continuous waveform data
% %     invoke(RA_16, 'SoftTrg', 1);    
% %     for i=1:50000:collect_samples
% % 
% %         %%%%%%% Collect and print the 1st half of the data buffer (while the 2nd half is filling)
% %         buffer_index = invoke(RA_16, 'GetTagVal', strcat ('Ch',num2str(chan_id),'Index')); 
% % 		while(buffer_index<25000)  
% % 		    buffer_index=invoke(RA_16, 'GetTagVal', strcat ('Ch',num2str(chan_id),'Index'));
% % 		end    
% %         % grab the next 25000 entries of each channel
% %         for j=1:length(channels)
% %             saveraw{channels(j)}{tag}(i:i+24999)=invoke(RA_16, 'ReadTagV', strcat ('Ch',num2str(chan_id),'wave'), 1, 25000);
% %         end    
% %         % save file
% %         if ~(exist([snd.path,snd.filename,'_raw.mat'])==2)   % first time, save new file
% %             save([snd.path,snd.filename,'_raw.mat'],'saveraw'); 
% %         else   % every other time append to existing file
% %             save([snd.path,snd.filename,'_raw.mat'],'saveraw','-append');   
% %         end
% %         
% %         
% %          
% %         %%%%%%% Collect and print the 2nd half of the data buffer (while the 1st half is filling)
% %         while(buffer_index>=25000 && buffer_index<50000)  
% % 		    buffer_index=invoke(RA_16, 'GetTagVal', strcat ('Ch',num2str(chan_id),'Index'));
% % 		end
% %         % grab the next 25000 entries of each channel
% %         for j=1:length(channels)
% %             saveraw{channels(j)}{tag}(i+25000:i+49999)=invoke(RA_16, 'ReadTagV', strcat ('Ch',num2str(chan_id),'wave'), 25001, 25000);
% %         end
% %         % save file
% %         save([snd.path,snd.filename,'_raw.mat'],'saveraw','-append');      
% %         
% %     end
% %     
% %     snd.collect_spikes=1;  % turn spike collection back on for next time
    
    
    
    