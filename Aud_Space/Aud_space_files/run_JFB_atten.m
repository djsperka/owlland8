function run_JFB_atten()
    global snd rec stopf zbus atten

    
    
    %%%set parameters without ui
    sq_color=abs(snd.foreground-snd.background)/2;
    prime_time=1.5; %%time in seconds for the priming stimulus
    snd.isi=3000;
    stopf=0;
    snd.pre=50;
    snd.post=prime_time*1000+50
    snd.play_sound1=0;
    snd.play_sound2=0;
    rec.numch=1;  %%only set up for one channel
    atten.post_range=[0,snd.post];
    rec.collecttime=snd.pre+snd.post;
    set_RA16;   %%update the values to the RA_16
    
    
    atten.spike_place=0;   %%data structures
    atten.time=zeros(1,500000);
    atten.rep=zeros(1,500000);        %%for both variables
    atten.condition=zeros(1,500000);        %%for both variables

    atten.sum_pre=zeros(6,snd.reps); %%structure for summary data
    atten.sum_post=zeros(6,snd.reps);
    
    
    
    %%Get the necessary user input
    uimenufcn(gcf,'WindowCommandWindow');
    home
    prime_dist=input('distance for priming dot to move? ');
    RF_offset=input('How many degrees should the edge of occluder be offset from the RF? ');
    occluder_size=input('How big (deg square) should the occluders be? ');
% % % % % % % % % % % %     
% % % % % % % % % % % %     temporary short cut
% % % % % % % % % % % %     prime_dist=15;
% % % % % % % % % % % %     RF_offset=2;
% % % % % % % % % % % %     occluder_size=3*snd.dotsize;

    fprintf(1,'\n\t\t\t\t\t%s\n%s\t%s\t\t%s\n\t\t\t\t\t%s\n\n','1','directions are numbered as','4','2','3')
    RF_corner=input('Direction of motion into the RF? ');
    if or(RF_corner<0,RF_corner>4)
        return
    end
    
    non_RF_corner=input('Direction of motion away from RF? ');
    if or(non_RF_corner<0,RF_corner>4)
        return
    end
    
    
    
    
        
    

    
    
    
    %%calculate a few things based on the user inputs
    prime_start=[snd.az,snd.el];
    RF_loc=[snd.az,snd.el];
    occ_loc_1=RF_loc;
    
    if RF_corner==1
        prime_start(2)=snd.el-prime_dist;
        occ_loc_1=occ_loc_1+[0,-RF_offset-occluder_size/2];
        end_loc1=RF_loc+[0,RF_offset];
    elseif RF_corner==2
        prime_start(1)=snd.az-prime_dist;
        occ_loc_1=occ_loc_1+[-RF_offset-occluder_size/2,0];
        end_loc1=RF_loc+[RF_offset,0];
    elseif RF_corner==3
        prime_start(2)=snd.el+prime_dist;
        occ_loc_1=occ_loc_1+[0,+RF_offset+occluder_size/2];
        end_loc1=RF_loc+[0,-RF_offset];
    elseif RF_corner==4
        prime_start(1)=snd.az+prime_dist;
        occ_loc_1=occ_loc_1+[+RF_offset+occluder_size/2,0];
        end_loc1=RF_loc+[-RF_offset,0];
    end


    
    
    occ_loc_2=prime_start;
    if non_RF_corner==1
        occ_loc_2=occ_loc_2+[0,prime_dist-RF_offset-occluder_size/2];
        non_RF_loc=prime_start+[0,prime_dist];
        end_loc2=non_RF_loc+[0,RF_offset];
    elseif non_RF_corner==2
        occ_loc_2=occ_loc_2+[prime_dist-RF_offset-occluder_size/2,0];
        non_RF_loc=prime_start+[prime_dist,0];
        end_loc2=non_RF_loc+[RF_offset,0];
    elseif non_RF_corner==3
        occ_loc_2=occ_loc_2+[0,-prime_dist+RF_offset+occluder_size/2];
        non_RF_loc=prime_start+[0,-prime_dist];
        end_loc2=non_RF_loc+[0,-RF_offset];
    elseif non_RF_corner==4
        occ_loc_2=occ_loc_2+[-prime_dist+RF_offset+occluder_size/2,0];
        non_RF_loc=prime_start+[-prime_dist,0];
        end_loc2=non_RF_loc+[-RF_offset,0];
    end
        
    
    %%calculate the locations of the occluders
    occ_PT1=[0,0,0,0];
    occ_PT1(1:2)=converttopixels(occ_loc_1-occluder_size/2,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    occ_PT1(3:4)=converttopixels(occ_loc_1+occluder_size/2,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    
    
    occ_PT2=[0,0,0,0];
    occ_PT2(1:2)=converttopixels(occ_loc_2-occluder_size/2,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    occ_PT2(3:4)=converttopixels(occ_loc_2+occluder_size/2,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});

    
    
    
    
    
        %%Check to make sure all of the parameters work with the visual
        %%settings
    snd.window=SCREEN(0,'OpenWindow',0);  HideCursor; %open window and hide cursor
    screen(snd.window,'FillRect',gamma_correct(snd.background)*snd.white);       %%  Blank the Screen with the background color

    temp_plot=[0,0,0,0];
    temp_plot(1:2)=converttopixels(prime_start-2,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    temp_plot(3:4)=converttopixels(prime_start+2,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    screen(snd.window,'Filloval',snd.white*[0,0,1],temp_plot); %%

    temp_plot(1:2)=converttopixels([snd.az,snd.el]-2,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    temp_plot(3:4)=converttopixels([snd.az,snd.el]+2,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    screen(snd.window,'Filloval',snd.white*[1,0,0],temp_plot); %%

    temp_plot(1:2)=converttopixels(non_RF_loc-2,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    temp_plot(3:4)=converttopixels(non_RF_loc+2,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    screen(snd.window,'Filloval',snd.white*[0,1,0],temp_plot); %%
    
    screen(snd.window,'FillRect',gamma_correct(sq_color)*snd.white,occ_PT1); %% Display occluder 1
    screen(snd.window,'FillRect',gamma_correct(sq_color)*snd.white,occ_PT2); %% Display occluder 2
    pause
    screen('closeall')
    
    vis_param_check=input('Input 0 if these params do not work. ');
    if vis_param_check==0
        return
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    
    
    
    
    
    
    
    
    
    
    
        

    
    
    
    

    
    %%calculate the paths for the two possible visual stimuli
    screen_num=prime_time*snd.hz;
    vis_step1=(end_loc1-prime_start)/(screen_num-1);
    for i=1:screen_num;
        vis_center1(i,:)=prime_start+((i-1)*vis_step1);
    end
    vis_min1=vis_center1-(snd.dotsize/2);
    vis_max1=vis_center1+(snd.dotsize/2);
    vis_min_PT1=convert_array_to_pixels(vis_min1',snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    vis_max_PT1=convert_array_to_pixels(vis_max1',snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    
    %%%probably want to put a trigger in here
    vis_step2=(end_loc2-prime_start)/(screen_num-1);
    for i=1:screen_num;
        vis_center2(i,:)=prime_start+((i-1)*vis_step2);
    end
    vis_min2=vis_center2-(snd.dotsize/2);
    vis_max2=vis_center2+(snd.dotsize/2);
    vis_min_PT2=convert_array_to_pixels(vis_min2',snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    vis_max_PT2=convert_array_to_pixels(vis_max2',snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    
    prime_bins=abs(round(screen_num*sum((occ_loc_1-prime_start)/(end_loc1-prime_start))));  %%number of frames of priming stimulus
    
   
    
    %%Start the stimuli and data acquisition
    
    
    
    
    
    
    
    
    
    
    
    %% open the visual window and display the occluders
    snd.window=SCREEN(0,'OpenWindow',0);  HideCursor; %open window and hide cursor
    screen(snd.window,'FillRect',gamma_correct(snd.background)*snd.white);       %%  Blank the Screen with the background color
    screen(snd.window,'FillRect',snd.black*[1,1,1],snd.trigger_loc); %% black out the box for the trigger
    screen(snd.window,'FillRect',gamma_correct(sq_color)*snd.white,occ_PT1); %% Display occluder 1
    screen(snd.window,'FillRect',gamma_correct(sq_color)*snd.white,occ_PT2); %% Display occluder 2
    priorityLevel=MaxPriority(snd.window,'WaitBlanking');
    

    
    tic
    
    for rep=1:snd.reps
         figure(findobj(0,'tag','Aud_Space_win'));     %% set the control window as active
         set(findobj(gcf,'tag','Print_rep'),'string',['rep ' num2str(rep) ' of ' num2str(snd.reps)]); %%print the rep counter

        
        
        condition=randperm(6); %%random order to present stimuli in
        for cond_pt=1:length(condition)
        while toc<(snd.isi/1000) %%set the ISI timing
            drawnow
        end
        tic
        %%calculate the stimuli
        if condition(cond_pt)<5
            if mod(condition(cond_pt),2)==1 %%set up the first part of the stimulus
                disp_min=vis_min_PT1;
                disp_max=vis_max_PT1;
            else
                disp_min=vis_min_PT2;
                disp_max=vis_max_PT2;
            end
            
            if condition(cond_pt)<3
                disp_min(:,prime_bins+1:end)=vis_min_PT1(:,prime_bins+1:end);
                disp_max(:,prime_bins+1:end)=vis_max_PT1(:,prime_bins+1:end);
            else
                disp_min(:,prime_bins+1:end)=vis_min_PT2(:,prime_bins+1:end);
                disp_max(:,prime_bins+1:end)=vis_max_PT2(:,prime_bins+1:end);
            end
        elseif condition(cond_pt)==5    %%just the last part of the sweep INTO RF
            disp_min=vis_min_PT1;
            disp_max=vis_max_PT1;
            disp_min(:,1:prime_bins)=vis_min_PT1(:,1:prime_bins);%%squash the stimulus
            disp_max(:,1:prime_bins)=vis_min_PT1(:,1:prime_bins);   
            
        elseif condition(cond_pt)==6    %%just the last part of sweep OUT of RF
            disp_min=vis_min_PT2;
            disp_max=vis_max_PT2;
            disp_min(:,1:prime_bins)=vis_min_PT2(:,1:prime_bins);   
            disp_max(:,1:prime_bins)=vis_min_PT2(:,1:prime_bins);   
 
        end    
        
        %%%probably want to put a trigger in here
    RF_loop={
        'screen(snd.window,''WaitBlanking'');'
        'screen(snd.window,''FillOval'',[snd.white,snd.black,snd.black],snd.trigger_loc);'
        'screen(snd.window,''WaitBlanking'');'
        'screen(snd.window,''FillRect'',[snd.black,snd.black,snd.black],snd.trigger_loc);'
        'screen(snd.window,''WaitBlanking'',2);'
        'screen(snd.window,''FillOval'',gamma_correct(snd.background)*snd.white,[disp_min(1,1),disp_min(2,1),disp_max(1,1),disp_max(2,1)]);'
        'screen(snd.window,''FillRect'',sq_color*[1,1,1],occ_PT1);' 
        'screen(snd.window,''FillRect'',sq_color*[1,1,1],occ_PT2);' 

        'for i=2:screen_num;'
            'screen(snd.window,''WaitBlanking'');'
            'screen(snd.window,''FillOval'',gamma_correct(snd.background)*snd.white,[disp_min(1,i-1),disp_min(2,i-1),disp_max(1,i-1),disp_max(2,i-1)]);'
            'screen(snd.window,''FillOval'',gamma_correct(snd.foreground)*snd.white,[disp_min(1,i),disp_min(2,i),disp_max(1,i),disp_max(2,i)]);'
            'screen(snd.window,''FillRect'',gamma_correct(sq_color)*snd.white,occ_PT1);' 
            'screen(snd.window,''FillRect'',gamma_correct(sq_color)*snd.white,occ_PT2);' 
        'end;'
        'screen(snd.window,''WaitBlanking'');'
        'screen(snd.window,''FillRect'',gamma_correct(snd.background)*snd.white);'
        'screen(snd.window,''FillRect'',gamma_correct(sq_color)*snd.white,occ_PT1);' 
        'screen(snd.window,''FillRect'',gamma_correct(sq_color)*snd.white,occ_PT2);' 

    };



     %%%trigger the data collection here  
     invoke(zbus,'zBusTrigA',0,0,4); %%start the aud and data collection.

     RUSH(RF_loop,priorityLevel);   %present the movie
     
     
     spikedata = acquire_spikes(rec.numch); %%grab the spikes
     my_spikes=spikedata{1}-snd.pre;
     if length(my_spikes)
         num_spikes=length(my_spikes);
            
         spk_rg=[atten.spike_place+1:atten.spike_place+num_spikes];
         atten.spike_place=atten.spike_place+num_spikes;
         atten.time(spk_rg)=my_spikes;
         atten.rep(spk_rg)=rep;        %%for both variables
         atten.condition(spk_rg)=condition(cond_pt);        %%for both variables
         
        prepts=length(find(my_spikes<0));
        atten.sum_pre(condition,rep)=prepts; %%structure for summary data
        postpts=length(find(my_spikes>atten.post_range(1) & my_spikes<atten.post_range(2)));
        atten.sum_post(condition,rep)=postpts;
    end

     %%collect and summarize the data here
     
         if stopf==1
             break
         end
    end%%end of the stim loop

    %% here I could do some plotting of the data
    if stopf==1
         break
     end
end%%end of the reps loop
    

        
        %%trim the data down to the collected points
        atten.time=atten.time(1:atten.spike_place);
        atten.rep=atten.rep(1:atten.spike_place);
        atten.condition=atten.condition(1:atten.spike_place);


        atten.RF_loc=RF_loc;
        atten.non_RF_loc=non_RF_loc;
        atten.prime_start=prime_start;
        atten.prime_dist=prime_dist;
        atten.RF_offset=RF_offset;
        atten.occluder_size=occluder_size;
       
        atten.occ_loc_1=occ_loc_1;
        atten.occ_loc_2=occ_loc_2;
        atten.prime_time=prime_time;



screen('closeall')



%%%save data here
uisave({'snd','rec','atten'})

return;