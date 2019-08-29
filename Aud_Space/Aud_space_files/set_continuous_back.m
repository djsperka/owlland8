function set_continuous_back()
global snd rec cont RP_1 RP_2 RA_16 zbus pa5_1 pa5_2;
    close;
    figure(findobj(0,'tag','cont_disp_1'))
    close
    figure(findobj(0,'tag','cont_disp_2'))
    close


    
    if cont.runmode==1
        cd ..
        currentdir=pwd;
        stopf=0;
        runf=0;
        snd.pause_flag=0;
        ASPath=strcat(currentdir,'\Aud_space_files');
        EqPath=strcat(currentdir,'\equalization_files');
        RPVDSpath=strcat(currentdir,'\RPVDS');
        cd(ASPath);
        
        if snd.runmode==1    %%  if you are planning on collecting data        
            %loadTDT(RPVDSpath,'RP2_1_joe','trigger_yoram','RA16four',4);
            loadTDT(RPVDSpath,'rp1_AM','rp2_AM','RA16eight',snd.atten_num);
            %%  set the equalization files
            cd(EqPath);
            load EQ_file_left;
            eq_left=b2;
            load EQ_file_right;
            eq_right=b2;
            clear b2;
            cd(ASPath);
	
            %loads eq_filters
            if invoke(RP_1,'WriteTagV','left_eq',0,eq_left)
                else
      	            e='left eq filter incorrectly loaded' 
            end
        
            if invoke(RP_1,'WriteTagV','right_eq',0,eq_right)
                else
      	            e='right eq filter incorrectly loaded' 
            end
            
%             if invoke(RP_2,'WriteTagV','left_eq',0,eq_left)
%                 else
%       	            e='left2 filter incorrectly loaded' 
%             end
%%% Removed all instances of RP_2 DJT 7/30/2012 
'Tried accessing RP_2 in set_RP2s_back.m  All instances of RP_2 have been removed'
        
%             if invoke(RP_2,'WriteTagV','right_eq',0,eq_right)
%                 else
%       	            e='right2 filter incorrectly loaded' 
%             end
%%% Removed all instances of RP_2 DJT 7/30/2012 
'Tried accessing RP_2 in set_RP2s_back.m  All instances of RP_2 have been removed'
            
            set_RA16;
            invoke(RA_16,'run');
        end;
    end;    
return;