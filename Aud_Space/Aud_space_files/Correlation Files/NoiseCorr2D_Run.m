function NoiseCorr2D_Run (spikes,corrtype, pre_post_type)
global  chan_select save_corr data_save fig_hands ALL_fig_hands suppress_figs first_pass_stat first_pass_loom
global pre_cell_stat pre_cell_loom post_cell_stat post_cell_loom %
global snd
chan_choices=find(chan_select==1);

%% Build pre, post, and response matrices, and the z-score matrix
pair_count=(length(chan_choices)*(length(chan_choices)-1))/2; %number of comparisons
%Blank cell arrays
resp_cell={};
zscore_cell_1D={};
zscore_cell_2D={};

fprintf('\nBuilding arrays for a 2D correlation. This could take a minute...\n');
%NOTE if this is really taking too long, could accelerate by calculating
%pre and post just for 
for chan=chan_choices
    tic
    if (strcmp(corrtype,'stat') && first_pass_stat) || (strcmp(corrtype,'loom') && first_pass_loom)
        %IF its the first time with either static or looming data,
        %calculate the respective pre and post cells
        if strcmp(corrtype,'stat')
            [post_cell_stat{chan},pre_cell_stat{chan}]=PreNPost_NoiseCorr(spikes,chan);

        else
            [post_cell_loom{chan},pre_cell_loom{chan}]=PreNPost_NoiseCorr(spikes,chan);

        end
        

    %%%% Combined into seperate function for readibility 
%     for i=1:length(spikes.Var1array)
%         var1=spikes.Var1array(i);
%         for j=1:length(spikes.Var2array)
%             var2=spikes.Var2array(j);
%             for rep=1:spikes.reps
%                 find_post= spikes.dataVar1==var1 & spikes.dataVar2==var2 & spikes.datachan==chan & spikes.datarep==rep & spikes.datatime>0 & spikes.datatime<spikes.post;
%                 find_pre= spikes.dataVar1==var1 & spikes.dataVar2==var2 & spikes.datachan==chan & spikes.datarep==rep & spikes.datatime<0 & spikes.datatime>(spikes.pre*(-1));
%                 if strcmp(corrtype,'stat')
%                     post_cell_stat{chan}(rep,i,j)=sum(find_post);
%                     pre_cell_stat {chan}(rep,i,j)=sum(find_pre);
%                     if sum(isnan(post_cell_stat{chan}))
%                         keyboard
%                     elseif sum(isnan(pre_cell_stat{chan}))
%                         keyboard
%                     end
%                 else
%                     post_cell_loom{chan}(rep,i,j)=sum(find_post);
%                     pre_cell_loom {chan}(rep,i,j)=sum(find_pre);
%                     if sum(isnan(post_cell_loom{chan}))
%                         keyboard
%                     elseif sum(isnan(pre_cell_loom{chan}))
%                         keyboard
%                     end
%                 end
%                 
%             end
%         end
%     end
    end
    
    %Select the appropriate pre and post cells
    if strcmp(corrtype,'stat')
        pre_cell=pre_cell_stat;
        post_cell=post_cell_stat;
    else
        pre_cell=pre_cell_loom;
        post_cell=post_cell_loom;
    end
    
    %Calculate the appropriate response cell, depending on whether pre,
    %post or adjusted responses are being correlated
    if pre_post_type==1;
        %Subtract duration-corrected pre from post
        resp_cell{chan}=post_cell{chan}-pre_cell{chan}*spikes.post/spikes.pre;
    elseif pre_post_type==2
        %Just use the pre_cell
        resp_cell{chan}=pre_cell{chan}; 
        
    elseif pre_post_type==3
        %Just use the post_cell
        resp_cell{chan}=post_cell{chan};
    else
        fprintf('\nPre_post_type value is not 1, 2 or 3.  Ya fucked up. \n')
        keyboard
    end
       
    %Calculate the mean response for each variable
    channel_means=mean(resp_cell{chan}); 
    %Subtract the mean
    mean_subtract=resp_cell{chan}-channel_means(ones(size(resp_cell{chan},1),1),:,:);
    %Calculate the response standard deviation for each variable
    channel_std=std(resp_cell{chan});
    %Divide by the standard deviation
    zscore_cell_2D{chan}=mean_subtract./(channel_std(ones(size(mean_subtract,1),1),:,:));
    %Collapse across dimensions to make this 1D
    zscore_cell_1D{chan}=zscore_cell_2D{chan}(:); 
    fprintf(strcat('\nChan',num2str(chan),' took :',num2str(toc),' to complete.\n'))  
        
end

if strcmp(corrtype,'stat')
    first_pass_stat=0;
else
    first_pass_loom=0;
end

clear i
clear j

%% Calculate Correlation!

%Initiate variables for storing correlation data
my_screen=get(0,'ScreenSize');
num_chan=length(chan_select);
potential_pairs=num_chan*(num_chan-1)/2;
store_pairs=NaN(potential_pairs,2);
store_r=NaN(potential_pairs,1);
store_p=NaN(potential_pairs,1);
    
%Initiate figure handles
if spikes.inter_loom
    if strcmp(corrtype,'stat')
    fig_hands=NaN(potential_pairs,2);
    end
else
    fig_hands=NaN(potential_pairs,1);
end

%Set strings for title
if pre_post_type==1
    pp_title=' Adjusted ';
elseif pre_post_type==2
    pp_title=' Pre Only ';
else 
    pp_title='Post Only ';
end
if strcmp(corrtype,'stat');
    dynam_title=' Static ';
else
    dynam_title=' Looming ';
end

counter=0;
for j=1:length(chan_choices); %for each channel
    chan1=chan_choices(j);
    for k=j+1:length(chan_choices); %for all channels this hasn't been paired with yet
        %% Build inputs
        chan2=chan_choices(k);
        counter=counter+1;
        store_position=potential_pairs- ( (num_chan-chan1) * (num_chan-chan1-1)/2) -(num_chan-chan2);
        %(num_chan-chan1)*(num_chan-chan1-1)/2) = number of pairs left once
        %channel 1 is complete
        %num_chan - chan2) = number pairs left to complete filling out
        %channel 1 pairs
        store_pairs(store_position,:)=[chan1,chan2];
        
        x=zscore_cell_1D{chan1};
        a=zscore_cell_2D{chan1};
        y=zscore_cell_1D{chan2};
        b=zscore_cell_2D{chan2};
        nantag=find(isnan(x) | isnan(y));
        x(nantag)=[];
        y(nantag)=[];
        
        %% Compute position-specific correlations
        h=CorrMap(a,b,chan1,chan2,resp_cell);
        if strcmp(corrtype,'loom')
            dynam_name='_loom';
            dynam_title=' Loom';
        else
            dynam_name='_stat';
            dynam_title=' Stat';
        end
        chan_tit=strcat('Chan',num2str(chan1),'xChan',num2str(chan2),dynam_title);
        chan_name=strcat('Chan',num2str(chan1),'xChan',num2str(chan2),dynam_name);
        title (strcat('Noise Corr Map : ',chan_tit))
        print(h,'-djpeg',chan_name)
        close
        
        %% Compute full field correlations
        [r,p]=corr(x,y);   
        store_r(store_position)=r;
        store_p(store_position)=p;
        
        %% Plot Correlations        
        if ~suppress_figs %if you didn't choose to have figures suppressed
        ho_split=length(chan_choices)*(length(chan_choices)-1)/2;
        p1=(counter-1)*my_screen(3)/ho_split; %Save room for correlograms!
        if strcmp(corrtype,'loom');
            p2=0; % Put it at the bottom
        else
        p2=(my_screen(4)/2); %Put it Halfway up
        end
        p3=my_screen(3)/ho_split;
        p4=my_screen(4)/2-85;
        if strcmp(corrtype,'stat')
            fig_hands(counter,1)=figure ('position', [p1 p2 p3 p4]);
        else
            fig_hands(counter,2)=figure ('position', [p1 p2 p3 p4]);
        end
        
        scatter (x,y);
        set (gcf,'menubar','default');
        hold on        
      
        %
        fit_line=polyfit(x,y,1);
        fit_handle=plot ([-3 3],([-3,3]*fit_line(1)+fit_line(2)),':g','LineWidth',4);
        legend (fit_handle,strcat('slope=',num2str(fit_line(1),2),'  r= ',num2str(r,3),' p= ',num2str(p,3)));
        %
        
        vertline=[min(min(y))-.25,max(max(y))+.25];
        plot ([0 0],vertline,'--k')
        horizline=[min(min(x))-.25,max(max(x))+.25];
        plot (horizline,[0 0],'--k')
        xlabel(strcat('Ch ', num2str(chan1), ' trial standard scores') );
        ylabel(strcat('Ch ', num2str(chan2), ' trial standard scores'));
        set(get(gca,'xlabel'),'fontsize',12);
        set(get(gca,'ylabel'),'fontsize',12);
        set (gca, 'xlim',horizline);
        set (gca, 'ylim',vertline);

        title([dynam_title ' ' pp_title ' Noise Corr Trial by Trial Scatter:   Trace= ' num2str(spikes.trace) '        channels= ' num2str(chan1) ' and ' num2str(chan2)]);

        hold off     
        end %if ~suppress_figs
    end 
    
end

ALL_fig_hands=[ALL_fig_hands,fig_hands];

%% Build structure that will be saved
if save_corr
    if pre_post_type==1
        pp_name='';
    elseif pre_post_type==2
        pp_name='_pre';
    elseif pre_post_type==3
        pp_name='_post';
    end
    if strcmp(corrtype,'loom')
        dynam_name='_loom';
    else
        dynam_name='';
        data_save.data_chans=store_pairs;
    end
    
    if snd.Var1>7 %if this was a visual stim
    eval(strcat('data_save.data_NCr_vis',pp_name,dynam_name,'=store_r;'));
    eval(strcat('data_save.data_NCp_vis',pp_name,dynam_name,'=store_p;'));
    else %this was auditory
    eval(strcat('data_save.data_NCr_aud',pp_name,dynam_name,'=store_r;'));
    eval(strcat('data_save.data_NCp_aud',pp_name,dynam_name,'=store_p;'));
    end
    
end