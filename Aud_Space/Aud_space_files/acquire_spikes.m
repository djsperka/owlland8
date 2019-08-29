function AllSpikes = acquire_spikes(numch, in_run_cont)

    global RA_16 snd spike_count rec cont multcont;
    
    if nargin==2  %%this means the function was called from run_continuosu
        save_spikes=cont.save_snips;
    else  %%function was called from aud_space
        save_spikes=snd.save_spikes;
    end

    allstrobe=1;  
    while allstrobe    %%%wait until the schmidt trigger drops
        allstrobe=invoke(RA_16,'GetTagVal','schmitt_strobe');
    end
     collecting=1;    
    while collecting>0    %%%wait until snipstore has finished collecting its last waveform     
        collecting=mod(invoke(RA_16,'GetTagVal','windex1'),rec.wavesamples);
    end
        
    invoke(RA_16,'halt');
    for i=[1:numch]        
        
        % Decide which buffer to access depending on if "save sound" box is checked.
        if save_spikes   % If saving waves, grab waveform buffer (this buffer contains spike times as well)
            spikeindex=strcat('windex',num2str(i));
            spiketag=strcat('wavedata',num2str(i));                               
        else  % If not saving waves, grab spiketime only buffer (advantages: saves on memory, no 'block-out' period)
            spikeindex=strcat('index',num2str(i));   
            spiketag=strcat('spikes',num2str(i));
        end
            
        % Grab data from buffer
        DataLength=invoke(RA_16,'GetTagVal',spikeindex); 
        spikes=invoke(RA_16,'ReadTagV',spiketag,0,DataLength); 
        
        %%Added to correct for the fact that our RA16 is running at 12k
        %%instead of 25k.  DJT 9/18/2012
%         spikes=spikes*25000/24000;
        spikes=spikes*24414/12207;  
        %Streamlined RA16_eight so I could run
%         it at 25khz.  Now I can remove this line  DJT 12/5/2012

        % Store in data structure
        if length(spikes)>=1
            AllSpikes{i}=spikes;
        else
            AllSpikes{i}=[];
        end;
    end;

        
    
    invoke(RA_16,'run');


return;
