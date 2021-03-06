function Aud_Space(user_defaults)
%%user_defaults must be a matlab file containing snd & rec defaults
global snd rec stopf runf pausef;
global RP_1 RP_2 pa5_1 pa5_2 zbus RA_16 screen_offset;

addpath(genpath('C:\MATLAB6p5p2\toolbox\Psychtoolbox')) %added in spring 2011 - DJT
addpath(genpath('C:\MATLAB6p5p2\toolbox\signal\signal')) %added fall 2011

currentdir=pwd;
stopf=0;
runf=0;
snd.pause_flag=0;


ASPath=strcat(currentdir,'\Aud_space_files');
RPVDSpath=strcat(currentdir,'\RPVDS');
defaultpath=strcat(currentdir,'\Defaults\');
EqPath=strcat(currentdir,'\..\computer_specific_calibrations');

if nargin==0    %%load the appropriate defaults
    user_defaults='offline';
end
load([defaultpath,user_defaults]);
snd.defaults=[defaultpath,user_defaults];

snd.path=defaultpath;      %%default path for saving upon start

[junk_info,current_rig]=dos('hostname');

%%--- Modified by Shreesh on 6.8.2010
%%--- Also modified Defaults/online.mat -> snd.rigs and snd.rig_room appropriately
% current_rig_p=strmatch(current_rig,snd.rig_room);
current_rig_p=strmatch(current_rig(1:end-1),snd.rig_room);


if snd.runmode==1
    snd.rigs
    char(snd.rigs(current_rig_p))
    current_rig_p
    vis_cal_file=['vis_',char(snd.rigs(current_rig_p))];
    EQ_cal_file=['EQ_file_',char(snd.rigs(current_rig_p))];
    
    gamma_inv_file=['gamma_inv_',char(snd.rigs(current_rig_p))];
    
    
    
    
    if exist([EqPath,'\',vis_cal_file,'.mat'])~=2
        fprintf(1,'ERROR: %s.mat  was not found \nMake sure the %s directory contains this file', vis_cal_file, EqPath);
        return;
    end
    if exist([EqPath,'\',EQ_cal_file,'.mat'])~=2
        fprintf(1,'ERROR: %s.mat  was not found \nMake sure the %s directory contains this file', EQ_cal_file, EqPath);
        return;
    end
    
    if exist([EqPath,'\',gamma_inv_file,'.mat'])~=2
        fprintf(1,'ERROR: %s.mat  was not found \nMake sure the %s directory contains this file', gamma_inv_file, EqPath);
        return;
    end
    
    %%load the visual calibrations
    vis_cal=load([EqPath,'\',vis_cal_file]);
    vis_fields=fieldnames(vis_cal.snd);
    for curr_field=1:length(vis_fields)
        snd=setfield(snd,vis_fields{curr_field},getfield(vis_cal.snd,vis_fields{curr_field}));
    end
    
    %        %% load the gamma curve
    load([EqPath,'\',gamma_inv_file]);
    snd.gamma_inv(2,:)=gamma_xaxis;
    snd.gamma_inv(1,:)=gamma_inv;
    
end

%% get the white and black values for the computer
window=Screen(0,'OpenWindow',0);
snd.hz=Screen(window,'FrameRate');  %get the refresh rate of the monitor
snd.black=BlackIndex(window);       %%  Find the value of black
snd.white=WhiteIndex(window);       %%  Find the Value of white
snd.priorityLevel=MaxPriority(0,'WaitBlanking');     %read the string 'loop' with high CPU priority.
Screen('CloseAll');                 %%  Close the Screen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

myscreen=get(0,'Screensize');   %%size of Screen for opening windows
screen_offset=(snd.controlwindow-1)*myscreen(3); %Made Global, so stimulus window opens on the correct Screen.  DJT 2/22/2012

cd(ASPath);

if snd.runmode==1    %%  if you are planning on collecting data
    
    %%Changed to RA16eight djt 9/13/2012
    loadTDT(RPVDSpath,'rp1_AM','rp2_AM','RA16eight',snd.atten_num, snd.fs);
    %         loadTDT(RPVDSpath,'rp1_AM','rp2_test','RA16four',snd.atten_num);
    
    %%  set the equalization files
    load([EqPath,'\',EQ_cal_file]);
    eq_left=  cal.invIR_L';
    eq_right= cal.invIR_R';
    clear cal;
    
    %loads eq_filters
    if invoke(RP_1,'WriteTagV','left_eq',0,eq_left)
    else
        e='left eq filter incorrectly loaded'
    end
    
    if invoke(RP_1,'WriteTagV','right_eq',0,eq_right)
    else
        e='right eq filter incorrectly loaded'
    end
    
    %         if invoke(RP_2,'WriteTagV','left_eq',0,eq_left)
    %             else
    %   	            e='left2 filter incorrectly loaded'
    %         end
    %
    %         if invoke(RP_2,'WriteTagV','right_eq',0,eq_right)
    %             else
    %   	            e='right2 filter incorrectly loaded'
    %         end
    %Removed 2/22/2012 by DJT.  Only have one RP2 processor
    
    set_RA16;
    invoke(RA_16,'run');
end;



%%colors (try tinkering with them when procrastinating)
c_yellow=[.95, .95, .7];
c_green=[.5,.58,.5];
c_red=[.7 .4 .4];
c_line=[.3 .3 .3];

%%open the windows
figure('position',[screen_offset+4  ((2-snd.controlwindow)*30+4) ((myscreen(3)/2)-8) ((myscreen(4)/3)-48)],...
    'menubar','none',...
    'color',c_green ,...
    'tag','Aud_Space_win');


figure('position',[((myscreen(3)/2)+screen_offset+4)  ((2-snd.controlwindow)*30+4) ((myscreen(3)/2)-8) ((myscreen(4)/3)-48)],...
    'menubar','none',...
    'color', c_green,...
    'tag','disp_win_3');


figure('position',[screen_offset+4 (myscreen(4)/3+12) ((myscreen(3)/2)-8) (2*myscreen(4)/3-90)],...
    'color', c_yellow,...
    'tag','disp_win_1');
fa = uimenu('Label','background');
uimenu(fa,'Label','Black','Callback','set(gcf,''color'',[0,0,0])');
uimenu(fa,'Label','White','Callback','set(gcf,''color'',[1,1,1])');
uimenu(fa,'Label','Cream','Callback','set(gcf,''color'',[.95, .95, .7])');
uimenu(fa,'Label','Green','Callback','set(gcf,''color'',[.4,.6,.4])');
uimenu(fa,'Label','Burgundy','Callback','set(gcf,''color'',[.6 .2 .2])');
uimenu(fa,'Label','');
uimenu(fa,'Label','Other','Callback','set_color');



figure('position',[((myscreen(3)/2)+screen_offset+4) (myscreen(4)/3+12) ((myscreen(3)/2)-8) (2*myscreen(4)/3-90)],...
    'color', c_yellow,...
    'tag','disp_win_2');
fa = uimenu('Label','background');
uimenu(fa,'Label','Black','Callback','set(gcf,''color'',[0,0,0])');
uimenu(fa,'Label','White','Callback','set(gcf,''color'',[1,1,1])');
uimenu(fa,'Label','Cream','Callback','set(gcf,''color'',[.95, .95, .7])');
uimenu(fa,'Label','Green','Callback','set(gcf,''color'',[.4,.6,.4])');
uimenu(fa,'Label','Burgundy','Callback','set(gcf,''color'',[.6 .2 .2])');
uimenu(fa,'Label','');
uimenu(fa,'Label','Other','Callback','set_color');


figure(findobj(0,'tag','Aud_Space_win'));     %% set the control window as active

%%set the menus
fa = uimenu('Label','File');
uimenu(fa,'Label','Open File','Callback','open_file',...
    'Separator','off','Accelerator','O');
uimenu(fa,'Label','Save File','Callback','save_file_dialog',...
    'Separator','off','Accelerator','S');
uimenu(fa,'Label','Update File','Callback','update_file',...
    'Separator','off','Accelerator','U');
uimenu(fa,'Label','');
uimenu(fa,'Label','Next','Callback','next_trace;',...
    'Accelerator','F');
uimenu(fa,'Label','Previous','Callback','prev_trace;',...
    'Separator','on','Accelerator','B');
uimenu(fa,'Label','');
uimenu(fa,'Label','Quit','Callback','close_AS;',...
    'Separator','on','Accelerator','Q');
fb = uimenu('Label','Test');
uimenu(fb,'Label','Run Test','Callback','run_tuning_curve_cb',...
    'Separator','on','Accelerator','R');
uimenu(fb,'Label','');
uimenu(fb,'Label','Collect Spike training','Callback','collect_spike_training_AS','Separator','on');
uimenu(fb,'Label','Run Continuous','Callback','set_continuous','Accelerator','C');
uimenu(fb,'Label','');
uimenu(fb,'Label','Interleave Traces', 'Callback', 'interleave_cb');
uimenu(fb,'Label','');
uimenu(fb,'Label','Pause','Callback','pause_cb;',...
    'Separator','off','Accelerator','P','tag','Pause_menu');
uimenu(fb,'Label','Stop','Callback','stop_cb;',...
    'Separator','on','Accelerator','K');


fc = uimenu('Label','Other');
uimenu(fc,'Label','Other params','Callback','other_params');
uimenu(fc,'Label','');
uimenu(fc,'Label','Save Default Copy','Callback','save_defaults');
uimenu(fc,'Label','');
uimenu(fc,'Label','Message','Callback','set_message','Accelerator','M');
uimenu(fc,'Label','');
%     uimenu(fc,'Label','Stimulus Grid','Callback','show_stim_grid','Accelerator','G');  % not working, take out
%     uimenu(fc,'Label','');
uimenu(fc,'Label','Estimate time','Callback','estimate_time');


uicontrol('style','text','units','normalized','position', [.00 .25 .75 .5],'backgroundcolor',c_yellow);%%line

uicontrol('style','text','units','normalized','position', [.00 .75 .98 .01],'backgroundcolor',c_line);%%line
uicontrol('style','text','units','normalized','position', [.0 .25 .98 .01],'backgroundcolor',c_line);%%line
uicontrol('style','text','units','normalized','position', [.75 .01 .006 .98],'backgroundcolor',c_line);%%line


%%   set Variable #1 range   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d=.1;

uicontrol('style','text',...
    'units','normalized',...
    'position', [.2 .51+d .1 .05],...
    'backgroundcolor',c_yellow,...
    'string','Minimum',...
    'horizontalalignment','left');
uicontrol('style','text',...
    'units','normalized',...
    'position', [.3 .51+d .1 .05],...
    'backgroundcolor',c_yellow,...
    'string','Maximum',...
    'horizontalalignment','left');
uicontrol('style','text',...
    'units','normalized',...
    'position', [.4 .51+d .1 .05],...
    'backgroundcolor',c_yellow,...
    'string','Step',...
    'horizontalalignment','left');


uicontrol('style','popup',...
    'units','normalized',...
    'position', [.05 .45+d .15 .06],...
    'backgroundcolor', c_yellow,...
    'horizontalalignment','left',...
    'string',snd.Var1_choices,...
    'tag','Var1',...
    'callback','set_test_params;');
uicontrol('style','edit',...
    'units','normalized',...
    'position', [.2 .45+d .08 .06],...
    'backgroundcolor',c_yellow,...
    'horizontalalignment','left',...
    'string',snd.Var1min,...
    'tag','Var1min',...
    'callback','set_range_params;');
uicontrol('style','edit',...
    'units','normalized',...
    'position', [.3 .45+d .08 .06],...
    'backgroundcolor',c_yellow,...
    'horizontalalignment','left',...
    'string',snd.Var1max,...
    'tag','Var1max',...
    'callback','set_range_params;');
uicontrol('style','edit',...
    'units','normalized',...
    'position', [.4 .45+d .08 .06],...
    'backgroundcolor',c_yellow,...
    'horizontalalignment','left',...
    'string',snd.Var1step,...
    'tag','Var1step',...
    'callback','set_range_params;');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%   set Variable #2 range   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uicontrol('style','text',...
    'units','normalized',...
    'position', [.2 .375+d .1 .05],...
    'backgroundcolor',c_yellow,...
    'string','Minimum',...
    'tag','Var2_min_label',...
    'horizontalalignment','left');
uicontrol('style','text',...
    'units','normalized',...
    'position', [.3 .375+d .1 .05],...
    'backgroundcolor',c_yellow,...
    'string','Maximum',...
    'tag','Var2_max_label',...
    'horizontalalignment','left');
uicontrol('style','text',...
    'units','normalized',...
    'position', [.4 .375+d .1 .05],...
    'backgroundcolor',c_yellow,...
    'string','Step',...
    'tag','Var2_step_label',...
    'horizontalalignment','left');


uicontrol('style','popup',...
    'units','normalized',...
    'position', [.05 .315+d .15 .06],...
    'backgroundcolor',c_yellow,...
    'horizontalalignment','left',...
    'string',snd.Var2_choices,...
    'tag','Var2',...
    'value',7,...
    'callback','set_test_params;');


uicontrol('style','edit',...
    'units','normalized',...
    'position', [.2 .315+d .08 .06],...
    'backgroundcolor',c_yellow,...
    'horizontalalignment','left',...
    'string',snd.Var2min,...
    'tag','Var2min',...
    'callback','set_range_params;');
uicontrol('style','edit',...
    'units','normalized',...
    'position', [.3 .315+d .08 .06],...
    'backgroundcolor',c_yellow,...
    'horizontalalignment','left',...
    'string',snd.Var2max,...
    'tag','Var2max',...
    'callback','set_range_params;');
uicontrol('style','edit',...
    'units','normalized',...
    'position', [.4 .315+d .08 .06],...
    'backgroundcolor',c_yellow,...
    'horizontalalignment','left',...
    'string',snd.Var2step,...
    'tag','Var2step',...
    'callback','set_range_params;');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




uicontrol('style','text',...
    'units','normalized',...
    'position', [.52 .44+d .1 .05],...
    'backgroundcolor',c_yellow,...
    'string','Reps',...
    'horizontalalignment','left');
uicontrol('style','edit',...
    'units','normalized',...
    'position', [.52 .36+d .08 .06],...
    'backgroundcolor',c_yellow,...
    'horizontalalignment','left',...
    'string',snd.reps,...
    'tag','reps',...
    'callback','set_range_params;');


uicontrol('style','text',...
    'units','normalized',...
    'backgroundcolor',c_green,...
    'fontweight','bold',...
    'string', 'sound on',...
    'position', [.78 .515+d .2 .1],...
    'tag','sound_on');
uicontrol('style','checkbox',...
    'units','normalized',...
    'backgroundcolor',c_green,...
    'string', 'Save Sound',...
    'position', [.78 .415+d .2 .05],...
    'tag','save_sound',...
    'callback','set_range_params',...
    'enable','on');
uicontrol('style','checkbox',...
    'units','normalized',...
    'backgroundcolor',c_green,...
    'string', 'Save Spikes',...
    'position', [.78 .315+d .2 .05],...
    'tag','save_spikes',...
    'callback','set_range_params',...
    'value',0,...
    'enable','on');
uicontrol('style','checkbox',...
    'units','normalized',...
    'backgroundcolor',c_green,...
    'string', 'Interleave Alone',...
    'position', [.78 .215+d .2 .05],...
    'tag','interleave_alone',...
    'callback','set_range_params',...
    'enable','off');






%%  interface buttons %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uicontrol('style','pushbutton',...
    'units','normalized',...
    'position', [.03 .05 .12 .15],...
    'horizontalalignment','center',...
    'string','Stimulus',...
    'backgroundcolor', c_yellow,...
    'fontweight','bold',...
    'callback','setsnd');

uicontrol('style','pushbutton',...
    'units','normalized',...
    'position', [.18 .05 .12 .15],...
    'horizontalalignment','center',...
    'string','Amplifier',...
    'fontweight','bold',...
    'tag','Amp_params',...
    'backgroundcolor', c_yellow,...
    'callback','set_AS_ch');

uicontrol('style','pushbutton',...
    'units','normalized',...
    'position', [.32 .05 .12 .15],...
    'horizontalalignment','center',...
    'string','Visual Grid',...
    'tag','Vis_grid',...
    'backgroundcolor', c_yellow,...
    'fontweight','bold',...
    'callback','Vis_Field');

uicontrol('style','pushbutton',...
    'units','normalized',...
    'position', [.46 .05 .12 .15],...
    'horizontalalignment','center',...
    'string','Map Field',...
    'fontweight','bold',...
    'backgroundcolor', c_yellow,...
    'tag','map_field_button',...
    'callback','map_field');

uicontrol('style','pushbutton',...
    'units','normalized',...
    'position', [.60 .05 .12 .15],...
    'horizontalalignment','center',...
    'string','Auditory Search',...
    'fontweight','bold',...
    'backgroundcolor', c_yellow,...
    'tag','aud_search_button',...
    'callback','aud_pointnclick');

uicontrol('style','pushbutton',...
    'units','normalized',...
    'position', [.8 .05 .15 .15],...
    'horizontalalignment','center',...
    'string','Run Test',...
    'backgroundcolor',c_red,...
    'fontweight','bold',...
    'tag','runtest',...
    'callback','run_tuning_curve_cb');


%%%display controls
%%  window to print the current rep into
uicontrol('style','edit',...
    'units','normalized',...
    'position', [.05 .9 .3 .08],...
    'backgroundcolor',c_green,...
    'horizontalalignment','center',...
    'string',snd.filename,...
    'tag','filename');

uicontrol('style','edit',...
    'units','normalized',...
    'position', [.05 .8 .3 .08],...
    'backgroundcolor',c_green,...
    'horizontalalignment','left',...
    'tag','Print_rep');

uicontrol('style','pushbutton',...
    'units','normalized',...
    'position', [.38 .9 .04 .08],...
    'horizontalalignment','center',...
    'string','<<',...
    'backgroundcolor', c_yellow,...
    'callback','first_trace');
uicontrol('style','pushbutton',...
    'units','normalized',...
    'position', [.42 .9 .03 .08],...
    'horizontalalignment','center',...
    'backgroundcolor', c_yellow,...
    'string','<',...
    'callback','prev_trace');

uicontrol('style','edit',...
    'units','normalized',...
    'position', [.45 .9 .2 .08],...
    'backgroundcolor',c_green,...
    'horizontalalignment','center',...
    'tag','Print_trace',...
    'callback','jump_to_trace');
uicontrol('style','pushbutton',...
    'units','normalized',...
    'position', [.65 .9 .03 .08],...
    'horizontalalignment','center',...
    'string','>',...
    'backgroundcolor', c_yellow,...
    'callback','next_trace');
uicontrol('style','pushbutton',...
    'units','normalized',...
    'position', [.68 .9 .04 .08],...
    'horizontalalignment','center',...
    'string','>>',...
    'backgroundcolor', c_yellow,...
    'callback','last_trace');



uicontrol('style','text',...
    'units','normalized',...
    'position', [.43 .8 .1 .06],...
    'backgroundcolor',c_green,...
    'string','Channel = ',...
    'horizontalalignment','left');

uicontrol('style','popupmenu',...
    'units','normalized',...
    'position', [.54 .8 .1 .08],...
    'backgroundcolor',c_green,...
    'horizontalalignment','left',...
    'string',num2cell([1:rec.numch]),...
    'tag','dispch',...
    'callback','set_dispch;');


%%%mask and unmask a pause button
uicontrol('style','text','units','normalized','position', [.8 .8 .15 .15],'backgroundcolor',c_line,'visible','on');
uicontrol('style','text','units','normalized','position', [.81 .81 .13 .13],'backgroundcolor',[0.8,0.5,0.0],'visible','on');

uicontrol('style','text','units','normalized','position', [.825 .825 .1 .1],'string','Pause',...
    'backgroundcolor',[0.8,0.5,0.0],'fontsize',12,'fontweight','bold','visible','on');

uicontrol('style','text','units','normalized','position', [.8 .8 .15 .15],'tag', 'pause_indicator',...
    'backgroundcolor',c_green,'visible','on');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if snd.runmode~=1
    set(findobj(gcf,'tag','map_field_button'),'enable','off');
    %         set(findobj(gcf,'tag','Vis_grid'),'enable','off');
    set(findobj(gcf,'tag','runtest'),'enable','off');
end


set_range_params;
set_test_params;
analysis_controls;
figure(findobj(0,'tag','Aud_Space_win'));     %% set the first window as active


%% TEMP panel saying what files were loaded
%     if snd.runmode==1
%         figure('position',[myscreen(3)/4,myscreen(4)/4,myscreen(3)/2,myscreen(4)/2],'color', [1,1,1]);
%            uicontrol('style','Listbox',...
%         	'units','normalized',...
%         	'position', [.2 .2 .6 .6],...
%         	'backgroundcolor',[1,1,1],...
%         	'horizontalalignment','left',...
%       		'string',{user_defaults,vis_cal_file,EQ_cal_file_L,EQ_cal_file_R},...
%        	    'tag','inter_tag');
%     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return;
