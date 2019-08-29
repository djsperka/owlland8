function run_inter_tuning_curve()
    global snd rec stopf runf RP_1 RP_2 pa5_1 pa5_2 RA_16  zbus;
    % Clear screen
    % Generate empty data acquisition vectors
    % Establish vectors used for across-trace stimulus randomization(shuffling)
    % Implement run_mat_curve.cb
    % At the end of a rep, update the displays to show the results.
    % Close the visual stim displays, and run the save routine; save_file_dialog.m

    %Summary/DJT intepretation of stimulus selection; 4/13/2013
    %First select which stimulus to play.  This is done by assigning each
    %stim type (Both, V1, or V2) a numberical range (1:6=both, 7:9=V1, 10:11=V2).
    %Then generate a random shuffling of that range (randperm(11)).  Pull
    %numbers in order (3=both, 7=V1, 2=both etc) to select which stim gets
    %played.
    %Similar process is used to select variable values, using mat_order,
    %varr1_order and varr2_order
        
    tic
    rawwave_start=cputime;  
    snd.starttime=clock;    %%  time stamp
    rec.collecttime=(snd.pre+snd.post);
    if snd.collect_rawwave
        set_RA16_rawwave
    else
        set_RA16        %%  set values on the RA16
    end
    runf=1;
    
    snd.check=1;
    
    %% Clear the Screen
    if snd.play_vis1==1 || snd.play_vis2==1 || snd.screenblank==1    %%%if there is a visual stimulus or the screen was blanked
        snd.window=Screen(0,'OpenWindow',0);
        HideCursor;                         %%  Hide the cursor
        Screen(snd.window,'fillRect',gamma_correct(snd.background)*snd.white);       %%  Blank the Screen with the background color
        Screen(snd.window,'FillRect',[snd.black,snd.black,snd.black],snd.trigger_loc); %% black out the box for the trigger
    end

    %% Create empy vectors for acquiring data
%%%%%make all of the data arrays 
    snd.datachan=zeros(1,50000);        %%for both variables
    snd.datatime=zeros(1,50000);
    snd.datarep=zeros(1,50000);
    snd.dataVar1=zeros(1,50000);
    snd.dataVar2=zeros(1,50000);
    snd.datatrial=zeros (1,50000);  %% Added 8/2/2012 DJT
    snd.spikeplace=0;    
    if snd.save_spikes
        snd.dataWave=zeros(rec.wavesamples-1,50000);    
    else
        snd.dataWave=[];
    end
    
    snd.datachan_arr1=zeros(1,50000);   %%for variable 1
    snd.datatime_arr1=zeros(1,50000);
    snd.datarep_arr1=zeros(1,50000);
    snd.dataVar1_arr1=zeros(1,50000);
    snd.datatrial_arr1=zeros(1,50000);  %%Added 8/2/2012 DJT
    snd.spikeplace_arr1=0;
    if snd.save_spikes
        snd.dataWave_arr1=zeros(rec.wavesamples-1,50000);    
    else
        snd.dataWave_arr1=[];
    end
    
    snd.datachan_arr2=zeros(1,50000);   %%for variable 2
    snd.datatime_arr2=zeros(1,50000);
    snd.datarep_arr2=zeros(1,50000);
    snd.dataVar2_arr2=zeros(1,50000);
    snd.datatrial_arr2=zeros(1,50000);  %%Added 8/2/2012 DJT
    snd.spikeplace_arr2=0;
    if snd.save_spikes
        snd.dataWave_arr2=zeros(rec.wavesamples-1,50000);    
    else
        snd.dataWave_arr2=[];
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%make all of the summary data arrays 
    snd.datamat_pre = zeros(length(snd.Var2array),length(snd.Var1array),rec.numch);
    snd.datamat_post = snd.datamat_pre;

    %if interleaved loomers, give arr1_pre and post the same structure as
    %datamat pre and post
    if snd.inter_loom
        snd.data_arr1_pre = zeros(length(snd.Var2array),length(snd.Var1array),rec.numch);
    else
    snd.data_arr1_pre = zeros(2,length(snd.Var1array),rec.numch);
    end
    snd.data_arr1_post = snd.data_arr1_pre;

    snd.data_arr2_pre = zeros(length(snd.Var2array),2,rec.numch);
    snd.data_arr2_post = snd.data_arr2_pre;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




	matsize=length(snd.Var1array)*length(snd.Var2array);
	arr1size=length(snd.Var1array);
	arr2size=length(snd.Var2array);


    if snd.interleave_alone==0
        stimnum=matsize;      %%total number of stimuli when no interleaving
    else
        stimnum=matsize+arr1size+arr2size;      %%total number of stimuli
    end
    
    % If you are trying to interleave looming and static stim DJT 6/11/2013
    if snd.inter_loom && snd.play_vis1
        run_inter_loom_curve
        return
    end



	while toc<snd.startpause        %%  pause at the start of the trial
        drawnow;
	end
    h=findobj(gcf,'tag','Print_trace');
    set(h,'string',['Trace ' num2str(snd.trace)]);
    
    snd.Var1_pres_order=[]; %Added 6/11/2013 DJT
    snd.Var2_pres_order=[]; %Added 6/11/2013 DJT
    snd.Var1_pres_order(1:snd.reps*stimnum)=NaN; %% Added 8/8/2012 DJT
    snd.Var2_pres_order(1:snd.reps*stimnum)=NaN; %% Added 8/8/2012 DJT
            
    tic        
    total_stim_played=0; %Keep track of how many stim have played DJT 5/14/1013
        
    %% Loop through each rep, presenting stim
    for rep=[1:snd.reps]
        randorder=randperm(stimnum);            %%randomization of the overall stimtype
        
        %%pointers for the individual tuning curves
        mat_place=1;        
        array1_place=1;
        array2_place=1;
        
        %%order for the individual tuning curves
        mat_order=randperm(matsize);
        array1_order=randperm(arr1size);
        array2_order=randperm(arr2size);

        
        for i=[1:stimnum]
            total_stim_played=total_stim_played+1;    %added DJT 5/14/2013        
            %  print the rep info to the screen
            figure(findobj(0,'tag','Aud_Space_win'));     %% set the countour window as active
            h=findobj(gcf,'tag','Print_rep');
            set(h,'string',['rep ' num2str(rep) ' of ' num2str(snd.reps) ' : ' 'stim ' num2str(i) ' of ' num2str(stimnum)]);
 
           if snd.check==1   %%% refers to previous stimulus 
                while toc<(snd.isi/1000)
                    drawnow;
                end
            end
            tic
            if randorder(i)<=matsize
               run_mat_curve(rep,mat_order,mat_place,total_stim_played); % Added total_stim_played 5/14/2013 DJT
                mat_place=mat_place+1;
              else
                if randorder(i)<=matsize+arr1size
                    run_arr1_curve(rep,array1_order,array1_place,total_stim_played) % Added total_stim_played 5/14/2013
                    array1_place=array1_place+1;
                  else
                    run_arr2_curve(rep,array2_order,array2_place,total_stim_played) % Added total_stim_played 5/14/2013
                    array2_place=array2_place+1;
                end
            end     %%end of if statements
                % Break if user enters ctrl-k, or if collecting raw wave for spike sort training
                % and time has exceed 'snd.collect_seconds'
                if (stopf==1 || (snd.collect_rawwave && cputime-rawwave_start>snd.collect_seconds))
                    break
                end;
                
        end %% end stim loop 
            if (stopf==1 || (snd.collect_rawwave && cputime-rawwave_start>snd.collect_seconds))
                break
            end;
        
        if (snd.show_graph && ~snd.collect_rawwave)  
            set_graphs(rep)
        end
        
        end %%end rep loop




    %%%close the screen at the end
    if or(or(and(snd.Var1>7,snd.Var1<13),and(snd.Var2>7,snd.Var2<12)),snd.screenblank==1)    %%if there is a visual stimulus or the screen was blanked
        Screen('CloseAll');                 %%  Close the Screen
    end
    %%  delete all of the unwanted points%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    snd.dataVar1=snd.dataVar1(1:snd.spikeplace);                    %
    snd.dataVar2=snd.dataVar2(1:snd.spikeplace);                    %
    snd.datachan=snd.datachan(1:snd.spikeplace);                    %
    snd.datatime=snd.datatime(1:snd.spikeplace);                    %
    snd.datarep=snd.datarep(1:snd.spikeplace);                      %
    snd.datatrial=snd.datatrial(1:snd.spikeplace);                  % %%Added 8/2/2012 by DJT
                                                                    %
    snd.datachan_arr1=snd.datachan_arr1(1:snd.spikeplace_arr1);     %
    snd.datatime_arr1=snd.datatime_arr1(1:snd.spikeplace_arr1);     %
    snd.datarep_arr1=snd.datarep_arr1(1:snd.spikeplace_arr1);       %
    snd.dataVar1_arr1=snd.dataVar1_arr1(1:snd.spikeplace_arr1);     %
    snd.datatrial_arr1=snd.datatrial_arr1(1:snd.spikeplace_arr1);   % %%Added 8/2/2012 by DJT
                                                                    %
    snd.datachan_arr2=snd.datachan_arr2(1:snd.spikeplace_arr2);     %
    snd.datatime_arr2=snd.datatime_arr2(1:snd.spikeplace_arr2);     %
    snd.datarep_arr2=snd.datarep_arr2(1:snd.spikeplace_arr2);       %
    snd.dataVar2_arr2=snd.dataVar2_arr2(1:snd.spikeplace_arr2);     %
    snd.datatrial_arr2=snd.datatrial_arr2(1:snd.spikeplace_arr2);   % %%Added 8/2/2012 by DJT
                                                                    %
    if snd.save_spikes                                              %
        snd.dataWave=snd.dataWave(:,[1:snd.spikeplace]);            %
        snd.dataWave_arr1=snd.dataWave_arr1(:,[1:snd.spikeplace_arr1]);  %
        snd.dataWave_arr2=snd.dataWave_arr2(:,[1:snd.spikeplace_arr2]);  %        
	end                                                             %    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% display results
    snd.endtime=clock;
    if (~snd.show_graph && ~snd.collect_rawwave)  
        set_graphs(rep)
    end
    
    %% save it
    if (snd.training==0 && ~snd.collect_rawwave)
        save_file_dialog
    end
return;
