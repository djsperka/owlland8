function save_file_bin()
    global snd rec rawwave RA_16 savesnd saverec;
    
    snd.collect_rawwave=1;     
    % strip the ".mat" extension and "_raw" and "_wav" tag off filename if they're there
    if findstr(snd.filename,'.mat')
        snd.filename=snd.filename(1:findstr(snd.filename,'.mat')-1);
    end
    if findstr(snd.filename,'_wav')
        snd.filename=snd.filename(1:findstr(snd.filename,'_wav')-1);
    end
    if findstr(snd.filename,'_raw')
        snd.filename=snd.filename(1:findstr(snd.filename,'_raw')-1);
    end
        
    %if new file path selected, clear all relevant globals. (need to do this even though 
    %we're not dealing with snd and rec in this function, because the next time around when we are 
    %dealing with snd and rec, snd.oldname will = snd.filename).
    if ~strcmp(snd.oldname,snd.filename)  
        savesnd={};
        saverec={};
        snd.trace=1;
        snd.maxtrace=snd.trace-1;   % so it can update when run tuning curve
    end    

    if exist([snd.path,snd.filename,'_raw.mat'])==2    
       %  file already exists-- let user choose whether to overwrite or start new one
       save_existing_raw_file_dialog;
      
    else   % This is the first time for this file, save it.
        buffer_size=8000000*2;  
        compression_SF=4681000/rec.gain; 

        for currentchan=1:rec.numch            
            chan_id=strcat('ChID',num2str(currentchan));
            chan=invoke(RA_16,'GetTagVal',chan_id);
            saveraw{chan}=rawwave{chan}; 
            
            % write to binary file for Gopal
            fid=fopen([snd.path,'\',snd.filename,'_raw'],'a');  
            count=fwrite(fid,saveraw{chan},'int16')

            fidh=fopen([snd.path,'\',snd.filename,'_raw_header'],'a');    
            fwrite(fidh,buffer_size,'float32');
            fwrite(fidh,compression_SF,'float32');
            fwrite(fidh,24414,'float32');    
            
            st= fclose(fid);
            st= fclose(fidh);
           
		end    
        %save([snd.path,'\',snd.filename,'_raw.mat'],'saveraw');    
		saveraw={};  % clear from memory 
    end
    
        % from command line after this has run--
%     fid= fopen('..\..\iii_raw','r');
%     [a,count]=fread(fid,inf,'int16');
%     fidh= fopen('..\..\iii_raw_header', 'r');
%     [a,count]=fread(fidh,inf,'float32');

    figure(findobj(0,'tag','Aud_Space_win'));     %% set the control window as active
    set(findobj(gcf,'tag','Print_trace'),'string',['Trace ' num2str(snd.trace)]);
    set_disp_params
    update_control_window 
    snd.collect_rawwave=0; 
return;

