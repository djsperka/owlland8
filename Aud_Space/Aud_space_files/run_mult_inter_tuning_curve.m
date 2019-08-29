function run_mult_inter_tuning_curve()
global multsnd snd rec stopf runf RP_1 RP_2 pa5_1 pa5_2 RA_16  zbus check;
% For interleaved traces 
% Initiates data acquisition vectors, shuffles trials, plots last trial, and saves

% Clear screen
% Generate empty data acquisition vectors
% Establish vectors used for across-trace stimulus randomization(shuffling)
% Implement run_inter_mat_curve.cb
% At the end of a rep, update the displays to show the results.  Can only
% display one trace, so plots from last trace
% Close the visual stim displays, and run the save routine; save_inter_file_dialog.m

%Get rid of white opening screen for PTB DJT 3/10/2014
Screen ('Preference','VisualDebugLevel',3);

tic

N=length(multsnd);  %% N is the number of traces to be interleaved

for i=1:N
    multsnd{i}.starttime=clock;    %%  time stamp
end

rec.collecttime=(snd.pre+snd.post);
set_RA16        %%  set values on the RA16
runf=1;

check=1;

screenblank=0;
for i=1:N
    if or(and(multsnd{i}.Var1>7,multsnd{i}.Var1<13),and(multsnd{i}.Var2>7,multsnd{i}.Var2<12))
        screenblank=1;
    end
end
if or(screenblank==1,snd.screenblank==1)    %%%if there is a visual stimulus or the screen was blanked
    snd.window=Screen(0,'OpenWindow',0);
    window=snd.window;
    HideCursor;                         %%  Hide the cursor
    Screen(snd.window,'fillRect',gamma_correct(snd.background)*snd.white);       %%  Blank the Screen with the background color
    Screen(snd.window,'FillRect',[snd.black,snd.black,snd.black],snd.trigger_loc); %% black out the box for the trigger
end

currentdir=pwd;
delete(strcat(currentdir,'\..\temp_waves\trace*'));  % clear any files in temp dir

for i=1:N
    multsnd{i}.datachan=zeros(1,50000);        %%for both variables
    multsnd{i}.datatime=zeros(1,50000);
    multsnd{i}.datarep=zeros(1,50000);
    multsnd{i}.dataVar1=zeros(1,50000);
    multsnd{i}.dataVar2=zeros(1,50000);
    multsnd{i}.spikeplace=0;
    multsnd{i}.stimulus = 0;  
    multsnd{i}.wavelist = [];  
    
    
    multsnd{i}.datachan_arr1=[];   %%for variable 1
    multsnd{i}.datatime_arr1=[];
    multsnd{i}.datarep_arr1=[];
    multsnd{i}.dataVar1_arr1=[];
    multsnd{i}.spikeplace_arr1=0;
    
    multsnd{i}.datachan_arr2=[];   %%for variable 2
    multsnd{i}.datatime_arr2=[];
    multsnd{i}.datarep_arr2=[];
    multsnd{i}.dataVar2_arr2=[];
    multsnd{i}.spikeplace_arr2=0;
    
    multsnd{i}.datamat_pre = zeros(length( multsnd{i}.Var2array),length( multsnd{i}.Var1array),rec.numch);
    multsnd{i}.datamat_post = multsnd{i}.datamat_pre;
    
    multsnd{i}.data_arr1_pre = [];
    multsnd{i}.data_arr1_post = [];
    
    multsnd{i}.data_arr2_pre = [];
    multsnd{i}.data_arr2_post = [];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:N  
    % matsize has one element for each interleaved tuning curve, 
    % and the value of the element is the number of stimuli in that curve
    matsize(i)=length(multsnd{i}.Var1array)*length(multsnd{i}.Var2array);
end


stimnum_pointer(1)=0;
for i=2:N+1
    stimnum_pointer(i)=stimnum_pointer(i-1)+matsize(i-1);    
end %Not sure what the point of stimnum_pointer is ... looks like it is the
% same as matsize, except with a 0 as the first element

total_stimnum=sum(matsize); %num of stim that will be presented in each rep

while toc<snd.startpause        %%  pause at the start of the trial
    drawnow;
end
h=findobj(gcf,'tag','Print_trace');
set(h,'string',['Mult Trace ' num2str(snd.trace)]);

%Make sure variable presentation orders are wiped clean, then saved 10/8/2013 DJT
multsnd{1}.Var1_pres_order=[]; 
multsnd{1}.Var2_pres_order=[];
multsnd{1}.Var1_pres_order(1:snd.reps*total_stimnum)=NaN; 
multsnd{1}.Var2_pres_order(1:snd.reps*total_stimnum)=NaN; 

tic

%% Loop through each repetition
trace_order=ones(snd.reps,total_stimnum)*nan; %for saving the order the traces occur in each rep
total_stim_played=0; %necessary for Spike2 conversion DJT 10/8/2013
for rep=[1:snd.reps]
    randorder=randperm(total_stimnum); % vector for storing the randomized
% trial presentation order.  Random, non-repeating numbers from 1:total_stimnum

    %%pointers for the individual tuning curves
    mat_place(1:N)=1;  
% this keeps track of how many of each trace have played, after the 3rd
% trace plays, mat_place(3) increases by 1 ... i think this is just
% diagnostic because it doesn't seem to be doing anything now - DJT
% 10/7/2013      
    
    %%order for the individual tuning curves
    for i=1:N
        mat_order{i}=randperm(matsize(i));
        % cell array, with each cell representing a trace, and containing
        % random numbers from 1:length(trace)
    end
    
    for i=[1:total_stimnum]  %% total # of stimuli to be presented in one rep
        total_stim_played=total_stim_played+1;
        %  print the rep info to the screen
        figure(findobj(0,'tag','Aud_Space_win'));     %% set the countour window as active
        h=findobj(gcf,'tag','Print_rep');
        set(h,'string',['rep ' num2str(rep) ' of ' num2str(snd.reps) ' : ' 'stim ' num2str(i) ' of ' num2str(total_stimnum)]);
        
        if check==1
            while toc<(snd.isi/1000)
                drawnow;
            end
        end
        tic
        
        for trace_num=1:N  % N is # of traces
            if stimnum_pointer(trace_num) < randorder(i) 
                if randorder(i) <= stimnum_pointer(trace_num+1)
                    run_inter_mat_curve(rep,mat_order{trace_num}, mat_place, trace_num, total_stim_played);  
                    %Added total_stim_played for Spike2 conversion DJT
                    %10/8/2013
                    trace_order(rep, i)=trace_num; % necessary for S2 --> OwlLand conversion 
                    %this lets me tell which trigger comes from which
                    %trace
                    % also have to input the trace # in question 
                    mat_place(trace_num)=mat_place(trace_num)+1;
                    current_trace=trace_num; %I think this is diagnostic cause it doesn't seem to be doing much DJT 10/7/2013
                    break;
                end
            end
        end
        if stopf==1
            break
        end;
        
    end     %%end of stimnum loop
    
    if stopf==1
        break
    end;
    
    
    if stopf==1
        break
    end;
    
    trace=snd.trace;
    
    snd=multsnd{N};  %% for the graphing, we will use the Nth trace.
    if or(screenblank==1,snd.screenblank==1)    %%%if there is a visual stimulus or the screen was blanked
        snd.window=window;
    end
    snd.trace=trace;
    set_graphs(rep)  
    
    
    
end %%end rep loop




%%%close the screen at the end
if or(screenblank==1,snd.screenblank==1)    %%%if there is a visual stimulus or the screen was blanked
    Screen('CloseAll');                 %%  Close the Screen
end
%%  delete all of the unwanted points%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:N
    multsnd{i}.dataVar1=multsnd{i}.dataVar1(1:multsnd{i}.spikeplace);                    
    multsnd{i}.dataVar2=multsnd{i}.dataVar2(1:multsnd{i}.spikeplace);                    
    multsnd{i}.datachan=multsnd{i}.datachan(1:multsnd{i}.spikeplace);                   
    multsnd{i}.datatime=multsnd{i}.datatime(1:multsnd{i}.spikeplace);                   
    multsnd{i}.datarep=multsnd{i}.datarep(1:multsnd{i}.spikeplace);   
    % 		if snd.save_spikes                                              
    %             multsnd{i}.dataWave=multsnd{i}.dataWave(:,[1:multsnd{i}.spikeplace]);                      
    % 		end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

random_id_tag=rand;
for i=1:N
    multsnd{i}.endtime=clock;
    %save the trace_order structure and ID tag for each trace DJT 10/7/2013
    multsnd{i}.trace_order=trace_order; 
    multsnd{i}.multi_tag=random_id_tag;
    %save the variable presentation order for each trace DJT 10/8/2013
    multsnd{i}.Var1_pres_order=multsnd{1}.Var1_pres_order; 
    multsnd{i}.Var2_pres_order=multsnd{1}.Var2_pres_order;    
end

if snd.training==0;
    save_inter_file_dialog;
end
return;


































