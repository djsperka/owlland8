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
    invoke(RP_1,'halt');   
    
    pa5_1.SetAtten(attenL1);
    err = pa5_1.GetError();
    if ~isempty(err)
        pa5_1.Display(err);
    end

    pa5_2.SetAtten(attenR1);
    err = pa5_2.GetError();
    if ~isempty(err)
        pa5_2.Display(err);
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
    
%     onoff = on_off1;
%     if onoff ~= 1; onoff = 0; end
%     RP_1.SetTagVal('onoff1', onoff);
% DJS this value always set to 1 - see below

% DJS - same is true for 'corr' - always using corr_condition=0

    RP_1.SetTagVal('onoff1', 1);
    RP_1.SetTagVal('Corr', 0);
    RP_1.SetTagVal('leftdelay1', left_delay1);
    RP_1.SetTagVal('rightdelay1', right_delay1);
    RP_1.SetTagVal('duration', duration);
    RP_1.SetTagVal('rise', rise+0.1);
    RP_1.SetTagVal('pre', pre);
    RP_1.SetTagVal('Wave_pointer', Wave_pointer);


    %% activate the hardware
    RP_1.run();
    
    return;
    