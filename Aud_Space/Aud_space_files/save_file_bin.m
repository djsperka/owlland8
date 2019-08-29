function save_file_bin()
    global snd rec savesnd saverec;
    currentdir=pwd;
    
    % strip the ".mat" extension off filename if it's there
    if findstr(snd.filename,'.mat')
        snd.filename=snd.filename(1:findstr(snd.filename,'.mat')-1);
    end
    % strip the "_wav" extension off filename if it's there
    if findstr(snd.filename,'_wav')
        snd.filename=snd.filename(1:findstr(snd.filename,'_wav')-1);
    end
    % strip the "_raw" extension off filename if it's there
    if findstr(snd.filename,'_raw')
        snd.filename=snd.filename(1:findstr(snd.filename,'_raw')-1);
    end
    
    
    if ~strcmp(snd.oldname,snd.filename)
        savesnd={};
        saverec={};
        snd.trace=1;
    end
    if exist([snd.path,snd.filename,'.mat'])==2        %%  if the file exists, do not over write
       openpath=[snd.path,snd.filename];
       load(openpath)
       snd.trace=length(savesnd)+1;  
   end

    if snd.save_sound==0
        snd.snd_corr1=[];
        snd.snd_corr2=[];
        snd.snd_uncorr1=[];
        snd.snd_uncorr2=[];
        snd.AMsnd_corr=[];
        snd.AMsnd_uncorr1=[];
        snd.AMsnd_uncorr2=[];
    end
    
    
    snd.inter_together= []; %% we are saving w/ this function because we DID NOT interleave multiple traces   
    snd.maxtrace=snd.trace;

    
    savesnd{snd.trace}=snd;
    saverec{snd.trace}=rec;
    if snd.save_spikes
        % don't save dataWave in general file, too big (will save to a separate file below)
        savesnd{snd.trace}.dataWave=[];
        savesnd{snd.trace}.dataWave_arr1=[];
        savesnd{snd.trace}.dataWave_arr2=[];                        
    end     
    save([snd.path,'\',snd.filename],'savesnd','saverec');    
    
    if snd.save_spikes
        % To avoid keeping lots of huge waveforms in memory, create a new variable (eg savewav13) for the waveforms  
        % in current trace, and append that variable onto the file of all previous traces. 
        % These 3 lines execute Matlab commands like this one:   savewav13.dataWave=snd.dataWave;  
        eval(sprintf('savewav%d.dataWave=snd.dataWave;',snd.trace))
        eval(sprintf('savewav%d.dataWave_arr1=snd.dataWave_arr1;',snd.trace))
        eval(sprintf('savewav%d.dataWave_arr2=snd.dataWave_arr2;',snd.trace))                

        snd.dataWave=[];
        snd.dataWave_arr1=[];
        snd.dataWave_arr2=[];
        
        %  this line executes a command like:
        %  save([snd.path,'\',snd.filename,'_wav.mat'], 'savewav13', '-append');
        if exist([snd.path,snd.filename,'_wav.mat'])==2
            eval(sprintf('save([snd.path,''\\'',snd.filename,''_wav.mat''],''savewav%d'',''-append'');', snd.trace));
        else
            eval(sprintf('save([snd.path,''\\'',snd.filename,''_wav.mat''],''savewav%d'');', snd.trace));
        end        
    end
    
    figure(findobj(0,'tag','Aud_Space_win'));     %% set the control window as active
    set(findobj(gcf,'tag','Print_trace'),'string',['Trace ' num2str(snd.trace)]);
    set_disp_params
    update_control_window


return;
