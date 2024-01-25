function doNoiseTone()
    global snd screen_offset;
    
    runningFlag = 0;    % this is 1 when stim are running
    pauseFlag = 0;
    stopFlag = 0;

    c_yellow=[.95, .95, .7];
    c_green=[.5,.58,.5];
    c_red=[.7 .4 .4];
    NTTag = 'NoiseTone_win';
    
    nt.pre1 = snd.pre;
    nt.duration1 = snd.duration;
    nt.post1 = snd.post;
    nt.itd1 = snd.itd1;
    nt.ild1 = snd.ild1;
    nt.abi1 = snd.abi1;
    nt.freqlo1 = snd.freqlo1;
    nt.freqhi1 = snd.freqhi1;
    
    nt.pre2 = snd.pre;
    nt.duration2 = snd.duration;
    nt.post2 = snd.post;
    nt.itd2 = snd.itd1;
    nt.ild2 = snd.ild1;
    nt.abi2 = snd.abi1;
    nt.frequency = 1000;
    nt.nperblock = 500;
    nt.nblocks = 10;
    nt.isi = snd.isi;
    nt.ibi = 15000; % ms
    nt.rise = snd.rise;
    nt.amplitude = snd.amplitude;

    if findobj(0, 'tag', NTTag)>=1
        figure(findobj(0, 'tag', NTTag));     %% set the first window as active
    else    %%open a new window
        myscreen=get(0,'screensize');
        figure('position', [4+screen_offset,(myscreen(4)-380),600,350], 'menubar', 'none', 'tag', NTTag, 'color', c_yellow, 'CloseRequestFcn', @closeNoiseTone);
    
        % column 1 is for noise.
        xc1 = 20;
        itemheight = 30;
    
    
        %% Noise STUFF
    
        % label snd1
        uicontrol('style','text',...
            'position', [xc1 320 120 20],...
            'backgroundcolor',c_yellow,...
            'string','NOISE',...
            'tag', 'NOISEtext',...
            'fontweight', 'bold',...
            'fontsize', 10,...
            'horizontalalignment','center');
    
        %% set pre
        uicontrol('style','text',...
            'position', [xc1 300 60 20],...
            'backgroundcolor',c_yellow,...
            'string','Pre',...
            'horizontalalignment','left');
        nt.uiPre1 = uicontrol('style','edit',...
            'position', [xc1+60 300 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.pre1,...
            'tag','pre1',...
            'callback', @cbNoiseTone);
    
    
        %% set duration
        uicontrol('style','text',...
            'position', [xc1 270 60 20],...
            'backgroundcolor',c_yellow,...
            'string','Duration',...
            'horizontalalignment','left');
        nt.uiDuration1 = uicontrol('style','edit',...
            'position', [xc1+60 270 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.duration1,...
            'tag','duration1',...
            'callback', @cbNoiseTone);
    
        %% set post
        uicontrol('style','text',...
            'position', [xc1 240 60 20],...
            'backgroundcolor',c_yellow,...
            'string','Post',...
            'horizontalalignment','left');
        nt.uiPost1 = uicontrol('style','edit',...
            'position', [xc1+60 240 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.post1,...
            'tag','post1',...
            'callback', @cbNoiseTone);


        %% set noiseband frequencies
        uicontrol('style','text',...
            'position', [xc1 210 60 20],...
            'backgroundcolor',c_yellow,...
            'string','NB Low',...
            'horizontalalignment','left');
        nt.uiFreqLo1 = uicontrol('style','edit',...
            'position', [xc1+60 210 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.freqlo1,...
            'tag','freqlo1',...
            'callback', @cbNoiseTone);
    
        % ild1
        uicontrol('style','text',...
            'position', [xc1 180 60 20],...
            'backgroundcolor',c_yellow,...
            'string','NB Hi',...
            'horizontalalignment','left');
        nt.uiFreqHi1 = uicontrol('style','edit',...
            'position', [xc1+60 180 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.freqhi1,...
            'tag','freqhi1',...
            'callback', @cbNoiseTone);



        %% set itd1
        uicontrol('style','text',...
            'position', [xc1 120 60 20],...
            'backgroundcolor',c_yellow,...
            'string','ITD',...
            'horizontalalignment','left');
        nt.uiITD1 = uicontrol('style','edit',...
            'position', [xc1+60 120 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.itd1,...
            'tag','itd1',...
            'callback', @cbNoiseTone);
    
        % ild1
        uicontrol('style','text',...
            'position', [xc1 90 60 20],...
            'backgroundcolor',c_yellow,...
            'string','ILD',...
            'horizontalalignment','left');
        nt.uiILD1 = uicontrol('style','edit',...
            'position', [xc1+60 90 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.ild1,...
            'tag','ild1',...
            'callback', @cbNoiseTone);
    
        % abi1
        uicontrol('style','text',...
            'position', [xc1 60 60 20],...
            'backgroundcolor',c_yellow,...
            'string','ABI',...
            'horizontalalignment','left');
        nt.uiABI1 = uicontrol('style','edit',...
            'position', [xc1+60 60 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.abi1,...
            'tag','abi1',...
            'callback', @cbNoiseTone);
    
    
        %% tone 
    
        % label for tone
        uicontrol('style','text',...
            'position', [xc1+150 320 120 20],...
            'backgroundcolor',c_yellow,...
            'string','TONE',...
            'fontweight', 'bold',...
            'fontsize', 10,...
            'horizontalalignment','center');
    
        %% set pre
        uicontrol('style','text',...
            'position', [xc1+150 300 60 20],...
            'backgroundcolor',c_yellow,...
            'string','Pre',...
            'horizontalalignment','left');
        nt.uiPre2 = uicontrol('style','edit',...
            'position', [xc1+150+60 300 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.pre2,...
            'tag','pre2',...
            'callback', @cbNoiseTone);
    
    
        %% set duration
        uicontrol('style','text',...
            'position', [xc1+150 270 60 20],...
            'backgroundcolor',c_yellow,...
            'string','Duration',...
            'horizontalalignment','left');
        nt.uiDuration2 = uicontrol('style','edit',...
            'position', [xc1+150+60 270 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.duration2,...
            'tag','duration2',...
            'callback', @cbNoiseTone);
    
        %% set post
        uicontrol('style','text',...
            'position', [xc1+150 240 60 20],...
            'backgroundcolor',c_yellow,...
            'string','Post',...
            'horizontalalignment','left');
        nt.uiPost2 = uicontrol('style','edit',...
            'position', [xc1+150+60 240 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.post2,...
            'tag','post2',...
            'callback', @cbNoiseTone);
    
    
        %% frequency for tone
        uicontrol('style','text',...
            'position', [xc1+150 180 60 20],...
            'backgroundcolor',c_yellow,...
            'string','Frequency',...
            'horizontalalignment','left');
        nt.uiFrequency = uicontrol('style','edit',...
            'position', [xc1+150+60 180 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.frequency,...
            'tag','frequency',...
            'callback', @cbNoiseTone);
    
    
        %% set itd2
        uicontrol('style','text',...
            'position', [xc1+150 120 60 20],...
            'backgroundcolor',c_yellow,...
            'string','ITD',...
            'horizontalalignment','left');
        nt.uiITD2 = uicontrol('style','edit',...
            'position', [xc1+150+60 120 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.itd2,...
            'tag','itd2',...
            'callback', @cbNoiseTone);
    
        % ild2
        uicontrol('style','text',...
            'position', [xc1+150 90 60 20],...
            'backgroundcolor',c_yellow,...
            'string','ILD',...
            'horizontalalignment','left');
        nt.uiILD2 = uicontrol('style','edit',...
            'position', [xc1+150+60 90 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.ild2,...
            'tag','ild2',...
            'callback', @cbNoiseTone);
    
        % abi2
        uicontrol('style','text',...
            'position', [xc1+150 60 60 20],...
            'backgroundcolor',c_yellow,...
            'string','ABI',...
            'horizontalalignment','left');
        nt.uiABI2 = uicontrol('style','edit',...
            'position', [xc1+150+60 60 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.abi2,...
            'tag','abi2',...
            'callback', @cbNoiseTone);
    
    
    
        xc3 = xc1 + 300;
    
        %% set rise time
        uicontrol('style','text',...
            'position', [xc3 300 60 20],...
            'backgroundcolor',c_yellow,...
            'string','Rise time',...
            'horizontalalignment','left');
        nt.uiRise = uicontrol('style','edit',...
            'position', [xc3+60 300 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.rise,...
            'tag','rise',...
            'callback', @cbNoiseTone);
    
        % ISI
        uicontrol('style','text',...
            'position', [xc3 270 150 20],...
            'backgroundcolor',c_yellow,...
            'string','Inter stim interval',...
            'horizontalalignment','left');
        nt.uiISI = uicontrol('style','edit',...
            'position', [xc3+150 270 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.isi,...
            'tag','isi',...
            'callback', @cbNoiseTone);
    
        % repeats per block
        uicontrol('style','text',...
            'position', [xc3 240 150 20],...
            'backgroundcolor',c_yellow,...
            'string','Noise+Tone per block',...
            'horizontalalignment','left');
        nt.uiNPerBlock = uicontrol('style','edit',...
            'position', [xc3+150 240 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.nperblock,...
            'tag','tnperblock',...
            'callback', @cbNoiseTone);
    
    
        % IBI
        uicontrol('style','text',...
            'position', [xc3 210 150 20],...
            'backgroundcolor',c_yellow,...
            'string','Inter block interval',...
            'horizontalalignment','left');
        nt.uiIBI = uicontrol('style','edit',...
            'position', [xc3+150 210 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string',nt.ibi,...
            'tag','ibi',...
            'callback', @cbNoiseTone);
    
        % number of blocks
        uicontrol('style','text',...
            'position', [xc3 180 150 20],...
            'backgroundcolor',c_yellow,...
            'string','Number of blocks',...
            'horizontalalignment','left');
        nt.uiNBlocks = uicontrol('style','edit',...
            'position', [xc3+150 180 60 20],...
            'backgroundcolor',c_yellow,...
            'horizontalalignment','left',...
            'string', nt.nblocks,...
            'tag','nblocks',...
            'callback', @cbNoiseTone);
    

        %% run button
        nt.uiRunButton = uicontrol('style','pushbutton',...
            'position', [xc3 120 60 20],...
            'horizontalalignment','center',...
            'string','Run',...
            'fontweight', 'bold', ...
            'fontsize', 10,...
            'backgroundcolor', c_red,...
            'callback', @runNoiseTone);

    
        %% pause button
        nt.uiPauseButton = uicontrol('style','pushbutton',...
            'position', [xc3+80 120 60 20],...
            'horizontalalignment','center',...
            'string','Pause',...
            'fontweight', 'bold', ...
            'fontsize', 10,...
            'backgroundcolor', c_red,...
            'callback', @pauseNoiseTone);
    
        %% stop button
        nt.uiStopButton = uicontrol('style','pushbutton',...
            'position', [xc3+160 120 60 20],...
            'horizontalalignment','center',...
            'string','Stop',...
            'fontweight', 'bold', ...
            'fontsize', 10,...
            'backgroundcolor', c_red,...
            'callback', @stopNoiseTone);

        %% status area
        uicontrol('style', 'text', ...
            'position', [xc3 80 60 20], ...
            'String', 'Status:', ...
            'horizontalalignment', 'right', ...
            'backgroundcolor',c_yellow,...
            'fontsize', 10, 'fontweight', 'bold');
        nt.uiStatusArea = uicontrol('style', 'text', ...
            'position', [xc3 50 220 60], ...
            'String', {'waiting....', 'still waiting', 'waiting even more'}, ...
            'horizontalalignment', 'left', ...
            'fontsize', 10, 'fontweight', 'bold');
        updateButtons();
    
    end    
    
    function updateButtons()
        if ~runningFlag
            % enable run
            set(nt.uiRunButton, 'enable','on');

            % disable pause and stop
            set(nt.uiPauseButton, 'enable','off');
            set(nt.uiStopButton, 'enable','off');
        else
            % disable run
            set(nt.uiRunButton, 'enable','off');

            % Enable pause and stop
            set(nt.uiPauseButton, 'enable','on');
            set(nt.uiStopButton, 'enable','on');
        end
    end

    function stopNoiseTone(src, event)
        stopFlag = 1;
        pauseFlag = 0;
    end

    function pauseNoiseTone(src, event)
        pauseFlag = 1;
        stopFlag = 0;
    end

    function cbNoiseTone(src, event)
    
        % update from gui elements
        nt.pre1 = str2num(get(nt.uiPre1,'string'));
        nt.duration1 = str2num(get(nt.uiDuration1,'string'));
        nt.post1 = str2num(get(nt.uiPost1,'string'));
        nt.itd1 = str2num(get(nt.uiITD1,'string'));
        nt.ild1 = str2num(get(nt.uiILD1,'string'));
        nt.abi1 = str2num(get(nt.uiABI1,'string'));

        nt.pre2 = str2num(get(nt.uiPre2, 'string'));
        nt.duration2 = str2num(get(nt.uiDuration2, 'string'));
        nt.post2 = str2num(get(nt.uiPost2, 'string'));
        nt.itd2 = str2num(get(nt.uiITD2, 'string'));
        nt.ild2 = str2num(get(nt.uiILD2, 'string'));
        nt.abi2 = str2num(get(nt.uiABI2, 'string'));
        nt.frequency = str2num(get(nt.uiFrequency, 'string'));
        nt.nperblock = str2num(get(nt.uiNPerBlock, 'string'));
        nt.nblocks = str2num(get(nt.uiNBlocks, 'string'));
        nt.isi = str2num(get(nt.uiISI, 'string'));
        nt.ibi = str2num(get(nt.uiIBI, 'string'));
        nt.rise = str2num(get(nt.uiRise, 'string'));
    
    end
    
    function closeNoiseTone(src, event)
        fprintf('In closeNoiseTone()\n');
        delete(gcf);    % don't call close() from here!
    end
    
    function triggerAndWait(w, rect, ms)
        % draw trig in rect
        Screen('FillRect', w, [127, 127, 127]);
        Screen('FillRect', w, [0,0,0], rect);
        Screen('FillOval', w, [255,0,0], rect);
        Screen('Flip', w);
        
        % erase trig from rect
        Screen('FillRect', w, [127, 127, 127]);
        Screen('FillRect', w, [0,0,0], rect);
        Screen('Flip', w);
        
        % now wait
        WaitSecs(ms/1000.0);
    end

    function runNoiseTone(src, event)
    %UNTITLED4 Summary of this function goes here
    %   Detailed explanation goes here
    
        global RP_1;
        
        fprintf('Running Noise Tone\n');
    
        % update buttons
        runningFlag = 1;
        updateButtons();
        
        
        totalMSPerBlock = nt.nperblock * (nt.pre1 + nt.duration1 + nt.post1 + nt.isi + nt.pre2 + nt.duration2 + nt.post2 + nt.isi);
        totalMS = nt.nblocks * totalMSPerBlock + (nt.nblocks-1) * nt.ibi;
        fprintf('Expected running time %d sec per block, %d sec total\n', totalMSPerBlock/1000, totalMS/1000);
        
        fprintf('Creating sounds, loading on RP2...\n');
        [nNoise, nTone, sound] = makeNoiseTone(snd.fs, snd.amplitude, nt.duration1, nt.freqlo1, nt.freqhi1, nt.duration2, nt.frequency);
        RP_1.WriteTagV('sound_corr', 0, sound);
        [nNoise_uncorr, nTone_uncorr, sound_uncorr] = makeNoiseTone(snd.fs, snd.amplitude, nt.duration1, nt.freqlo1, nt.freqhi1, nt.duration2, nt.frequency);
        RP_1.WriteTagV('sound_uncorr', 0, sound_uncorr);   
        % The use of one or both of these is controlled by the 
        % corr_condition, abbreviated as 'corr' in the TDT tags. There are 
        % two conditions: 0 is correlated L/R, 1 is uncorrelated. 

        
        % Open window. We only need this for triggering. 
        [snd.window, wrect] = Screen(0, 'OpenWindow', 0);
        
        % block loop
        for iblock=1:nt.nblocks

            fprintf('Block %d\n', iblock);
            
            % noise-tone pairs within each block, with ISI
            for ipair=1:nt.nperblock

                fprintf('Noise %d/%d\n', iblock, ipair);

                % Noise
                runTDTSound(nt.itd1, nt.ild1, nt.abi1, nt.duration1, nt.rise, nt.pre1, 0);
                
                % Trigger and wait until sound complete
                triggerAndWait(snd.window, snd.trigger_loc, nt.pre1+nt.duration1);
                
                % ISI                
                WaitSecs(nt.isi/1000);

                fprintf('Tone %d/%d\n', iblock, ipair);

                % Tone
                runTDTSound(nt.itd2, nt.ild2, nt.abi2, nt.duration2, nt.rise, nt.pre2, nNoise);
                
                % Trigger and wait until sound complete
                triggerAndWait(snd.window, snd.trigger_loc, nt.pre2+nt.duration2);
                
                % ISI
                WaitSecs(nt.isi/1000);

            end
        end
        Screen('Close', snd.window);
        snd.window = 0;
        
        % enable run button
        set(nt.uiRunButton, 'enable','on');

    end


end