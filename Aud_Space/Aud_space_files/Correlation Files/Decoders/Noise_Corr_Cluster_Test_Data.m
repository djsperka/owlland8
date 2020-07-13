function Noise_Corr_Cluster_Test_Data
% This script is designed to make some artificial data to test different
% approaches of cluster analysis on

%imagine 100 observations of 5 conditions along 10 dimensions)
obs=100;
cond=5;
dim=11;
data=rand(dim,obs,cond);
counter=0;
for i=1:cond
    counter=counter+1;
    data(:,:,i)=data(:,:,i)+counter;    
end
data=data(:,:)';
data_zscore=(data-ones(size(data,1),1)*mean(data)) ./ (ones(size(data,1),1)*std(data));
linecolors=linspecer(cond);
figure
hold on
for i=1:cond
    range=(i-1)*obs+1:i*obs;
    plot (data_zscore(range,1),data_zscore(range,2),'o','MarkerEdgeColor',linecolors(i,:))
end
hold off

%% Cluster test data

%%% Hierarchical ... hunting for cutoff
% Hmmmm ... even for my artificial data that is clearly clustered into 5
% groups, trying to use the generic clusterdata function with a cutoff
% seems to be extremely sensitive, to the point where I don't know what I
% would have to set the threshold to define 5 clusters.  
for i=1.154:.0001:1.155

    T=clusterdata(data_zscore,i);
    fprintf ('\nThreshold = %.4f  Clusters = %.0f', i,length(unique(T)))
end

thresh=1.154;
T=clusterdata(data_zscore,thresh);
    fprintf ('\nThreshold = %.4f  Clusters = %.0f', thresh,length(unique(T)))
clust_cnt=length(unique(T));
linecolors=linspecer(clust_cnt);
figure
hold on
for i=1:clust_cnt
    range=T==i;
    plot (data_zscore(range,1),data_zscore(range,2),'o','MarkerEdgeColor',linecolors(i,:))
end
hold off

%%% Hierarchical using predefined number of clusters
clust_cnt=5;
% T=clusterdata(data_zscore,clust_cnt); %made errors 0 out of 10 times
T=clusterdata(data,clust_cnt); %made errors 0 out of 10 times
linecolors=linspecer(clust_cnt);
figure
hold on
for i=1:clust_cnt
    range=T==i;
    plot (data_zscore(range,1),data_zscore(range,2),'o','MarkerEdgeColor',linecolors(i,:))
end
hold off

%%% Hierachical manually, so you can see the dendrogram
Y=pdist(data_zscore,'euclid');
Z=linkage(Y,'single');
figure
dendrogram(Z,0);
data_ass_col=ones(obs,1)*(1:cond);
data_ass=data_ass_col(:);

%%% Kmeans clustering
clust_cnt=5;
% kindx=kmeans(data_zscore,clust_cnt); %3 out of 10 had a single error
kindx=kmeans(data,clust_cnt); %7 out of 10 had a single error
linecolors=linspecer(clust_cnt);
% figure %Show histogram
% hist(kindx);
figure
hold on
for i=1:clust_cnt
    range=kindx==i;
    plot (data_zscore(range,1),data_zscore(range,2),'o','MarkerEdgeColor',linecolors(i,:))
end
hold off


%% PCA on test data
[coeff, score, latent]=pca (data); %score gives you the scores in PCA space, latent gives the eigenvectors for each column
figure
plot (score(:,1),score(:,2),'o')


