function Location_Decoder_Wrapper (handles)
% This will be the wrapper does the following:
% Sets the appropriate settings 
% Load data
% Sort data w/ indexing
% Run decoder
% Perform statistics
% Plot results

% Population features to measure: 
% accuracy of localization estimate
% standard deviation of estimate

global respORpost resp_sort dropvisout keepvisin vistuned dropaudout keepaudin audtuned site_cell site_names pathname

%% Set controls

%Choose which units to keep/drop
respORpost=get(handles.respORpost,'Value'); %1=resp, 2=post
resp_sort=1; %Use these sorting functions? If 0, ignore rest of options 
dropvisout=get(handles.dropvisout,'Value'); %only use non-responders to vout?
keepvisin=get(handles.keepvisin,'Value'); %only use responders to vin?
vistuned=get(handles.vistuned,'Value'); %use tuning to sort?
dropaudout=get(handles.dropaudout,'Value'); 
keepaudin=get(handles.keepaudin,'Value');
audtuned=get(handles.audtuned,'Value');

min_chan=str2double(get(handles.min_chan,'String')); %minimum number of channels to run decoder

norm_type=get(handles.norm_type,'Value'); 
%1=no normalization ... divide by total number of cells
%2=norm by activity ... divide by absolute value of the total activity on this trial
%3=norm position ... adjust "0 activity" to be centered between peaks
%4=norm distribution ... same as 3 but 

nShuff=str2double(get(handles.num_shuffles,'String')); %number of times to shuffle trials to disrupt correlations
interp_scale=str2double(get(handles.interp_scale,'String')); %number of steps between points in interpolation

%Choose your conditions
justvis=get(handles.justvis,'Value');
justaud=get(handles.justaud,'Value');
manual_select=get(handles.manual_select,'Value');

if manual_select
    VwI=get(handles.VwI,'Value');
    VsI=get(handles.VsI,'Value');
    VwO=get(handles.VwO,'Value');
    VsO=get(handles.VsO,'Value');
    VsO_VwI=get(handles.VsO_VwI,'Value');
    VwO_VsI=get(handles.VwO_VsI,'Value');
    VwO_VwI=get(handles.VwO_VwI,'Value');
    AI=get(handles.AI,'Value');
    AO=get(handles.AO,'Value');
    AI_VwI=get(handles.AI_VwI,'Value');
    AO_VwI=get(handles.AO_VwI,'Value');
    AI_VwO=get(handles.AI_VwO,'Value');
    AO_VwO=get(handles.AO_VwO,'Value');
    AI_AO=get(handles.AI_AO,'Value');
    label_mask=logical([VwI,VsI,VwO,VsO,VsO_VwI,VwO_VsI,VwO_VwI,AI,AO,AI_VwI,AO_VwI,AI_VwO,AO_VwO,AI_AO]);    
    
elseif ~justvis && ~justaud
    fprintf('\nError!  You must select either manual, justvis or justaud\n')
    dbstack
    keyboard
else
    label_mask= false(1,14);
    if justvis
        label_mask(1,1:7)=1;
        if (keepaudin || audtuned) && ~justaud
            fprintf('\nDanger Will Robinson: You are selecting for AUD properties without processing AUD responses.  You sure this is what you want?\n')
            dbstack
            keyboard
        end
    end
    if justaud
        if (keepvisin || vistuned) && ~justvis
            fprintf('\nDanger Will Robinson: You are selecting for VIS properties without processing VIS responses.  You sure this is what you want?\n')
            dbstack
            keyboard
        end
        label_mask(1,[8 9 14])=1;
    end
end
    

% vis_cond=[1,2,3,4,5,6,7];
% aud_cond=[8,9,14];
% bim_cond=[10,11,12,13];

%translate choices to strings
nC=sum(label_mask); %number of conditions
mt_labels{1}='Vw_I  ';
mt_labels{2}='Vs_I  ';
mt_labels{3}='Vw_O  ';
mt_labels{4}='Vs_O  ';
mt_labels{5}='Vs_O  Vw_I';
mt_labels{6}='Vw_O  Vs_I';
mt_labels{7}='Vw_O  Vw_I';
mt_labels{8}='A_I  ';
mt_labels{9}='A_O  ';
mt_labels{10}='A_I  Vw_I';
mt_labels{11}='A_O  Vw_I';
mt_labels{12}='A_I  Vw_O';
mt_labels{13}='A_O  Vw_O';
mt_labels{14}='A_I  A_O';
cond_choices=mt_labels(label_mask);   

all_modalities=[1 1 1 1 1 1 1 2 2 3 3 3 3 2];
modalities=all_modalities(label_mask);
% 
% %% Open data and index it
% 
% %choose your data
% startdir=cd;
% cd ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition')
% [filenames,pathname]=uigetfile('MultiSelect','on');
% if ~iscell(filenames) %deals with the scenario when you only select one file
%     tempcell{1}=filenames;
%     filenames=tempcell;
% end
% cd (startdir)

%generate population cell and condition index
nS=length(site_names); %number of sites
% all_sites=cell(nS,1); %population cell
do_me=zeros(nS,nC); %nS x nC: zero if site doesn't have condition; numerical 
% value corresponding to that trace number if it does have condition

%stores the In and Out condition numbers necessary for sorting based on
%responses
VWIn_num=nan(nS,1);
VSIn_num=nan(nS,1);
VWOut_num=nan(nS,1);
AIn_num=nan(nS,1);
AOut_num=nan(nS,1);

for i=1:nS %for all sites
    curr_site=site_cell{i};
    for j=1:nC %see which conditions this site has
        condition=cond_choices{j};
        has_cond=strcmp(curr_site.id_mt_labels,condition);
        %%%% Need this to be able to handle inverse condition labels
        if sum(has_cond)==1
            do_me(i,j)=find(has_cond==1);
        else % if you didn't find the condition, try switching the first and second word            
            k=strfind(condition,' ');
            if max(k)<length(condition) %there were two words ... switch em!
                first_word=condition(1:k(1)-1);
                second_word=condition(k(end)+1:end);
                condition=sprintf('%s  %s',second_word,first_word);
                has_cond=strcmp(curr_site.id_mt_labels,condition);
                if sum(has_cond)==1
                    do_me(i,j)=find(has_cond==1);
                else
                    fprintf('\nCouldn''t find condition %s for this site:\n%s\n',condition,site_names{i})
%                     dbstack
%                     keyboard
                end
            else %there was only one word
                fprintf('\nCouldn''t find condition %s for this site:\n%s\n',condition,site_names{i})
%                 dbstack
%                 keyboard
            
            end
            
        end
    end
    
    %%% Identify Specific Conditions for Response Sorting
    condition=mt_labels{1}; %ID VWeak In
    has_cond=strcmp(curr_site.id_mt_labels,condition);
    if sum(has_cond)==1
        VWIn_num(i)=find(has_cond==1);
    else
        fprintf ('\nNOTE: This site did not have  VWeak-In\n%s\n',site_names{i})
    end
    
    condition=mt_labels{2}; %ID VStrong In
    has_cond=strcmp(curr_site.id_mt_labels,condition);
    if sum(has_cond)==1
        VSIn_num(i)=find(has_cond==1);
    else
        fprintf ('\nNOTE: This site did not have  VStrong-In\n%s\n',site_names{i})
    end
    
    condition=mt_labels{3}; %ID VWeak Out
    has_cond=strcmp(curr_site.id_mt_labels,condition);
    if sum(has_cond)==1
        VWOut_num(i)=find(has_cond==1);
    else
        fprintf ('\nNOTE: This site did not have  VWeak-Out\n%s\n',site_names{i})
    end
    
    condition=mt_labels{8}; %ID Aud In
    has_cond=strcmp(curr_site.id_mt_labels,condition);
    if sum(has_cond)==1
        AIn_num(i)=find(has_cond==1);
    else
        fprintf ('\nNOTE: This site did not have  Aud-In\n%s\n',site_names{i})
    end
    
    condition=mt_labels{9}; %ID Aud Out
    has_cond=strcmp(curr_site.id_mt_labels,condition);
    if sum(has_cond)==1
        AOut_num(i)=find(has_cond==1);
    else
        fprintf ('\nNOTE: This site did not have  Aud-In\n%s\n',site_names{i})
    end
    
end



%% run location decoder for each and site
nRep=50; %number of repetitions of each stim
numChans=nan(nS,nC);
stim_loc=nan(nS,2);
peak_locs=cell(nS,1);
raw_x_locs=nan(nS,nRep,nC);
raw_y_locs=nan(nS,nRep,nC);
shuff_x_locs=nan(nS,nRep*nShuff,nC);
shuff_y_locs=nan(nS,nRep*nShuff,nC);
temp_raw_corr=cell(nS,nC); 
temp_shuff_corr=cell(nS,nC); 
for i=1:nC %for each condition
    modality=modalities(i);
    for j=1:nS %for each site
        if do_me(j,i)~=0 %if that site had the condirion
            group=do_me(j,i); %recall what group that was
            file_path=strcat(pathname,site_names{j});
            
            if modality==1
                in_cond=[VWIn_num(j),VSIn_num(j)];
                out_cond=VWOut_num(j);
            elseif modality==2
                in_cond=AIn_num(j);
                out_cond=AOut_num(j);
            else %modality==3
            end
%             fprintf ('\n-------RUNNING SITE %s----------\n',filenames{j})
%             fprintf('\ni=%f,  j=%f',i,j);
            
            [numChans(j,i),stim_loc(j,:), peak_locs{j},raw_x_locs(j,:,i), raw_y_locs(j,:,i), shuff_x_locs(j,:,i), shuff_y_locs(j,:,i),temp_raw_corr{j,i},temp_shuff_corr{j,i}]=Location_Decoder_Run (group,file_path,nShuff,modality,in_cond,out_cond,norm_type,handles);
            
        end
    end
    
    
end

%% Drop sites without enough units
drop_site=numChans(:,1)<min_chan;
do_me(drop_site,:)=0;
stim_loc(drop_site,:)=nan;
% peak_locs(drop_site)=nan;
raw_x_locs(drop_site,:,:)=nan;
raw_y_locs(drop_site,:,:)=nan;
shuff_x_locs(drop_site,:,:)=nan;
shuff_y_locs(drop_site,:,:)=nan;

%% Center data to stim locations
raw_x_norm=raw_x_locs-repmat(stim_loc(:,1),[1,nRep,nC]); %nS x nRep x nC
raw_y_norm=raw_y_locs-repmat(stim_loc(:,2),[1,nRep,nC]);
raw_dist_norm=(raw_x_norm.^2+raw_y_norm.^2).^.5;
shuff_x_norm=shuff_x_locs-repmat(stim_loc(:,1),[1,nRep*nShuff,nC]);
shuff_y_norm=shuff_y_locs-repmat(stim_loc(:,2),[1,nRep*nShuff,nC]);
shuff_dist_norm=(shuff_x_norm.^2+shuff_y_norm.^2).^.5;

%% Plot nosie correlations before and after shuffle
if get(handles.comp_nc,'Value');
    corr_means=nan(nC,2);
    corr_stds=nan(nC,2);
    corr_p=nan(nC,1);
    for i=1:nC %for each condition
        raw_corr=[];
        shuff_corr=[];
        for j=1:nS %for each site
            raw_corr=[raw_corr;temp_raw_corr{j,i}];
            shuff_corr=[shuff_corr;temp_shuff_corr{j,i}];
        end
        corr_means(i,:)=[nanmean(raw_corr),nanmean(shuff_corr)];
        corr_stds(i,:)=[nanstd(raw_corr),nanstd(shuff_corr)];
        [~,corr_p(i)]=ttest2(raw_corr(~isnan(raw_corr)),shuff_corr(~isnan(shuff_corr))); 


    end
    
    %plot it!
    x=[1:nC];
    y=corr_means;
    figure
    bar(x,y)
    set(gca,'XTickLabel',cond_choices)
    hold on
    x=[x-.125;x+.125]';
    errorbar(x,y,corr_stds,'.')
    ylabel('Correlation (Pearson''s r)')
    title (sprintf('Raw vs Shuffled Noise Correlations'))
    legend({'Raw','Shuffled'})
    
    fprintf('\nEffect of Shuffling on Noise Correlations\n')
    for i=1:nC
        fprintf('\nCondtion=%s  ::  p(Corr_raw==Corr_shuff)=%.4f',cond_choices{i},corr_p(i))
    end
    fprintf('\n------------------------------------\n')
    
end

%% Calculate Statistics (Probability Distributions) Within Each Cohort

if get(handles.plot_pd,'Value')
    
    plot_cond=get(handles.ppd_choice,'Value'); % condition to plot PDs for
    linecolors=linspecer(nS); %set colors for each condition
    
    legtext={};
    ftest_h=nan(nS,nC);
    ftest_p=nan(nS,nC);
    ttest_h=nan(nS,nC);
    ttest_p=nan(nS,nC);
    
    fprintf ('\nCondition:')
    fprintf('\t%s',cond_choices{:})
    
    pd_fig=figure;
    
    xlabel ('Estimate Azimuth re. Stim Position')
    ylabel ('P(X-az)')
    title (sprintf('Estimate Probability Distributions for %s Condition',cond_choices{plot_cond}))
    hold on
    for i=1:nS
        % for just looking along x dimension
        %     raw_vect=squeeze(raw_x_norm(i,:,:));
        %     shuff_vect=squeeze(shuff_x_norm(i,:,:));
        
        % for doing total distance from stim
        raw_vect=squeeze(raw_dist_norm(i,:,:));
        shuff_vect=squeeze(shuff_dist_norm(i,:,:));
        
        %Calculate the probability distribution
        xval = -35:.1:35; %range to plot PDs over
        [raw_muhat,raw_sigmahat] = normfit(raw_vect); %prob dist values
        raw_yval = normpdf(xval,raw_muhat(plot_cond),raw_sigmahat(plot_cond)); %make prob dist
        [shuff_muhat,shuff_sigmahat] = normfit(shuff_vect);
        shuff_yval = normpdf(xval,shuff_muhat(plot_cond),shuff_sigmahat(plot_cond));
        
        %Plot the probability distribution
        plot(xval,raw_yval,'Color',linecolors(i,:))
        plot(xval,shuff_yval,':','Color',linecolors(i,:))
        
        %Compare variances
        [ftest_h(i,:),ftest_p(i,:)]=vartest2(raw_vect,shuff_vect);
        
        %Compare error means
        [ttest_h(i,:),ttest_p(i,:)]=ttest2(abs(raw_vect),abs(shuff_vect));
        
        fprintf('\n%s',site_names{i})
        fprintf('\nFtest P= ')
        fprintf('\t%.3f',ftest_p(i,:))
        fprintf('\nTTest P=')
        fprintf(' \t%.3f',ttest_p(i,:))
        fprintf('\n')
        
        legtext{i*2-1}=site_names{i};
        legtext{i*2}='';
    end
    legend (legtext,'Interpreter','none')
    hold off
    
end

%% Calculate Average Error with Each Trial as a Sample
if get (handles.plot_trial_samples,'Value')
    
    if get(handles.ts_az,'Value')
        Plot_Trial_Sample (raw_x_norm,shuff_x_norm,nShuff,cond_choices,'Azimuth')
    end
    
    if get(handles.ts_el,'Value')
        Plot_Trial_Sample(raw_y_norm,shuff_y_norm,nShuff,cond_choices,'Elevation')        
    end
    
    if get(handles.ts_dist,'Value')
        Plot_Trial_Sample(raw_dist_norm,shuff_dist_norm,nShuff,cond_choices,'Total Distance')        
    end
    
end

%% Calculate Mean and Standard Deviation in Errors with Each Cohort As a Sample

if get(handles.plot_cohort_samples,'Value')
    
    if get(handles.cs_az,'Value')
        Plot_Cohort_Sample (raw_x_norm,shuff_x_norm,cond_choices,'Azimuth')        
    end

    if get(handles.cs_el,'Value')
        Plot_Cohort_Sample (raw_y_norm,shuff_y_norm,cond_choices,'Elevation')
    end
    
    if get(handles.cs_dist,'Value')
        Plot_Cohort_Sample (raw_dist_norm,shuff_dist_norm,cond_choices,'Total Distance');        
    end
        
end

function Plot_Trial_Sample (raw_norm,shuff_norm,nShuff,cond_choices,type)

[nS,nRep,nC]=size(raw_norm);

raw_error=abs(reshape(raw_norm,nS*nRep,nC));
shuff_error=abs(reshape(shuff_norm,nS*nRep*nShuff,nC));

%%% Make Figure for Azimuth
figure
bar([nanmean(raw_error);nanmean(shuff_error)]');
set (gca,'XTickLabel',cond_choices(:))
hold on
title (sprintf('%s Estimate: Raw vs Shuffled : Sample=Single Trial',type))
ylabel(sprintf('Decoder Error (%s Degrees)',type))
xlabel('Stimulus condition')

% Add errorbars
errorbar([1:nC]-.125,nanmean(raw_error),nanstd(raw_error),'.')
errorbar([1:nC]+.125,nanmean(shuff_error),nanstd(shuff_error),'.r')

% % Add scatter
% plot (repmat([1:nC]-.125,nS*nRep,1),raw_error_x,'.b','MarkerSize',2)
% plot (repmat([1:nC]+.125,nS*nRep*nShuff,1),shuff_error_x,'.r','MarkerFaceColor','w','MarkerSize',2)

hold off

%%% ttest
[~,ttest_p]=ttest2(raw_error,shuff_error); %unpaired sample ttest comparing shuffled to raw across conditions
raw_mean=nanmean(raw_error);
shuff_mean=nanmean(shuff_error);
fprintf ('\nUn-Paired 2-sample ttests for Error in %s (Raw==Shuffle) across conditions ... each TRIAL is a sample n(raw)=%.0f, n(shuff)=%.0f',type,sum(~isnan(raw_error(:,1))),sum(~isnan(shuff_error(:,1))))
for i=1:nC
    fprintf ('\nCondition:  %s\t mean(raw)=%.2f :: mean(shuff)=%.2f\t pval: %.4f',cond_choices{i},raw_mean(i),shuff_mean(i),ttest_p(i))
end
fprintf('\n\n')

%%% ftest
[~,ftest_p]=vartest2(raw_error,shuff_error);
raw_std=nanstd(raw_error);
shuff_std=nanstd(shuff_error);
fprintf ('\nUn-Paired 2-sample Ftests for STD in %s (Raw==Shuffle) across conditions ... each TRIAL is a sample n(raw)=%.0f, n(shuff)=%.0f',type,sum(~isnan(raw_error(:,1))),sum(~isnan(shuff_error(:,1))))
for i=1:nC
    fprintf ('\nCondition:  %s\t std(raw)=%.2f :: std(shuff)=%.2f\t pval: %.4f',cond_choices{i},raw_std(i),shuff_std(i),ftest_p(i))
end
fprintf('\n\n')


function [mean_tt_p,std_tt_p]=Plot_Cohort_Sample(raw_norm,shuff_norm,cond_choices,type)

[nS,nRep,nC]=size(raw_norm);
site_RE=squeeze(nanmean(abs(raw_norm),2));
site_SE=squeeze(nanmean(abs(shuff_norm),2)); % nS x nC

site_RStd=squeeze(nanstd(abs(raw_norm),[],2));
site_SStd=squeeze(nanstd(abs(shuff_norm),[],2));

%% Look at mean errors
%%% Make figure for mean error
figure
bar([nanmean(site_RE);nanmean(site_SE)]')
hold on

% Add errorbars
errorbar([1:nC]-.125,nanmean(site_RE),nanstd(site_RE),'.')
errorbar([1:nC]+.125,nanmean(site_SE),nanstd(site_SE),'.r')

% Add scatter
plot (repmat([1:nC]-.125,nS,1),site_RE,'ob','MarkerSize',5,'MarkerFace','w')
plot (repmat([1:nC]+.125,nS,1),site_SE,'ob','MarkerSize',5,'MarkerFace','w')

hold off

set (gca,'XTickLabel',{cond_choices{:}})
title (sprintf('%s Mean Estimate Error: Raw vs Shuffled : Sample=Cohort',type))
ylabel(sprintf('Decoder Error (%s Degrees)',type))
xlabel('Stimulus condition')


%%% Perform Ttest on mean errors
[~,mean_tt_p]=ttest(site_RE,site_SE); %paired sample ttest comparing shuffled to raw across conditions
raw_mean_mean=mean(site_RE);
shuff_mean_mean=mean(site_SE);

fprintf ('\nPaired 2-sample ttests for %s Average Error [Raw==Shuffle]  across conditions ... each COHORT is a sample',type)
for i=1:nC
    fprintf ('\nCondition:  %s\t mean(Raw_mean)=%.2f :: mean(Shuff_mean)=%.2f\t pval: %.4f',cond_choices{i},raw_mean_mean(i),shuff_mean_mean(i),mean_tt_p(i))
end
fprintf('\n\n')

%% Look at standard deviation in errors
%%% Make figure for standard deviation in error
figure
bar([nanmean(site_RStd);nanmean(site_SStd)]')
hold on

% Add errorbars
errorbar([1:nC]-.125,nanmean(site_RStd),nanstd(site_RStd),'.')
errorbar([1:nC]+.125,nanmean(site_SStd),nanstd(site_SStd),'.r')

% Add scatter
plot (repmat([1:nC]-.125,nS,1),site_RStd,'ob','MarkerSize',5,'MarkerFace','w')
plot (repmat([1:nC]+.125,nS,1),site_SStd,'ob','MarkerSize',5,'MarkerFace','w')

hold off

set (gca,'XTickLabel',{cond_choices{:}})
title (sprintf('%s STD Estimate Error: Raw vs Shuffled : Sample=Cohort',type))
ylabel(sprintf('Decoder Standard Deviation (%s Degrees)',type))
xlabel('Stimulus condition')

%%% Perform Ttest on standard deviations
% [~,std_tt_p]=ttest(site_RStd(~isnan(site_RStd)),site_SStd(~isnan(site_SStd))); %paired sample ttest comparing shuffled to raw across conditions
std_tt_p=nan(nC,1);

raw_mean_std=mean(site_RStd);
shuff_mean_std=mean(site_SStd);

fprintf ('\nPaired 2-sample ttests for %s STD [Raw==Shuffle] across conditions ... each COHORT is a sample',type)
for i=1:nC
    [~,std_tt_p(i)]=ttest(site_RStd(:,i),site_SStd(:,i));
    fprintf ('\nCondition:  %s\tmean(raw_std)=%.2f :: mean(shuff_std)=%.2f\t pval: %.4f',cond_choices{i},raw_mean_std(i),shuff_mean_std(i),std_tt_p(i))
end
fprintf('\n\n')


