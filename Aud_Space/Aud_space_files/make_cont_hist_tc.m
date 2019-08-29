function make_cont_hist_tc(cont,visdiv,ITDdiv,pretime)

    final_vis_time=cont.time;
    if length(cont.vis_pos_array(1,:))~=length([0:1/60:cont.time])
        finaltime=cont.time-(1/60);
    end
    
    
    vis_x_pos=interp1([0:1/60:finaltime],cont.vis_pos_array(1,:),[0:(1/500):cont.time]);
    vis_x=zeros(1,10*cont.time+1);
    
    %% make 10 hz bins
    for i=[0:10*cont.time]
          vis_x(i+1)=mean(vis_x_pos(1+i*10:11+i*10));  
    end
    
    spike_hist=hist(cont.spike_times/1000,[0:(1/10):cont.time]);
    vis_p=floor((vis_x-cont.az_min)/(cont.az_max-cont.az_min)*visdiv)+2;

    
    
    
    resp_mat=zeros(visdiv+2,pretime+1);
    time_mat=zeros(visdiv+2,pretime+1);
    
    
    for i=(pretime+1):length(spike_hist)   
    for j=[-pretime:0]
        cur_place=i+j;
        resp_mat(vis_p(cur_place),j+pretime+1)=resp_mat(vis_p(cur_place),j+pretime+1)+spike_hist(i);
    end
    end
    figure
    resp_mat=resp_mat(2:visdiv+1,:);
        contourf(resp_mat,100)
            h=get(gca,'children');
            set(h,'linestyle','none');
    
% % %     vis_dir=diff(vis_x_pos);
% % % 	vis_dir(find(vis_dir>0))=1;
% % %     vis_dir(find(vis_dir<0))=-1;
% % %     vis_dir(length(vis_x_pos))=0;
% % %     
% % % 	spike_hist=hist(cont.spike_times/1000,[0:(1/500):cont.time]);
% % % 	
% % % 	visstep=(cont.az_max-cont.az_min)/visdiv;
% % % 	ITDstep=(cont.ITD_max-cont.ITD_min)/ITDdiv;
% % % 
% % %     resp_hist_left=zeros(visdiv+2,(pretime+posttime+1));     %%mat is slightly bigger for edge effects
% % % 	resp_hist_right=zeros(visdiv+2,(pretime+posttime+1));     %%mat is slightly bigger for edge effects
% % % 	resp_time_left=zeros(visdiv+2,(pretime+posttime+1));     %%mat is slightly bigger for edge effects
% % % 	resp_time_right=zeros(visdiv+2,(pretime+posttime+1));     %%mat is slightly bigger for edge effects
% % % 	
% % % 	vis_p=floor((vis_x_pos-cont.az_min)/(cont.az_max-cont.az_min)*visdiv)+2;
% % % % 	ITD_p=floor((cont.ITD_pos-cont.ITD_min)/(cont.ITD_max-cont.ITD_min)*ITDdiv)+2;
% % % 
% % %     
% % %     for i=[(pretime+1):min([length(vis_x_pos),length(cont.ITD_pos),length(spike_hist),length(vis_dir)])-posttime]
% % %     for j=[-pretime:posttime]
% % %         if vis_dir(i+j)==1
% % %                 resp_hist_right(vis_p(i+j),j+pretime+1)=resp_hist_right(vis_p(i+j),j+pretime+1)+spike_hist(i+j);
% % %                 resp_time_right(vis_p(i+j),j+pretime+1)=resp_time_right(vis_p(i+j),j+pretime+1)+(1/500);
% % %             end
% % %             if vis_dir(i+j)==-1
% % %                 resp_hist_left(vis_p(i+j),j+pretime+1)=resp_hist_left(vis_p(i+j),j+pretime+1)+spike_hist(i+j);
% % %                 resp_time_left(vis_p(i+j),j+pretime+1)=resp_time_left(vis_p(i+j),j+pretime+1)+(1/500);
% % %         end
% % %     end
% % %     end
% % %     resp_hist_r=resp_hist_right(2:visdiv+1,:);
% % %     resp_hist_l=resp_hist_left(2:visdiv+1,:);
% % %     resp_time_r=resp_time_right(2:visdiv+1,:);
% % %     resp_time_l=resp_time_left(2:visdiv+1,:);
% % %     
% % %     
% % %     
% % % % %     figure      %%vis plot
% % % % % 	plot([cont.az_min+(0.5*visstep):visstep:cont.az_max-(0.5*visstep)],sum(resp_hist_l')./sum(resp_time_l'))
% % % % %     set(gca,'nextplot','add')
% % % % % 	plot([cont.az_min+(0.5*visstep):visstep:cont.az_max-(0.5*visstep)],sum(resp_hist_r')./sum(resp_time_r'),'r')
% % % % % 	plot([cont.az_min+(0.5*visstep):visstep:cont.az_max-(0.5*visstep)],sum(resp_hist_r'+resp_hist_l')./sum(resp_time_r'+resp_time_l'),'k')
% % % % %     ylabel('Spikes/Second');
% % % % %     xlabel('Visual Azimuth (deg)');
% % % % %     set(gca,'xlim',[cont.az_min,cont.az_max])
% % % % %     set(gca,'xtick',round([cont.az_min:visstep:cont.az_max]))
% % % % %     set(get(gca,'children'),'linewidth',3)
% % % % %     
% % % % %     figure      %%ITD plot
% % % % % 	plot([cont.ITD_min+(0.5*ITDstep):ITDstep:cont.ITD_max-(0.5*ITDstep)],sum(resp_hist_l)./sum(resp_time_l))
% % % % %     set(gca,'nextplot','add')
% % % % % 	plot([cont.ITD_min+(0.5*ITDstep):ITDstep:cont.ITD_max-(0.5*ITDstep)],sum(resp_hist_r)./sum(resp_time_r),'r')
% % % % % 	plot([cont.ITD_min+(0.5*ITDstep):ITDstep:cont.ITD_max-(0.5*ITDstep)],sum(resp_hist_r+resp_hist_l)./sum(resp_time_r+resp_time_l),'k')
% % % % %     ylabel('Spikes/Second');
% % % % %     xlabel('ITD (micro sec)');
% % % % %     set(gca,'xlim',[cont.ITD_min,cont.ITD_max])
% % % % %     set(gca,'xtick',round([cont.ITD_min:ITDstep:cont.ITD_max]))
% % % % %     set(get(gca,'children'),'linewidth',3)
% % % 
% % %  figure
% % %  
% % % %  size(resp_hist_r)
% % % %  size(resp_time_r)
% % % %  size(resp_hist_l)
% % % %  size(resp_time_l)
% % % %  size([-pretime:posttime]/500)
% % % %  size([cont.az_min+(0.5*visstep):visstep:cont.az_max-(0.5*visstep)])
% % %  
% % %  contourf([-pretime:posttime]/500,[cont.az_min+(0.5*visstep):visstep:cont.az_max-(0.5*visstep)],resp_hist_r./resp_time_r,100)
% % %               colorbar;       %%show a reference bar for the contour plot
% % %             h=get(gca,'children');
% % %             set(h,'linestyle','none');
% % %  figure
% % %  contourf([-pretime:posttime]/500,[cont.az_min+(0.5*visstep):visstep:cont.az_max-(0.5*visstep)],resp_hist_l./resp_time_l,100)
% % %               colorbar;       %%show a reference bar for the contour plot
% % %             h=get(gca,'children');
% % %             set(h,'linestyle','none');
% % %   
% % %     
return;