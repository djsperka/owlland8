function MNLR_Classifer ()
% function to take in my multi-trace data and run it through a multinomial
% logistic regression classifer 

%% Set controls
groups=[1 2 3 4 5 6]; %choose which conditions to look at
respORpost=1; %1=resp, 2=post
resp_sort=0; %sort based on responses?  
dropvisout=1;
keepvisin=1;
dropaudout=0;
keepaudin=0;

num_resamp=10; %number of times to resample the data for mnlr testing
test_proportion=.2; %proportion of the data used for the test set

num_shuffles=10; %number of times to shuffle trials to disrupt correlations

%% Open some data, filter it and shape it for clustering
startdir=cd;
cd ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition')
uiopen
cd (startdir)

fprintf('\n~~~ Running Multinomial Logistic Classification on data from %s - %s ~~~\n',site_date,site_id)

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

%%% make a list of categories
group_mat=nan(size(all_resp,1),1);
trial_mat=nan(size(all_resp,1),1);
for i=1:length(groups)
    range=(i-1)*reps+1:i*reps;
    group_mat(range)=ones(reps,1)*groups(i);
    trial_mat(range)=1:reps;
end
    
%%% Resample and Test Classification
test_size=ceil(reps * (test_proportion));
train_size=reps-test_size;

fprintf ('\nCategorizing groups:')
fprintf('\n%s',id_mt_labels{groups})
fprintf('\n\nTraining on %.0f%% of data ... %.0f/%.0f samples\n',100*train_size/reps, train_size,reps)

num_right=nan(num_resamp,1); %for tracking classification accuracy
% h=figure;
for i=1:num_resamp
    %%% Resmple
    train_data=datasample([1:reps],train_size,'Replace',false);
    train_indx=ismember(trial_mat,train_data);
    test_data=1:reps;
    test_data(train_data)=[];
    test_indx=ismember(trial_mat,test_data);
    
    %%% Perform Classification
    B = mnrfit (all_resp (train_indx,:),group_mat(train_indx));
    pihat=mnrval(B,all_resp(test_indx,:));
    [prob,indx]=max(pihat');
    num_right(i)=sum(indx==group_mat(test_indx)');
      
    win_assign=indx'==1 | indx'==2 | indx'==6;
    actual_win=group_mat(test_indx)==1 | group_mat(test_indx)==2 | group_mat(test_indx)==6 ;
    
    winwin=logical(win_assign.*actual_win); %actual=win, assigned = win
    winlose=logical(~win_assign.*actual_win); %actual=win, assigned=lose
    losewin=logical(win_assign.*~actual_win); %actual=lose, assigned=win
    loselose=logical(~win_assign.*~actual_win); %actual=lose, assigned=lose
    
% [coeff, score, latent]=pca (all_resp(test_indx,:));
% 
% figure (h)
% hold on
% scatter3(score(winwin,1),score(winwin,2),score(winwin,3),'bo')
% scatter3(score(winlose,1),score(winlose,2),score(winlose,3),'bx')
% scatter3(score(losewin,1),score(losewin,2),score(losewin,3),'rx')
% scatter3(score(loselose,1),score(loselose,2),score(loselose,3),'ro')
% hold off
%     
    %     sum(reshape(indx==group_mat(test_indx)',10,4));
    for j=1:length(groups)
        assign_table(j,:,i)=sum(reshape(indx==groups(j),test_size,length(groups)));
    end
end

percent_right=100*num_right/sum(test_indx);
fprintf('\nAvg success rate %.2f%% w/ std of %.2f%%.  Chance=%.2f%%\n',mean(percent_right),std(percent_right),100/length(groups))

%%% Print performance for each group
id_mt_labels{5}='lose';
id_mt_labels{6}='win ';
average_assign=mean(assign_table,3);
fprintf('\n\n------Average Assignments----------\n\t\t')
fprintf('%s\t',id_mt_labels{groups})
for i=1:length(groups)
    fprintf('\n%s',id_mt_labels{groups(i)})
    fprintf('\t%.1f',average_assign(i,:))
end
fprintf('\n\nColumn = Actual class, Row = assigned class\n')

% %%% Shuffle and re-test Classification
% shuffled_percents=nan(num_resamp,num_shuffles);
% for j=1:num_shuffles
%     
%     shuffled=Shuffle_Trials(all_resp);
%     
%     num_right=nan(num_resamp,1); %for tracking classification accuracy
%     for i=1:num_resamp
%         %%% Resmple
%         train_data=datasample([1:reps],train_size,'Replace',false);
%         train_indx=ismember(trial_mat,train_data);
%         test_data=1:reps;
%         test_data(train_data)=[];
%         test_indx=ismember(trial_mat,test_data);
%         
%         %%% Perform Classification
%         B = mnrfit (all_resp (train_indx,:),group_mat(train_indx));
%         pihat=mnrval(B,all_resp(test_indx,:));
%         [prob,indx]=max(pihat');
%         num_right(i)=sum(indx==group_mat(test_indx)');
%         
%     end
%     
%     shuffled_percents(:,j)=100*num_right/sum(test_indx);
%     
% end
% shuffled_percents=shuffled_percents(:);
% 
% fprintf('\nShuffled success rate %.2f%% w/ std of %.2f%%.  Chance=%.2f%%\n',mean(shuffled_percents),std(shuffled_percents),100/length(groups))

%% Figue out how well we seperate "win" from "lose"
if length(groups)==6
    
    win=[1 1 0 0 0 1];
    lose=double(~win);
    winwin=win'*win .* average_assign; %was win, guessed win
    loselose=lose'*lose .* average_assign; %was lose, guessed lose
    winlose=lose'*win .* average_assign; %was win, guessed lose
    losewin=win'*lose .* average_assign; %was lose, guessed win
    
    fprintf('\n\nWas win, guessed win: %.1f/30', sum(sum(winwin)))
    fprintf('\nWas win, guessed lose: %.1f/30', sum(sum(winlose)))
    fprintf('\nWas lose, guessed win: %.1f/30', sum(sum(losewin)))
    fprintf('\nWas lose, guessed lose: %.1f/30\n\n', sum(sum(loselose)))
    
    fprintf('\n%.2f\t%.2f\t%.2f\t%.2f\n',sum(sum(winwin)),sum(sum(winlose)),sum(sum(losewin)),sum(sum(loselose)))
    
    keyboard
    
end

% %%% Normalize ... do I do this before fitting my data??
% %%% After playing with this, z-scoring does not seem to effect my MNLR
% all_resp_zscore=(all_resp-ones(size(all_resp,1),1)*mean(all_resp)) ./ ( ones(size(all_resp,1),1)*std(all_resp) );
% 
% B = mnrfit (all_resp_zscore,group_mat);
% pihat=mnrval(B,all_resp_zscore);
% [prob,indx]=max(pihat');
% fprintf('\n\nSuccessfully categorized %.0f / %.0f using z-scored data\n',sum(indx==group_mat'),length(indx))