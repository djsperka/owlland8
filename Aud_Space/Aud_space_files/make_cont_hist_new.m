function make_cont_hist_new(visdiv,ITDdiv)
    global cont rec;
    spike_hist_vis=zeros(cont.reps,60*cont.time+1);
    vis_mat=spike_hist_vis;
    dir_mat=vis_mat;
    
    for i=[1:cont.reps]
        spike_hist_vis(i,:)=histc(cont.spike_times{i}/1000,[0:1/60:cont.time]);
    end
    for i=[1:cont.reps]
        vis_mat(i,:)=cont.vis_pos_array{i}(1,:);
        dir_mat(i,:)=[diff(cont.vis_pos_array{i}(1,:)),0];
    end
    
    sum(sum(spike_hist_vis))
    
    vis_mat=round((vis_mat-cont.az_min)/(cont.az_max-cont.az_min)*visdiv+1);
    [rep_p,time_p]=ind2sub(size(spike_hist_vis),find(spike_hist_vis));
    vis_hist_l=zeros(cont.reps,visdiv+1);
    vis_hist_r=zeros(cont.reps,visdiv+1);
	for i=[1:length(rep_p)]
        vis_loc=vis_mat(rep_p(i),time_p(i));
        if dir_mat(rep_p(i),time_p(i))>0
            vis_hist_r(rep_p(i),vis_loc)=vis_hist_r(rep_p(i),vis_loc)+spike_hist_vis(rep_p(i),time_p(i));
          else
            vis_hist_l(rep_p(i),vis_loc)=vis_hist_l(rep_p(i),vis_loc)+spike_hist_vis(rep_p(i),time_p(i));
        end
	end
        sum(sum([vis_hist_r,vis_hist_l]))

    vis_hist_r=vis_hist_r(:,1:visdiv)
    vis_hist_l=vis_hist_l(:,1:visdiv)
    figure;
    plot(sum(vis_hist_r),'r')
    set(gca,'nextplot','add')
    
    plot(sum(vis_hist_l))
%     plot(mean(sum(vis_hist_r),sum(vis_hist_l)),'k')
    
    
    
    sum(sum([vis_hist_r,vis_hist_l]))
    
    
    
    
    
return;