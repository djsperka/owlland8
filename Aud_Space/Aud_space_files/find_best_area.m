function find_best_area()
    global snd rec;
    figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
    snd.ba_cutoff=str2num(get(findobj(gcf,'tag','ba_cutoff'),'string'));  %%  get the cutoff level
    snd.ba_cutoff=max(snd.ba_cutoff,0);
    snd.ba_cutoff=min(snd.ba_cutoff,100);
    set(findobj(gcf,'tag','ba_cutoff'),'string',snd.ba_cutoff);
    %%clear all of the labels    
    set(findobj(gcf,'tag','Var1_ba_label'),'string','');
    set(findobj(gcf,'tag','Var2_ba_label'),'string','');
    set(findobj(gcf,'tag','Var1_alone_ba_label'),'string','');
    set(findobj(gcf,'tag','Var2_alone_ba_label'),'string','');

    
    
    set_graphs(snd.reps)        %%  clear the graphs of previous best area plots.
    
    %%create the display graphs
    if snd.graph_type==1    %%display type is adjusted
        dispmat=(snd.datamat_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.datamat_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
    end
    if snd.graph_type==2    %%display type is pre
        dispmat=snd.datamat_pre(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and devide by reps
    end
    if snd.graph_type==3    %%display type is post or normal// both should be normalized the same
        dispmat=snd.datamat_post(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and devide by reps
    end
    if snd.graph_type==4    %%display type is post or normal// both should be normalized the same
        dispmat=snd.datamat_post(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and devide by reps
        dispmat=100*((dispmat-min(min(dispmat)))/(max(max(dispmat))-min(min(dispmat))));
    end
    if snd.interleave_alone==1
        if snd.graph_type==1    %%display type is adjusted
            disparr1=(snd.data_arr1_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.data_arr1_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
            disparr2=(snd.data_arr2_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.data_arr2_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
        end
        if snd.graph_type==2    %%display type is pre
                disparr1=snd.data_arr1_pre(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and divide by reps
                disparr2=snd.data_arr2_pre(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and divide by reps
        end
        if snd.graph_type>=3    %%display type is post or normal// both should be normalized the same
            disparr1=snd.data_arr1_post(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and divide by reps
            disparr2=snd.data_arr2_post(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and divide by reps
        end
    end
       
    tempmat=100*((dispmat-min(min(dispmat)))/(max(max(dispmat))-min(min(dispmat))));
    [var2_rf_pts,var1_rf_pts]=find(tempmat>=snd.ba_cutoff);
    
    %%get the spike counts for each point
    for i=[1:length(var2_rf_pts)];
        spike_counts(i)=tempmat(var2_rf_pts(i),var1_rf_pts(i));
    end;
    
    
    snd.var1_ba=sum(immultiply(snd.Var1array(var1_rf_pts),spike_counts)/sum(spike_counts));
    snd.var2_ba=sum(immultiply(snd.Var2array(var2_rf_pts),spike_counts)/sum(spike_counts));
    
    
    if or(snd.interleave_alone==0,min(size(dispmat))>1)
        if length(snd.Var2array)>1 & snd.Var2~=7
            snd.ba_handle(2)=line(snd.var1_ba,snd.var2_ba,'linestyle','none','color',[0,0,0],'marker','+');
          else
            snd.ba_handle(2)=line([snd.var1_ba,snd.var1_ba],get(gca,'ylim'),'linestyle',':','color',[0,0,0],'marker','+');
        end
        set(gca,'nextplot','replace');
        
        
            %%plot the points that are involved in the average
    figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
    set(gca,'nextplot','add');
    if length(snd.Var2array)>1 & snd.Var2~=7
        snd.ba_handle(1)=line(snd.Var1array(var1_rf_pts),snd.Var2array(var2_rf_pts),'linestyle','none','color',[0,0,0],'marker','.');
      else
        snd.ba_handle(1)=bar(snd.Var1array(var1_rf_pts),transpose(dispmat(1,var1_rf_pts)),'-.r');
    end

        %%  print the best area
        
        figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
           
        if length(snd.Var2array)>1 & snd.Var2~=7
            set(findobj(gcf,'tag','var1_ba'),'string',num2str(round(snd.var1_ba*10)/10));
            set(findobj(gcf,'tag','var2_ba'),'string',num2str(round(snd.var2_ba*10)/10));
            set(findobj(gcf,'tag','Var1_ba_label'),'string',snd.Var1_choices(snd.Var1));
            set(findobj(gcf,'tag','Var2_ba_label'),'string',snd.Var2_choices(snd.Var2));
          else
            set(findobj(gcf,'tag','var1_ba'),'string',num2str(round(snd.var1_ba*10)/10));
            set(findobj(gcf,'tag','Var1_ba_label'),'string',snd.Var1_choices(snd.Var1));
        end
    end
    
   
    if snd.interleave_alone==1
        
        %%%find Var1 alone
        tempmat=100*((disparr1(1,:)-min(min(disparr1)))/(max(max(disparr1))-min(min(disparr1))));
        var1_rf_pts=find(tempmat>=snd.ba_cutoff);
        snd.var1_inter_ba=sum(immultiply(snd.Var1array(var1_rf_pts),tempmat(var1_rf_pts))/sum(tempmat(var1_rf_pts)));
        
        %%%find Var2 alone
        tempmat=100*((disparr2(:,1)-min(min(disparr2)))/(max(max(disparr2))-min(min(disparr2))));
        var2_rf_pts=find(tempmat>=snd.ba_cutoff);
        snd.var2_inter_ba=sum(immultiply(transpose(snd.Var2array(var2_rf_pts)),tempmat(var2_rf_pts))/sum(tempmat(var2_rf_pts)));
        
        
        figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
        
        
        
        
        if size(dispmat,2)>1        
            set(findobj(gcf,'tag','var1_ba'),'string',num2str(round(snd.var1_ba*10)/10));
            set(findobj(gcf,'tag','var1_alone_ba'),'string',num2str(round(snd.var1_inter_ba*10)/10));
            set(findobj(gcf,'tag','Var1_ba_label'),'string',snd.Var1_choices(snd.Var1));
            set(findobj(gcf,'tag','Var1_alone_ba_label'),'string',snd.Var1_choices(snd.Var1));
        end
        
        if size(dispmat,1)>1
            set(findobj(gcf,'tag','var2_ba'),'string',num2str(round(snd.var2_ba*10)/10));
            set(findobj(gcf,'tag','var2_alone_ba'),'string',num2str(round(snd.var2_inter_ba*10)/10));
            set(findobj(gcf,'tag','Var2_ba_label'),'string',snd.Var2_choices(snd.Var2));
            set(findobj(gcf,'tag','Var2_alone_ba_label'),'string',snd.Var2_choices(snd.Var2));
        end   
      
        
    end
return;