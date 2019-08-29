function loadTDT(RPVDS_path,RP1name,RP2name,RA16name,atten_num)
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
    RP_2=actxcontrol('RPco.x',[1    1   1   1],figure('visible','off'));
    RA_16=actxcontrol('RPco.x',[1    1   1   1],figure('visible','off'));
    
    if atten_num>0  %%allows up to four attenuators to be added
        pa5_1=actxcontrol('PA5.x',[1    1   1   1],figure('visible','off'));
        if invoke(pa5_1,'connectPA5','GB',1)
            'connected to attenuator 1'
            else
            'unable to connect attenuator 1'
        end
        
        if atten_num>1
            pa5_2=actxcontrol('PA5.x',[1    1   1   1],figure('visible','off'));
            if invoke(pa5_2,'connectPA5','GB',2)
                'connected to attenuator 2'
                else
                'unable to connect attenuator 2'
            end
    
            if atten_num>2
                pa5_3=actxcontrol('PA5.x',[1    1   1   1],figure('visible','off'));
                if invoke(pa5_3,'connectPA5','GB',3)
                    'connected to attenuator 3'
                    else
                    'unable to connect attenuator 3'
                end
    
                if atten_num>3
                    pa5_4=actxcontrol('PA5.x',[1    1   1   1],figure('visible','off'));
                    if invoke(pa5_4,'connectPA5','GB',4)
                        'connected to attenuator 4'
                        else
                        'unable to connect attenuator 4'
                    end
                end
            end
        end
    end
            
    
    
    invoke(RP_1,'ClearCOF'); %Clears all the Buffers and circuits on that RP2
    invoke(RP_2,'ClearCOF');
    
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
    
    if invoke(RP_2,'connectRP2','GB',2)
        'connected to RP2'
    else
        'unable to connect RP2.  But dont even worry bout it, cause we aint got one in the DeBello lab'
    end
    
%     if invoke(RA_16, 'ConnectRA16','GB',1);
%         'connected to RA16'
%     else
%         'unable to connect RA16'
%     end

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
    
    %%  Load the necessary files to the selected hardware devices
    if ~strcmp(RP1name,'')
        if invoke(RP_1,'loadCOFsf',strcat(RPVDS_path,'\',RP1name), 0)
            invoke(RP_1, 'clearCOF');
            invoke(RP_1, 'loadCOF',strcat(RPVDS_path,'\',RP1name));
            strcat(RP1name,' loaded on RP1')
        else
            'error in loading RP1'
        end
    end
    
    %removed this DJT 7/2/2014
%     if ~strcmp(RP2name,'')
%         if invoke(RP_2,'loadCOFsf',strcat(RPVDS_path,'\',RP2name), 0)
%             invoke(RP_2, 'clearCOF');
%             invoke(RP_2, 'loadCOF',strcat(RPVDS_path,'\',RP2name));
%             strcat(RP2name,' loaded on RP2')
%         else
%             'error in loading RP2'
%         end
%     end

    if ~strcmp(RA16name,'')
        if invoke(RA_16,'loadCOFsf',strcat(RPVDS_path,'\',RA16name), 2)
            strcat(RA16name,' loaded on RA16')
        else
            'error in loading RA16'
        end
    end
    cd(currentdir);
return;