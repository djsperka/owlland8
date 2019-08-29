function present_sound(inarray)
       global RP_1 RP_2 pa5_1 pa5_2 zbus snd;
       currentdir=pwd;
       
       
        tone=0;%% unless told otherwise, do not present a tone.     
        itd=inarray(1);
        ild=inarray(2);
        abi=-inarray(3);
        frequency=inarray(4);
        
        duration=inarray(5);
        rise=inarray(6);
        pre=inarray(7);
        amplitude=inarray(8);

        if frequency~=0;        %%if a frequency curve is running
            tone=1;
        end;
        
% %     invoke(RP_1,'halt');
% %     invoke(RP_2,'halt');



%    global duration rise pre amplitude cent_freq width_freq itd abi ild;
% % % %     present a sound stimulus after it has been loaded.
% % % % 
% % % %     duration is in ms
% % % %     amplitude is in units I don't understand
% % % %     rise is in ms
% % % %     pre is in ms
% % % %     left_delay is in ms
% % % %     right delay in in ms
% % % %     left_eq
% % % %     right_eq
% % % %     abi
% % % %     ITD in microseconds
       
            
            
            
    
 
    
   
    
    %%Set the attenuators.
    attenR=abi-(ild/2);
    attenL=abi+(ild/2);
    rise=rise+0.1;
    
    if invoke(pa5_1,'SetAtten',attenL);
    else
        e='Left AP5 error'
    end
    if invoke(pa5_2,'SetAtten',attenR);
    else
        e='Right AP5 error'
    end
    %%%%%%%%%%%%%%%%%%%%%%%
    
    
    %get the values for ITD
    delay=abs(itd/1000);       %   adjust the ITD from microseconds to ms
    if itd<=0
        left_delay=0.5;
        right_delay=0.5+delay;  %%adjust for the fact that there is an imposed 5 microsecond difference between the channels
        
    else
        left_delay=0.5+delay;
        right_delay=0.5;
    end
    
    %%%%%%%%%%%% set sound values
    if invoke(RP_1,'SetTagVal','tone',tone);        %%logic for tone
        else
            'unable to set tag value'
    end
    if invoke(RP_1,'SetTagVal','frequency',(1000*frequency));  %%if a tone is played this is the frequency
        else
            'unable to set tag value'
    end
    if invoke(RP_1,'SetTagVal','duration',duration);
        else
            'unable to set tag value'
    end
    
    if invoke(RP_1,'SetTagVal','rise',rise);
        else
            'unable to set tag value'
    end
    
    if invoke(RP_1,'SetTagVal','pre',(pre+snd.aud_offset));
        else
            'unable to set tag value'
    end
    
    if invoke(RP_1,'SetTagVal','amplitude',amplitude);
        else
            'unable to set tag value'
    end
    if invoke(RP_1,'SetTagVal','amp_mod',snd.amp_mod);
        else
            'unable to set tag value'
    end
    if invoke(RP_1,'SetTagVal','Freq_mod',snd.Freq_mod);
        else
            'unable to set tag value'
    end

%     if invoke(RP_1,'SetTagVal','cent_freq',cent_freq);
%         else
%             'unable to set tag value'
%     end
%     
%     if invoke(RP_1,'SetTagVal','width_freq',width_freq);
%         else
%             'unable to set tag value'
%     end
    
    if invoke(RP_1,'SetTagVal','left_delay',left_delay);
        else
            'unable to set tag value'
    end
    
    if invoke(RP_1,'SetTagVal','right_delay',right_delay);
        else
            'unable to set tag value'
    end
    
    %% you need to invoke anything that you are going to use.
    invoke(RP_1,'run');
    invoke(RP_2,'run');

return;