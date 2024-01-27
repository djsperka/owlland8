function Aud_Space(user_defaults, varargin)
%%user_defaults must be a matlab file containing snd & rec defaults
global snd rec stopf runf pausef;
global RP_1 RP_2 pa5_1 pa5_2 zbus RA_16 screen_offset;



p = inputParser;
% user default .mat file basename
addRequired(p, 'userDefaults', @ischar);

% experiment name - default is 'test' - opens all owland dialogs.
defaultExpt = 'test';
expectedExpts = {'test', 'noisetone'};
addParameter(p, 'expt', defaultExpt, @(x) any(validatestring(x, expectedExpts)));

% rig name - this parameter specifies the filenames:
% vis_<rig>.mat
% EQ_file_<rig>.mat
% gamma_inv_<rig>.mat
% These files must exist in the folder 'computer_specific_calibrations'

defaultRig='DannysBox';
addParameter(p, 'rig', defaultRig, @(x) ischar(x));

% screen offset
defaultScreenOffset = -1600;
addParameter(p, 'offset', defaultScreenOffset, @(x) isscalar(x));

% rcx file (testing)
defaultRCX = 'rp1_AM';
addParameter(p, 'rcx', defaultRCX, @(x) ischar(x));

%% parse input

parse(p, user_defaults, varargin{:});
fprintf('User defaults %s\n', p.Results.userDefaults);
fprintf('Expt chosen %s\n', p.Results.expt);
fprintf('Rig chosen %s\n', p.Results.rig);

stopf=0;
runf=0;
snd.pause_flag=0;



%% Generate useful folder names, set path (this session only).
[pathAS, b, x] = fileparts(mfilename('fullpath'));
pathOwl=fullfile(pathAS, '..');
pathASF=fullfile(pathAS,'Aud_space_files');
pathRPVDS=fullfile(pathAS,'RPVDS');
pathDefault=fullfile(pathAS,'Defaults');
pathEQ=fullfile(pathOwl, 'computer_specific_calibrations');
addpath(pathASF, ...
        fullfile(pathASF, 'Flexible_Stim'), ...
        fullfile(pathOwl, 'Equalization'));
        

    
%% Load user defaults file. 
    
load(fullfile(pathDefault, p.Results.userDefaults));
snd.defaults=fullfile(pathDefault, p.Results.userDefaults);

snd.path=pathDefault;      %%default path for saving upon start


%% Load calibration files for this rig. 

if snd.runmode==1
    vis_cal_base=['vis_', p.Results.rig, '.mat'];
    EQ_cal_base=['EQ_file_', p.Results.rig, '.mat'];
    gamma_inv_base=['gamma_inv_', p.Results.rig, '.mat'];
    
    vis_cal_filename = fullfile(pathEQ, vis_cal_base);
    EQ_cal_filename = fullfile(pathEQ, EQ_cal_base);
    gamma_inv_filename = fullfile(pathEQ, gamma_inv_base);
    
    
    if exist(vis_cal_filename)~=2
        fprintf(1,'ERROR: vis cal file %s was not found \nMake sure the %s directory contains this file', vis_cal_base, pathEQ);
        return;
    end
    if exist(EQ_cal_filename)~=2
        fprintf(1,'ERROR: EQ cal file %s was not found \nMake sure the %s directory contains this file', EQ_cal_base, pathEQ);
        return;
    end
    
    if exist(gamma_inv_filename)~=2
        fprintf(1,'ERROR: Gamma cal file %s was not found \nMake sure the %s directory contains this file', gamma_inv_base, pathEQ);
        return;
    end
    
    %%load the visual calibrations
    vis_cal=load(vis_cal_filename);
    vis_fields=fieldnames(vis_cal.snd);
    for curr_field=1:length(vis_fields)
        snd=setfield(snd,vis_fields{curr_field},getfield(vis_cal.snd,vis_fields{curr_field}));
    end
    
    %% load the gamma curve
    load(gamma_inv_filename);
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

% screen offset is the x position, in matlab figures, of the control
% window. In other words, opening a figure with left-hand-x position of
% 'screen_offset' would open that figure on the left hand side of the
% control window. The old way was using snd.controlwindow and assumed that
% the screens were arranged in a particular way. 
% TODO: create a function to determine this value.

screen_offset = p.Results.offset;
% myscreen=get(0,'Screensize');   %%size of Screen for opening windows
% screen_offset=(snd.controlwindow-1)*myscreen(3); %Made Global, so stimulus window opens on the correct Screen.  DJT 2/22/2012


cd(pathASF);


if snd.runmode==1    %%  if you are planning on collecting data
    
    %%Changed to RA16eight djt 9/13/2012
    loadTDT(pathRPVDS, p.Results.rcx,'rp2_AM','RA16eight',snd.atten_num, snd.fs);
    % djs use cmd line arg loadTDT(pathRPVDS,'rp1_AM','rp2_AM','RA16eight',snd.atten_num, snd.fs);
    %         loadTDT(RPVDSpath,'rp1_AM','rp2_test','RA16four',snd.atten_num);
    
    %%  set the equalization files
    load(EQ_cal_filename);
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
    
    set_RA16;
    invoke(RA_16,'run');
end;



if strcmp(p.Results.expt, 'noisetone')
    doNoiseTone();
else
    doOwland();
end


return;
