function save_inter_file_bin()
    global snd rec savesnd saverec multsnd;
    currentdir=pwd;

    N=length(multsnd);
     
    trace=max(snd.trace,1);

    if ~strcmp(snd.oldname,snd.filename)
        savesnd={};
        saverec={};
        trace=1;
    end

    % strip ".mat" file extension if it's there (also "_wav", "_raw")
    if findstr(snd.filename,'.mat')
        snd.filename=snd.filename(1:findstr(snd.filename,'.mat')-1);
    end    
    if findstr(snd.filename,'_wav')
        snd.filename=snd.filename(1:findstr(snd.filename,'_wav')-1);
    end    
    if findstr(snd.filename,'_raw')
        snd.filename=snd.filename(1:findstr(snd.filename,'_raw')-1);
    end    
    
    if exist([snd.path,snd.filename,'.mat'])==2        %%  if the file exists, do not over write
       openpath=[snd.path,snd.filename];
       load(openpath)
       trace=length(savesnd)+1;
    end
   
   first_trace=trace;
   
   for i=[1:N]
        if multsnd{i}.save_sound==0
            multsnd{i}.snd_corr1=[];
            multsnd{i}.snd_corr2=[];
            multsnd{i}.snd_uncorr1=[];
            multsnd{i}.snd_uncorr2=[];
            multsnd{i}.AMsnd_corr=[];
            multsnd{i}.AMsnd_uncorr1=[];
            multsnd{i}.AMsnd_uncorr2=[];
        end
       
		multsnd{i}.oldname= snd.oldname;
		multsnd{i}.filename=snd.filename;
		multsnd{i}.path=snd.path;
		multsnd{i}.inter_together = [first_trace:first_trace+N-1];
		snd=multsnd{i};
		snd.trace=trace;  % KM: current multsnd=i, actual tracenum = trace
        
		savesnd{snd.trace}=snd;
		saverec{snd.trace}=rec;
                
		save([snd.path,'\',snd.filename],'savesnd','saverec');      %%save the files
        
        if snd.save_spikes
            % Load the temp file for this trace to get the waveform data
            load(strcat(currentdir,'\..\temp_waves\trace',num2str(i)));
            allwaves = strcat ('savewav', num2str(trace), '.dataWave'); 
            eval(sprintf('%s = [];', allwaves));
            
            for k = 1:length(multsnd{i}.wavelist)
                nextwave = strcat ('w', num2str(multsnd{i}.wavelist(k))); 
                eval(sprintf('%s = cat(2,%s,%s);',allwaves,allwaves,nextwave)); 
                eval(sprintf('%s = [];', nextwave));  % clear from memory
            end

            % save 'savewavX.dataWave' to the _wav.mat file
            if exist([snd.path,snd.filename,'_wav.mat'])==2
                eval(sprintf('save([snd.path,''\\'',snd.filename,''_wav.mat''],''savewav%d'',''-append'');', trace));
            else
                eval(sprintf('save([snd.path,''\\'',snd.filename,''_wav.mat''],''savewav%d'');', trace));
            end        
            
            % clean up
            eval(sprintf('%s = [];', allwaves));
            delete(strcat(currentdir,'\..\temp_waves\trace',num2str(i),'.mat'));
            
        end
        trace=trace+1;
    end
    
 
        
    snd.maxtrace=snd.trace;

    
    figure(findobj(0,'tag','Aud_Space_win'));     %% set the control window as active
    set(findobj(gcf,'tag','Print_trace'),'string',['Trace ' num2str(snd.trace)]);
    set_disp_params
    update_control_window


return;
