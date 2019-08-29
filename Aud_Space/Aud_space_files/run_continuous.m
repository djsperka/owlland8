function    run_continuous(vis_locs_min,vis_locs_max,screenpause,fore,back,window);
        global RA_16 RP_1 zbus spikes frametimes cont snd;
        %%vis_locs=2xn

        white=WhiteIndex(window);       %%
        back=back*white;
        fore=fore*white;
        
        screen(window,'fillRect',back);       %%  Blank the Screen with the background color
        screen(window,'FillRect',[snd.black,snd.black,snd.black],snd.trigger_loc);
        
        
        priorityLevel=MaxPriority(0,'WaitBlanking');     %set the CPU priority of the vis stimulus.
        hz=SCREEN(window,'FrameRate');
        num_scr=size(vis_locs_min,2);
        if hz~=60
            'refresh rate error'
        end
        
        
        loop={
            'SCREEN(window,''WaitBlanking'',screenpause);'
            'SCREEN(window,''FillOval'',fore(1),[vis_locs_min(1,1),vis_locs_min(2,1),vis_locs_max(1,1),vis_locs_max(2,1)]);'
            'screen(window,''FillOval'',[snd.white,snd.black,snd.black],snd.trigger_loc);' %%present a trigger
            
            'for i=[2:size(vis_locs_min,2)]'
                'SCREEN(window,''WaitBlanking'',screenpause);'
                'SCREEN(window,''FillOval'',back,[vis_locs_min(1,i-1),vis_locs_min(2,i-1),vis_locs_max(1,i-1),vis_locs_max(2,i-1)]);'
                'SCREEN(window,''FillOval'',fore(i),[vis_locs_min(1,i),vis_locs_min(2,i),vis_locs_max(1,i),vis_locs_max(2,i)]);'
            'end;'
            'SCREEN(window,''WaitBlanking'',screenpause);'  %% hold the final screen
            'SCREEN(window,''FillRect'',back);' %%  Blank the Screen with the background color
        };          %%create a string that contains the necessary lines to display all boxes.

        invoke(zbus,'zBusTrigA',0,0,4);
        RUSH(loop,priorityLevel);   %present the movie with high priority
        screen(window,'fillRect',back);       %%  Blank the Screen with the background color


return;

