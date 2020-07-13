function Location_Decoder_Contour ()
% use this to try to use neural responses to decode the location of the
% stimulus, based on their tuning preferences
% Set controls
%   decide which conditions will be used, 
% Open the data, filter it and shape it.  
%   Peak responses are 
% 

%% Set controls
groups=[1 2 3 ]; %choose which conditions to look at

respORpost=1; %1=resp, 2=post
resp_sort=1; %sort based on responses?  
dropvisout=1;
keepvisin=1;
dropaudout=0;
keepaudin=0;

plot_contours=1; %do you want to plot contour maps for visualization purposes?
plot_groups=[1 ]; %if you are plotting contour maps, which groups do you want to plot? Choose 1:n where n= number of groups

num_shuffles=10; %number of times to shuffle trials to disrupt correlations

interp_scale=10; %number of steps between points in interpolation

prod_or_mean=1; %1 = product, 2 = mean ... decides how contour maps are combined

norm_to_vweak=0; %use this to decide whether or not to normalize to your vweak condition

%% Open some data, filter it and shape it for analysis
startdir=cd;
cd ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition')
uiopen
cd (startdir)

%%% Select Data
all_resp=nan(length(id_mt_data.resp_cell), size(id_mt_data.resp_cell{1},1), size(id_mt_data.resp_cell{1},2));

%%% Use cubic interpolation to find max firing rate
[peak_resp,Xq,Yq,Zq_pop]=Find_Peaks(id_vis_map,interp_scale,respORpost);

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

vweak_resp=all_resp(:,:,1);

all_resp=all_resp(:,:,groups); %chan x reps x condition

%%% Sort by Response Classifications
responders=ones (chans,1);
if resp_sort
    
    if dropvisout
    responders=data_responds(:,3)==0; %drop vis-out responders
    end
    if keepvisin
    responders=responders & (data_responds(:,2)==1 | data_responds(:,1)==1); % drop vis-in NONresponders
    end
    if dropaudout
        keyboard
    end
    if keepaudin
        keyboard
    end
    
    chans=sum(responders);
    
    fprintf ('\n%.0f of %.0f Channels Used\n',sum(responders), length(responders))
    all_resp=all_resp(responders,:,:);
    vweak_resp=vweak_resp(responders,:,:);
    peak_resp=peak_resp(responders);
    peak_locs=id_wa_peak_vis(responders,:);
    Zq_pop=Zq_pop(:,:,responders);
    
else
    peak_locs=id_wa_peak_vis;
end

%% Calculate vector for raw data using the RF topo approach
%%% Terminology: 
nX=size (Zq_pop,2); %=length of X dimension of interpolated stim
nY=size (Zq_pop,1); %=length of Y dimension for interpolated stim
nC=sum(responders); %=number of cells
nR=size(all_resp,2);%=number of reps
nG=length(groups);  %=number of groups


%%% Normalize responses to their max firing rate
peak_mat=peak_resp*ones(1,nR); %tile resps from nCx1 --> nCxnR
peak_mat=repmat(peak_mat,[1 1 nG]); %tile peak_mat into 3rd dimension, corresponding to nG
if norm_to_vweak
    scale_vect=mean(all_resp,2) ./ (repmat(mean (vweak_resp,2),[1 1 nG] )); %scale responses according to vweak resp nC x 1 x nG
    scale_mat=repmat(scale_vect,[1 nR 1]); % nC x nR x nG
    norm_resp=all_resp./scale_mat./peak_mat; %normalize measured responses vweak, then to max responses from receptive fields nCxnRxnG
    %%%%% NOTE This makes it so that the mean responses for all classes are the
    %%%%% same.  The subplot figures below are all calculated from mean
    %%%%% responses, so this will make them all equivalent.
else
    norm_resp=all_resp./peak_mat;
end

% %%% Look at effects of normalizing to vweak
% norm_resp2=all_resp./peak_mat; %normalize measured responses vweak, then to max responses from receptive fields nCxnRxnG
% A=squeeze(sum(sum(norm_resp>1)));
% B=squeeze(sum(sum(norm_resp2>1)));
% C=squeeze(sum(sum(norm_resp<1)));
% D=squeeze(sum(sum(norm_resp2<1)));
% fprintf('\nS=scaled to Vweak, NS = not scaled to vweak')
% fprintf('\nS>1\tNS>1\tS<1\tNS<1')
% fprintf('\n%.0f \t%.0f \t%.0f \t%.0f',[A B C D]')
% fprintf('\n')

%%% Reshape response matrices and contour maps for compatible operations
norm_resp_mat=reshape(norm_resp,[1,1,nC,nR,nG]); %1 x 1 x nC x nR x nG
norm_resp_mat=repmat(norm_resp_mat,[nY nX]); %nY x nX x nC x nRx nG
Zq_pop_mat=repmat(Zq_pop,[1,1,1,nR,nG]); %nY x nX x nC x nR x nG

%%% Use response mags to select contours and invert above contour
cut_contour=norm_resp_mat-abs(Zq_pop_mat-norm_resp_mat); % nY x nX x nC x nR x nG

%%% normalize the cut_contours so they don't go negative and their sum is 1 making them similar to probability distributions
cut_contour_scaled=cut_contour - repmat(min(min(cut_contour)),[nY,nX,1,1,1]);
cut_contour_scaled=cut_contour_scaled ./ repmat(sum(sum(cut_contour_scaled)),[nY,nX,1,1,1]);

%%% Add all the contour maps together and find their max values
if prod_or_mean==2
sum_contour=squeeze(sum(cut_contour,3)); %nY x nX x nR x nG
combi_contour=sum_contour;
elseif prod_or_mean==1
%%% Calculate the product of the scaled contour maps
prod_contour=squeeze(prod(cut_contour_scaled,3));
combi_contour=prod_contour;
end

[m,xind]=max(max(combi_contour)); %1 x 1 x nR x nG
xind=squeeze(xind); %nR x nG
[m,yind]=max(combi_contour(:,xind));
yind=reshape(yind,reps,nG); %nR x nG
m=reshape(m,reps,nG); %nR x nG

%%% Convert indeces to locations
x_mat=nan(nR,nG);
y_mat=x_mat;
for i=1:nG;
    x_mat(:,i)=Xq(1,xind(:,i));
    y_mat(:,i)=Yq(yind(:,i),1);
end

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

linecolors=linspecer(nG); %set colors for each group
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
shuff_x_mean=nan(num_shuffles,nG);
shuff_x_std=nan(num_shuffles,nG);
shuff_y_mean=nan(num_shuffles,nG);
shuff_y_std=nan(num_shuffles,nG);
for i=1:num_shuffles
    
    shuff_norm_resp=Shuffle_Trials(norm_resp); % Shuffle normalized responses
    
    %%% Reshape response matrices and contour maps for compatible operations
    shuff_norm_resp_mat=reshape(shuff_norm_resp,[1,1,size(shuff_norm_resp)]); %1x1xNxRxG
    shuff_norm_resp_mat=repmat(shuff_norm_resp_mat,size(Xq)); %YxXxNxRxG
    
    %%% Use response mags to select contours and invert above contour
    cut_contour=shuff_norm_resp_mat-abs(Zq_pop_mat-shuff_norm_resp_mat); % YxXxNxRxG
    
    %%% normalize the cut_contours so they don't go negative and their sum is 1 making them similar to probability distributions
    cut_contour_scaled=cut_contour - repmat(min(min(cut_contour)),[nY,nX,1,1,1]);
    cut_contour_scaled=cut_contour_scaled ./ repmat(sum(sum(cut_contour_scaled)),[nY,nX,1,1,1]);
    
    if prod_or_mean==2
        %%% Add all the contour maps together and find their max values
        sum_contour=squeeze(sum(cut_contour,3)); %nY x nX x nR x nG
        combi_contour=sum_contour;
    elseif prod_or_mean==1
        %%% Calculate the product of the scaled contour maps
        prod_contour=squeeze(prod(cut_contour_scaled,3));
        combi_contour=prod_contour;
    end

    [m,xind]=max(max(combi_contour)); %1x1xRxG
    xind=squeeze(xind); %RxG
    [m,yind]=max(combi_contour(:,xind));
    yind=reshape(yind,reps,nG); %RxG
    m=reshape(m,reps,nG); %RxG
    
    %%% Convert indeces to locations
    shuff_x_mat=nan(reps,nG);
    shuff_y_mat=shuff_x_mat;
    for j=1:nG;
        shuff_x_mat(:,j)=Xq(1,xind(:,j));
        shuff_y_mat(:,j)=Yq(yind(:,j),1);
    end    
    
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

x_error=abs(x_mean-id_vin);
xshuff_error=abs(mean_shuff_x_mean-id_vin);
y_error=abs(y_mean-id_vis_el);
yshuff_error=abs(mean_shuff_y_mean-id_vis_el);

fprintf ('\n\nPrediction Errors')
fprintf ('\n%s \t%s \t\t%s \t%s \t\t%s','group','x','xshuff','y','yshuff')
fprintf ('\n%.0f \t\t%.2f \t%.2f \t%.2f \t%.2f',[groups;x_error;xshuff_error;y_error;yshuff_error])
fprintf ('\n')

%% For visualization purposes calculate the mean reponse map and 
%%
%%
%%
%% CRAP ... this isn't really true to the data.  Making a calculation on the means is NOT the same as taking the mean of the calculations.  This will need to be adjusted later
if plot_contours
    
    %%%%%% Get this working so you can visualize what your normalization
    %%%%%% routines are ACTUALLY doing from a computational standpoint!
    
    resp_mean=mean(norm_resp,2); %calculate mean response for each channel ... nC x 1 x nG
    
    %%% Reshape response matrices and contour maps for compatible operations
    resp_mean=reshape(resp_mean,[1,1,nC,nG]); %prep for tiling 1 x 1 x nC x nG
    resp_mean_mat=repmat(resp_mean,[nY, nX,1]); %tile responses into meshgrid for surf mapping ... nY x nX x nC x nG
    Zq_pop_4D=repmat(Zq_pop,[1 1 1 nG]);
    
    %%% Use response mags to select contours and invert above contour
    mean_cut_contour=resp_mean_mat-abs(Zq_pop_4D-resp_mean_mat); %invert RF above contour ... nY x nX x nC x nG
    
    %%% normalize the cut_contours so they don't go negative and their sum is 1 making them similar to probability distributions
    mean_cut_contour_scaled=mean_cut_contour - repmat(min(min(mean_cut_contour)),[nY,nX,1,1,1]);
    mean_cut_contour_scaled=mean_cut_contour_scaled ./ repmat(sum(sum(mean_cut_contour_scaled)),[nY,nX,1,1,1]);    
        
    if prod_or_mean==2
        %%% Add all the contour maps together and find their max values
        sum_contour=squeeze(sum(mean_cut_contour,3)); %nY x nX x nR x nG
        combi_contour=sum_contour;
    elseif prod_or_mean==1
        %%% Calculate the product of the scaled contour maps
        prod_contour=squeeze(prod(mean_cut_contour_scaled,3));
        combi_contour=prod_contour;
    end
    
    [m,mean_xind]=max(max(combi_contour));
    [m,mean_yind]=max(combi_contour(:,mean_xind));
    mean_xind=squeeze(mean_xind);
    mean_yind=squeeze(mean_yind);
    
    %%% prep variables for tiling suplots
    plot_cols=ceil(chans^.5);
    plot_rows=ceil(chans/plot_cols);
    
    for g=1:length(plot_groups)
        
        plot_gr=plot_groups(g); %this is the group being plotted
        
        %%% initiate the three types of figures that will be used
        resp_map=figure;
        cut_map=figure;
%         comb_map=figure;
        
        col=0;
        row=1;  
        for i=1:nC;
            col=col+1;
            if col>plot_cols
                col=1;
                row=row+1;
            end
            
            %%% Plot RF contour maps
            figure (resp_map);
            subplot(plot_rows,plot_cols,col+(row-1)*plot_cols)
            surf (Xq,Yq,Zq_pop_mat(:,:,i,plot_gr))
            xlabel('Azimuth')
            ylabel('Elevation')
            zlabel('Resp')
            alpha(0.5);
            
            %%% Plot RFs inverted at selected contour
            figure(cut_map);
            subplot(plot_rows,plot_cols,col+(row-1)*plot_cols)
            surf (Xq,Yq,mean_cut_contour_scaled(:,:,i,plot_gr))
            xlabel('Azimuth')
            ylabel('Elevation')
            alpha(0.5);
            
%             %%% Plot contour maps over eachother
%             figure(comb_map);
%             hold on
%             surf(Xq,Yq,mean_cut_contour_scaled(:,:,i,plot_gr));
%             hold off
        end
        
        %%% Add appropriate titles
        figure (resp_map)
        title ('Neural Receptive Fields, re. Max Resp')
        
        figure (cut_map)
        title ('"cut" Neural RFs, inverted at measured response')
        
%         figure (comb_map)
%         title ('"cut" Neural RFs, overlayed')
%         alpha(.1);
        
        %%% add the contour maps together and find their peak response
        figure
        hold on
        surf(Xq,Yq,combi_contour(:,:,plot_gr));
        mean_xloc=Xq(mean_yind(plot_gr),mean_xind(plot_gr));
        mean_yloc=Yq(mean_yind(plot_gr),mean_xind(plot_gr));
        plot3 (mean_xloc, mean_yloc,m(plot_gr),'xw','LineWidth',3,'MarkerSize',15)
        plot3 (mean_xloc, mean_yloc,m(plot_gr),'xk','LineWidth',2,'MarkerSize',12)
        xlabel('Azimuth')
        ylabel('Elevation')
        title ('Integrated Neural Responses')
                
    end
    
end


function [peak_resp,Xq,Yq,Zq_pop]=Find_Peaks(map,interp_scale,respORpost)
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
    
    if respORpost==1
        Z=map.resp(:,:,i);
    else
        Z=map.post(:,:,i);
    end
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

