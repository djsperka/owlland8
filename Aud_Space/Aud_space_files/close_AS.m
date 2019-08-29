function close_AS()
    global RP_1 RP_2 RA_16 snd;
    if snd.runmode==1 
        invoke(RP_1,'ClearCOF');
%         invoke(RP_2,'ClearCOF'); Removed all instances of RP_2 DJT 7/30/2012        
        invoke(RA_16,'ClearCOF');
    end;
    cd ..;
    close all
    clear all
return;