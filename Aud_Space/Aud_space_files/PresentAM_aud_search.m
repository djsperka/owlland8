function PresentAM(inarray,Wave_pointer)
    global RP_1 RP_2 zbus pa5_1 pa5_2 pa5_3 pa5_4 snd;    
    
%    present_sound_array=[snd.itd1,snd.ild1,snd.abi1,0,snd.duration,snd.rise,snd.pre,snd.amplitude,snd.itd2,snd.ild2,snd.abi2, snd.corr, snd.play_sound1, snd.play_sound2];      %%default sound array

% fprintf ('These are the params being fed through PresentAM_aud_search\n\n')

    itd1=inarray(1);
    ild1=inarray(2);
    abi1=inarray(3);
    duration=inarray(5);
    rise=inarray(6);
    pre=inarray(7);
    itd2=inarray(9);
    ild2=inarray(10);
    abi2=inarray(11);
    corr_condition=inarray(12);
    on_off1=inarray(13);
    on_off2=inarray(14);
    
    
    %%Set each attenuator to the minimum attentuation of the two sounds that enter it .
    %% here, we consider the abs(abi)
    
    abi1= abs(abi1);
    abi2= abs(abi2);
    
    attenL1 = abi1 + ild1/2 ;
    attenR1 = abi1 - ild1/2 ;
    
    attenL2 = abi2 + ild2/2 ;
    attenR2 = abi2 - ild2/2 ;
    
    
    %% halt the hardware
    invoke(RP_1,'halt');   
%     invoke(RP_2,'halt');  Removed all instances of RP_2 DJT 7/30/2012  
    
    
    if invoke(pa5_1,'SetAtten', attenL1);
    else
        e='Left AP5 error'
    end
    
    if invoke(pa5_2,'SetAtten',attenR1);
    else
        e='Right AP5 error'
    end
    
    
    
    if snd.atten_num>2
        if invoke(pa5_3,'SetAtten', attenL2);
            %'connected to pa5_3'
        else
            e='Left AP5 error'
        end
        
        if invoke(pa5_4,'SetAtten',attenR2);
            %'connected to pa5_4'    
        else
            e='Right AP5 error'
        end
    end 
        
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    if invoke(RP_1,'SetTagVal','Corr', corr_condition);
        else
            'unable to set corr value on rp1'
    end
    
    
%     if invoke(RP_2,'SetTagVal','Corr', corr_condition);
%         else
%             'unable to set corr value on rp2'
%     end
%%% Removed all instances of RP_2 DJT 7/30/2012 
    
        %%%%%%%%%%%%%%%%%%%%%%%
    
    
    %get the values for ITD
    
    %First do sound1
        delay=abs(itd1/1000);       %   adjust the ITD from microseconds to ms
        if itd1<=0  %% right ear lagging
            left_delay1=.05;   % 
            right_delay1=.05+delay;  %%adjust for the fact that there is an imposed 5 microsecond difference between the channels
        else  %% right ear leading
            left_delay1=.05+delay;  
            right_delay1=.05;   % 
        end
        %Now take care of sound2
        delay=abs(itd2/1000);       %   adjust the ITD from microseconds to ms
        if itd2<=0
            left_delay2=.05;
            right_delay2=.05+delay;  
        else
            left_delay2=.05+delay;
            right_delay2=.05;
        end

%%%%%%%%%%%%%%%%% turn sounds on and off

if (on_off1 ==1)
        if invoke(RP_1,'SetTagVal','onoff1', 1);
        else
            'unable to set onoff tag value for sound1'
        end
else
        if invoke(RP_1,'SetTagVal','onoff1', 0);
        else
            'unable to set onoff tag value for sound1'
        end
end

if (on_off2 ==1)
%         if invoke(RP_2,'SetTagVal','onoff2', 1);
%         else
%             'unable to set onoff tag value for sound2'
%         end
%%% Removed all instances of RP_2 DJT 7/30/2012 
'Thinks that RP_2 should be on in PresentAM.m  All isntances of RP_2 have been removed'
else
%         if invoke(RP_2,'SetTagVal','onoff2', 0);
%         else
%             'unable to set onoff tag value for sound2'
%         end
%%% Removed all instances of RP_2 DJT 7/30/2012 
end
    
    
    %%%%%%%%%%%%   set sound values


    if invoke(RP_1,'SetTagVal','leftdelay1',left_delay1);
        else
            'unable to set delay tag value for sound1'
    end
    
    if invoke(RP_1,'SetTagVal','rightdelay1',right_delay1);
        else
            'unable to set delay tag value for sound 1'
    end
    
%     if invoke(RP_2,'SetTagVal','leftdelay2',left_delay2);
%         else
%             'unable to set delay tag value for sound2'
%     end
%%% Removed all instances of RP_2 DJT 7/30/2012 
    
%     if invoke(RP_2,'SetTagVal','rightdelay2',right_delay2);
%         else
%             'unable to set delay tag value for sound2'
%     end
%%% Removed all instances of RP_2 DJT 7/30/2012 
    
    if invoke(RP_1,'SetTagVal','duration',duration);
        else
            'unable to set duration value'
    end
    
%     if invoke(RP_2,'SetTagVal','duration',duration);
%         else
%             'unable to set duration value'
%     end
%%% Removed all instances of RP_2 DJT 7/30/2012 
    
    if invoke(RP_1,'SetTagVal','rise',rise+0.1);
        else
            'unable to set rise value'
    end
    
%    if invoke(RP_2,'SetTagVal','rise',rise+0.1);
%         else
%             'unable to set rise value'
%     end
%%% Removed all instances of RP_2 DJT 7/30/2012 
    
    if invoke(RP_1,'SetTagVal','pre',pre);
        else
            'unable to set pre value'
    end
    
%     if invoke(RP_2,'SetTagVal','pre',pre);
%         else
%             'unable to set pre value'
%     end
%%% Removed all instances of RP_2 DJT 7/30/2012 
    

    
    if invoke(RP_1,'SetTagVal','Wave_pointer',Wave_pointer);
        else
            'unable to set Wave_pointer'
    end

%     if invoke(RP_2,'SetTagVal','trggate', 0);
%         else
%             'unable to set trigger gate value'
%     end
%%% Removed all instances of RP_2 DJT 7/30/2012 
                        


    %% activate the hardware
    invoke(RP_1,'run');   
%     invoke(RP_2,'run'); %%% Removed all instances of RP_2 DJT 7/30/2012 
    
    return;
    