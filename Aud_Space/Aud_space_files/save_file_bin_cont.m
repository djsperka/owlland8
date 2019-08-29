function save_file_bin_cont()
    global snd rec cont savecont savesnd saverec multcont multsnip;
        currentdir=pwd;
        tempfile=cont.filename;
        temppath=cont.path;
%         [temppath,tempfile]

            cont=multcont{1}; 
            cont.path=temppath;
            cont.filename=tempfile;
            
            
            savecont={};
            saverec={};

            if ~strcmp(cont.path(length(cont.path)),'\')    %%check to see if cont.path ends with a slash
                path=[cont.path,'\'];
              else
                path=cont.path;
            end
		
            file=cont.filename;
            
            % strip ".mat" file extension if it's there (and "_wav" and "_raw")
            if findstr(file,'.mat')
                file=file(1:findstr(file,'.mat')-1);
            end    
            if findstr(file,'_wav')
                file=file(1:findstr(file,'_wav')-1);
            end    
            if findstr(file,'_raw')
                file=file(1:findstr(file,'_raw')-1);
            end    
                                                           
            if exist([path,file,'.mat'])==2        %%  if the file exists, do not over write
               load([path,file]);
               cont.trace=length(savecont)+1;
               trace=cont.trace;
            else
               trace=1;
            end
            path
            file

            
        for i=[1:length(multcont)]   
            cont=multcont{i}; 
%             cont.path=temppath;
%             cont.filename=tempfile;
            
%             savecont={};
%             saverec={};
%             cont.trace=1;
            
            cont.trace=trace;
            cont.filename=file;
            cont.path=path;
            savecont{trace}=cont; 
            saverec{trace}=rec;
            trace=trace+1;
                  
            if cont.save_snips   %  //savecont{cont.trace}
                % Load the temp file for this trace to get the waveform data
                load(strcat(currentdir,'\..\temp_waves\trace',num2str(i)));
                allwaves = strcat ('savecontwav', num2str(cont.trace), '.dataWave');   
                eval(sprintf('%s = [];', allwaves));
                   
                % go through all wave vars in temp file (in order!) and cat them onto master wavefile for this trace- savecontwavX.dataWave
                for r = 1:cont.reps   
                    nextwave = strcat ('w', num2str(r)); 
                    eval(sprintf(('leng = length(%s);'), nextwave));  % get the number of channels stored in this rep's var
                    for ch = 1:leng    
                        %sprintf('%s{%s}{%s} = %s{%s}', allwaves,num2str(r),num2str(ch), nextwave,num2str(ch))
                        eval(sprintf('%s{%s}{%s} = %s{%s};', allwaves,num2str(r),num2str(ch), nextwave,num2str(ch)));
                    end                    
                    eval(sprintf('%s = [];', nextwave));  % clear from memory                       
                end
                               
                % save 'savecontwavX' to the _wav.mat file
                if exist([path,file,'_wav.mat'])==2
                    %sprintf('save([path,file,''_wav.mat''],''savecontwav%d'',''-append'');', cont.trace)
                    eval(sprintf('save([path,file,''_wav.mat''],''savecontwav%d'',''-append'');', cont.trace));
                else
                    %sprintf('save([path,file,''_wav.mat''],''savecontwav%d'');', cont.trace)
                    eval(sprintf('save([path,file,''_wav.mat''],''savecontwav%d'');', cont.trace));  
                end        
                
                % clean up
                eval(sprintf('%s = [];', allwaves));
                delete(strcat(currentdir,'\..\temp_waves\trace',num2str(i),'.mat'));  
                
            end
        end
        
        save([path,file],'savecont','saverec');      %%save the files
               
return;

