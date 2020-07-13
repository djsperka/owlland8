function Location_Decoder_Weight_Ave2 ()
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


%% Set controls
groups=[ 1 3 4]; %choose which conditions to look at

respORpost=1; %1=resp, 2=post
resp_sort=1; %sort based on responses?  
dropvisout=0; %only use non-responders to vout?
keepvisin=0; %only use responders to vin?
vistuned=1; %use tuning to sort?
dropaudout=0; 
keepaudin=0;
audtuned=0;

num_shuffles=10; %number of times to shuffle trials to disrupt correlations

interp_scale=10; %number of steps between points in interpolation

%% Open some data, filter it and shape it for analysis
startdir=cd;
cd ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition')
uiopen
cd (startdir)

%%% Select Data
all_resp=nan(length(id_mt_data.resp_cell), size(id_mt_data.resp_cell{1},1), size(id_mt_data.resp_cell{1},2));

%%% Use cubic interpolation to find max firing rate
[peak_resp,Xq,Yq,Zq_pop]=Find_Peaks(id_vis_map,interp_scale);

%%% Choose response or post data
[chans, reps, ~]=size (all_resp);
for i=1:chans
    if respORpost==1
        all_resp(i,:,:)=id_mt_data.resp_cell{i};
    elseif respORpost==2
        all_resp(i,:,:)=id_mt_data.post_cell{i};
    else
        error ('need to choose something for respORpost')
    end
end
all_resp=all_resp(:,:,groups); %chan x reps x condition

%%% Sort by Response Classifications
responders=ones (chans,1);
if resp_sort
    
    if dropvisout
    responders=data_responds(:,3)==0; %drop vis-out responders
    end
    if keepvisin
%     responders=responders & data_responds(:,2)==1; % drop vis-in NONresponders
    responders=responders & (data_responds(:,2)==1 | data_responds(:,1)==1); % drop vis-in NONresponders
    end
    if vistuned
        responders=responders & id_tuned_vis==1;
    end
    if dropaudout
        keyboard
    end
    if keepaudin
        keyboard
    end
    if audtuned
        keyboard
    end
    
    fprintf ('\n%.0f of %.0f Channels Used\n',sum(responders), length(responders))
    all_resp=all_resp(responders,:,:);
    peak_resp=peak_resp(responders);
    peak_locs=id_wa_peak_vis(responders,:);
    Zq_pop=Zq_pop(:,:,responders);
    
end
chans=sum(responders);

%% Calculate vector for raw data using the vector weighted average approach
%%% Normalize responses to their max firing rate
peak_mat=peak_resp*ones(1,reps); %tile resps from Nx1 --> NxM where N = num cells, M = number of reps
peak_mat=repmat(peak_mat,[1 1 length(groups)]); %tile peak_mat into 3rd dimension, corresponding to stim conditions
norm_resp=all_resp./peak_mat; %normalize measured responses to max responses

%% Normalize peak vectors so they all have the same pull relative to their positional center
force_vectors=nan(size(peak_locs));
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

%%% Use normalized responses and tuning to estimate location

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%THESE TWO are for just using peak locations
% x_vect=norm_resp(:,:)'*peak_locs(:,1) ./ sum(norm_resp(:,:))'; %Mx1, where M = reps*groups
% y_vect=norm_resp(:,:)'*peak_locs(:,2) ./ sum(norm_resp(:,:))';

%THESE TWO are for normalizing contributions based on relative tuning
x_vect=norm_resp(:,:)'*force_vectors(:,1)+peak_cent(1); %Mx1, where M = reps*groups
y_vect=norm_resp(:,:)'*force_vectors(:,2)+peak_cent(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x_mat=reshape(x_vect,reps,length(groups)); %row = trials, column = group
y_mat=reshape(y_vect,reps,length(groups)); 
x_mean=mean(x_mat); %1xN where N = num groups
x_std=std(x_mat); %1xN where N = num groups  
y_mean=mean(y_mat);
y_std=std(y_mat);

%% Plot Raw Data
plot_x=[x_mean'-x_std' x_mean'+x_std'; repmat(x_mean',1,2)]; 
plot_y=[repmat(y_mean',1,2);y_mean'-y_std' y_mean'+y_std'];
%for 2 groups this will be Horiz. line for group 1, horz for group 2, vert
%group 1, vert group 2, where the horiz. line = [x_mean-std, x_mean+std] by
%[y_mean, y_mean[ for that group

linecolors=linspecer(length(groups)); %set colors for each group
linecell=num2cell(linecolors,2); %need to be a Mx1 cell where each row is a [3x1] double
linecell_means=repmat(linecell,2,1);

h=figure;
hold on
plot (id_vin,id_vis_el,'xk','MarkerSize',20,'LineWidth',3) %plot actual stim location
plot (peak_locs(:,1),peak_locs(:,2),'+k','MarkerSize',20,'LineWidth',3) %plot neuron tuning

h_points=plot(x_mat,y_mat,'.');
set (h_points,{'Color'},linecell); %sets colors for multiple groups at once

h_means=plot (plot_x', plot_y');
set (h_means,{'Color'},linecell_means);

BL=min(peak_locs); %bottom left
TR=max(peak_locs); %top right
plot ([BL(1),TR(1),TR(1),BL(1),BL(1)],[BL(2),BL(2),TR(2),TR(2),BL(2)],':g') %plot bounding box
plot ([peak_cent(1),BL(1);peak_cent(1),TR(1)],[BL(2),peak_cent(2);TR(2),peak_cent(2)],':g') %plot center of box

legend({'Stim Position','Neuron Tuning',id_mt_labels{groups}})
xlabel('Visual Azimuth')
ylabel('Visual Elevation')
title ('Stim Location Estimates from Vector Decoder','FontSize',15)

hold off

%% Calculate vector for shuffled data
shuff_x_mean=nan(num_shuffles,length(groups));
shuff_x_std=nan(num_shuffles,length(groups));
shuff_y_mean=nan(num_shuffles,length(groups));
shuff_y_std=nan(num_shuffles,length(groups));
for i=1:num_shuffles
    
    shuff_norm=Shuffle_Trials(norm_resp); % Shuffle normalized responses
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %THESE TWO are for just using peak locations
    %     shuff_x_vect=shuff_norm(:,:)'*peak_locs(:,1) ./ sum(norm_resp(:,:))';
    %     shuff_y_vect=shuff_norm(:,:)'*peak_locs(:,2) ./ sum(norm_resp(:,:))';
    %THESE TWO are for normalizing contributions based on relative tuning
    shuff_x_vect=shuff_norm(:,:)'*force_vectors(:,1)+peak_cent(1); %Mx1, where M = reps*groups
    shuff_y_vect=shuff_norm(:,:)'*force_vectors(:,2)+peak_cent(2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    shuff_x_mat=reshape(shuff_x_vect,reps,length(groups)); %row = trials, column = group
    shuff_y_mat=reshape(shuff_y_vect,reps,length(groups));
    shuff_x_mean(i,:)=mean(shuff_x_mat);
    shuff_x_std(i,:)=std(shuff_x_mat);
    shuff_y_mean(i,:)=mean(shuff_y_mat);
    shuff_y_std(i,:)=std(shuff_y_mat);
    
end

mean_shuff_x_mean=mean(shuff_x_mean);
mean_shuff_x_std=mean(shuff_x_std);
mean_shuff_y_mean=mean(shuff_y_mean);
mean_shuff_y_std=mean(shuff_y_std);

%%% Plot it
plot_x=[mean_shuff_x_mean'-mean_shuff_x_std' mean_shuff_x_mean'+mean_shuff_x_std'; repmat(mean_shuff_x_mean',1,2)]; 
plot_y=[repmat(mean_shuff_y_mean',1,2);mean_shuff_y_mean'-mean_shuff_y_std' mean_shuff_y_mean'+mean_shuff_y_std'];

figure (h)
hold on

h_means=plot (plot_x', plot_y','--','LineWidth',2);
set (h_means,{'Color'},linecell_means);

% draw axis lines ... of doesn't reach zero, don't draw axis
range=get (gca,'xlim');
range(2,:)= get(gca,'ylim');
if ~(range(2,1)>0 || range(2,2)<0)
plot (range(1,:),[0 0],'k')
end
if ~(range(1,1)>0 || range (1,2)<0)
plot ([0 0],range(2,:),'k')
end

%% Print results to screen
fprintf ('\nActual stim location:  Az=%.0f El=%.0f',id_vin, id_vis_el)
% fprintf ('\nEstimated by raw data (correlations intact):  Az=%.2f  El=%.2f ... stds=[%.2f %.2f]', x_mean,x_std)
% fprintf ('\nEstimated by shuffle data (correlations gone):  Az=%.2f  El=%.2f ... stds=[%.2f %.2f]\n', mean_shuff_x_mean,mean_shuff_x_std)

fprintf('\n\nComparison of MEANS')
fprintf('\n%s \t%s \t%s \t%s \t%s \t%s \t%s','Group','Raw Az','Shuff Az','(Raw-Shuff)','Raw El','Shuff El','(Raw-Shuff)')
fprintf('\n%.0f \t\t%.2f \t%.2f \t\t%.2f \t\t\t%.2f \t%.2f \t\t%.2f',[groups; x_mean; mean_shuff_x_mean; x_mean-mean_shuff_x_mean; y_mean; mean_shuff_y_mean; y_mean-mean_shuff_y_mean])
fprintf('\n')

fprintf('\n\nComparison of STANDARD DEVIATIONS')
fprintf('\n%s \t%s \t%s \t%s \t%s \t%s \t%s','Group','Raw Az','Shuff Az','(Raw-Shuff)','Raw El','Shuff El','(Raw-Shuff)')
fprintf('\n%.0f \t\t%.2f \t%.2f \t\t%.2f \t\t\t%.2f \t%.2f \t\t%.2f',[groups; x_std; mean_shuff_x_std; x_std-mean_shuff_x_std; y_std; mean_shuff_y_std; y_std-mean_shuff_y_std])
fprintf('\n')

x_error=abs(x_mean-id_vin);
xshuff_error=abs(mean_shuff_x_mean-id_vin);
y_error=abs(y_mean-id_vis_el);
yshuff_error=abs(mean_shuff_y_mean-id_vis_el);

fprintf ('\n\nPrediction Errors')
fprintf ('\n%s \t%s \t\t%s \t%s \t\t%s','group','x','xshuff','y','yshuff')
fprintf ('\n%.0f \t\t%.2f \t%.2f \t%.2f \t%.2f',[groups;x_error;xshuff_error;y_error;yshuff_error])
fprintf ('\n')


function [peak_resp,Xq,Yq,Zq_pop]=Find_Peaks(map,interp_scale)
%Find peaks of all channels using cubic interpolation
[~,~,chans]=size(map.resp);

show_maps=0;

x=map.Var1array;
x_step=(x(2)-x(1))/interp_scale;
xq=x(1):x_step:x(end);
y=map.Var2array;
y_step=(y(2)-y(1))/interp_scale;
yq=y(1):y_step:y(end);
[X,Y]=meshgrid(x,y);
[Xq,Yq]=meshgrid(xq,yq);

peak_resp=nan(chans,1);

plot_cols=ceil(chans^.5);
plot_rows=ceil(chans/plot_cols);
col=0;
row=1;

if show_maps
    h=figure;
    hold on
end

Zq_pop=nan([size(Xq),chans]);

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
    end
    
end

if show_maps
    hold off
end

