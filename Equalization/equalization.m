global cal RP_1 RP_2 pa5_1 pa5_2 pa5_3 pa5_4 RA_16  zbus;

% Set defaults
cal.path='';
cal.file='';
cal.fs=2.4414e+004;
cal.collect=2^11;
cal.reps=130;  %150   % this determines how long the sound is
cal.min=2;
cal.max=11;
cal.buffer_size=cal.collect*cal.reps;
cal.trx_L=[];
cal.trx_R=[];
cal.invIR_L=[];
cal.invIR_R=[];
cal.atten=30;  
cal.amp=2;
cal.earphone=666;  % set this to a dummy value just to initialize this field in cal

%%% colors
cal.c_yellow=[.95, .95, .7];
cal.c_green=[.5,.58,.5]; 
cal.c_red=[.7 .4 .4];
cal.c_line=[.3 .3 .3];


% Open main menu
main_menu;

fprintf(1,'\n\nHOW TO CONNECT THE CABLES WHEN USING THIS PROGRAM:\n')
fprintf(1,'Output 1 of RP_1 goes to the PA5 input of the appropriate earphone\n')
fprintf(1,'Output 2 of RP_1 goes to input 2 of RP_1\n') %changed from RP_2 to RP_1 DJT 3/13/2012
fprintf(1,'Input 1 of RP_1 comes from the microphone amplifier\n\n'); %changed from RP_2 to RP_1 DJT 3/13/2012

 
