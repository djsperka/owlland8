function jfb_pharmacology_tuning_curve()
    global snd rec runf stopf RP_1 RP_2;
    
    %%params that I might want to change...
        
     
    
    
    
    %%get user input
    clc; fprintf(1,'%s\n',['This function will present a single value ITD curve from the ITD and ILD selected in the stimulus window.']); drawnow;
    ITD_array_check = input('If the wrong ITD curve is selected, type 0 now.  ');
    if ITD_array_check==0
        return;
    end
    snd.reps=input('How many reps should be run? ');
    snd.isi=input('Set the ISI in ms: ');
    
    
    
    
    
    stopf=0;

    
    %% update all of the snd. params etc
    snd.save_spikes=0; %% NO SPIKE SAVING YET
    rec.numch=1; %%only works with one channel
    
    snd.Var1=1; %%run an ITD curve of only one value
    snd.Var1array=[snd.itd1];
    snd.Var1min=snd.itd1;
    snd.Var1max=snd.itd1;
    snd.Var1step=100;   %%finish setting the ITD curve values
    
    
    snd.pre=100;
    snd.post=600;
    snd.duration=500;
    
    
    %%%%%make all of the data arrays 
    snd.datachan=zeros(1,50000);        %%for both variables
    snd.datatime=zeros(1,50000);
    snd.datarep=zeros(1,50000);
    snd.dataVar1=zeros(1,50000);
    snd.dataVar2=zeros(1,50000);
    snd.spikeplace=0;

    post_rg=[0,snd.duration];%% range from which to count spikes
    hist_data=[];
        
    set(findobj(gcf,'tag','Print_trace'),'string',['Trace ' num2str(snd.trace)]);
    figure(findobj(0,'tag','disp_win_1')); clf;  
    figure(findobj(0,'tag','disp_win_2')); clf;
    figure(findobj(0,'tag','disp_win_3'));
    set(findobj(gcf,'tag','var1_ba'),'string','');
    set(findobj(gcf,'tag','var2_ba'),'string','');
    set(findobj(gcf,'tag','var1_alone_ba'),'string','');
    set(findobj(gcf,'tag','var2_alone_ba'),'string','');
    snd.ba_handle=[];
    
    %%%%%%%%%%%%%%%%%%%%
    
    
    
    %% Open a window for visual stimuli and start the pre pause
    snd.window=SCREEN(0,'OpenWindow',0);
    HideCursor;                         %%  Hide the cursor
    screen(snd.window,'fillRect',gamma_correct(snd.background)*snd.white);       %%  Blank the Screen with the background color
    screen(snd.window,'FillRect',[snd.black,snd.black,snd.black],snd.trigger_loc); %% black out the box for the trigger
    
    tic; while toc<5; drawnow; end; tic;  %% pause a bit after opening the window the pre waiting time

        play_sound=1;   %%play the sound
        play_vis=0;     %%never present a visual stimulus

        for rep=1:snd.reps %%cycle through each stimulus rep
             figure(findobj(0,'tag','Aud_Space_win'));     %% set the AS window as active
             h=findobj(gcf,'tag','Print_rep');
             set(h,'string',['rep ' num2str(rep) ' of ' num2str(snd.reps)]);

             while toc<(snd.isi/1000) %%set the ISI
                drawnow;
             end;
             tic
                         
                 
                present_sound_array=[snd.itd1,snd.ild1,snd.abi1,0,snd.duration,snd.rise,snd.pre,snd.amplitude,snd.itd2,snd.ild2,snd.abi2, snd.corr, play_sound,0];      %%default sound array
                presentAM(present_sound_array,1);   %%load the sound info to RPVDS
                movedot(snd.window,dotcenter,[0,0],snd.foreground,0,snd.background,snd.angle,0,snd.dotsize,1,snd.pre,0,1,snd.duration,0,0,snd.distance, 0,[play_vis,0],snd.size_change);      %%set vis and trigger sound    
                spikedata = acquire_spikes(rec.numch);  %%collect the data from RPVDS

                
                

                %%place the data into proper arrays
                my_spikes=spikedata{1}-snd.pre;
                num_spikes=length(my_spikes);
                spk_rg=[snd.spikeplace+1:snd.spikeplace+num_spikes];
                snd.spikeplace=snd.spikeplace+num_spikes;
                
                %%into original raster arrays
                snd.datachan(spk_rg)=1;        %%for both variables
                snd.datatime(spk_rg)=my_spikes;
                snd.datarep(spk_rg)=rep;
                snd.dataVar1(spk_rg)=snd.itd1;
                snd.dataVar2(spk_rg)=nan;
                                         
                post_spikes=length(find(my_spikes>post_rg(1) & my_spikes<=post_rg(2)));
                pre_spikes=length(find(my_spikes<0));
                hist_data(rep)=post_spikes-(pre_spikes*diff(post_rg)/snd.pre);
                
                
                
%                 %%plot the data every 5 reps
%                 if mod(rep,5)==0
                    
                    figure(findobj(0,'tag','disp_win_1')); clf;
                    plot(hist_data,'k*');

                    figure(findobj(0,'tag','disp_win_2')); hold on;
                    set(gca,'ylim',[0,snd.reps]);
                    plot(my_spikes,rep*ones(size(my_spikes)),'k.');
%                 end

                
                if stopf==1
                    break
                end;
            end %%end the rep loop
            
            
            screen('CloseAll');                 %%  Close the Screen
            
            
            %%  delete all of the unwanted points%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                snd.datachan=snd.datachan(1:snd.spikeplace);        
                snd.datatime=snd.datatime(1:snd.spikeplace);
                snd.datarep=snd.datarep(1:snd.spikeplace);
                snd.dataVar1=snd.dataVar1(1:snd.spikeplace);
                snd.dataVar2=snd.dataVar2(1:snd.spikeplace);

                
                save_file_dialog

    return;

