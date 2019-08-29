function save_raw_file_bin_overwrite()
    global snd rec rawwave RA_16;

    if exist([snd.path,snd.filename,'_raw.mat'])==2    
        % user has chosen to overwrite existing raw file
        for currentchan=1:rec.numch            
            chan_id=strcat('ChID',num2str(currentchan));
            chan=invoke(RA_16,'GetTagVal',chan_id);
            saveraw{chan}=rawwave{chan}; 
		end    
        save([snd.path,'\',snd.filename,'_raw.mat'],'saveraw');          
		saveraw={};  % clear from memory 
    else
        'Error: called save_raw_file_bin_overwrite for a non-existent file!'
    end
     
return;

