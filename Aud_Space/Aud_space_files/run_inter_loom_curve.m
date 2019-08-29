function run_inter_loom_curve
global snd rec stopf runf RP_1 RP_2 pa5_1 pa5_2 RA_16  zbus;

matsize=length(snd.Var1array)*length(snd.Var2array);
stimnum=matsize*2;

% 'running inter loom curve script'

while toc<snd.startpause        %%  pause at the start of the trial
        drawnow;
	end
    h=findobj(gcf,'tag','Print_trace');
            set(h,'string',['Trace ' num2str(snd.trace)]);
            snd.Var1_pres_order=[]; %added these three lines 6/11/2013 DJT
            snd.Var2_pres_order=[];
            snd.Inter_loom_store=[];
    snd.Var1_pres_order(1:snd.reps*stimnum)=NaN; % Added 8/8/2012 DJT
    snd.Var2_pres_order(1:snd.reps*stimnum)=NaN; % Added 8/8/2012 DJT
    snd.Inter_loom_store(1:snd.reps*stimnum)=NaN; % Added 6/11/2013 DJT
            
    tic        
    total_stim_played=0; %Keep track of how many stim have played DJT 5/14/1013
    save_sizechange=snd.size_change; %snd.size_change will be changing values, so keep a marker!
        
    for rep=[1:snd.reps]
        randorder=randperm(stimnum);            %%randomization of the overall stimtype
        
        %%pointers for the individual tuning curves
        mat_place=1;        
        array1_place=1;
        array2_place=1;
        
        %%order for the individual tuning curves
        mat_order=randperm(matsize);
        array1_order=randperm(matsize);
%         array2_order=randperm(arr2size);
        
        for i=[1:stimnum]
            total_stim_played=total_stim_played+1;    %added DJT 5/14/2013
            %%  print the rep info to the screen
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
                snd.size_change=0;
                run_mat_curve(rep,mat_order,mat_place,total_stim_played); % Added total_stim_played 5/14/2013 DJT
                mat_place=mat_place+1;
            else

                snd.size_change=save_sizechange;
                run_arr1_curve(rep,array1_order,array1_place,total_stim_played) % Added total_stim_played 5/14/2013
                array1_place=array1_place+1;

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


    snd.endtime=clock;
    if (~snd.show_graph && ~snd.collect_rawwave)  
        set_graphs(rep)
    end
    
    if (snd.training==0 && ~snd.collect_rawwave)
        save_file_dialog
    end
    %restore snd.size_change
    snd.size_change=save_sizechange;
return;
