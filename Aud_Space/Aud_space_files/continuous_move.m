function   continuous_move(cont_trace,rep,window,RA16_type)
    global multcont multsnip snd rec RP_1 RP_2 RA_16 zbus pa5_1 pa5_2;

    cont=multcont{cont_trace};

    noise_rate=cont.noise_hz;
    error_flag=1;
    
    switch cont.motion_type
        case 1  %%colored noise
            %%% This is where the colored noise function should go
            fprintf(1,'\n%s','Noise is not yet set up');
%             drawnow;
%             break
%             break
%             break
%             break
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        case 2  %%single sweep
            %% make the visual stimuli
            if cont.az_min==cont.az_max %% if Azimuth is not ranging
                vis_pos_x=ones(1,round(cont.time*60))*cont.az_min;
                vis_pos_y=ones(size(vis_pos_x))*cont.vis_el;    %%set elevation to vis_el
              else %%if az is ranging
                vis_bin=(cont.az_max-cont.az_min)/60/cont.time;      %%bin size for 60 hz
                vis_pos_x=[cont.az_min+(vis_bin/2):vis_bin:cont.az_max-(vis_bin/2)]; %% set the azimuth frames
                vis_pos_y=ones(size(vis_pos_x))*cont.vis_el;    %%set elevation to vis_el
            end
            
            %%make the auditory stimuli
            if cont.ITD_min==cont.ITD_max %% if ITD is not ranging
                cont.ITD_pos=ones(1,round(cont.time*500))*cont.ITD_min;
              else %%if ITD is ranging
                ITD_bin=(cont.ITD_max-cont.ITD_min)/500/cont.time;     %% bin size for 500 hz
                cont.ITD_pos=[cont.ITD_min+(ITD_bin/2):ITD_bin:cont.ITD_max-(ITD_bin/2)]; %% aud sampled at 500 Hz
            end
            
            if cont.dir==2  %%if left flip the stimuli around
                vis_pos_x=fliplr(vis_pos_x);
                vis_pos_y=fliplr(vis_pos_y);
                cont.ITD_pos=fliplr(cont.ITD_pos);
            end
            
    end; 
    cont.vis_pos_array=zeros(2,length(vis_pos_x));
    radius_adjust=ones(2,length(vis_pos_x));
    cont.vis_pos_array(1,:)=vis_pos_x;
    cont.vis_pos_array(2,:)=vis_pos_y;
    
    cont.vis_lum=ones(1,length(vis_pos_x));

    
    
    radius_adjust(1,:)=cont.vis_radius_h;
    radius_adjust(2,:)=cont.vis_radius_v;
    
    
    cont.ITD_pos=cont.ITD_pos+cont.ITD_offset;        %%shift the ITD relative to the vis
    ITD_pos=cont.ITD_pos/1000;  %% convert from microsecs to millisecs for the RPVDs
    
    
    
    
    vis_pos_array_min=convert_array_to_pixels(cont.vis_pos_array-radius_adjust,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    vis_pos_array_max=convert_array_to_pixels(cont.vis_pos_array+radius_adjust,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});

    
        amplitude=cont.amplitude;
        if cont.present_aud==0
            amplitude=0;
        end;
        if cont.present_vis==0
            cont.vis_lum=cont.back*cont.vis_lum;
          else
            cont.vis_lum=cont.fore*cont.vis_lum;
        end;



    if RA16_type==1
        set_RA16     %%%import values from Aud_spaces
    end
    
    
    abi= abs(cont.abi);
    
    attenL1 = abi + cont.ILD/2 ;
    attenR1 = abi - cont.ILD/2 ;
  
    invoke(RP_1,'halt'); 
%     invoke(RP_2,'halt');  Removed all instances of RP_2 DJT 7/30/2012 
    invoke(RA_16,'halt'); 


       %% set attenuators 
    if invoke(pa5_1,'SetAtten', attenL1);
    else
        e='Left AP5 error'
        error_flag=error_flag*2;
    end
    if invoke(pa5_2,'SetAtten',attenR1);
    else
        e='Right AP5 error'
        error_flag=error_flag*3;
    end
    if invoke(RP_1,'SetTagVal','rise',0.1);
    else
        'unable to set rise value'
        error_flag=error_flag*5;
    end
    if invoke(RP_1,'SetTagVal','duration',cont.time*1000);
    else
        'unable to set duration value'
        error_flag=error_flag*7;
    end
    if invoke(RA_16,'SetTagVal','collecttime',cont.time*1000);
        else
        'unable to set collecttime value'
        error_flag=error_flag*11;
    end
    if invoke(RP_1,'SetTagVal','amp',amplitude);
        else
        'unable to set amplitude value'
        error_flag=error_flag*13;
    end

    ITD_pos_L=zeros(size(ITD_pos));
    ITD_pos_R=ITD_pos_L;
    
    ITD_pos_L(find(ITD_pos>0))=ITD_pos(find(ITD_pos>0));
    ITD_pos_R(find(ITD_pos<0))=abs(ITD_pos(find(ITD_pos<0)));
   
   
    if invoke(RP_1,'WriteTagV','moving_wv_L',0,ITD_pos_L+.05)
    else
        e='moving_wv_L incorrectly loaded' 
        error_flag=error_flag*17;
    end
    if invoke(RP_1,'WriteTagV','moving_wv_R',0,ITD_pos_R+.05)
    else
        e='moving_wv_R incorrectly loaded' 
        error_flag=error_flag*19;
    end

    
    invoke(RP_1,'run'); 
%     invoke(RP_2,'run'); Removed all instances of RP_2 DJT 7/30/2012 
    invoke(RA_16,'run'); 
    
    
    
    
    %%%% save all if the stim is random, and only the first rep if the stim
    %%%% is frozen
        multcont{cont_trace}.ITD_pos{rep}=cont.ITD_pos;
        multcont{cont_trace}.vis_pos_array{rep}=cont.vis_pos_array;
        multcont{cont_trace}.error_flag(rep)=error_flag;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    

%%present the stimuli
    run_continuous(vis_pos_array_min,vis_pos_array_max,1,cont.vis_lum,cont.back,window);

        
            %%Collect the spike data.  THE 'spikedata' ARRAY WILL COME BACK IN ONE OF TWO POSSIBLE FORMATS.  
            %%IF "SAVE SPIKES" IS SELECTED, THEN THE ARRAY WILL HAVE 'rec.wavesamples' (approx 40) ELEMENTS 
            %%FOR EACH SPIKE-- THE FIRST POINT IS SPIKE TIME AND THE REMAINING POINTS ARE THE WAVEFORM.  IF 
            %%"SAVE SPIKES" IS *NOT* SELECTED, THEN THE ARRAY WILL HAVE JUST ONE ELEMENT FOR EACH SPIKE-- THE
            %%SPIKE TIME.
            spikedata = acquire_spikes(rec.numch, 1);   % arg 2 indicates calling acquire_spikes from run_continuous                        
            
            % Fill in data for each spike
            for currentchan=[1:rec.numch]  
                 if multcont{cont_trace}.save_snips
                    numSpikes = floor (length(spikedata{currentchan}) / rec.wavesamples);  % floor ignores unfinished waves
                    waves{currentchan} = zeros(rec.wavesamples-1, numSpikes); % matrix to save waveforms
                 else
                     numSpikes = length(spikedata{currentchan});
                 end
                 
                 multcont{cont_trace}.spike_times{rep}.chan{currentchan}=[];%%clear old data
                 
                 for spike=[1:numSpikes]    %%  loop through all the spike data
                        %%%%%%%%%%%% Need to extract spiketime differently depending on which format the data is in.
                        if multcont{cont_trace}.save_snips                            
                            element = (spike-1)*rec.wavesamples + 1;  % calculate the first element of this spike's waveform                        
                            multcont{cont_trace}.spike_times{rep}.chan{currentchan}(spike) = spikedata{currentchan}(element); % spike time is first element                            
                            waves{currentchan}(:,spike) = spikedata{currentchan}(element+1 : element+rec.wavesamples-1)'; % waveform is the rest                            
                        else    
                            multcont{cont_trace}.spike_times{rep}.chan{currentchan}(spike) = spikedata{currentchan}(spike);  
                        end              
                 end;  
            end;     
                
                
                % Save 'waves' array to the temp file for the appropriate trace
                if multcont{cont_trace}.save_snips
                    eval(sprintf ('w%d = waves;', rep))  % store wave in numbered variable to preserve ordering information                    
                    currentdir=pwd;	
                    tempfile=strcat(currentdir,'\..\temp_waves\trace',num2str(cont_trace));  % print to a temp file for this trace #
                    
                    if exist([tempfile,'.mat'],'file')==2
                        %sprintf('save(''%s'',''w%d'',''-append'');', tempfile, rep)
                        eval(sprintf('save(''%s'',''w%d'',''-append'');', tempfile, rep));
                    else
                        %sprintf('save(''%s'',''w%d'');', tempfile, rep)
                        eval(sprintf('save(''%s'',''w%d'');', tempfile, rep));
                    end                            
                    waves=[];
                    eval(sprintf ('w%d = [];', rep));
                end
                
            
 return;



