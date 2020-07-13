function SpikeCorr_Wrap
global chan_select snd full_var full_time
%global maxlag fs ... NOW SET IN GUI ... un-quote this and line further
%down wrapper to activate manual controls
% Need Description

% addpath ('C:\MATLAB6p5p2\OwlLand\spikesort')
% addpath ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\spikesort')
% addpath ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\DataAnalysis')

spikes=snd;
chan=find(chan_select==1);

%% ----------------------------Main Code -------------------------

%% Data check
%CHECK that variables necessary for Drop_Trials exist before bothering to
%do any of the other processing
if ~length(spikes.Var1_pres_order)==0 && ~length(spikes.Var2_pres_order)==0
    if spikes.interleave_alone==1
        if sum(isnan(spikes.Var1_pres_order))==0
            fprintf ('\n\nSorry homes, interleave_alone was checked but it looks like there are not any NaNs in there\n')
            fprintf ('This will cause you problems when trying to run Drop_Trials.\nLeaving script\n')
            return
        end
    end
else
    fprintf ('\n\nSorry homes, doesn''t look like Var1_pres_order and/or Var2_pres_order were saved.  This will give some problems with Drop_Trials.\n')
    fprintf ('Alternatives are available in NoTrial.m, but you will have to do some reprogramming to cluge it together\nLeaving script\n')
    return
end  

%% Data Prep 1 (inter-loom conditional) - seperate static and loom
if spikes.inter_loom
    spikes_loom=Inter_Loom_Builder(spikes);
    loom_tag=find(spikes.Inter_loom_store~=0);
    stat_tag=find(spikes.Inter_loom_store==0);
    spikes.Var1_pres_order=spikes.Var1_pres_order(stat_tag);
    spikes.Var2_pres_order=spikes.Var2_pres_order(stat_tag);
    spikes_loom.Var1_pres_order=spikes_loom.Var1_pres_order(loom_tag);
    spikes_loom.Var2_pres_order=spikes_loom.Var2_pres_order(loom_tag);
end

%Use these for Rasters and Correlogram titles
topper='Real'; 
bottomer='UnRl';

%% Data Prep 2 - Isolate spikes from relevant channels
spikes=Chan_Selector (spikes, chan);
if spikes.inter_loom
spikes_loom=Chan_Selector(spikes_loom,chan);
end


%% Data Prep 3 (2D - conditional) - Collapse 2D data

if length(spikes.Var2array)>1 && spikes.Var2~=7
    %Plot heat maps and rasters
    top_handles=Matrix_Graph (spikes, chan);
    bottom_handles=Raster (spikes, chan, bottomer);

if ~full_var    
    Var2Range=input ('\nThere are 2 dimensions!!!\nSelect the variable 2 (Y-Axis) range you are interested in [min max]:  ');
    spikes=TwoD_Collapse (spikes, Var2Range);
    if spikes.inter_loom
        spikes_loom=TwoD_Collapse (spikes_loom,Var2Range);
    end
end
    % Reset plots
    for hand=top_handles
        figure (hand)
        close
    end
    for hand=bottom_handles
        figure(hand)
        close
    end
end

%%%% 1D and 2D traces treated the same after this

%Generate raster plots
if spikes.interleave_alone
    top_handles=Inter_Raster (spikes, chan, topper);
elseif spikes.inter_loom    
    top_handles=Raster (spikes, chan, topper);
    bottom_handles=Raster(spikes_loom,chan,bottomer);
else
    top_handles=Raster (spikes, chan, topper);
end

%% Data Prep 4 - Select Variable Range
if ~full_var
Var1Range=input ('\nSelect the variable range you are interested in [min max]:  ');
spikes=Select_Variable_Range(spikes, Var1Range);
if spikes.inter_loom
    spikes_loom=Select_Variable_Range(spikes_loom,Var1Range);
end
end
% Generate raster plots
for hand=top_handles     
    figure (hand)     
    close 
end
if spikes.inter_loom
    for hand=bottom_handles
        figure (hand)
        close
    end
end
if spikes.interleave_alone
    top_handles=Inter_Raster (spikes, chan, topper);
elseif spikes.inter_loom
    top_handles=Raster (spikes, chan, topper);
    bottom_handles=Raster(spikes_loom,chan,bottomer);    
else
    top_handles=Raster (spikes, chan, topper);
end

%% Data Prep 5 - Select the time window for analysis
if ~full_time
TWin=input ('Select the time window you want to analyze (eg: [-50 100]) :');
spikes=Select_Time_Window(spikes, TWin);
if spikes.inter_loom
    spikes_loom=Select_Time_Window(spikes_loom,TWin);
end
end
%% Data Prep 6 - Assign trial tags
%Does not require any data to be in spikes.datatrial already. This is
%an essential function for making shuffle work properly.  Don't remember
%why now
spikes=Add_Trials(spikes);
if spikes.inter_loom
    spikes_loom=Add_Trials(spikes_loom);
end

% Generate rasters
for hand=top_handles     
    figure (hand)     
    close 
end
if spikes.inter_loom
    for hand=bottom_handles
        figure (hand)
        close
    end
end
if spikes.interleave_alone
    top_handles=Inter_Raster (spikes, chan, topper);
else
    top_handles=Raster (spikes, chan, topper);
end


%% Cross Correlation Analysis
%------------------------------

%Set global paramaters - NOW SET IN INITIAL GUI
% fs=1; %Set bin width == 1
% maxlag =20;  % Length of time past 0 to consider for corralation (msec); 

fprintf ('Data prepared.  Type ''return'' to run correlations \n\n')
keyboard %%GREAT DEBUGGING POINT

if ~spikes.interleave_alone

% Run correlation on raw data
[raw_cell] = SpikeCorr_Anal (spikes, chan);

% Shuffle times and do it again
[shuff_cell] = SpikeCorr_Anal_Shuffle (spikes,chan);

% Compare shuffle to raw
SpikeCorr_Plot_Shuffle (spikes, raw_cell, shuff_cell,chan);

if spikes.inter_loom
    % Repeat for looming data
    [raw_cell_loom]=SpikeCorr_Anal (spikes_loom,chan);
    [shuff_cell_loom]=SpikeCorr_Anal_Shuffle (spikes_loom,chan);
    SpikeCorr_Plot_Shuffle(spikes_loom,raw_cell_loom,shuff_cell_loom,chan);
end
else
    %If interleave alone is activated, generate new spikes structures and
    %populate them with the variable 1 alone and variable 2 alone specific
    %fields and run through the correlation routines as with the normal
    %data
    
    % Build new data structures
    [arr1_spikes,arr2_spikes]=Inter_Builder(spikes);
    
    % Run correlation on raw data 
    [raw_mean, raw_sem] = SpikeCorr_Anal (spikes, chan);
    [arr1_raw_mean, arr1_raw_sem]=SpikeCorr_Anal(arr1_spikes,chan);
    [arr2_raw_mean, arr2_raw_sem]=SpikeCorr_Anal(arr2_spikes,chan);
    
    % Shuffle times and do it again
    [shuff_mean, shuff_sem] = SpikeCorr_Anal_Shuffle (spikes,chan);
    [arr1_shuff_mean, arr1_shuff_sem]=SpikeCorr_Anal_Shuffle(arr1_spikes,chan);
    [arr2_shuff_mean, arr2_shuff_sem]=SpikeCorr_Anal_Shuffle(arr2_spikes,chan);
    
    % Compare shuffle to raw
    SpikeCorr_Plot_Shuffle (spikes, raw_mean, raw_sem, shuff_mean, shuff_sem);
    SpikeCorr_Plot_Shuffle (arr1_spikes, arr1_raw_mean,arr1_raw_sem, arr1_shuff_mean, arr1_shuff_sem);
    SpikeCorr_Plot_Shuffle (arr2_spikes, arr2_raw_mean, arr2_raw_sem, arr2_shuff_mean, arr2_shuff_sem);
    
end
% keyboard
% WinChoose = input ('\nWould you like to enter a new time window? (''y''/''n'')\n WARNING this will close all of your windows\n');
% end

%% Jitter Analysis Routines
jitter_on=0; %change to 1 to turn jitter on

if jitter_on
    Run_Jitter(spikes);
    else  
    fprintf ('\n Jitter turned off\n')
end


gcf;
% fprintf ('figure #%d is %s data\n', gcf,topper)
keyboard
end
