function set_continuous(runmode)
        global snd multcont list rec cont RP_1 RP_2 RA_16 zbus pa5_1 pa5_2 stopf;
        set_cont_defaults
        clear global multcont list;
        global multcont list;
        stopf=0;
        
        if nargin==0
            runmode=cont.runmode;  %%runmode==1-> collect data.  Any other number->disable data collection
        end
         
        if runmode
            invoke(RP_1,'ClearCOF');  %%remove currently load RPVDS 
%             invoke(RP_2,'ClearCOF');
%%% Removed all instances of RP_2 DJT 7/30/2012 
             
            currentdir=pwd;
            ASPath=strcat(currentdir,'/../Aud_space_files');
            EqPath=strcat(currentdir,'/../../computer_specific_calibrations');
            RPVDSpath=strcat(currentdir,'/../RPVDS');
        
            %%changed to RA16eight DJT 9/13/2012
            loadTDT(RPVDSpath,'moving_snd','rp2_test','RA16eight',snd.atten_num);
            
            %%%computer specific calibration
            [junk_info,current_rig]=dos('hostname');
            current_rig_p=strmatch(current_rig,snd.rig_room);
    
            EQ_cal_file_L=['EQ_file_left_',char(snd.rigs(current_rig_p))];
            EQ_cal_file_R=['EQ_file_right_',char(snd.rigs(current_rig_p))];

            if exist([EqPath,'\',EQ_cal_file_L,'.mat'])~=2
                fprintf(1,'ERROR: %s.mat  was not found \nMake sure the %s directory contains this file', EQ_cal_file_L, EqPath);
                return;
            end
            if exist([EqPath,'\',EQ_cal_file_R,'.mat'])~=2
                fprintf(1,'ERROR: %s.mat  was not found \nMake sure the %s directory contains this file', EQ_cal_file_R, EqPath);
                return;
            end        
            
            load([EqPath,'\',EQ_cal_file_L]);
            eq_left=b2;
            load([EqPath,'\',EQ_cal_file_R]);
            eq_right=b2;
            clear b2;

            %loads eq_filters
            if invoke(RP_1,'WriteTagV','left_eq',0,eq_left)
                else
      	            e='left eq filter incorrectly loaded' 
            end
        
            if invoke(RP_1,'WriteTagV','right_eq',0,eq_right)
                else
      	            e='right eq filter incorrectly loaded' 
            end
    
            set_RA16;
            invoke(RA_16,'run');
        end;

% % %             
% % %             
% % %             
% % %             
% % %             
% % %             
% % %             
% % %             
% % %             
% % %             
% % %             
% % %             %%  set the equalization files
% % %             cd(EqPath);
% % %             load EQ_file_left;
% % %             eq_left=b2;
% % %             load EQ_file_right;
% % %             eq_right=b2;
% % %             clear b2;
% % %             cd(ASPath);
% % % 	
% % %             %loads eq_filters
% % %             if invoke(RP_1,'WriteTagV','left_eq',0,eq_left)
% % %                 else
% % %       	            e='left eq filter incorrectly loaded' 
% % %             end
% % %         
% % %             if invoke(RP_1,'WriteTagV','right_eq',0,eq_right)
% % %                 else
% % %       	            e='right eq filter incorrectly loaded' 
% % %             end
% % %             set_RA16     %%%import values from Aud_spaces
% % %             invoke(RA_16,'run');
% % %         end
% % %     
    myscreen=get(0,'screensize');
    c_yellow=[.95, .95, .7];
    c_green=[.5,.58,.5]; 
    c_red=[.7 .4 .4];
    c_line=[.3 .3 .3];
    c_load=[0.526,0.552,0.552];
    
    figure('position',[1280*runmode+4,34,myscreen(3)/3-8,myscreen(4)-68],...
        'menubar','none',...
        'color', c_yellow,...  
        'tag','set_cont_win');
    
    fb = uimenu('Label','File');
        uimenu(fb,'Label','Open','Callback','open_cont;','Accelerator','O');
        uimenu(fb,'Label','Update','Callback','update_file_cont','Accelerator','U');
        uimenu(fb,'Label','Close','Callback','set_continuous_back;','Accelerator','Q');
        uimenu(fb,'Label','','Separator','on');
        uimenu(fb,'Label','');
        uimenu(fb,'Label','Previous','Callback','prev_cont;','Accelerator','P');
        uimenu(fb,'Label','Next','Callback','next_cont;','Accelerator','N');
        uimenu(fb,'Label','','Separator','on');
        uimenu(fb,'Label','');
        uimenu(fb,'Label','Stop','Callback','stop_cb;','Separator','on','Accelerator','K');
    fc = uimenu('Label','Special');
        uimenu(fc,'Label','P Curves','Callback','set_prediction;');
        uimenu(fc,'Label','Segment Curves','Callback','set_cont_segments;');
        uimenu(fc,'Label','');
        uimenu(fc,'Label','Run in Order','Callback','run_mult_cont_in_order;');
        
        
       

    uicontrol('style','text','units','normalized','position', [.025 .91 .95 .08],'backgroundcolor',c_line);
    uicontrol('style','text','units','normalized','position', [.03 .9125 .94 .075],'backgroundcolor',c_red); 
    uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.05 .955 .4 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.filename,...
    	'tag','filename','callback','set_cont_params;'); 

    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.05 .92 .15 .025],...
    	'backgroundcolor',c_red,...
    	'horizontalalignment','left',...
  		'string','Trace');
   
    uicontrol('style','pushbutton',...
    	'units','normalized',...
    	'position', [.2 .92 .04 .025],...
    	'backgroundcolor',c_green,...
    	'horizontalalignment','center',...
        'fontweight','bold',...
  		'string','<',...
    	'callback','prev_cont;'); 
    uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.25 .92 .15 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.trace,...
    	'tag','trace',...
        'callback','jump_to_cont');
   uicontrol('style','pushbutton',...
    	'units','normalized',...
    	'position', [.41 .92 .04 .025],...
    	'backgroundcolor',c_green,...
    	'horizontalalignment','center',...
        'fontweight','bold',...
  		'string','>',...
    	'callback','next_cont;'); 

    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.55 .92 .2 .025],...
    	'backgroundcolor',c_red,...
    	'horizontalalignment','left',...
  		'string','VS cutoff');
    uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.7 .92 .12 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string','0.25',...
        'tag','vs_cutoff');
    
        uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.55 .955 .15 .025],...
    	'backgroundcolor',c_red,...
    	'horizontalalignment','center',...
  		'string','V strength');     
        uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.7 .955 .1 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string','',...
    	'tag','vs_label_l');     
        uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.8 .955 .1 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string','',...
    	'tag','vs_label_r');     


       
       

    
    %%%    ITD and Az params
    iv1=.07;
    iv2=.07;
    iv3=-.04;
    iv4=0;
    uicontrol('style','text',...
   	    'units','normalized',...
   	    'position', [.15 .8+iv1 .15 .02],...
   	    'backgroundcolor',c_yellow,...
   	    'string','Minimum',...
   	    'horizontalalignment','left');
    uicontrol('style','text',...
   	    'units','normalized',...
   	    'position', [.3 .8+iv1 .15 .02],...
   	    'backgroundcolor',c_yellow,...
   	    'string','Maximum',...
   	    'horizontalalignment','left');
    uicontrol('style','text',...
   	    'units','normalized',...
   	    'position', [.05 .77+iv1 .15 .02],...
   	    'backgroundcolor',c_yellow,...
   	    'string','ITD',...
   	    'horizontalalignment','left');
    uicontrol('style','text',...
   	    'units','normalized',...
   	    'position', [.05 .74+iv1 .15 .02],...
   	    'backgroundcolor',c_yellow,...
   	    'string','Az',...
   	    'horizontalalignment','left');

   uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.15 .77+iv1 .14 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.ITD_min,...
   	    'tag','ITD_min',...
    	'callback','set_cont_params;'); 
   uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.3 .77+iv1 .14 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.ITD_max,...
   	    'tag','ITD_max',...
    	'callback','set_cont_params;'); 
   uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.15 .74+iv1 .14 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.az_min,...
   	    'tag','az_min',...
    	'callback','set_cont_params;'); 
   uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.3 .74+iv1 .14 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.az_max,...
   	    'tag','az_max',...
    	'callback','set_cont_params;'); 

    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.47 .77+iv1 .08 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string','ILD'); 
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.47 .74+iv1 .08 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string','El'); 
    uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.55 .77+iv1 .08 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.ILD,...
   	    'tag','ILD',...
    	'callback','set_cont_params;'); 
    uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.55 .74+iv1 .08 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.vis_el,...
   	    'tag','vis_el',...
    	'callback','set_cont_params;'); 
    
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.73 .77+iv1 .2 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','right',...
  		'string','Present',...
        'tag','present_aud',...
        'callback','set_cont_params',...
        'value',cont.present_aud);
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.73 .74+iv1 .2 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','right',...
  		'string','Present',...
        'tag','present_vis',...
        'callback','set_cont_params',...
        'value',cont.present_vis);

    
    
    
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.05 .72+iv2 .9 .005],...
    	'backgroundcolor',c_line);
    
    
    uicontrol('style','popup',...
    	'units','normalized',...
    	'position', [.05 .68+iv2 .2 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string',cont.motion_type_array,...
   	    'tag','motion_type',...
        'value',cont.motion_type,...
    	'callback','set_cont_params;');  
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.3 .68+iv2 .2 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string','correlated',...
   	    'tag','correlated',...
   	    'value',cont.correlated,...
    	'callback','set_cont_params;'); 

    
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.05 .64+iv2 .2 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string','Background'); 
    uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.25 .64+iv2 .08 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.back,...
   	    'tag','back',...
    	'callback','set_cont_params;'); 
    
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.05 .61+iv2 .2 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','Left',...
  		'string','Foreground'); 
    uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.25 .61+iv2 .08 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.fore,...
   	    'tag','fore',...
    	'callback','set_cont_params;'); 
    
    
    
    
    
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.05 .58+iv2 .2 .022],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string','Start Pause'); 
    uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.25 .58+iv2 .08 .022],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.startpause,...
   	    'tag','startpause',...
    	'callback','set_cont_params;'); 
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.05 .55+iv2 .2 .022],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string','ISI'); 
    uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.25 .55+iv2 .08 .022],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.isi,...
   	    'tag','isi',...
    	'callback','set_cont_params;'); 

    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.05 .52+iv2 .2 .022],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string','ABI'); 
    uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.25 .52+iv2 .08 .022],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.abi,...
   	    'tag','abi',...
    	'callback','set_cont_params;'); 

    
    
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.64 .67+iv2 .14 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','right',...
  		'string','noise rate'); 
    uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.81 .67+iv2 .15 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.noise_hz,...
   	    'tag','noise_hz',...
    	'callback','set_cont_params;');  
   uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.64 .64+iv2 .14 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','right',...
  		'string','time (s)'); 
   uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.81 .64+iv2 .15 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.time,...
   	    'tag','time',...
    	'callback','set_cont_params;'); 

    
    
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.64 .61+iv2 .14 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','right',...
  		'string','reps'); 
    uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.81 .61+iv2 .15 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.reps,...
   	    'tag','reps',...
    	'callback','set_cont_params;');
    
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.64 .58+iv2 .16 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','right',...
  		'string','Rise (ms)'); 
    uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.81 .58+iv2 .15 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.rise,...
   	    'tag','rise',...
    	'callback','set_cont_params;');  
    
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.64 .55+iv2 .16 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','right',...
  		'string','Start dir'); 
    uicontrol('style','popup',...
    	'units','normalized',...
    	'position', [.82 .55+iv2 .15 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string',{'right','left'},...
   	    'tag','dir',...
        'value',cont.dir,...
    	'callback','set_cont_params;');  

    
    
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.78 .52+iv2 .2 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','right',...
    	'value',cont.save_snips,'callback','set_cont_params;',...
  		'string','Save snips','tag','save_snips'); 


    
    
    
    
       
    
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.05 .61+iv3 .9 .005],...
    	'backgroundcolor',c_line);
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.05 .57+iv3 .15 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string','Vis radius'); 
   uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.2 .57+iv3 .08 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.vis_radius_h,...
   	    'tag','vis_radius_h',...
    	'callback','set_cont_params;'); 
   uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.29 .57+iv3 .08 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.vis_radius_v,...
   	    'tag','vis_radius_v',...
    	'callback','set_cont_params;'); 
   uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.05 .54+iv3 .15 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string','ITD offset'); 
   uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.2 .54+iv3 .08 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string',cont.ITD_offset,...
   	    'tag','ITD_offset',...
    	'callback','set_cont_params;'); 
    uicontrol('style','pushbutton',...
    	'units','normalized',...
    	'position', [.75 .55+iv3 .2 .05],...
    	'backgroundcolor',c_green,...
        'fontweight','bold',...
    	'horizontalalignment','center',...
  		'string','Run',...
    	'callback','run_one_cont;');     

 
    
    %%%%%%%%analysis stuff
        uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.05 .48+iv4 .9 .005],...
    	'backgroundcolor',c_line);
    
    
    
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.05 .44+iv4 .08 .02],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string','Plot');     
    uicontrol('style','popup',...
    	'units','normalized',...
    	'position', [.13 .44+iv4 .15 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string',{'Aud','Vis','Both'},...
        'value',1,...
    	'tag','hist_type');  
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.3 .44+iv4 .05 .02],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string','Ch');     
    uicontrol('style','popup',...
    	'units','normalized',...
    	'position', [.35 .44+iv4 .1 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string',[1:rec.numch],...
  		'value',rec.dispch,...
        'tag','display_chan');


    
    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.46 .44+iv4 .12 .02],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','right',...
  		'string','vis div');     
   uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.6 .44+iv4 .08 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string','10','tag','visdiv');     

    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.7 .44+iv4 .12 .02],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','right',...
  		'string','ITD div');     
    uicontrol('style','edit',...
    	'units','normalized',...
    	'position', [.84 .44+iv4 .08 .025],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string','10','tag','ITDdiv');     
    
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.05 .41+iv4 .2 .02],...
    	'backgroundcolor',c_yellow,...
  		'string','fit gauss',...
    	'tag','show_g_fit');     
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.3 .41+iv4 .2 .02],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','center',...
  		'string','Summary',...
    	'tag','show_win_2');     
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.05 .38+iv4 .25 .02],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string','Show Error',...
  		'value',1,...
        'tag','show_error');
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.3 .38+iv4 .25 .02],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string','Show Graphs',...
  		'value',1,...
        'tag','show_graphs');
    
        uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.05 .33+iv4 .2 .02],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string','Exclude',...
  		'value',0,...
        'tag','param_set_wrong',...
        'callback', 'update_param_set_wrong');
    
    
    uicontrol('style','pushbutton',...
    	'units','normalized',...
    	'position', [.75 .38+iv4 .2 .05],...
    	'backgroundcolor',c_red,...
    	'horizontalalignment','center',...
        'fontweight','bold',...
  		'string','Plot',...
        'callback','show_cont_graphs;');

    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% interleave multiple traces window
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rm_v=.03;
        uicontrol('style','text',...
        'units','normalized',...
        'position', [.25 .10+rm_v .8 .1],...
        'backgroundcolor',c_yellow,...
        'string','Interleave Mult Traces ',...
        'fontweight','bold',...
        'fontsize',12,...
        'horizontalalignment','left');

        uicontrol('style','pushbutton',...
		'units','normalized',...
		'position', [.1 .12+rm_v .2 .04],...
		'horizontalalignment','center',...
		'string','Add',...
        'fontweight','bold',...
        'backgroundcolor',c_load,...
		'callback','add_cont_cb');
       
        uicontrol('style','pushbutton',...
		'units','normalized',...
		'position', [.36 .12+rm_v .2 .04],...
		'horizontalalignment','center',...
		'string','Remove',...
        'fontweight','bold',...
        'backgroundcolor',c_load,...
		'callback','remove_cont_cb');
    
        uicontrol('style','pushbutton',...
		'units','normalized',...
		'position', [.62 .12+rm_v .2 .04],...
		'horizontalalignment','center',...
		'string','Display',...
        'fontweight','bold',...
        'backgroundcolor',c_load,...
		'callback','disp_cont_cb');

       uicontrol('style','Listbox',...
    	'units','normalized',...
    	'position', [.1 .01+rm_v .7 .1],...
    	'backgroundcolor',c_yellow,...
    	'horizontalalignment','left',...
  		'string','',...
   	    'tag','inter_cont_tag'); 
    
    
    
    
        uicontrol('style','pushbutton',...
        'units','normalized',...
        'position', [.83 .02+rm_v .16 .07],...
        'horizontalalignment','center',...
        'string','Run Mult',...
        'backgroundcolor',c_red,...
        'fontweight','bold',...
        'tag','run',...
        'callback','run_cont_tuning_curve');
        
    
    
   uicontrol('style','text',...
        'units','normalized',...
        'position', [.02 .01 .16 .02],...
        'horizontalalignment','right',...
        'string','Progress',...
        'backgroundcolor',c_yellow,...
        'fontweight','bold');
   uicontrol('style','text',...
        'units','normalized',...
        'position', [.2 .01 .11 .02],...
        'backgroundcolor',[.2,.2,.2],...
        'tag','prog_1',...
        'visible','off');
   uicontrol('style','text',...
        'units','normalized',...
        'position', [.32 .01 .11 .02],...
        'backgroundcolor',[.2,.2,.2],...
        'tag','prog_2',...
        'visible','off');
   uicontrol('style','text',...
        'units','normalized',...
        'position', [.44 .01 .11 .02],...
        'backgroundcolor',[.2,.2,.2],...
        'tag','prog_3',...
        'visible','off');
   uicontrol('style','text',...
        'units','normalized',...
        'position', [.56 .01 .11 .02],...
        'backgroundcolor',[.2,.2,.2],...
        'tag','prog_4',...
        'visible','off');
   uicontrol('style','text',...
        'units','normalized',...
        'position', [.68 .01 .11 .02],...
        'backgroundcolor',[.2,.2,.2],...
        'tag','prog_5',...
        'visible','off');
   uicontrol('style','text',...
        'units','normalized',...
        'position', [.8 .01 .11 .02],...
        'backgroundcolor',[.2,.2,.2],...
        'tag','prog_6',...
        'visible','off');
    
    
    
    figure('position',[myscreen(3)/3+4,34,2*myscreen(3)/3-8,myscreen(4)/2-68],'color', c_yellow,'tag','cont_disp_2');
    figure('position',[myscreen(3)/3+4,myscreen(4)/2+34,2*myscreen(3)/3-8,myscreen(4)/2-68],'color', c_yellow,'tag','cont_disp_1');
    figure(findobj(0,'tag','set_cont_win'));     %% set the third window as active   
    
    
return;
