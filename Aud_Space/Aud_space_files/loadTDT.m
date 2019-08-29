function loadTDT(RPVDS_path,RP1name,RP2name,RA16name,atten_num, samp_freq)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         
%     Function loads TDT hardware with the chosen RPVDS files.  
%     The function then sets the equalization parameters for the two speakers.
%     if a string is empty ('') the program will skip that instrument.
%         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global RP_1 RP_2 pa5_1 pa5_2 pa5_3 pa5_4 RA_16  zbus;

currentdir=pwd;

%set activeX objects and connect
zbus=actxcontrol('ZBUS.x',[1    1   1   1],figure('visible','off'));
RP_1=actxcontrol('RPco.x',[1    1   1   1],figure('visible','off'));
% RP_2=actxcontrol('RPco.x',[1    1   1   1],figure('visible','off')); Removed all instances of RP_2 DJT 7/30/2012 
RA_16=actxcontrol('RPco.x',[1    1   1   1],figure('visible','off'));

if atten_num>0  %%allows up to four attenuators to be added
    pa5_1=actxcontrol('PA5.x',[1    1   1   1],figure('visible','off'));
    if invoke(pa5_1,'connectPA5','GB',1)
        'connected to attenuator 1'
        if invoke(pa5_1,'SetAtten',99);
        else
            e='AP5 error in load TDT'
        end
    else
        'unable to connect attenuator 1'
    end
    
    if atten_num>1
        pa5_2=actxcontrol('PA5.x',[1    1   1   1],figure('visible','off'));
        if invoke(pa5_2,'connectPA5','GB',2)
            'connected to attenuator 2'
            if invoke(pa5_2,'SetAtten',99);
            else
                e='AP5 error in load TDT'
            end
        else
            'unable to connect attenuator 2'
        end
        
        if atten_num>2
            pa5_3=actxcontrol('PA5.x',[1    1   1   1],figure('visible','off'));
            if invoke(pa5_3,'connectPA5','GB',3)
                'connected to attenuator 3'
                if invoke(pa5_3,'SetAtten',99);
                else
                    e='AP5 error in load TDT'
                end
            else
                'unable to connect attenuator 3'
            end
            
            if atten_num>3
                pa5_4=actxcontrol('PA5.x',[1    1   1   1],figure('visible','off'));
                if invoke(pa5_4,'connectPA5','GB',4)
                    'connected to attenuator 4'
                    if invoke(pa5_4,'SetAtten',99);
                    else
                        e='AP5 error in load TDT'
                    end
                else
                    'unable to connect attenuator 4'
                end
            end
        end
    end
end
            
    
    
    invoke(RP_1,'ClearCOF'); %Clears all the Buffers and circuits on that RP2
%     invoke(RP_2,'ClearCOF'); Removed all instances of RP_2 DJT 7/30/2012 
    
    if invoke(zbus,'connectZBUS','GB');
        'connected to zbus'
    else
        'unable to connect zbus'
    end
    
    if invoke(RP_1,'connectRP2','GB',1)
        'connected to RP1'
    else
        'unable to connect RP1'
    end
    
%     if invoke(RP_2,'connectRP2','GB',2)  
%         'connected to RP2'
%     else
%         'unable to connect RP2'
%     end
%%%% Removed all instances of RP_2 DJT 7/30/2012 
    
    if invoke(RA_16, 'ConnectRA16','GB',1);
        'connected to RA16'
    else
        'unable to connect RA16'
    end

    %%  clear zbus
    invoke(zbus,'HardwareReset',1);
    invoke(zbus,'FlushIO',1);
    
    %  set the unused attenuators to high
%     if invoke(pa5_3,'SetAtten',100);
%     else
%         e='AP5 error on 3'
%     end
%     if invoke(pa5_4,'SetAtten',100);
%     else
%         e='AP5 error on 4'
%     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if samp_freq==25000
    cof_num=2;
    'Sampling frquency is 25000 Hz'
elseif samp_freq==50000
    cof_num=3;
    'Sampling frquency is 50000 Hz'
else
    'SAMPLING FREQUENCY IS WRONG!'
end
    %%  Load the necessary files to the selected hardware devices
    if ~strcmp(RP1name,'')
        if invoke(RP_1,'loadCOFsf',strcat(RPVDS_path,'\',RP1name), 0)
            invoke(RP_1, 'clearCOF');
            invoke(RP_1, 'loadCOFsf',strcat(RPVDS_path,'\',RP1name),cof_num);
            strcat(RP1name,' loaded on RP1')
        else
            'error in loading RP1'
        end
    end
    
%     if ~strcmp(RP2name,'')
%         if invoke(RP_2,'loadCOFsf',strcat(RPVDS_path,'\',RP2name), 0) 
%             invoke(RP_2, 'clearCOF'); Removed all instances of RP_2 DJT 7/30/2012 
%             invoke(RP_2, 'loadCOFsf',strcat(RPVDS_path,'\',RP2name),
%             cof_num);   Removed all instances of RP_2 DJT 7/30/2012 
%             strcat(RP2name,' loaded on RP2')
%         else
%             'error in loading RP2'
%         end
%     end
%%% Removed all instances of RP_2 DJT 7/30/2012 

    if ~strcmp(RA16name,'')
        if invoke(RA_16,'loadCOFsf',strcat(RPVDS_path,'\',RA16name), 2)
            strcat(RA16name,' loaded on RA16')
        else
            'error in loading RA16'
        end
    end
    cd(currentdir);
return;