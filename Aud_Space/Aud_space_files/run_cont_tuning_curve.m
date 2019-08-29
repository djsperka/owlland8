function run_cont_tuning_curve(RA16_type)
    global multcont multsnip cont rec stopf runf RP_1 RP_2 pa5_1 pa5_2 RA_16  zbus check stopf;
    
    window=SCREEN(0,'OpenWindow',0);
    hidecursor;                         %%  Hide the cursor
    screen(window,'fillRect',cont.back);       %%  Blank the Screen with the background color
    waitsecs(1);
    
    
    tic;                                %%  begin startpause
    stopf=0;
    multsnip={};    %%blank out all previous snips
    
    N=length(multcont)  %% N is the number of traces to be interleaved
    if ~nargin
        RA16_type=1;
    end
    
    currentdir=pwd;
    delete(strcat(currentdir,'\..\temp_waves\trace*'));  % clear any files in temp dir
    
    for i=1:N
        multcont{i}.starttime=clock;    %%  time stamp
    end
        
	for i=1:N
	%%%%zero whatever multcont stuff is in need to being zeroed 
        multcont{i}.spike_times={};
        multcont{i}.ITD_pos={};
        multcont{i}.vis_pos_array={};
	end
    
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    total_stimnum=0;
    for i=1:N
          total_stimnum=total_stimnum+multcont{i}.reps;       
    end
    randorder=randperm(total_stimnum);            %%randomization of the overall stimtype

    stimnum_pointer(1)=0;
    for i=[2:N+1]
        stimnum_pointer(i)=stimnum_pointer(i-1)+multcont{i-1}.reps;    
    end

    %%pointers for the individual tuning curves
    rep_place(1:N)=0;
    
    
    
    %%%  PROGRESS BAR
    figure(findobj(0,'tag','set_cont_win'));
    set(findobj(gcf,'tag','prog_1'),'visible','off');
    set(findobj(gcf,'tag','prog_2'),'visible','off');
    set(findobj(gcf,'tag','prog_3'),'visible','off');
    set(findobj(gcf,'tag','prog_4'),'visible','off');
    set(findobj(gcf,'tag','prog_5'),'visible','off');
    set(findobj(gcf,'tag','prog_6'),'visible','off');
    drawnow
    %%%%%%%%%%%%%%%%%%
    
    while toc<cont.startpause
        drawnow;  %%wait the desired amount of time before starting
    end
     
    
	for i=[1:total_stimnum]
        %%PROGRESS BAR
        findobj(0,'tag','set_cont_win');
        for j=1:(floor(i/total_stimnum*5)+1)
            tagname=['prog_',num2str(j)];
            set(findobj(gcf,'tag',tagname),'visible','on');
        end
        drawnow
        %%%%%%%%%%%%%%%

		for trace_num=1:N  % N is # of traces
            
            
			if stimnum_pointer(trace_num) < randorder(i) 
				if randorder(i) <= stimnum_pointer(trace_num+1)
                    rep_place(trace_num)=rep_place(trace_num)+1;
                    continuous_move(trace_num, rep_place(trace_num),window,RA16_type);  %% also have to input the trace # in question
                    tic
                    while toc<cont.isi  %%wait the isi between stimuli sequences
                        drawnow;
                        if stopf==1
                            break
                        end
                    end
                    break;
				end
            end
            if stopf==1
                break
            end
		end
        if stopf==1
            break
        end
	end

    for i=1:N
        multcont{i}.endtime=clock;
    end
    
    %%% save stuff
    
        SCREEN('CloseAll');                 %%  Close the Screen
        save_file_dialog_cont;
return;
    
  