function run_mult_cont_in_order(RA16_type)
    global multcont multsnip cont rec stopf runf RP_1 RP_2 pa5_1 pa5_2 RA_16  zbus check stopf;
    
    window=SCREEN(0,'OpenWindow',0);
    hidecursor;                         %%  Hide the cursor
    tic;                                %%  begin startpause
    stopf=0;
    multsnip={};    %%blank out all previous snips
    
    N=length(multcont);  %% N is the number of traces to be interleaved
    if ~nargin
        RA16_type=1;
    end
    
    
    for i=1:N
        multcont{i}.starttime=clock;    %%  time stamp
    end
	for i=1:N
	%%%%zero whatever multcont stuff is in need to being zeroed 
        multcont{i}.spike_times=[];
        multcont{i}.ITD_pos=[];
        multcont{i}.vis_pos_array=[];
	end
    
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
     
    
	for trace=[1:N]
        %%PROGRESS BAR
        findobj(0,'tag','set_cont_win');
        tagname=['prog_',num2str(floor(trace/N*5)+1)];
        set(findobj(gcf,'tag',tagname),'visible','on');
        drawnow
        %%%%%%%%%%%%%%%

        for rep=1:multcont{trace}.reps % rep is the current rep
            continuous_move(trace,rep,window,RA16_type);  %% also have to input the trace # in question
            tic
            while toc<cont.isi  %%wait the isi between stimuli sequences
                drawnow;
            end
		end            
	end

    for i=1:N
        multcont{i}.endtime=clock;
    end
    
    %%% save stuff
    SCREEN('CloseAll');                 %%  Close the Screen
    save_file_dialog_cont;
return;
