function [waglob]=WAGlob_Run (dispmat, disparr1, disparr2)

% Hacked from Knudsen lab's fit_weighted_average function DJT 9/8/2013
global snd rec;

figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
snd.ba_cutoff=str2num(get(findobj(gcf,'tag','ba_cutoff'),'string'));  %%  get the cutoff level
snd.ba_cutoff=max(snd.ba_cutoff,0);
snd.ba_cutoff=min(snd.ba_cutoff,100);
set(findobj(gcf,'tag','ba_cutoff'),'string',snd.ba_cutoff);

%%  clear the graphs of previous best area plots.
set_graphs(snd.reps)

%%% BEGIN KRISTIN'S ADDITIONS

% For the rest of the function, set the upper left graphing window as
% active, and have the plots add rather than replace each other.
figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
set(gca,'nextplot','add')



%% var1 ranging, no var2 (simple tuning curve) -OR- var1 ranging, var2 constant, always both
if (snd.Var2==7 && snd.interleave_alone==0) ||  (snd.Var2~=7 && length(snd.Var2array)==1 && snd.interleave_alone==0)
    
    WAGlob_Anal(snd.Var1array,dispmat)
    
end

%% var1 ranging, var2 ranging (matrix tuning curve)%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (doesn't compute half-max width)
if snd.Var2~=7 && length(snd.Var2array)>1  && snd.interloom_type==1 %added interloom contingency DJT 7/7/2013
    % Get a *first estimate* of the best x and y by collapsing all data into 1-D arrays
    % KM note: one thing that can go wrong here is if the first estimate returns an NaN
    % (because edge of curve is off of the plot), then the "slices" are just taken at the
    % first element of each array.
    dispy_collapse=squeeze(sum(dispmat,2));    %%flatten data
    dispx_collapse=squeeze(sum(dispmat,1));    %%flatten data
    waglob(1)=WAGlob_Anal(snd.Var1array,dispx_collapse);
    waglob(2)=WAGlob_Anal(snd.Var2array,dispy_collapse');
    
    
        figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
        plot(waglob(1),waglob(2), '+', 'markersize', 20,'LineWidth',3,'MarkerEdgeColor','w');
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if snd.Var2~=7 && length(snd.Var2array)>1  && snd.interloom_type~=1 %added interloom contingency DJT 7/7/2013
    % Get a *first estimate* of the best x and y by collapsing all data into 1-D arrays
    % KM note: one thing that can go wrong here is if the first estimate returns an NaN
    % (because edge of curve is off of the plot), then the "slices" are just taken at the
    % first element of each array.
    
    dispy_collapse=squeeze(sum(disparr1,2));    %%flatten data
    dispx_collapse=squeeze(sum(disparr1,1));    %%flatten data
    waglob(1)=WAGlob_Anal(snd.Var1array,dispx_collapse);
    waglob(2)=WAGlob_Anal(snd.Var2array,dispy_collapse');
    
        figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
        plot(waglob(1),waglob(2), '+', 'markersize', 20,'LineWidth',3,'MarkerEdgeColor','w');
   
end

%% var1 ranging, var2 constant, interleave alone
if snd.Var2~=7 && length(snd.Var2array)==1 && snd.interleave_alone==1
    
    fprintf('\nNot currently programmed.  Pausing in WAGlob_Run\n')
    keyboard
    
end

%% var1 ranging, var2 ranging, interleave alone
%% (doesn't plot half-max width)
if snd.Var2~=7 && length(snd.Var2array)>1 && snd.interleave_alone==1
    
    fprintf('\nNot sure this is actually equiped to deal with interleaved 2D data.  Pausing in WAGlob_Run\n')
    keyboard
    
    % Together
    dispy=squeeze(sum(dispmat,2));
    dispx=squeeze(sum(dispmat,1));
    [com_both1,leftval_both1,rightval_both1,xi_both1,yi_both1,leftval_width_both1,rightval_width_both1,x_est_flag]= WAPeak_Anal(snd.Var1array,dispx,snd.ba_cutoff/100);
    [com_both2,leftval_both2,rightval_both2,xi_both1,yi_both2,leftval_width_both2,rightval_width_both2,y_est_flag]= WAPeak_Anal(snd.Var2array,dispy,snd.ba_cutoff/100);
    
    % Alone
    [com_alone1,leftval_alone1,rightval_alone1,xi_alone1,yi_alone1,leftval_width_alone1,rightval_width_alone1,xalone_est_flag]= WAPeak_Anal(snd.Var1array,disparr1,snd.ba_cutoff/100);
    [com_alone2,leftval_alone2,rightval_alone2,xi_alone2,yi_alone2,leftval_width_alone2,rightval_width_alone2,yalone_est_flag]= WAPeak_Anal(snd.Var2array,disparr2,snd.ba_cutoff/100);
    
    
    figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
    set(findobj(gcf,'tag','Var1_alone_ba_label'),'string',snd.Var1_choices(snd.Var1));
    set(findobj(gcf,'tag','Var1_alone_label'),'string','Alone');
    set(findobj(gcf,'tag','Var2_alone_ba_label'),'string',snd.Var2_choices(snd.Var2));
    set(findobj(gcf,'tag','Var2_alone_label'),'string','Alone');
    set(findobj(gcf,'tag','Var1_ba_label'),'string',snd.Var1_choices(snd.Var1));
    set(findobj(gcf,'tag','Var2_ba_label'),'string',snd.Var2_choices(snd.Var2));
    
    set(findobj(gcf,'tag','var1_alone_ba'),'string',round(com_alone1*10)/10);
    set(findobj(gcf,'tag','var2_alone_ba'),'string',round(com_alone2*10)/10);
    set(findobj(gcf,'tag','var1_ba'),'string',round(com_both1*10)/10);
    set(findobj(gcf,'tag','var2_ba'),'string',round(com_both2*10)/10);
    
    set(findobj(gcf,'tag','var1_alone_width'),'string',round((rightval_width_alone1 - leftval_width_alone1)*10)/10);
    set(findobj(gcf,'tag','var2_alone_width'),'string',round((rightval_width_alone2 - leftval_width_alone2)*10)/10);
    set(findobj(gcf,'tag','var1_width'),'string',round((rightval_width_both1 - leftval_width_both1)*10)/10);
    set(findobj(gcf,'tag','var2_width'),'string',round((rightval_width_both2 - leftval_width_both2)*10)/10);
end


%%% Set the upper left graphing window to replace for the next trace.
figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
set(gca,'nextplot','replace')

% wa_peak=[com_x,com_y];




return;