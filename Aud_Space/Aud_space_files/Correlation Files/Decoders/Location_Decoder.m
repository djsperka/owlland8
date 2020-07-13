function Location_Decoder ()
% use this to try to use neural responses to decode the location of the
% stimulus, based on their tuning preferences
% Set controls
%   decide which conditions will be used, 
% Open the data, filter it and shape it.  
%   Peak responses are 
% 

%% Set controls
groups=[2,6]; %choose which conditions to look at

respORpost=1; %1=resp, 2=post
resp_sort=1; %sort based on responses?  
dropvisout=1;
keepvisin=1;
dropaudout=0;
keepaudin=0;

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
    responders=responders & data_responds(:,2)==1; % drop vis-in NONresponders
    end
    if dropaudout
        keyboard
    end
    if keepaudin
        keyboard
    end
    
    fprintf ('\n%.0f of %.0f Channels Used\n',sum(responders), length(responders))
    all_resp=all_resp(responders,:,:);
    peak_resp=peak_resp(responders);
    peak_locs=id_wa_peak_vis(responders,:);
    Zq_pop=Zq_pop(:,:,responders);
    
end
chans=sum(responders);

%% Calculate vector for raw data using the RF topo approach
%%% Normalize responses to their max firing rate
peak_mat=peak_resp*ones(1,reps); %tile resps from Nx1 --> NxM where N = num cells, M = number of reps
peak_mat=repmat(peak_mat,[1 1 length(groups)]); %tile peak_mat into 3rd dimension, corresponding to stim conditions
norm_resp=all_resp./peak_mat; %normalize measured responses to max responses

%%% This next bit processes just a single condition for debugging purposes.
resp_mean=mean(norm_resp(:,:,1),2); %calculate mean response for each channel
resp_mean=reshape(resp_mean,[1,1,length(resp_mean)]); %prep for tiling
resp_mean_mat=repmat(resp_mean,[size(Xq),1]); %tile responses into meshgrid for surf mapping

cut_contour=resp_mean_mat-abs(Zq_pop-resp_mean_mat); %invert RF above contour

%initiate the three types of figures that will be used
resp_map=figure;
cut_map=figure;
comb_map=figure;

%prep variables for tiling suplots
plot_cols=ceil(chans^.5); 
plot_rows=ceil(chans/plot_cols);
col=0;
row=1;
for i=1:size(cut_contour,3);
    col=col+1;
    if col>plot_cols
        col=1;
        row=row+1;
    end
    figure (resp_map);
    subplot(plot_rows,plot_cols,col+(row-1)*plot_cols)
    surf (Xq,Yq,Zq_pop(:,:,i))
    xlabel('Azimuth')
    ylabel('Elevation')
    zlabel('Resp')
    alpha(0.5);
    
    figure(cut_map);
    subplot(plot_rows,plot_cols,col+(row-1)*plot_cols)
    surf (Xq,Yq,cut_contour(:,:,i))
    xlabel('Azimuth')
    ylabel('Elevation')
    alpha(0.5);
    
    figure(comb_map);
    hold on
    surf(Xq,Yq,cut_contour(:,:,i));
    hold off
end
figure (resp_map)
title ('Neural Receptive Fields, re. Max Resp')

figure (cut_map)
title ('"cut" Neural RFs, inverted at measured response')

figure (comb_map)
title ('"cut" Neural RFs, overlayed')
alpha(1/chans);

% add the contour maps together and find their peak response
sum_contour=sum(cut_contour,3);
[m,yind]=max(max(sum_contour));
[m,xind]=max(sum_contour(:,yind));
figure
hold on
surf(Xq,Yq,sum_contour);
plot3 (Xq(xind,yind),Yq(xind,yind),m,'xw','LineWidth',3,'MarkerSize',15)
plot3 (Xq(xind,yind),Yq(xind,yind),m,'xk','LineWidth',2,'MarkerSize',12)
xlabel('Azimuth')
ylabel('Elevation')
title ('Integrated Neural Responses')

Z_temp=0.5-abs(Zq_pop(:,:,4) - 0.5);
%%% Use normalized responses and tuning to estimate location
x_vect=norm_resp(:,:)'*peak_locs(:,1) ./ sum(norm_resp(:,:))'; %Mx1, where M = reps*groups
y_vect=norm_resp(:,:)'*peak_locs(:,2) ./ sum(norm_resp(:,:))';
x_mat=reshape(x_vect,reps,length(groups)); %row = trials, column = group
y_mat=reshape(y_vect,reps,length(groups)); 
x_mean=mean(x_mat); %1xN where N = num groups
x_std=std(x_mat); %1xN where N = num groups
y_mean=mean(y_mat);
y_std=std(y_mat);

%%% Plot it
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
    shuff_x_vect=shuff_norm(:,:)'*peak_locs(:,1) ./ sum(norm_resp(:,:))';
    shuff_y_vect=shuff_norm(:,:)'*peak_locs(:,2) ./ sum(norm_resp(:,:))';
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

range=get (gca,'xlim');
range(2,:)= get(gca,'ylim');

plot (range(1,:),[0 0],'k')
plot ([0 0],range(2,:),'k')

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

%%%%%%%%% CODE DUMP %%%%%%%%%%%%%%%%

%%%% This chunk calculates vector weighted average in a different way that
%%%% didn't work well ... basically just 
% %% Calculate vector for raw data
% %%% Normalize responses to their max firing rate
% peak_mat=peak_resp*ones(1,reps);
% peak_mat=repmat(peak_mat,[1 1 length(groups)]); %tile peak_mat into 3rd dimension
% norm_resp=all_resp./peak_mat;
% 
% %%% Use normalized responses and tuning to estimate location
% x_vect=norm_resp(:,:)'*peak_locs(:,1) ./ size(norm_resp,1); %Mx1, where M = reps*groups
% y_vect=norm_resp(:,:)'*peak_locs(:,2) ./ size(norm_resp,1);
% x_mat=reshape(x_vect,reps,length(groups)); %row = trials, column = group
% y_mat=reshape(y_vect,reps,length(groups)); 
% x_mean=mean(x_mat); %1xN where N = num groups
% x_std=std(x_mat); %1xN where N = num groups
% y_mean=mean(y_mat);
% y_std=std(y_mat);
% 

% %% Calculate vector for shuffled data
% shuff_x_mean=nan(num_shuffles,length(groups));
% shuff_x_std=nan(num_shuffles,length(groups));
% for i=1:num_shuffles
%     
%     shuff_norm=Shuffle_Trials(norm_resp); % Shuffle normalized responses
%     shuff_x_vect=shuff_norm(:,:)'*peak_locs(:,1) ./ size(norm_resp,1);
%     shuff_y_vect=shuff_norm(:,:)'*peak_locs(:,2) ./ size(norm_resp,1);
%     shuff_x_mat=reshape(shuff_x_vect,reps,length(groups)); %row = trials, column = group
%     shuff_y_mat=reshape(shuff_y_vect,reps,length(groups));
%     shuff_x_mean(i,:)=mean(shuff_x_mat);
%     shuff_x_std(i,:)=std(shuff_x_mat);
%     shuff_y_mean(i,:)=mean(shuff_y_mat);
%     shuff_y_std(i,:)=std(shuff_y_mat);
%     
% end
% 
% mean_shuff_x_mean=mean(shuff_x_mean);
% mean_shuff_x_std=mean(shuff_x_std);
% mean_shuff_y_mean=mean(shuff_y_mean);
% mean_shuff_y_std=mean(shuff_y_std);
% 
% %%% Plot it
% plot_x=[mean_shuff_x_mean'-mean_shuff_x_std' mean_shuff_x_mean'+mean_shuff_x_std'; repmat(mean_shuff_x_mean',1,2)]; 
% plot_y=[repmat(mean_shuff_y_mean',1,2);mean_shuff_y_mean'-mean_shuff_y_std' mean_shuff_y_mean'+mean_shuff_y_std'];
% 
% figure (h)
% hold on
% 
% h_means=plot (plot_x', plot_y','--','LineWidth',2);
% set (h_means,{'Color'},linecell_means);
% 
% range=get (gca,'xlim');
% range(2,:)= get(gca,'ylim');
% 
% plot (range(1,:),[0 0],'k')
% plot ([0 0],range(2,:),'k')