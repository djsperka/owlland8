function set_RP2s_back()
global snd rec cont RP_1 RP_2 RA_16 zbus pa5_1 pa5_2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%    %% set everything back to normal
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
        currentdir=pwd;
    ASPath=strcat(currentdir,'/../Aud_space_files');
    EqPath=strcat(currentdir,'/../equalization_files');
    RPVDSpath=strcat(currentdir,'/../RPVDS');

        invoke(RP_1,'ClearCOF');  %remove currently load RPVDS 
        %%%% reload rp1_AM and rp2_AM to leave it as it was before the NBfreq
        %%%% curve
        
        if invoke(RP_1,'loadCOF',strcat(RPVDSpath,'\','rp1_AM'))
            'rp1_AM loaded on RP1'
        else
            'error in loading RP1'
        end
        
%         if invoke(RP_2,'loadCOF',strcat(RPVDSpath,'\','rp2_AM'))
%             'rp2_AM loaded on RP2'
%         else
%             'error in loading RP2'
%         end
%%% Removed all instances of RP_2 DJT 7/30/2012 
'Tried accessing RP_2 in set_RP2s_back.m  All instances of RP_2 have been removed'
        
        %  set the equalization files
        cd(EqPath);
        load EQ_file_left;
        eq_left=b2;
        load EQ_file_right;
        eq_right=b2;
        clear b2;
        cd(ASPath);

        %%loads eq_filters
        
        if invoke(RP_1,'WriteTagV','left_eq',0,eq_left)
            else
  	            e='eq filter incorrectly loaded' 
        end
    
        if invoke(RP_1,'WriteTagV','right_eq',0,eq_right)
            else
  	            e='eq filter incorrectly loaded' 
        end

%         if invoke(RP_2,'WriteTagV','left_eq',0,eq_left)
%             else
%   	            e='eq filter incorrectly loaded' 
%         end
%%% Removed all instances of RP_2 DJT 7/30/2012 
'Tried accessing RP_2 in set_RP2s_back.m  All instances of RP_2 have been removed'
    
%         if invoke(RP_2,'WriteTagV','right_eq',0,eq_right)
%             else
%   	            e='eq filter incorrectly loaded' 
%         end
%%% Removed all instances of RP_2 DJT 7/30/2012 
'Tried accessing RP_2 in set_RP2s_back.m  All instances of RP_2 have been removed'
        
        invoke(RP_1,'run');
%         invoke(RP_2,'run');
%%% Removed all instances of RP_2 DJT 7/30/2012 
    
        
        return;