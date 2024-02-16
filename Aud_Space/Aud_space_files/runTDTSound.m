function runTDTSound(itd1, ild1, abi1, duration, rise, pre, Wave_pointer)
%runTDTSound Halt hardware, set tag values for sound presentation, then
%run hardware (which waits for a trigger before playing sound). Based on
%PresentAM(). Note, I think the hardware will still require a trigger to
%actually process the sounds. 

    global RP_1 pa5_1 pa5_2;
    
    %%Set each attenuator to the minimum attentuation of the two sounds that enter it .
    %%here, we consider the abs(abi)
    
    abi1= abs(abi1);
    
    attenL1 = abi1 + ild1/2 ;
    attenR1 = abi1 - ild1/2 ;
    
    %% halt the hardware
    RP_1.Halt();

    if ~pa5_1.SetAtten(attenL1)
        error('Cannot set atten on pa5_1: %s', pa5_1.GetError());
    end

    if ~pa5_2.SetAtten(attenR1)
        error('Cannot set atten on pa5_2: %s', pa5_2.GetError());
    end

    %get delay values

    delay=abs(itd1/1000);       %   adjust the ITD from microseconds to ms
    if itd1<=0  %% right ear lagging
        left_delay1=.05;   % 
        right_delay1=.05+delay;  %%adjust for the fact that there is an imposed 5 microsecond difference between the channels
    else  %% right ear leading
        left_delay1=.05+delay;  
        right_delay1=.05;   % 
    end
    
    % Both 'onoff1' and 'Corr' are always set to 1 for this usage. That
    % means the noise is always correlated (same sound buffer used for left
    % and right - that's because 'Corr' == 0). The 'onoff1' parameter is a
    % holdover from when there were two sounds, and one of them could be
    % switched on or off using this parameter. There are no longer two
    % sounds here, but the 'onoff1' parameter remains. 
    
    RP_1.SetTagVal('onoff1', 1);
    RP_1.SetTagVal('Corr', 0);
    RP_1.SetTagVal('leftdelay1', left_delay1);
    RP_1.SetTagVal('rightdelay1', right_delay1);
    RP_1.SetTagVal('duration', duration);
    RP_1.SetTagVal('rise', rise+0.1);
    RP_1.SetTagVal('pre', pre);
    RP_1.SetTagVal('Wave_pointer', Wave_pointer);
    
    %% activate the hardware
    if ~RP_1.Run()
        error('Error running circuit.');
    end

    return;
    