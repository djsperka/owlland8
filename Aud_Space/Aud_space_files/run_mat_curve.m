function run_mat_curve(rep,stimulus_order,stimulus_place, total_stim_played) %%Added stimnum 8/8/2012 DJT
global snd rec stopf runf RP_1 RP_2 pa5_1 pa5_2 RA_16  zbus;

[Var2_place,Var1_place]=ind2sub(size(snd.datamat_pre(:,:,1)),stimulus_order(stimulus_place));

%With each stimulus presentation, store the values 8/8/2012 DJT
snd.Var1_pres_order(total_stim_played)=snd.Var1array(Var1_place);
snd.Var2_pres_order(total_stim_played)=snd.Var2array(Var2_place);

%If looming and static are interleaved, save their presentation order
if snd.inter_loom
    snd.Inter_loom_store(total_stim_played)=snd.size_change;
end

present_sound_array=[snd.itd1,snd.ild1,snd.abi1,0,snd.duration,snd.rise,snd.pre+snd.aud_offset,snd.amplitude,snd.itd2,snd.ild2,snd.abi2, snd.corr, snd.play_sound1, snd.play_sound2];      %%default sound array

angle=snd.angle;                    %% set the angle of motion
dotcenter=[snd.az,snd.el];          %%  set the visual location
dotcenter2=[snd.az2,snd.el2];          %%  set the visual location for vis2   
fore_lum=snd.foreground;            %%  set the visual luminance
fore_lum2=snd.foreground2;            %%  set the visual luminance for vis2

Wave_pointer=1;
snd.check=1;

stim_curve=0;   %this means not a electrical stim curve


switch snd.Var1         %%% update the stimuli based on the current values FOR VAR1
    case 1  %%ITD1
        present_sound_array(1)=snd.Var1array(Var1_place);     
    case 2  %%ILD1
        present_sound_array(2)=snd.Var1array(Var1_place);              %%update this Var1 position
    case 3  %%ABI1
        present_sound_array(3)=snd.Var1array(Var1_place);              %%update this Var1 position
    case 4  %%tone           
        Wave_pointer=((Var1_place-1)*snd.duration*60)+1;             %%set the wave_pointer to the proper wave section
    case 5   %%nbfreq
        Wave_pointer=((Var1_place-1)*snd.duration*60)+1;         %%set the wave_pointer to the proper wave section
    case 6      %%stim
        snd.trgdelay=snd.Var1array(Var1_place);
        if invoke(RP_2,'SetTagVal','trgdelay',(snd.pre+snd.trgdelay));  %%delay relative to zero for trigger in ms
        else
            'unable to set trigger delay'
        end
        stim_curve=1;
    case 7      %%old av test now place holder 
    case 8  %%vis az
        dotcenter(1)=snd.Var1array(Var1_place);
    case 9  %%vis el
        dotcenter(2)=snd.Var1array(Var1_place);
    case 10 %%vis lum
        fore_lum=snd.Var1array(Var1_place);
    case 11  %% vis angle
        angle=snd.Var1array(Var1_place);
    case 12  %% AVflank
        present_sound_array(1)=snd.Var1array(Var1_place)-snd.ITDflank;
        dotcenter(1)= (snd.Var1array(Var1_place)+snd.ITDflank)/2.5;
    case 13  %%Az2
        dotcenter2(1)=snd.Var1array(Var1_place);
    case 14  %%El2
        dotcenter2(2)=snd.Var1array(Var1_place);
    case 15  %%VVflank
        dotcenter2(1)= snd.Var1array(Var1_place)-snd.ITDflank/2.5;
        dotcenter(1)= snd.Var1array(Var1_place)+snd.ITDflank/2.5;
    case 16    %% ITD2
        present_sound_array(9)=snd.Var1array(Var1_place);              %%update this Var1 position
    case 17  %% ILD2
        present_sound_array(10)=snd.Var1array(Var1_place);              %%update this Var1 position
    case 18  %% ABI2
        present_sound_array(11)=snd.Var1array(Var1_place);              %%update this Var1 position
    case 19  %%ITDFlank
        present_sound_array(1)=snd.Var1array(Var1_place)-snd.ITDflank;
        present_sound_array(9)=snd.Var1array(Var1_place)+snd.ITDflank;
end

switch snd.Var2         %%% update the stimuli based on the current values FOR VAR2
    case 1  %%ITD
        present_sound_array(1)=snd.Var2array(Var2_place);
    case 2  %%ILD
        present_sound_array(2)=snd.Var2array(Var2_place);              %%update this Var2 position
    case 3  %%ABI
        present_sound_array(3)=snd.Var2array(Var2_place);              %%update this Var2 position
    case 4     
    case 5     
    case 6      %%stim
        snd.trgdelay=snd.Var2array(Var2_place);
        if invoke(RP_2,'SetTagVal','trgdelay',(snd.pre+snd.trgdelay));  %%delay relative to zero for trigger in ms
        else
            'unable to set trigger delay'
        end
        stim_curve=1;
    case 7      %%none
    case 8  %%vis az
        dotcenter(1)=snd.Var2array(Var2_place);
    case 9  %%vis el
        dotcenter(2)=snd.Var2array(Var2_place);
    case 10 %%vis lum
        fore_lum=snd.Var2array(Var2_place);
    case 11  %% vis angle
        angle=snd.Var2array(Var2_place);
    case 12  %%for now, these are nothings.
    case 13  %%Az2
        dotcenter2(1)=snd.Var2array(Var2_place);
    case 14  %%El2
        dotcenter2(2)=snd.Var2array(Var2_place);
    case 15  
        
    case 16    %% ITD2
        present_sound_array(9)=snd.Var2array(Var2_place);              %%update this Var1 position
    case 17  %% ILD2
        present_sound_array(10)=snd.Var2array(Var2_place);              %%update this Var1 position
    case 18  %% ABI2
        present_sound_array(11)=snd.Var2array(Var2_place);              %%update this Var1 position
        
end


%%%%  PRESENT THE STIMULI        
PresentAM(present_sound_array,Wave_pointer);  %%  set the sound
movedot(snd.window,dotcenter,dotcenter2,fore_lum,fore_lum2,snd.background,angle,snd.angle2,snd.dotsize,snd.dotsize2,snd.pre,snd.amp_mod_vis,snd.Freq_mod,snd.duration,snd.vis_offset,stim_curve, snd.distance, snd.distance2,[snd.play_vis1,snd.play_vis2],snd.size_change,snd.size_change2);      %%set vis and trigger sound

   
%%%COLLECT THE SPIKE DATA (unless this is a raw wave data collection for spike sort training).
if ~snd.collect_rawwave
    
    %%Get the spike data.  THE 'spikedata' ARRAY WILL COME BACK IN ONE OF TWO POSSIBLE FORMATS.  
    %%IF "SAVE SPIKES" IS SELECTED, THEN THE ARRAY WILL HAVE 'rec.wavesamples' (approx 40) ELEMENTS 
    %%FOR EACH SPIKE-- THE FIRST POINT IS SPIKE TIME AND THE REMAINING POINTS ARE THE WAVEFORM.  IF 
    %%"SAVE SPIKES" IS *NOT* SELECTED, THEN THE ARRAY WILL HAVE JUST ONE ELEMENT FOR EACH SPIKE-- THE
    %%SPIKE TIME.
    
    spikedata = acquire_spikes(rec.numch);                
    
    % build the data arrays/matrices
    for currentchan=[1:rec.numch]  %%this should take in all of the spikes from acquired data
        if snd.save_spikes
            numSpikes = floor (length(spikedata{currentchan}) / rec.wavesamples);  % floor ignores unfinished waves
        else
            numSpikes = length(spikedata{currentchan});
        end
        for spike=[1:numSpikes]    %%  loop through all the spike data
            snd.spikeplace=snd.spikeplace+1;
            if snd.spikeplace>length(snd.dataVar1)       %%% increase the size of the datamatrix if necessary
                snd.dataVar1=[snd.dataVar1,zeros(1,50000)];
                snd.dataVar2=[snd.dataVar2,zeros(1,50000)];
                snd.datachan=[snd.datachan,zeros(1,50000)];
                snd.datatime=[snd.datatime,zeros(1,50000)];
                snd.datarep=[snd.datarep,zeros(1,50000)];	
                snd.datatrial=[snd.datatrial,zeros(1,50000)];   %% Added 8/2/2012 DJT
                if snd.save_spikes     
                    snd.dataWave=[snd.dataWave,zeros(rec.wavesamples-1,50000)]; 
                end;
            end;
            drawnow;
            %something like this--->>>snd.dataVar1(snd.spikeplace,snd.spikeplace+length(AllSpikes{currentchan}))=snd.Var1array(Var1_place);
            snd.dataVar1(snd.spikeplace)=snd.Var1array(Var1_place);
            snd.dataVar2(snd.spikeplace)=snd.Var2array(Var2_place);
            snd.datachan(snd.spikeplace)=currentchan;
            snd.datarep(snd.spikeplace)=rep;
            snd.datatrial(snd.spikeplace)=stimulus_place;  %% Added 8/2/2012 DJT
            
            %%%%%%%%%%%% Need to extract spiketime differently depending on which format the data is in.
            if snd.save_spikes 
                element = (spike-1)*rec.wavesamples + 1;  % calculate the first element of this spike's waveform
                snd.datatime(snd.spikeplace)   = spikedata{currentchan}(element) - snd.pre; % spike time is first element
                snd.dataWave(:,snd.spikeplace) = spikedata{currentchan}(element+1 : element+rec.wavesamples-1)'; % waveform is the rest
                % snd.dataWave(:,snd.spikeplace)=AllWaves{currentchan}((spike-1)*68+2 : (spike*68-1))';  % grab data points #2-67 from waveform                            
            else
                snd.datatime(snd.spikeplace) = spikedata{currentchan}(spike) - snd.pre;  
            end              
            %%%%%%%%%%%%
            
            if snd.datatime(snd.spikeplace)<=0  %%save the data in a summary matrix
                snd.datamat_pre(Var2_place,Var1_place,currentchan)=snd.datamat_pre(Var2_place,Var1_place,currentchan)+1;
            else
                if and(snd.datatime(snd.spikeplace) <= snd.rangemax, snd.datatime(snd.spikeplace) >= snd.rangemin)
                    snd.datamat_post(Var2_place,Var1_place,currentchan)=snd.datamat_post(Var2_place,Var1_place,currentchan)+1;
                end
            end;         
            
            drawnow;
        end;  %% end spike train loop
        
    end;   %%end currentchan loop  
    
end;   % end "if ~snd.collect_rawwave"

return;

