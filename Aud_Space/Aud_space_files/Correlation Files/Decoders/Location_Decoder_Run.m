function [nCh,stim_loc, peak_locs,raw_x_vect, raw_y_vect, shuff_x_vect_full, shuff_y_vect_full,norm_corr,shuff_corr]=Location_Decoder_Run (cond,file_path,nShuff,modality,in_cond,out_cond,norm_type,handles)
% Inputs are the condition being tested, the path for the file workspace
% being used, and the number of iterations to go through the shuffle

% use this to try to use neural responses to decode the location of the
% stimulus, based on their tuning preferences.  
%
% This is the second pass at a vector decoder. For each trial, takes each
% channel's tuning location and multiplies it by its response magnitude.
% Adds each of these weighted inputs together, then divides the whole thing
% by the SUM OF THE RESPONSE MAGNITUDES to normalize.

% Set controls
%   decide which conditions will be used, 
% Open the data, filter it and shape it.  
%   Peak responses are 
% 
global respORpost resp_sort dropvisout keepvisin vistuned dropaudout keepaudin audtuned

%% Set controls

interp_scale=10; %number of steps between points in interpolation

plot_on=get(handles.site_plot,'Value');

%% Open some data, filter it and shape it for analysis
load(file_path)

%%% One of the outputs
stim_loc=[id_vin, id_vis_el];

%%% Select Data
all_resp=nan(length(id_mt_data.resp_cell), size(id_mt_data.resp_cell{1},1), size(id_mt_data.resp_cell{1},2));

%%% When I mapped with static and looming, I named them accordingly
if exist('id_vis_map_stat')
    id_vis_map=id_vis_map_stat;
end

%%% Use cubic interpolation to find max firing rate
[peak_resp,Xq,Yq,Zq_pop]=Find_Peaks(id_vis_map,interp_scale,handles);

%%% Choose response or post data
[nCh, nRep, ~]=size (all_resp);

nCon=length(cond); %number of conditions ... not actually used any more
for i=1:nCh
    if respORpost==1
        all_resp(i,:,:)=id_mt_data.resp_cell{i};
    elseif respORpost==2
        all_resp(i,:,:)=id_mt_data.post_cell{i};
    else
        error ('need to choose something for respORpost')
    end
end
all_resp=all_resp(:,:,cond); %chan x reps x condition

%%% Sort by Response Classifications
responders=ones (nCh,1);
if resp_sort
    
    if dropvisout
        responders=responders & ~data_responds(:,out_cond); %drop vis-out responders
    end
    if keepvisin
        responders=responders & (data_responds(:,in_cond(1)) | data_responds(:,in_cond(2))); % drop vis-in NONresponders
    end
    if vistuned
        responders=responders & id_tuned_vis;
    end
    if dropaudout
        responders=responders & ~(data_responds(:, out_cond));
    end
    if keepaudin
        responders=responders & (data_responds(:, in_cond));
    end
    if audtuned
        responders=responders & id_tuned_aud;
    end
    
end

%% If there are too few channels, bail.
nCh=sum(responders); %number of channels
if nCh<2
    stim_loc=nan(2,1); 
    peak_locs=[];
    raw_x_vect=nan(nRep,1);
    raw_y_vect=nan(nRep,1);
    shuff_x_vect_full=nan(nRep*nShuff,1);
    shuff_y_vect_full=nan(nRep*nShuff,1);
    norm_corr=[];
    shuff_corr=[];
    return
end

%% Find encoder values for each unit

%%% If you are using the opimal linear estimator decoder
if get(handles.ole_decoder,'Value') 
    
    if modality==1 %visual
        rec_dat=id_vis_map;
    else %audiory
        rec_dat=id_aud_map;
    end
    
    fprintf ('\nStarting OLE...\n')
    opt_params=Optimal_Linear_Estimator (rec_dat,responders);
    
    norm_type=5;
    
else %%% Use a peak-based decoder
    
    
    %     fprintf ('\n%.0f of %.0f Channels Used\n',sum(responders), length(responders))
    all_resp=all_resp(responders,:,:);
    peak_resp=peak_resp(responders);
    if modality==1 %visual
        peak_locs=id_wa_peak_vis(responders,:);
    elseif modality==2 %auditory
        peak_locs=id_wa_peak_aud(responders,:);
    else %Bimodal.  What the crap do I do now??
        keyboard
    end
    
    Zq_pop=Zq_pop(:,:,responders);
    
    %% Calculate vector for raw data using the vector weighted average approach
    %%% Normalize responses to their max firing rate
    peak_mat=peak_resp*ones(1,nRep); %nChx1 --> nCh x nRep
    peak_mat=repmat(peak_mat,[1 1 length(cond)]); %tile peak_mat into 3rd dimension, corresponding to stim conditions
    norm_resp=all_resp./peak_mat; %normalize measured responses to max responses
    
    %% Normalize peak vectors so they all have the same pull relative to their positional center
    force_vectors=nan(size(peak_locs)); %nCh x 2
    % Calculate the center
    peak_cent=min(peak_locs)+(max(peak_locs)-min(peak_locs))/2;
    % Subtract center so peaks are distributed around origin
    peak_locs_TL=peak_locs-ones(size(peak_locs,1),1)*peak_cent;
    % Calculate Left/Right Force Vectors
    right_cent=peak_locs_TL(:,1)>0; %find everything pulling right
    right_pull=sum(peak_locs_TL(right_cent,1)); %find total pull to the right
    force_vectors(right_cent,1)=peak_locs_TL(right_cent,1)/right_pull; %make total pull to the right =1;
    left_pull=abs(sum(peak_locs_TL(~right_cent,1))); %total left pull
    force_vectors(~right_cent,1)=peak_locs_TL(~right_cent,1)/left_pull; %normalize left pull
    % Calculate Up/Down Force Vectors
    above_cent=peak_locs_TL(:,2)>0;
    up_pull=sum(peak_locs_TL(above_cent,2));
    down_pull=abs(sum(peak_locs_TL(~above_cent,2)));
    force_vectors(above_cent,2)=peak_locs_TL(above_cent,2)/up_pull;
    force_vectors(~above_cent,2)=peak_locs_TL(~above_cent,2)/down_pull;
    % Scale to fit bounding box ... otherwise scaled to 1
    force_scale=ones(size(force_vectors,1),1)* (max(peak_locs)-min(peak_locs))/2;
    force_vectors=force_vectors .* force_scale;
    
end

%% GENERATE ARTIFICIAL DATA FOR DEBUGGING PURPOSES
% nRep=100*nRep;
% norm_resp=randn(nCh,nRep);
% norm_resp(1,:)=norm_resp(1,:)+1;

%% Use normalized responses and tuning to estimate location

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch norm_type
    
    case 1 %no normalization ... divide by number of channels
        raw_x_vect=norm_resp(:,:)'*peak_locs(:,1) / nCh; %Mx1, where M = reps*conditions
        raw_y_vect=norm_resp(:,:)'*peak_locs(:,2) / nCh;
        
    case 2 %divide by sum of the absolute value of the avtivity on this trial
        raw_x_vect=norm_resp(:,:)'*peak_locs(:,1) ./ sum(abs(norm_resp(:,:)))'; %Mx1, where M = reps*conditions
        raw_y_vect=norm_resp(:,:)'*peak_locs(:,2) ./ sum(abs(norm_resp(:,:)))';
        
    case 3 %adjust baseline position
        raw_x_vect=norm_resp(:,:)'*peak_locs_TL(:,1)+peak_cent(1); %Mx1, where M = reps*conditions
        raw_y_vect=norm_resp(:,:)'*peak_locs_TL(:,2)+peak_cent(2);
        
    case 4 %case 2 AND adjust pull to accound for non-homogenous sampling
        raw_x_vect=norm_resp(:,:)'*force_vectors(:,1)+peak_cent(1); %Mx1, where M = reps*conditions
        raw_y_vect=norm_resp(:,:)'*force_vectors(:,2)+peak_cent(2);
        
    case 5 %optimal linear estimator
        fprintf ('\nThis is as far as I have made it modifying the decoder\n')
        dbstack
        keyboard
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Condition Data ... want all cohorts in pop to have 50 reps for matrix
%%% reasons
if nRep > 50
    fprintf ('\nLooks like you had more than 50 reps for this condition. Pausing ''cause I''m not sure how to handle that\n')
    dbstack
    keyboard
end
if nRep<50
    raw_x_vect=[raw_x_vect;nan(50-nRep,1)];
    raw_y_vect=[raw_y_vect;nan(50-nRep,1)];
end

%% Calculate vector for shuffled data
shuff_x_mat=nan(nRep,nShuff);
shuff_y_mat=nan(nRep,nShuff);
shuff_x_vect_full=nan(50*nShuff,1);
shuff_y_vect_full=nan(50*nShuff,1);
store_shuff_norm=nan(nCh,nRep,nShuff); 

for i=1:nShuff
    
    shuff_norm=nan(size(norm_resp));
    for j=1:nCh
        shuff_norm(j,:)=norm_resp(j,randperm(nRep));
    end
    
    store_shuff_norm(:,:,i)=shuff_norm;
%     shuff_norm=Shuffle_Trials(norm_resp); % Shuffle normalized responses
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    switch norm_type
        case 1 %no normalization
            shuff_x_vect=shuff_norm(:,:)'*peak_locs(:,1) / nCh;
            shuff_y_vect=shuff_norm(:,:)'*peak_locs(:,2) / nCh;
                        
        case 2 %divide by sum of the absolute value of the avtivity on this trial
            shuff_x_vect=shuff_norm(:,:)'*peak_locs(:,1) ./ sum(abs(shuff_norm(:,:)))';
            shuff_y_vect=shuff_norm(:,:)'*peak_locs(:,2) ./ sum(abs(shuff_norm(:,:)))';
            
        case 3 %adjust baseline position         
            shuff_x_vect=shuff_norm(:,:)'*peak_locs_TL(:,1)+peak_cent(1); %Mx1, where M = reps*conditions
            shuff_y_vect=shuff_norm(:,:)'*peak_locs_TL(:,2)+peak_cent(2);
            
        case 4 %case 3 + adjust pull for nonhomogenous sampling            
            shuff_x_vect=shuff_norm(:,:)'*force_vectors(:,1)+peak_cent(1); %Mx1, where M = reps*conditions
            shuff_y_vect=shuff_norm(:,:)'*force_vectors(:,2)+peak_cent(2);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Had these in here when I still had multiple conditions.  Leaving it for
    %%% now
%     shuff_x_mat=reshape(shuff_x_vect,nRep,nG); %row = trials, column = condition
%     shuff_y_mat=reshape(shuff_y_vect,nRep,nG);
%     shuff_x_mean(i,:)=mean(shuff_x_mat);
%     shuff_x_std(i,:)=std(shuff_x_mat);
%     shuff_y_mean(i,:)=mean(shuff_y_mat);
%     shuff_y_std(i,:)=std(shuff_y_mat);
%     
    %%% Make sure there are 50 reps per shuffle
    if nRep<50
        shuff_x_vect=[shuff_x_vect;nan(50-nRep,1)];
        shuff_y_vect=[shuff_y_vect;nan(50-nRep,1)];
    end
    
    shuff_x_mat(:,i)=shuff_x_vect;
    shuff_y_mat(:,i)=shuff_y_vect;
    
    shuff_x_vect_full(50*i-49:50*i)=shuff_x_vect;
    shuff_y_vect_full(50*i-49:50*i)=shuff_y_vect;
    
end

%% Compare Noise Correlations Before and After Shuffle
if get(handles.comp_nc,'Value') && nCh>1
    %run on raw
    rho=corr(norm_resp');
    useme=logical(triu(ones(size(rho)),1));
    norm_corr=rho(useme);
    
    
    %run on shuffled
    temp_shuff_corr=nan(size(norm_corr,1),nShuff);
    for i = 1:nShuff
        rho_shuff=corr(store_shuff_norm(:,:,i)');
        temp_shuff_corr(:,i)=rho_shuff(useme);
    end
    shuff_corr=temp_shuff_corr(:);
    
else
    norm_corr=[];
    shuff_corr=[];
end


%% Plot Data
%%% Plot Raw Data
if plot_on
    
    %%% Calculate Raw Data for Plotting
    x_mat=reshape(raw_x_vect,nRep,nCon); %row = nRep, column = condition
    y_mat=reshape(raw_y_vect,nRep,nCon);
    x_mean=nanmean(x_mat); %1 x nG
    x_std=nanstd(x_mat); %1 x nG
    y_mean=nanmean(y_mat); %1 x nG
    y_std=nanstd(y_mat); %1 x nG

    plot_x_raw=[x_mean'-x_std' x_mean'+x_std'; repmat(x_mean',1,2)];
    plot_y_raw=[repmat(y_mean',1,2);y_mean'-y_std' y_mean'+y_std'];
    %for 2 conditions this will be Horiz. line for condition 1, horz for condition 2, vert
    %condition 1, vert condition 2, where the horiz. line = [x_mean-std, x_mean+std] by
    %[y_mean, y_mean] for that condition
    
        
    %%% Calculate Shuffled Data for Plotting
    shuff_x_mean=nanmean(shuff_x_mat);
    shuff_y_mean=nanmean(shuff_y_mat);
    shuff_x_std=nanstd(shuff_x_mat);
    shuff_y_std=nanstd(shuff_y_mat);
    
    mean_shuff_x_mean=mean(shuff_x_mean);
    mean_shuff_x_std=mean(shuff_x_std);
    mean_shuff_y_mean=mean(shuff_y_mean);
    mean_shuff_y_std=mean(shuff_y_std);

    plot_x_shuff=[mean_shuff_x_mean'-mean_shuff_x_std' mean_shuff_x_mean'+mean_shuff_x_std'; repmat(mean_shuff_x_mean',1,2)];
    plot_y_shuff=[repmat(mean_shuff_y_mean',1,2);mean_shuff_y_mean'-mean_shuff_y_std' mean_shuff_y_mean'+mean_shuff_y_std'];
    
    
    h1=figure;
    hold on
    %%%% First plot in the order you want things to show up on the legend
    %%% Plot reference points
    plot (peak_locs(:,1),peak_locs(:,2),'+k','MarkerSize',20,'LineWidth',3) %plot neuron tuning
    plot (id_vin,id_vis_el,'xg','MarkerSize',20,'LineWidth',3) %plot actual stim location  
    
    %%% Plot Raw Data
    h_points_raw=plot(x_mat,y_mat,'*b'); %plot single trial estimates
    h_means_raw=plot (plot_x_raw', plot_y_raw','b','LineWidth',5); %plot mean and STD
    
    %%% Plot Shuffled Data
    h_means_shuff=plot (plot_x_shuff', plot_y_shuff','--r','LineWidth',5); %plot mean and standard deviation
    h_points_shuff=plot (shuff_x_mat(:),shuff_y_mat(:),'or','MarkerSize',3); %plot single trial estimates
    
    %%% Plot Raw Data - plot again to plot overtop of shuffled
    h_points_raw=plot(x_mat,y_mat,'*b'); %plot single trial estimates
    h_means_raw=plot (plot_x_raw', plot_y_raw','b','LineWidth',3); %plot mean and STD
    h_points_raw=plot(x_mat,y_mat,'*b'); %plot single trial estimates
    
    %%% Plot reference points - plot again to plot overtop of shuffled
    plot (peak_locs(:,1),peak_locs(:,2),'+k','MarkerSize',20,'LineWidth',3) %plot neuron tuning
    plot (id_vin,id_vis_el,'xg','MarkerSize',20,'LineWidth',3) %plot actual stim location  
    
    %%% Plot Bounding Box
    if norm_type==3 || norm_type==4 %if adjusting pull
        BL=min(peak_locs); %bottom left
        TR=max(peak_locs); %top right
        plot ([BL(1),TR(1),TR(1),BL(1),BL(1)],[BL(2),BL(2),TR(2),TR(2),BL(2)],':g') %plot bounding box
        plot ([peak_cent(1),BL(1);peak_cent(1),TR(1)],[BL(2),peak_cent(2);TR(2),peak_cent(2)],':g') %plot center of box
    end
    
    
    legend({'Neuron Tuning','Stim Position',id_mt_labels{cond}})
    xlabel('Visual Azimuth')
    ylabel('Visual Elevation')
    title ('Stim Location Estimates from Vector Decoder','FontSize',15)
    
    %used this when coloring by condition
%     set (h_means,{'Color'},linecell_means);
    
    % draw axis lines ... of doesn't reach zero, don't draw axis
    range=get (gca,'xlim');
    range(2,:)= get(gca,'ylim');
    if ~(range(2,1)>0 || range(2,2)<0)
        plot (range(1,:),[0 0],'k')
    end
    if ~(range(1,1)>0 || range (1,2)<0)
        plot ([0 0],range(2,:),'k')
    end
    
    %%%Print error to screen
    x_error=x_mat(~isnan(x_mat))-id_vin;
    y_error=y_mat(~isnan(y_mat))-id_vis_el;
    total_distance=((x_error'*x_error+y_error'*y_error) / length(x_error) ) ^.5
    fprintf ('\nError = %.1f\n',total_distance)
    
    keyboard
%     close
end

% %% Print results to screen
% fprintf ('\nActual stim location:  Az=%.0f El=%.0f',id_vin, id_vis_el)
% % fprintf ('\nEstimated by raw data (correlations intact):  Az=%.2f  El=%.2f ... stds=[%.2f %.2f]', x_mean,x_std)
% % fprintf ('\nEstimated by shuffle data (correlations gone):  Az=%.2f  El=%.2f ... stds=[%.2f %.2f]\n', mean_shuff_x_mean,mean_shuff_x_std)
% 
% fprintf('\n\nComparison of MEANS')
% fprintf('\n%s \t%s \t%s \t%s \t%s \t%s \t%s','condition','Raw Az','Shuff Az','(Raw-Shuff)','Raw El','Shuff El','(Raw-Shuff)')
% fprintf('\n%.0f \t\t%.2f \t%.2f \t\t%.2f \t\t\t%.2f \t%.2f \t\t%.2f',[condition; x_mean; mean_shuff_x_mean; x_mean-mean_shuff_x_mean; y_mean; mean_shuff_y_mean; y_mean-mean_shuff_y_mean])
% fprintf('\n')
% 
% fprintf('\n\nComparison of STANDARD DEVIATIONS')
% fprintf('\n%s \t%s \t%s \t%s \t%s \t%s \t%s','condition','Raw Az','Shuff Az','(Raw-Shuff)','Raw El','Shuff El','(Raw-Shuff)')
% fprintf('\n%.0f \t\t%.2f \t%.2f \t\t%.2f \t\t\t%.2f \t%.2f \t\t%.2f',[condition; x_std; mean_shuff_x_std; x_std-mean_shuff_x_std; y_std; mean_shuff_y_std; y_std-mean_shuff_y_std])
% fprintf('\n')
% 
% x_error=abs(x_mean-id_vin);
% xshuff_error=abs(mean_shuff_x_mean-id_vin);
% y_error=abs(y_mean-id_vis_el);
% yshuff_error=abs(mean_shuff_y_mean-id_vis_el);
% 
% fprintf ('\n\nPrediction Errors')
% fprintf ('\n%s \t%s \t\t%s \t%s \t\t%s','condition','x','xshuff','y','yshuff')
% fprintf ('\n%.0f \t\t%.2f \t%.2f \t%.2f \t%.2f',[condition;x_error;xshuff_error;y_error;yshuff_error])
% fprintf ('\n')



function [peak_resp,Xq,Yq,Zq_pop]=Find_Peaks(map,interp_scale,handles)
%Find peaks of all channels using cubic interpolation
[~,~,chans]=size(map.resp);

show_maps=get(handles.show_rf,'Value');

x=map.Var1array;
x_step=(x(2)-x(1))/interp_scale;
xq=x(1):x_step:x(end);
y=map.Var2array;
y_step=(y(2)-y(1))/interp_scale;
yq=y(1):y_step:y(end);
[X,Y]=meshgrid(x,y);
[Xq,Yq]=meshgrid(xq,yq);

peak_resp=nan(chans,1);

if show_maps
    h=figure;
    hold on
end

Zq_pop=nan([size(Xq),chans]);


plot_cols=ceil(chans^.5);
plot_rows=ceil(chans/plot_cols);
col=0;
row=1;

for i=1:chans
    col=col+1;
    if col>plot_cols
        row=row+1;
        col=1;
    end
    
    Z=map.resp(:,:,i);
    Zq=interp2(X,Y,Z,Xq,Yq,'cubic');   
    peak_resp(i)=max(Zq(:));
    
    Zq_pop(:,:,i)=Zq/peak_resp(i);
    
    if show_maps
        figure(h)
        subplot(plot_rows,plot_cols,col+(row-1)*plot_cols)
        surf(Xq,Yq,Zq)
        
        % show each individual figure
        figure
        surf(Xq,Yq,Zq)
        pause
        close
        
    end
    
end

if show_maps
    hold off
end

function opt_params=Optimal_Linear_Estimator (rec_dat,responders)

nCh=sum(responders);

%%% Make cost function and minimize
% Grab responses and stimulus values
maps=rec_dat.resp(:,:,responders);
if sum(sum(maps,3)==0)>0
    fprintf('\Crap, you have a at least one stim position that never elicited a spike from any neuron.  This will cause problems in your decoder.  Pausing so you can scope it\n')
    dbstack
    keyboard
end
nXs=length(rec_dat.Var1array);
nYs=length(rec_dat.Var2array);
x_locs=repmat(rec_dat.Var1array,[nYs,1]);
y_locs=repmat(rec_dat.Var2array',[1,nXs]);

%vectorize responses and stim values
resp_vect=reshape(maps,[nXs*nYs,nCh]);

Stim_est=@(params)[resp_vect,ones(nXs*nYs,1)]*params;
cost = @(params) sum( ( diag((Stim_est(params)-[x_locs(:),y_locs(:)])*(Stim_est(params)-[x_locs(:),y_locs(:)])' )).^.5 ); %param 1=X, param 2=Y

opt_params=nan(nCh+1,2,100);
costs=nan(100,1);
options.Display='off';
options.LargeScale='off';
for j=1:100
    initial_params=rand(nCh+1,2);
    [opt_params(:,:,j),costs(j)]=fminunc(cost,initial_params,options);
end
[lowest_min,pointer]=min(costs);
opt_params=opt_params(:,:,pointer);
%show costs
figure
hist (costs)
title ('Costs for 100 runs of parameter fits')


%%% Visualize Localization
%  Make correct matrices to start
loc_ests=Stim_est(opt_params);
%calculate the cost of using these parameters
cost_vect =  ( diag((Stim_est(opt_params)-[x_locs(:),y_locs(:)])*(Stim_est(opt_params)-[x_locs(:),y_locs(:)])' )).^.5 ;
%calculate the cost of just guessing the center location every time
center_est_cost_vect =  ( diag((ones(nXs*nYs,1)*[mean(x_locs(:)),mean(y_locs(:))]-[x_locs(:),y_locs(:)])*(ones(nXs*nYs,1)*[mean(x_locs(:)),mean(y_locs(:))]-[x_locs(:),y_locs(:)])' )).^.5 ;
figure
hist (cost_vect)
title (sprintf('Costs per Stimulus :: Mean = %.2f degrees\nStimulus Range Y=[%.0f %.0f]  X=[%.0f %.0f]',mean(cost_vect),min(y_locs),max(y_locs),min(x_locs(:)),max(x_locs(:))))

cost_mat=reshape(cost_vect,nYs,nXs);

% Visualize location estimates vs actual estimates
figure
hold on
plot (x_locs,y_locs,'xb','MarkerSize',15)
plot (loc_ests(:,1),loc_ests(:,2),'xk','MarkerSize',15)
plot ([x_locs(:),loc_ests(:,1)]',[y_locs(:),loc_ests(:,2)]',':r')
title (sprintf('Stim Location Estimates :: Total Cost=%.1f :: Cost of Guessing Mean=%.1f',sum(cost_vect),sum(center_est_cost_vect)))
legend ({'Stim Locations','Estimates'})

% Interpolate
interp_scale=10;
x=x_locs(1,:);
x_step=(x(2)-x(1))/interp_scale;
xq=x(1):x_step:x(end);
y=y_locs(:,1);
y_step=(y(2)-y(1))/interp_scale;
yq=y(1):y_step:y(end);
[X,Y]=meshgrid(x,y);
[Xq,Yq]=meshgrid(xq,yq);

% Make subplots
h=figure;
hold on
plot_cols=ceil((nCh+1)^.5);
plot_rows=ceil((nCh+1)/plot_cols);
col=0;
row=1;

chantitles=find(responders==1);

for i=1:nCh
    col=col+1;
    if col>plot_cols
        row=row+1;
        col=1;
    end
    
    Z=maps(:,:,i);
    Zq=interp2(X,Y,Z,Xq,Yq,'cubic');
    peak_resp(i)=max(Zq(:));
    
    Zq_pop(:,:,i)=Zq/peak_resp(i);
    
    figure(h)
    subplot(plot_rows,plot_cols,col+(row-1)*plot_cols)
    contourf(Xq(1,:),Yq(:,1),Zq,100);       %%show contour plot of one Channel
    title (sprintf('Channel %.0f',chantitles(i)));
    h_C=get(gca,'children');
    set(h_C,'linestyle','none');
    hold on
    plot (opt_params(i,1),opt_params(i,2),'xk','LineWidth',15)
    plot (opt_params(i,1),opt_params(i,2),'xw','LineWidth',10)
    
end

% Make one more plot to show the errors in the estimates
col=col+1;
if col>plot_cols
    row=row+1;
    col=1;
end

Z=cost_mat;

Zq=interp2(X,Y,Z,Xq,Yq,'cubic');

figure(h)
subplot(plot_rows,plot_cols,col+(row-1)*plot_cols)
% surf(Xq,Yq,Zq)
title ('Estimate Errors');

contourf(Xq(1,:),Yq(:,1),Zq,100);       %%show contour plot of one Channel
%     colorbar;       %%show a reference bar for the contour plot
h_C=get(gca,'children');
set(h_C,'linestyle','none');

pause
close (h)
