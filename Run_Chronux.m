function Run_Chronux

cd ('spikesort');

%% Select the files you want to spike sort.  Extract the data from them and
%% store it in an array for input in to the Chronux sorting package
[spikes,pathname,filename] = Chronux_Input;

%%%%Taken from Shreesh's wrapper package
%------------------------------------------------------
%% AUTOMATED SPIKE SORTING
%hacked together from Chronux Spike Sort package and Shreesh's
%spikesort_main_distr.m
%- - - - - - - - - - - - - - - - - - - - - - - - - - - -
figW=0.4;figH=0.5;
%%%%% STEPS          
%          spikes = ss_dejitter(spikes);
%          spikes = ss_outliers(spikes);
%          spikes = ss_kmeans(spikes);
%          spikes = ss_energy(spikes);
%          spikes = ss_aggregate(spikes);
%          assignments = spikes.hierarchy.assigns;


%%%%% LOOKING AT THE RAW DATA
% figure(1); colormap jet;
% subplot(2,1,1); plot(spikes.waveforms'); axis tight; title('Raw Data');
% subplot(2,1,2); histxt(spikes.waveforms); h = gca;

% ssg_databrowse2d(spikes);
% ssg_databrowse3d(spikes);

%%%%% ALIGNING SPIKES
% spikes
% NewFigure;
% plot(spikes.waveforms','k-')
% pause
spikes = ss_dejitter(spikes);
%GENERATING FIGURES
%%---Fig1----
NewFigure(figW,figH); colormap jet; 
subplot(3,1,1); plot(spikes.waveforms'); axis tight; title('Centered Data');
subplot(3,1,2); histxt(spikes.waveforms); clim = get(gca, 'CLim');% if(ishandle(h)), set(h, 'CLim', clim); end;
%%%%% REMOVING OUTLIERS
spikes = ss_outliers(spikes);
subplot(3,1,3); plot(spikes.waveforms'); axis tight; title('Centered Data w/ Outliers Removed');
%figure(3); 
plot(spikes.waveforms'); axis tight; title('Centered Data w/ Outliers Removed');

%%%%% INITIAL CLUSTERING
spikes = ss_kmeans(spikes);
% NewFigure(figW,figH);  set(gcf, 'Renderer', 'OpenGL');
% clusterXT(spikes, spikes.overcluster.assigns);  title('Local Clusters');
% % (note: this is a good time to check stationarity of your data.  For example,

%%---Fig2---
NewFigure(figW,figH); plot(spikes.spiketimes, spikes.overcluster.assigns, '.'); xlabel('Time (sec)'); ylabel('Cluster #');
% NewFigure(figW,figH); ssg_databrowse2d(spikes);

%%%%% FINAL CLUSTERING

spikes = ss_energy(spikes); spikes = ss_aggregate(spikes);
%%---Fig3---
NewFigure(figW,figH); colormap jet;
showclust(spikes, spikes.hierarchy.assigns); 

%%---Fig4---
NewFigure(figW,figH); set(gcf, 'Renderer', 'OpenGL');
clusterXT(spikes, spikes.hierarchy.assigns); title('Final Clusters'); 

%%---Fig5---
NewFigure(figW,figH);
aggtree(spikes); title('Aggregation Tree'); 

%%---Fig6---
NewFigure(figW,figH);
correlations(spikes);  title('Auto- and Cross- Correlations');

%%---Fig7---
% projections of the clustered data and to check if the results seem reasonable.
ssg_databrowse3d(spikes); set(gcf,'color','w'); view(-30,22);
scrsz = get(0,'ScreenSize'); ssfac1=0.4; ssfac2=0.6;
%set(gcf,'Position',[1 ssfac2*scrsz(4) ssfac1*scrsz(3) ssfac2*scrsz(4)]);
%%% 
set(gcf,'Position',[1 scrsz(4)-ssfac2*scrsz(4)-50 ssfac1*scrsz(3) ssfac2*scrsz(4)]);

% (note: For neurons with relatively high firing rates, the algorithm can watch
%         for refractory periods to determine when to stop the aggregation.  Since
%         this does not work well for neurons with very low firing rates, it can
%         sometimes make mistakes towards the end of the aggregation, joining
%         clusters that should not be joined or vice versa.  A person looking at
%         figures 5-7 can usually see this fairly quickly.  The problem can be
%         corrected using the following types of commands:)
% spikes = merge_clusters(spikes, clusternumber1, clusternumber2);
% spikes = split_cluster(spikes, clusternumber);
%         After you do this, replot figures 5-7 above and see if things look better).

%...CHECK THAT THESE WORK
%%%...these will need to be renamed according to my new schemes

%%%%% GETTING CLUSTER ASSIGNMENTS
spikes.assignments = spikes.hierarchy.assigns;
%spikes.origAssignments = spikes.assignments(reverseSortInd);  -I'm not
%screwing with the order, so I don't think I need this step
spikes.origfilename = filename;
%spikes.origtraceset = traceSet; %%%I WILL need to make something to this
%effect.  I'm selecting specific recording numbers
%spikes.newfilename = ['SpikesTraceData_',siteId];
%spikes.newtraceset = 1:length(traceSet);


fprintf ('Pausing before verification step. Continuing will close current figures.\n')
fprintf ('To continue to verification type: return\nTo abort type: dbquit')
keyboard

close all

%------------------------------------------------------
%%% VERIFYING SPIKE SORTING 
% hacked from Shreesh's VerifySpikeSporting_distr.m
%- - - - - - - - - - - - - - - - - - - - - - - - - - -

loc_PlotSpikeSortingStuff(spikes);

fprintf('List of spike assignemtns: %d ',unique(spikes.assignments));  %Prints to screen what spike assignments are possible

fprintf ('\n\n-- INSTRUCTIONS --\n ''x'': Exits the program. Do this if you are satisfied with the spike clustering results.\n')
fprintf ('''z'': returns undoes any modifications and returns original cluster assignments\n')
fprintf('''m 2 4'': Merges cluster numbers 2 and 4.\n')
fprintf('''s 7'': Splits cluster number 7 once.\n')
fprintf('''r 4 13'': Renames cluster 4 and cluster 13. This is useful only in\n')
fprintf('certain special situations; you shouldn''t need this most of the time.\n')
fprintf('{''m 2 4'',''s 7''}: If you want to do multiple things simultaneously. Note the syntax.\n')

doWhat = input('MergeOrSplit [#] ');
%%%%%%%%%% MODIFIED 8.17.2012 DJT:
spikesbackup=spikes; %%DJT 8/17
while ~strcmp(doWhat(1),'x') & ~strcmp(doWhat(1),'w')
    if iscell(doWhat), %%If doWhat is a cell array
        doWhatStr=doWhat;clear doWhat;
        for k=1:length(doWhatStr)  %%Convert cell array to a string
            doWhat=doWhatStr{k};
            inps=str2num(doWhat(2:end));
            if strcmp(doWhat(1),'m');
                spikes = merge_clusters(spikes, inps(1),inps(2));
            elseif strcmp(doWhat(1),'s');
                spikes = split_cluster(spikes, inps(1));
            elseif strcmp(doWhat(1),'r');
                spikes = rename_clusters(spikes, inps(2),inps(1));
            elseif strcmp(doWhat(1),'z');
                spikes=spikesbackup; %%DJT 8/27
            end
        end
    else
        inps=str2num(doWhat(2:end));
        if strcmp(doWhat(1),'m');
            spikes = merge_clusters(spikes, inps(1),inps(2));
        elseif strcmp(doWhat(1),'s');
            spikes = split_cluster(spikes, inps(1));
        elseif strcmp(doWhat(1),'r');
            spikes = rename_clusters(spikes, inps(2),inps(1));
        elseif strcmp(doWhat(1),'z');
            spikes=spikesbackup;  %%DJT 8/27
        end
    end
    loc_PlotSpikeSortingStuff(spikes);
    fprintf('New list of spike assignments: %d /n ',unique(spikes.hierarchy.assigns));
    doWhat = input('MergeOrSplit [#] ');
    fprintf('\n\n');
end %while
clear spikesbackup; %DJT 8/17

fprintf ('-------------VERIFICATION COMPLETE---------------\n\n')
fprintf ('Are you truely happy with the results?/nTruely??/n/n  Type return to write this data to file, or type dbquit to abort\n\n')
keyboard

%------------------------------------------------------------------------
%%% FINALIZING SPIKE SORTING
%hacked from Shreesh's FinalizedSpikeSporting_distr.m
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

%% SAVING
fprintf('\n SAVING FINALIZED CLUSTERS...\n');
fprintf('(%s/%s) \n',pathname,filename);
%%-- the finalized sorted data both as part of the
%%-- appropriate savesnd (data mat file) and SpikesWaves, and
%if flag==1 %if we did some merging/splitting

%% --- GETTING CLUSTER ASSIGNMENTS---------------
%[spikes,spikeSortSummary] = GetSpikeSortSummary_distr(spikes);

%% --- PLOTTING n SAVING THE FIGURES---------------
PlotNSaveSpikeSortFigures_distr(spikes,pathname,filename)

%% --- SAVING THE SPIKES struct
savetext=['save ',pathname,'/SpikesortedData/',exptType,'/Finalized/SpikesClusters_',siteId,' spikes'];
eval(savetext);
fprintf('%s\n',savetext);


%% --- APPENDING THE ORIGINAL DATA FILE WITH SPIKE CLASSES
load([parentDataDir,'/SpikesortedData/',exptType,'/JustSorted/SpikesTraceData_',siteId]);
newsnd = AppendSpikeSortInfo_distr(newsnd,traceSet,spikes,spikeSortSummary);


%% --- SAVING THE ORIGINAL DATA FILE WITH SPIKE CLASSES
savetext=['save ',parentDataDir,'/SpikesortedData/',exptType,'/Finalized/SpikesTraceData_',siteId,' newsnd newrec'];
eval(savetext);

fprintf('%s. Traces =  [',filename);
fprintf ('%d ',traceSet);
fprintf(']. Spike classes = [');

fprintf('%d ',unique(spikes.assignments));
fprintf('] \n\n');
