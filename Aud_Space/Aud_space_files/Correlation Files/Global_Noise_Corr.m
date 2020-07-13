function [pop_explained_var,pop_corrs]=Global_Noise_Corr(site_data,unit_tagger,handles)
%responses needs to include every response from each trial, each neuron and
%each conditions
%calculate each neuron's correlation with the measured "global noise"
%start by calculating each neurons noise
%then for each neuron, average every other neurons noise, and optimize it
%with respect to alpha

do_me=find(unit_tagger==1);
%covnert data cells to matrices
for i=1:length(do_me);
    
    unit=do_me(i);
    post_mat(:,:,i)=site_data.id_mt_data.post_cell{unit};
    pre_mat(:,:,i)=site_data.id_mt_data.pre_cell{unit};
    
end

switch get(handles.glob_corr_type,'Value')
    case 1
        resp_mat=post_mat-pre_mat;
    case 2
        resp_mat=post_mat;        
    case 3
        resp_mat=pre_mat;        
end

[nR,nC,nU]=size(resp_mat); %number or reps, conditions and units
signal_mat=mean(resp_mat,1); %average responses for each unit in each condition

noise_mat=resp_mat-repmat(signal_mat,[nR,1,1]); %nR x nC x nU

%% Carandini Method

%initialize population vectors
pop_alphas=nan(nU,nC);
pop_residuals=nan(nU,nC);
pop_explained_var=nan(nU,nC);
loc_glob_corr=nan(nU,nC);

for i=1:nU %for each unit
    unit=i;
    other_units=~(1:nU==unit);
    glob_noise=mean(noise_mat(:,:,other_units),3); %nR x nC x 1
    
    for j=1:nC %for each stimulus class
        class=j;
        
        response=signal_mat(1,class,unit); %this units average response to this stim
        measured=resp_mat(:,class,unit); %trial-by-trial responses to this stim
        
        %minimize the mean squared error for including the global noise in
        %the model
        mse=@(alpha) mean( (response+alpha*glob_noise(:,class)-measured).^2 );
        unit_alpha=fminsearch(mse,1);
        unit_residual=mse(unit_alpha);
        
        %find the difference between the measured responses and those
        %predicted w/ global noise included in the model. Use this to
        %estimate "explained variance"
        local_noise=response+unit_alpha*glob_noise(:,class)-measured;
        unit_explained_var=1-var(local_noise)/var(resp_mat(:,class,unit));
        
        %this will see if there is any remaining correlation between global
        %noise and local noise.  There shouldn't be
        loc_glob_corr(i,j)=corr(local_noise,glob_noise(:,class));
        
        %save the data into population vectors
        pop_alphas(i,j)=unit_alpha;
        pop_residuals(i,j)=unit_residual;
        pop_explained_var(i,j)=unit_explained_var;
    end
end

%% My method ... just do a pearsons correlation on each unit w/ global noise
tiler=[nR,1,1]; %used w/ repmat
unit_zscores= (resp_mat - repmat(signal_mat,tiler) ) ./ repmat(std(resp_mat,1),tiler);
pop_corrs=nan(nU,nC);
for i=1:nU
    unit=i;
    other_units=~(1:nU==unit);
    global_sum=nansum(unit_zscores(:,:,other_units),3); %note: tried z-scoring the global-sum before correlating ... didn't make a difference
    unit_corr=diag(corr(unit_zscores(:,:,unit),global_sum));
    pop_corrs(i,:)=unit_corr;
end

%% Plot these two metrics against eachother
compare_metrics=0;
if compare_metrics
plotme=~isnan(pop_corrs);
figure
plot (pop_explained_var(plotme).^.5,pop_corrs(plotme),'o');
xlabel('Carandini "Explained Variance" (var^.^5)')
ylabel ('My Global Pearson''s r')

pause
close
end



 
