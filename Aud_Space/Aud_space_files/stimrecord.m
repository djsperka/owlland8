%%% This program assumes that var1 = ITD and var2 = stim

function stimrecord(trace,mintime,maxtime) 

global savesnd saverec;
% if no arguments given, uses the currently active sound and times
if nargin==0
    global snd;
    mintime=snd.rangemin;
    maxtime=snd.rangemax;
else
    snd=savesnd{trace};
end

% Make sure this is an interleaved trace before continuing
if (snd.interleave_alone==0)
    snd.interleave_alone
    return

% Make sure min is less than max
elseif (mintime >= maxtime)
    return
    
    
% Begin program.
else

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Make timecourse histogram
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Make stim/nostim ITD curve
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % For each ITD value, get a count of the spikes that occurred at that value (in the
    % desired time window) in both the stim and no-stim trials.
    i = 1;
    for var1 = snd.Var1array   % step through array of ITDs
        
        % snd.data* = ITD + stim spikes
        spikes = find(snd.dataVar1==var1 & snd.datatime>=mintime & snd.datatime<=maxtime); 
        stim_spikes(i) = length(spikes);   
        
        % snd.data*_arr1 = just ITD spikes
        spikes = find(snd.dataVar1_arr1==var1 & snd.datatime_arr1>=mintime & snd.datatime_arr1<=maxtime);
        nostim_spikes(i) = length(spikes);
        
        i = i+1;
    end

    figure;
    set(gca,'nextplot','add');

    % plot stim_spikes in filled red (have to add 0's at snd.Var1array's min and max to normalize graph)
    fill ([min(snd.Var1array),snd.Var1array,max(snd.Var1array)], [0,stim_spikes,0],'r');
    % plot nostim_spikes in filled black (over filled red)
    fill ([min(snd.Var1array),snd.Var1array,max(snd.Var1array)], [0,nostim_spikes,0],'k');
    % plot stim spikes again in red line (over filled black) so can see both curves
    plot (snd.Var1array, stim_spikes,'r','LineWidth', 2);

end

