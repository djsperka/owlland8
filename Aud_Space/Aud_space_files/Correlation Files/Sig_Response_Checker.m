function sig_flag=Sig_Response_Checker
global chan_select snd
% Function to detect if there are significant responses within the sampled
% field. 
% For each channel, samples all pre-response periods to build a "baseline"
% sample.  Compares baseline to response for each stimulus location, with
% [# repetitions] samples from each location.  Uses the non-parametric
% test for comparing two independent samples, the Wilcoxin Rank Sum test,
% (equivalent to the Mann-Whitney U Test)

sig_flag=NaN(size(chan_select));
chan_choices=find(chan_select==1);
spikes=snd;
siglev=.05; %set the p-value that qualifies significance

sigmat=NaN(length(spikes.Var1array),length(spikes.Var2array),length(chan_select));
% normmat_post=zeros(size(sigmat)); %matrix for testing normalcy in the post period
% normmat_pre=NaN(size(chan_select)); %matrix for testing normalcy in the pre period
tic
for chan=chan_choices
    %%%%%%% BUILD SAMPLE POPULATIONS
    postmat=NaN(length(spikes.Var1array),length(spikes.Var2array),spikes.reps);
    premat=NaN(length(spikes.Var1array)*length(spikes.Var2array)*spikes.reps,1);

    for i=1:length(spikes.Var1array)
        var1=spikes.Var1array(i);
        for j=1:length(spikes.Var2array)
            var2=spikes.Var2array(j);
            for rep=1:spikes.reps
            
                find_post= find (spikes.dataVar1==var1 & spikes.dataVar2==var2 & spikes.datachan==chan & spikes.datarep==rep & spikes.datatime>0 & spikes.datatime<spikes.post);
                postmat(i,j,rep)=length(find_post);
                find_pre= find(spikes.dataVar1==var1 & spikes.dataVar2==var2 & spikes.datachan==chan & spikes.datarep==rep & spikes.datatime<0 & spikes.datatime>(spikes.pre*(-1)));
                premat(rep + (j-1)*spikes.reps + (i-1)*length(spikes.Var2array)*spikes.reps)=length(find_pre);
                
            end
       
        end
    end
    
    %%%%%%% CALCULATE SIGNIFICANT DIFFERENCES
    premat=premat*(spikes.post/spikes.pre); %Correct for differences in pre and post time
%     normmat_pre(chan)=jbtest(premat);
    for i=1:length(spikes.Var1array)
        for j=1:length(spikes.Var2array)
%             normmat_post(i,j,chan)=jbtest(squeeze(postmat(i,j,:)));
            [p,sigmat(i,j,chan)]=ranksum(squeeze(postmat(i,j,:)),premat,'Tail','right','Alpha',siglev); %test for significance
%             sigmat(i,j,chan)=ttest2(squeeze(postmat(i,j,:)),premat,'Vartype','unequal','Tail','right','Alpha',siglev);
        end
    end
    
    if max(max(sigmat(:,:,chan)))>0 %if there was a significant response
        sig_flag(chan)=1;
    else
        sig_flag(chan)=0;
    end
     
    fprintf (strcat('\nChannel :',num2str(chan),' completed\n'))
    toc
%     sigmat(:,:,chan)=ttest2(postmat,premat,'Dim',3,'Vartype','unequal','Tail','right','Alpha',siglev);
    
end



''