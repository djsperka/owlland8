function Noise_Corr_Cluster_Anal
% My question is this; can I use the data recorded to destinguish
% "strongest stim is here" from "strongest stim is NOT here"?

% cut and past this when uiopen is caleld to get the right folder 
%C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition

%% Set controls
groups=[1 2 3 4 5 6]; %choose which conditions to look at
num_clusts= 2; %length (groups); %decide how many clusters you want to make
respORpost=1; %1=resp, 2=post
resp_sort=1; %sort based on responses?  
dropvisout=0;
keepvisin=1;
dropaudout=0;
keepaudin=0;

%% Open some data, filter it and shape it for clustering
startdir=cd;
cd ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition')
uiopen
cd (startdir)

%%% Select Data
all_resp=nan(length(id_mt_data.resp_cell), size(id_mt_data.resp_cell{1},1), size(id_mt_data.resp_cell{1},2));

[chans, reps, ~]=size (all_resp);
% NOTE: conditions Vout and Ain+Vin give good separation just for testing out my algorithms
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

id_mt_labels(groups)

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
    
    fprintf ('\n%.0f of %.0f Channels Used\n',sum(responders), length(responders))
    all_resp=all_resp(responders,:,:);
end

%%% Shape
all_resp=all_resp(:,:)'; %data x chan(condition unwrapped with reps to make data)

%%% Normalize
all_resp_zscore=(all_resp-ones(size(all_resp,1),1)*mean(all_resp)) ./ ( ones(size(all_resp,1),1)*std(all_resp) );

%% Perform a PCA on the data
[coeff, score, latent]=pca (all_resp);
linecolors=linspecer(length(groups));
figure
title ('Different Stim Conditions in PCA Space')
hold on
for i=1:length(groups)
    range=(i-1)*reps+1:i*reps;
    if size(score,2)>2
        scatter3(score(range,1),score(range,2),score(range,3),'MarkerEdgeColor',linecolors(i,:)) %normal 3d scatter
    elseif size(score,2)==2        
        scatter(score(range,1),score(range,2),'MarkerEdgeColor',linecolors(i,:)) %normal 3d scatter
    else 
        error ('Less than 2 responsive channels')
    end
%     scatter3sph(score(range,1),score(range,2),score(range,3),'Color',linecolors(i,:),'transp',.3,'size',.3) %transparent plot    
end
legend (id_mt_labels{groups});
hold off

%% K-means Clustering
num_groups=length(groups);
kindx=kmeans(score,num_clusts);
kindx_mat=reshape(kindx,[reps,num_groups]);
countmat=nan(num_clusts,num_groups);
for i=1:num_clusts
    countmat(i,:)=sum(kindx_mat==i);
end
countmat
figure
title ('Kmeans Clustering Assignments displayed in PCA space')
hold on
linecolors=linspecer(num_clusts);
for i=1:num_clusts
    range=kindx==i;
    if size (score,2)>2
        scatter3(score(range,1),score(range,2),score(range,3),'MarkerEdgeColor',linecolors(i,:))
    else
        scatter(score(range,1),score(range,2),'MarkerEdgeColor',linecolors(i,:)) %normal 3d scatter
    end
end


%% Hierarchical Cluster on zscore
num_groups=length(groups);
T=clusterdata(score,num_clusts);
T_mat=reshape(T,[reps,num_groups]);
countmat=nan(num_clusts,num_groups);
figure
title ('Hierarchical Cluster Assignments Displayed in PCA Space')
hold on
linecolors=linspecer(num_clusts);
for i=1:num_clusts
    range=T==i;
    if size (score,2)>2
        scatter3(score(range,1),score(range,2),score(range,3),'MarkerEdgeColor',linecolors(i,:))
    else
        scatter(score(range,1),score(range,2),'MarkerEdgeColor',linecolors(i,:)) 
    end
    countmat(i,:)=sum(T_mat==i);
end
countmat

 
