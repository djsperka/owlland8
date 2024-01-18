function SpikeCorr_RUN (Manual_Input)
global snd chan_select fs maxlag full_var full_time

% addpath ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\DataAnalysis')

c_yellow=[.95, .95, .7];
c_green=[.5,.58,.5];
c_red=[.7 .4 .4];

%set initial values
snd=Manual_Input;
num_chan=max(snd.datachan);
chan_select = zeros(1,num_chan);
fs=1;
maxlag=20;
full_var=0;
full_time=0;

%%open a new window
myscreen=get(0,'screensize');
figure('position',[(myscreen(3)/2),(myscreen(4)/2-380),300,600],'menubar','none','tag','JoeSound_win', 'color', c_yellow);

%% Channel Selection
for i=1:num_chan;
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.05 .8/num_chan*(num_chan+1-i)+.08 .4 .1],...
        'backgroundcolor',c_yellow,...
        'string',strcat('Channel ', num2str(i)),...
        'horizontalalignment','center',...
        'fontsize',12);
    
    uicontrol('style','checkbox',...
        'units','normalized',...
        'position', [.4 .8/num_chan*(num_chan+1-i)+.14 .1 .05],...
        'backgroundcolor',c_yellow,...
        'fontsize',8,...
        'tag', strcat('chan',num2str(i)),...
        'callback', 'Update_Set_Dotproduct',...
        'horizontalalignment','left');
end

%% Select Buttons
uicontrol('style','pushbutton',...
    'units','normalized',...
    'position', [.6 .9 .4 .05],...
    'backgroundcolor',c_yellow,...
    'string','Select All',...
    'fontsize',12,...
    'tag', 'select_all',...
    'callback', 'Set_Noisecorr_Select_All',...
    'horizontalalignment','left');

uicontrol('style','pushbutton',...
    'units','normalized',...
    'position', [.6 .85 .4 .05],...
    'backgroundcolor',c_yellow,...
    'string','Deselect All',...
    'fontsize',12,...
    'tag', 'deselect_all',...
    'callback', 'Set_Noisecorr_Deselect_All',...
    'horizontalalignment','left');

%% Control Settings
%Bin Width
uicontrol('style','text',...
    'units','normalized',...
    'position', [.55 .33 .4 .05],...
    'backgroundcolor',c_yellow,...
    'string','Bin Width (ms)',...
    'fontsize',12,...
    'fontweight','bold',...
    'callback', 'Update_Set_Spikecorr',...
    'horizontalalignment','center');
uicontrol('style','edit',...
    'units','normalized',...
    'position', [.65 .3 .2 .05],...
    'backgroundcolor',c_yellow,...
    'string',fs,...
    'fontsize',12,...
    'tag', 'freq',...
    'callback', 'Update_Set_Spikecorr',...
    'horizontalalignment','center');

%Correlation time window
uicontrol('style','text',...
    'units','normalized',...
    'position', [.55 .23 .4 .05],...
    'backgroundcolor',c_yellow,...
    'string','Max Lag (ms)',...
    'fontsize',12,...
    'fontweight','bold',...
    'callback', 'Update_Set_Spikecorr',...
    'horizontalalignment','center');
uicontrol('style','edit',...
    'units','normalized',...
    'position', [.65 .2 .2 .05],...
    'backgroundcolor',c_yellow,...
    'string',maxlag,...
    'fontsize',12,...
    'tag', 'mlag',...
    'callback', 'Update_Set_Spikecorr',...
    'horizontalalignment','center');

%Skip variable and time window selection
uicontrol('style','checkbox',...
    'units','normalized',...
    'position', [.55 .5 .4 .05],...
    'backgroundcolor',c_yellow,...
    'fontsize',8,...
    'string','Full Variable Range',...
    'tag', 'full_var',...
    'callback', 'Update_Set_Spikecorr',...
    'horizontalalignment','left');
uicontrol('style','checkbox',...
    'units','normalized',...
    'position', [.55 .45 .4 .05],...
    'backgroundcolor',c_yellow,...
    'fontsize',8,...
    'string','Full Time Window',...
    'tag', 'full_time',...
    'callback', 'Update_Set_Spikecorr',...
    'horizontalalignment','left');

%% Run Button
uicontrol('style','pushbutton',...
    'units','normalized',...
    'position', [.1 .025 .8 .1],...
    'horizontalalignment','center',...
    'string','Do it!',...
    'fontweight', 'bold', ...
    'fontsize', 10,...
    'backgroundcolor', c_red,...
    'callback','SpikeCorr_Wrap');