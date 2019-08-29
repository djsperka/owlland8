function run_inter_mat_curve(rep,stimulus_order,stimulus_place, trace_num,total_stim_played)
%added total stim played DJT 10/8/2013
global multsnd snd rec stopf runf RP_1 RP_2 pa5_1 pa5_2 RA_16  zbus check;

[Var2_place,Var1_place]=ind2sub(size(multsnd{trace_num}.datamat_pre(:,:,1)),stimulus_order(stimulus_place(trace_num)) );

%With each stimulus presentation, store the values 10/8/2013 DJT
multsnd{1}.Var1_pres_order(total_stim_played)=multsnd{trace_num}.Var1array(Var1_place);
multsnd{1}.Var2_pres_order(total_stim_played)=multsnd{trace_num}.Var2array(Var2_place);

present_sound_array=[multsnd{trace_num}.itd1,multsnd{trace_num}.ild1,multsnd{trace_num}.abi1,0,multsnd{trace_num}.duration,multsnd{trace_num}.rise,multsnd{trace_num}.pre+multsnd{trace_num}.aud_offset,multsnd{trace_num}.amplitude,multsnd{trace_num}.itd2,multsnd{trace_num}.ild2,multsnd{trace_num}.abi2, multsnd{trace_num}.corr, multsnd{trace_num}.play_sound1, multsnd{trace_num}.play_sound2];      %%default sound array

angle=multsnd{trace_num}.angle;                    %% set the angle of motion
dotcenter=[multsnd{trace_num}.az,multsnd{trace_num}.el];        %%  set the visual location
dotcenter2=[multsnd{trace_num}.az2,multsnd{trace_num}.el2];          %%  set the visual location for vis2   
fore_lum=multsnd{trace_num}.foreground;            %%  set the visual luminance
fore_lum2=multsnd{trace_num}.foreground2;            %%  set the visual luminance for vis2
distance=multsnd{trace_num}.distance;


stim_curve=0;
Wave_pointer=1;
check=1;

%% update the stimuli based on the current values FOR VAR1
switch multsnd{trace_num}.Var1         
    case 1  %%ITD1
        present_sound_array(1)=multsnd{trace_num}.Var1array(Var1_place);     
        aud_stim=1;
    case 2  %%ILD1
        present_sound_array(2)=multsnd{trace_num}.Var1array(Var1_place);              %%update this Var1 position
        aud_stim=1;
    case 3  %%ABI1
        present_sound_array(3)=multsnd{trace_num}.Var1array(Var1_place);              %%update this Var1 position
        aud_stim=1;
    case 4  %%tone           
        Wave_pointer=((Var1_place-1)*multsnd{trace_num}.duration*60)+1;             %%set the wave_pointer to the proper wave section
        aud_stim=1;
    case 5   %%nbfreq
        Wave_pointer=((Var1_place-1)*multsnd{trace_num}.duration*60)+1;         %%set the wave_pointer to the proper wave section
        aud_stim=1;
    case 6      %%stim
        multsnd{trace_num}.trgdelay=multsnd{trace_num}.Var1array(Var1_place);
%         if invoke(RP_2,'SetTagVal','trgdelay',(multsnd{trace_num}.pre+multsnd{trace_num}.trgdelay));  %%delay relative to zero for trigger in ms
%         else
%             'unable to set trigger delay'
%         end 
%%%Removed all instances of RP_2 DJT 7/30/2012 
'Tried accessing RP_2 in run_inter_mat_curve.m, which has been removed'
        stim_curve=1;
    case 7      %%old av test now place holder 
    case 8  %%vis az
        dotcenter(1)=multsnd{trace_num}.Var1array(Var1_place);
        vis_stim=1;
    case 9  %%vis el
        dotcenter(2)=multsnd{trace_num}.Var1array(Var1_place);
        vis_stim=1;
    case 10 %%vis lum
        fore_lum=multsnd{trace_num}.Var1array(Var1_place);
        vis_stim=1;
    case 11  %% vis angle
        angle=multsnd{trace_num}.Var1array(Var1_place)
        vis_stim=1;
    case 12  %% AVflank
        present_sound_array(1)=multsnd{trace_num}.Var1array(Var1_place)-multsnd{trace_num}.ITDflank;
        dotcenter(1)= (multsnd{trace_num}.Var1array(Var1_place)+multsnd{trace_num}.ITDflank)/2.5;
        vis_stim=1;
        aud_stim=1;
    case 13  %%Az2
        dotcenter2(1)=multsnd{trace_num}.Var1array(Var1_place);
    case 14  %%El2
        dotcenter2(2)=multsnd{trace_num}.Var1array(Var1_place);
    case 15  %%VVflank 
        dotcenter2(1)= multsnd{trace_num}.Var1array(Var1_place)-multsnd{trace_num}.ITDflank/2.5;
        dotcenter(1)= multsnd{trace_num}.Var1array(Var1_place)+multsnd{trace_num}.ITDflank/2.5;
    case 16    %% ITD2
        present_sound_array(9)=multsnd{trace_num}.Var1array(Var1_place);              %%update this Var1 position
        aud_stim=1;
    case 17  %% ILD2
        present_sound_array(10)=multsnd{trace_num}.Var1array(Var1_place);              %%update this Var1 position
        aud_stim=1;
    case 18  %% ABI2
        present_sound_array(11)=multsnd{trace_num}.Var1array(Var1_place);              %%update this Var1 position
        aud_stim=1;
    case 19  %%ITDFlank
        present_sound_array(1)=multsnd{trace_num}.Var1array(Var1_place)-multsnd{trace_num}.ITDflank;
        present_sound_array(9)=multsnd{trace_num}.Var1array(Var1_place)+multsnd{trace_num}.ITDflank;
        aud_stim=1;
end
%% update the stimuli based on the current values FOR VAR2
switch multsnd{trace_num}.Var2         %
    case 1  %%ITD
        present_sound_array(1)=multsnd{trace_num}.Var2array(Var2_place);
        aud_stim=1;
    case 2  %%ILD
        present_sound_array(2)=multsnd{trace_num}.Var2array(Var2_place);              %%update this Var2 position
        aud_stim=1;    
    case 3  %%ABI
        present_sound_array(3)=multsnd{trace_num}.Var2array(Var2_place);              %%update this Var2 position
        aud_stim=1;    
    case 4   
    case 5     
    case 6      %%stim
        multsnd{trace_num}.trgdelay=multsnd{trace_num}.Var2array(Var2_place);
%         if invoke(RP_2,'SetTagVal','trgdelay',(multsnd{trace_num}.pre+multsnd{trace_num}.trgdelay));  %%delay relative to zero for trigger in ms
%         else
%             'unable to set trigger delay'
%         end
%%% Removed all instances of RP_2 DJT 7/30/2012 
'Tried accessing RP_2 in run_inter_mat_curve, which has been removed'
        stim_curve=1;
    case 7      %%none
    case 8  %%vis az
        dotcenter(1)=multsnd{trace_num}.Var2array(Var2_place);
        vis_stim=1;
    case 9  %%vis el
        dotcenter(2)=multsnd{trace_num}.Var2array(Var2_place);
        vis_stim=1;
    case 10 %%vis lum
        fore_lum=multsnd{trace_num}.Var2array(Var2_place);
        vis_stim=1;
    case 11  %% vis angle
        angle=multsnd{trace_num}.Var2array(Var2_place);
        vis_stim=1;
    case 12  %%for now, these are nothings.
    case 13  %%Az2
        dotcenter2(1)=multsnd{trace_num}.Var2array(Var2_place);
    case 14  %%El2
        dotcenter2(2)=multsnd{trace_num}.Var2array(Var2_place);
    case 15 
    case 16    %% ITD2
        present_sound_array(9)=multsnd{trace_num}.Var2array(Var2_place);              %%update this Var1 position
        aud_stim=1;
    case 17  %% ILD2
        present_sound_array(10)=multsnd{trace_num}.Var2array(Var2_place);              %%update this Var1 position
        aud_stim=1;
    case 18  %% ABI2
        present_sound_array(11)=multsnd{trace_num}.Var2array(Var2_place);              %%update this Var1 position
        aud_stim=1;
        
end

%% Tag Traces - this is so we can know what trace happens when we convert 
%%from Spike2 back to OwlLand DJT 10/7/2013
% multsnd{trace_num}

%%  %%%%%%% PRESENT THE STIMULI           
presentAM(present_sound_array,Wave_pointer);
movedot(snd.window,dotcenter,dotcenter2,fore_lum,fore_lum2,multsnd{trace_num}.background,angle,multsnd{trace_num}.angle2,multsnd{trace_num}.dotsize,multsnd{trace_num}.dotsize2,multsnd{trace_num}.pre,multsnd{trace_num}.amp_mod_vis,multsnd{trace_num}.Freq_mod,multsnd{trace_num}.duration,multsnd{trace_num}.vis_offset,stim_curve, multsnd{trace_num}.distance, multsnd{trace_num}.distance2,[multsnd{trace_num}.play_vis1,multsnd{trace_num}.play_vis2],multsnd{trace_num}.size_change, snd.size_change2);      %%set vis and trigger sound    
%size_change-->size_change2 ... made changes independent DJT 10/4/2013

%%Collect the spike data.  THE 'spikedata' ARRAY WILL COME BACK IN ONE OF TWO POSSIBLE FORMATS.  
%%IF "SAVE SPIKES" IS SELECTED, THEN THE ARRAY WILL HAVE 'rec.wavesamples' (approx 40) ELEMENTS 
%%FOR EACH SPIKE-- THE FIRST POINT IS SPIKE TIME AND THE REMAINING POINTS ARE THE WAVEFORM.  IF 
%%"SAVE SPIKES" IS *NOT* SELECTED, THEN THE ARRAY WILL HAVE JUST ONE ELEMENT FOR EACH SPIKE-- THE
%%SPIKE TIME.
spikedata = acquire_spikes(rec.numch); 

% Set up arrays to hold waveforms for this iteration of run_inter_mat_curve (one stimulus presentation). At end of this 
% function, waveforms will get printed to temp files (an alternative to using snd.dataWaves-- saves on memory.)
if snd.save_spikes
    spike_count=0;                
    for currentchan=[1:rec.numch]    
        numSpikes = floor (length(spikedata{currentchan}) / rec.wavesamples);  % floor ignores unfinished waves                    
        spike_count = spike_count + numSpikes;
    end                          
    waves = zeros(rec.wavesamples-1, spike_count); % matrix to save waveforms 
    allspikes=0;   % counter for all spikes seen in this iteration of run_inter_mat_curve 
    multsnd{trace_num}.stimulus=multsnd{trace_num}.stimulus+1;  % count a new iteration of run_inter_mat_curve
    multsnd{trace_num}.wavelist = [multsnd{trace_num}.wavelist, multsnd{trace_num}.stimulus];  %keep a list of waves for save_inter_file_bin
end

% Fill in data for each spike
for currentchan=[1:rec.numch]  
    if snd.save_spikes
        numSpikes = floor (length(spikedata{currentchan}) / rec.wavesamples); 
    else
        numSpikes = length(spikedata{currentchan});
    end
    for spike=[1:numSpikes]    %%  loop through all the spike data
        if snd.save_spikes
            allspikes=allspikes+1;
        end
        multsnd{trace_num}.spikeplace= multsnd{trace_num}.spikeplace+1;
        
        %%% increase the size of the datamatrix if necessary
        if multsnd{trace_num}.spikeplace>length(multsnd{trace_num}.dataVar1)       
            multsnd{trace_num}.dataVar1=[multsnd{trace_num}.dataVar1,zeros(1,50000)];
            multsnd{trace_num}.dataVar2=[multsnd{trace_num}.dataVar2,zeros(1,50000)];
            multsnd{trace_num}.datachan=[multsnd{trace_num}.datachan,zeros(1,50000)];
            multsnd{trace_num}.datatime=[multsnd{trace_num}.datatime,zeros(1,50000)];
            multsnd{trace_num}.datarep=[multsnd{trace_num}.datarep,zeros(1,50000)];
            %                             if snd.save_spikes     
            %                                 multsnd{trace_num}.dataWave=[multsnd{trace_num}.dataWave,zeros(rec.wavesamples-1,50000)];
            %                             end;
        end;
        drawnow;
        %something like this--->>>snd.dataVar1(snd.spikeplace,snd.spikeplace+length(AllSpikes{currentchan}))=snd.Var1array(Var1_place);
        multsnd{trace_num}.dataVar1(multsnd{trace_num}.spikeplace)= multsnd{trace_num}.Var1array(Var1_place);
        multsnd{trace_num}.dataVar2(multsnd{trace_num}.spikeplace)= multsnd{trace_num}.Var2array(Var2_place);
        multsnd{trace_num}.datachan(multsnd{trace_num}.spikeplace)=currentchan;
        multsnd{trace_num}.datarep(multsnd{trace_num}.spikeplace)=rep;
        
        %%%%%%%%%%%% Need to extract spiketime differently depending on which format the data is in.
        if snd.save_spikes                                                            
            element = (spike-1)*rec.wavesamples + 1;  % calculate the first element of this spike's waveform                        
            multsnd{trace_num}.datatime(multsnd{trace_num}.spikeplace) = spikedata{currentchan}(element) - multsnd{trace_num}.pre; % spike time is first element                            
            waves(:,allspikes) = spikedata{currentchan}(element+1 : element+rec.wavesamples-1)'; % waveform is the rest                            
            % multsnd{trace_num}.dataWave(:,multsnd{trace_num}.spikeplace) = spikedata{currentchan}(element+1 : element+rec.wavesamples-1)'; % waveform is the rest
        else    
            multsnd{trace_num}.datatime(multsnd{trace_num}.spikeplace) = spikedata{currentchan}(spike) - multsnd{trace_num}.pre;  
        end              
        %%%%%%%%%%%% 
        
        if multsnd{trace_num}.datatime(multsnd{trace_num}.spikeplace) <= 0  %%save the data in a summary matrix
            multsnd{trace_num}.datamat_pre(Var2_place,Var1_place,currentchan)= multsnd{trace_num}.datamat_pre(Var2_place,Var1_place,currentchan)+1;
        else
            if and(multsnd{trace_num}.datatime(multsnd{trace_num}.spikeplace) <= multsnd{trace_num}.rangemax, multsnd{trace_num}.datatime(multsnd{trace_num}.spikeplace)>= multsnd{trace_num}.rangemin)
                multsnd{trace_num}.datamat_post(Var2_place,Var1_place,currentchan)=multsnd{trace_num}.datamat_post(Var2_place,Var1_place,currentchan)+1;
            end
        end;
        
        drawnow;
    end;  %% end spike train loop
end;   %%end currentchan loop   

% Save 'waves' array to the temp file for the appropriate trace
if snd.save_spikes
    eval(sprintf ('w%d = waves;', multsnd{trace_num}.stimulus))  % store wave in numbered variable to preserve ordering information                    
    currentdir=pwd;	
    tempfile=strcat(currentdir,'\..\temp_waves\trace',num2str(trace_num));  % print to a temp file for this trace #
    
    if exist([tempfile,'.mat'],'file')==2
        eval(sprintf('save(''%s'',''w%d'',''-append'');', tempfile, multsnd{trace_num}.stimulus));
    else
        eval(sprintf('save(''%s'',''w%d'');', tempfile, multsnd{trace_num}.stimulus));
    end                            
    waves=[];
    eval(sprintf ('w%d = [];', multsnd{trace_num}.stimulus));
end



return;

