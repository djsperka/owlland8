function make_cont_hist_flat(visdiv,ITDdiv,hist_type)
    global cont rec;
    %% make a contour plot showing the response at various combinations of
    %% auditory and visual locations.
    %%hist_type,  1=aud, 2=vis, 3=both
    
    
    %%%There is a divide by zero error in this.  All of the zero time
    %%%entries have been bumped up.
    
    
    %%plotting defaults
    snip_res=0.3;   %%resolution in seconds of snip traces
    
    
    
    
    figure(findobj(0,'tag','set_cont_win'));     %% set the third window as active
    
    if nargin==0
        visdiv=str2num(get(findobj(gcf,'tag','visdiv'),'string'));
        ITDdiv=str2num(get(findobj(gcf,'tag','ITDdiv'),'string'));
        hist_type=get(findobj(gcf,'tag','hist_type'), 'value');
    end
    
    
    
    
    
    
    
    myscreen=get(0,'screensize');
    c_yellow=[.95, .95, .7];
    c_green=[.5,.58,.5]; 
    c_red=[.7 .4 .4];
    c_line=[.3 .3 .3];
    c_load=[0.526,0.552,0.552];

    
    histmat=zeros(visdiv+1,ITDdiv+1,cont.reps,4);   %%make a matrix for visloc, ITDloc, rep, and direction(1:4)ll,rl,lr,rr
    histime=zeros(visdiv+1,ITDdiv+1,cont.reps,4);   %%make a matrix for visloc, ITDloc, rep, and direction(1:4)ll,rl,lr,rr
    
    
    vis_list=zeros(cont.reps,60*cont.time+1);
    spike_list=zeros(cont.reps,60*cont.time+1);
    ITD_list=zeros(cont.reps,60*cont.time+1);

    vis_dir_list=zeros(cont.reps,60*cont.time);
    ITD_dir_list=zeros(cont.reps,60*cont.time);

    
    for i=[1:cont.reps]
        vis_list(i,:)=cont.vis_pos_array{i}(1,:);%%order vis into a matrix
        spike_list(i,:)=histc(cont.spike_times{i}/1000,[0:1/60:cont.time]);%%resample spikes at vis rate and form matrix
        spike_list_disp(i,:)=histc(cont.spike_times{i}/1000,[0:0.1:cont.time]);%%resample spikes at vis rate and form matrix
        
        ITD_list(i,:)=interp1([0:1/500:cont.time], cont.ITD_pos{i},[0:1/60:cont.time], 'linear' );%%resample ITD at vis rate and form matrix
        
        vis_dir_list(i,:)=diff(cont.vis_pos_array{i}(1,:));%%order vis direction into a matrix
        ITD_dir_list(i,:)=diff(interp1([0:1/500:cont.time], cont.ITD_pos{i},[0:1/60:cont.time], 'linear' )); %%ITD direction
    end
    
    
            vis_list_disp=vis_list;
            ITD_list_disp=ITD_list;

    
    
    %%divide ITD and vis Direction into right and left
    visleft=find(vis_dir_list<0);
    ITDleft=find(ITD_dir_list<0);
    vis_dir_list=ones(size(vis_dir_list));
    ITD_dir_list=ones(size(ITD_dir_list))*3;
    vis_dir_list(visleft)=0;
    ITD_dir_list(ITDleft)=1;

    
    dir_p=vis_dir_list+ITD_dir_list;%%this pointer is 1 for vlal, 2 for vral,3 for vlar,4 for vrar,
    
    vis_list=floor((vis_list-cont.az_min)/(cont.az_max-cont.az_min)*visdiv)+1;
    ITD_list=floor((ITD_list-cont.ITD_min)/(cont.ITD_max-cont.ITD_min)*ITDdiv)+1;
    
    for i=[1:size(vis_list,1)]
        for j=[1:size(vis_list,2)-1]
            histmat(vis_list(i,j),ITD_list(i,j),i,dir_p(i,j))=histmat(vis_list(i,j),ITD_list(i,j),i,dir_p(i,j))+spike_list(i,j);
            histime(vis_list(i,j),ITD_list(i,j),i,dir_p(i,j))=histime(vis_list(i,j),ITD_list(i,j),i,dir_p(i,j))+(1/60);
        end
    end
    
    histmat=histmat(1:visdiv,1:ITDdiv,:,:);
    histime=histime(1:visdiv,1:ITDdiv,:,:);
    
    cont.histmat=histmat;
    cont.histime=histime;
    
  
    if findobj(0,'tag','cont_disp_1')>=1
        figure(findobj(0,'tag','cont_disp_1'));     %% set the first window as active
    else    %%open a new window
        figure('position',[myscreen(3)/3+4,myscreen(4)/2+34,2*myscreen(3)/3-8,myscreen(4)/2-68],'color', c_yellow,'tag','cont_disp_1');
    end
    clf;
    if findobj(0,'tag','cont_disp_2')>=1
        figure(findobj(0,'tag','cont_disp_2'));     %% set the first window as active
      else    %%open a new window
        figure('position',[myscreen(3)/3+4,34,2*myscreen(3)/3-8,myscreen(4)/2-68],'color', c_yellow,'tag','cont_disp_2');
    end
    clf;    
    if hist_type==3
            %%%make contour for all direction combinations
            alldir_hist=squeeze(sum(histmat,4));
            alldir_time=squeeze(sum(histime,4));
            %%%open a figure
            az_step=(cont.az_max-cont.az_min)/visdiv;
            ITD_step=(cont.ITD_max-cont.ITD_min)/ITDdiv;
            az_array=[cont.az_min+(0.5*az_step):az_step:cont.az_max-(0.5*az_step)];
            ITD_array=[cont.ITD_min+(0.5*ITD_step):ITD_step:cont.ITD_max-(0.5*ITD_step)];
            figure(findobj(0,'tag','cont_disp_1'));     %% set the first window as active
            set(gca,'nextplot','replace')
            contourf(ITD_array,az_array,sum(alldir_hist,3)./sum(alldir_time,3),100);       %%show contour plot of one Channel
            colorbar;       %%show a reference bar for the contour plot
            h=get(gca,'children');
            set(h,'linestyle','none');
            xlabel('ITD');
            ylabel('Azimuth');
            set(get(gca,'xlabel'),'fontsize',14);
            set(get(gca,'ylabel'),'fontsize',14);
		
            %%%make contour for left ITD left vis direction combinations
            for i=[1:4]
                hist=squeeze(histmat(:,:,:,i));
                time=squeeze(histime(:,:,:,i));
                az_step=(cont.az_max-cont.az_min)/visdiv;
                ITD_step=(cont.ITD_max-cont.ITD_min)/ITDdiv;
                az_array=[cont.az_min+(0.5*az_step):az_step:cont.az_max-(0.5*az_step)];
                ITD_array=[cont.ITD_min+(0.5*ITD_step):ITD_step:cont.ITD_max-(0.5*ITD_step)];
                figure(findobj(0,'tag','cont_disp_2'));     %% set the first window as active
                subplot(2,2,i)
                set(gca,'nextplot','replace')
                contourf(ITD_array,az_array,sum(hist,3)./sum(time,3),100);       %%show contour plot of one Channel
                colorbar;       %%show a reference bar for the contour plot
                h=get(gca,'children');
                set(h,'linestyle','none');
                visdir_title='left';
                ITDdir_title='left';
                if mod(i,2)==0;
                    visdir_title='right';
                end
                if i>2;
                    ITDdir_title='right';
                end
                xlabel(['ITD ',ITDdir_title]);
                ylabel(['vis ',visdir_title]);
                set(get(gca,'xlabel'),'fontsize',12);
                set(get(gca,'ylabel'),'fontsize',12);
            end
        end    

        if hist_type==1
            allhist=squeeze(sum(squeeze(sum(squeeze(sum(histmat,4)),3)),1));    %%flatten data except for ITD info
            alltime=squeeze(sum(squeeze(sum(squeeze(sum(histime,4)),3)),1));
            dispall=allhist./alltime;
            
            rhist=squeeze(sum(squeeze(sum(squeeze(sum(histmat(:,:,:,3:4),4)),3)),1));    %%grab all ITD moving to right
            rtime=squeeze(sum(squeeze(sum(squeeze(sum(histime(:,:,:,3:4),4)),3)),1));
            dispr=rhist./rtime;
            
            lhist=squeeze(sum(squeeze(sum(squeeze(sum(histmat(:,:,:,1:2),4)),3)),1));    %%grab all ITD moving to the left
            ltime=squeeze(sum(squeeze(sum(squeeze(sum(histime(:,:,:,1:2),4)),3)),1));
            displ=lhist./ltime;

            figure(findobj(0,'tag','cont_disp_1'));     %% set the first window as active
            set(gca,'nextplot','replace')
            ITD_step=(cont.ITD_max-cont.ITD_min)/ITDdiv;
            ITD_array=[cont.ITD_min+(0.5*ITD_step):ITD_step:cont.ITD_max-(0.5*ITD_step)];
            
            
                        %%fit gauss curves
            [beta,r,J] =nlinfit(ITD_array,(dispall-min(dispall))/(max(dispall)-min(dispall)),@gauss,[mean(ITD_array) 10]);
            [betar,r,J] =nlinfit(ITD_array,(dispr-min(dispr))/(max(dispr)-min(dispr)),@gauss,[mean(ITD_array) 10]);
            [betal,r,J] =nlinfit(ITD_array,(displ-min(displ))/(max(displ)-min(displ)),@gauss,[mean(ITD_array) 10]);
            ITD_array_int=[min(ITD_array):.25:max(ITD_array)];
            plot(ITD_array,dispall,'k','Linewidth',3)
            set(gca,'nextplot','add')
            plot(ITD_array,dispr,'r','Linewidth',2)
            plot(ITD_array,displ,'b','Linewidth',2)
            
            figure(findobj(0,'tag','set_cont_win'));
            if get(findobj(gcf,'tag','show_g_fit'),'value')
                figure(findobj(0,'tag','cont_disp_1'));
			    plot(ITD_array_int,gauss(beta,ITD_array_int)*(max(dispall)-min(dispall))+min(dispall), 'k','Linewidth',1);
			    plot(ITD_array_int,gauss(betar,ITD_array_int)*(max(dispr)-min(dispr))+min(dispr), 'r','Linewidth',1);
			    plot(ITD_array_int,gauss(betal,ITD_array_int)*(max(displ)-min(displ))+min(displ), 'b','Linewidth',1);
            end
            
            if get(findobj(gcf,'tag','show_win_2'),'value')
	        
                %%time course for the second window
                
                figure(findobj(0,'tag','cont_disp_2'));
                clf
                

                
                
                %%make and plot snips
                sweeptimes=zeros(1,1+cont.noise_hz);
                dir=ITD_dir_list(1,1);
                sweeps=2;
                
                for j=[1:size(ITD_dir_list,2)]
                    if dir~=ITD_dir_list(1,j)
                        sweeptimes(sweeps)=j/60;
                        sweeps=sweeps+1;
                        dir=ITD_dir_list(1,j);
                    end
                end
                sweeptimes(sweeps)=size(ITD_dir_list,2)/60;
                snip1={};
                snip2={};
                num1=1;
                num2=1;
                for i=[1:cont.reps]
                    for j=[2:length(sweeptimes)]
                        if ~mod(j,2)
                            snip1{num1}=histc(cont.spike_times{i}/1000,[sweeptimes(j-1):0.1:sweeptimes(j)]);
                            num1=num1+1;
                          else
                            snip2{num2}=histc(cont.spike_times{i}/1000,[sweeptimes(j-1):0.1:sweeptimes(j)]);
                            num2=num2+1;
                        end
                    end    
                end
                
                maxsweep=max([length(snip1),length(snip2)]);
                
                
                ha1=axes('units','normalized','position', [.05,.4,.4,.4],'nextplot','replacechildren');
                set(gca,'nextplot','add')
                for i=[1:length(snip1)]
                    plot([1:length(snip1{i})]/10,snip1{i},'k','linewidth',1,'color',[i/maxsweep,0,1-i/maxsweep])
                end
                set(gca,'xlimmode','manual','xlim',[0,cont.time/cont.noise_hz]);

                if length(snip2)            
                    ha2=axes('units','normalized','position', [.55,.4,.4,.4],'nextplot','replacechildren');
                    set(gca,'nextplot','add')
                    for i=[1:length(snip2)]
                        plot([1:length(snip2{i})]/10,snip2{i},'k','linewidth',1,'color',[i/maxsweep,0,1-i/maxsweep])
                    end
                    set(gca,'xlimmode','manual','xlim',[0,cont.time/cont.noise_hz]);
                end
                
                ha3=axes('units','normalized','position', [.05,.1,.9,.2],'nextplot','replacechildren');
                plot([0:0.1:cont.time], sum(spike_list_disp,1),'k','linewidth',0.05)
                set(gca,'XTickLabelMode','manual','XTickLabel','');
                set(gca,'xlimmode','manual','xlim',[0,cont.time]);
                set(gca,'ylimmode','manual','ylim',[0,max(sum(spike_list_disp,1))]);
                set(gca,'YTickLabelMode','manual','YTickLabel','');
	
                ha4=axes('units','normalized','position', [.05,.05,.9,.05],'nextplot','replacechildren');
                plot([0:1/60:cont.time], mean(ITD_list_disp,1),'r')
                set(gca,'xlimmode','manual','xlim',[0,cont.time]);
                set(gca,'ylimmode','manual','ylim',[cont.ITD_min,cont.ITD_max]);
                set(gca,'YTickLabelMode','manual','YTickLabel','');
%                 set(gca,'nextplot','add')
%                 plot(sweeptimes,ones(size(sweeptimes))*mean([cont.ITD_min,cont.ITD_max]),'*')
                
            end        
            
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        if hist_type==2
            %%(v,a,r,d)
            allhist=squeeze(sum(squeeze(sum(squeeze(sum(histmat,4)),3)),2));    %%flatten data except for vis info
            alltime=squeeze(sum(squeeze(sum(squeeze(sum(histime,4)),3)),2));
            dispall=allhist./alltime;
            
            
            rhist=squeeze(sum(squeeze(sum(squeeze(sum(histmat(:,:,:,3:4),4)),3)),2));    %%grab all vis moving to right
            rtime=squeeze(sum(squeeze(sum(squeeze(sum(histime(:,:,:,3:4),4)),3)),2));
            dispr=rhist./rtime;
            
            lhist=squeeze(sum(squeeze(sum(squeeze(sum(histmat(:,:,:,1:2),4)),3)),2));    %%grab all vis moving to the left
            ltime=squeeze(sum(squeeze(sum(squeeze(sum(histime(:,:,:,1:2),4)),3)),2));
            displ=lhist./ltime;
            
                figure(findobj(0,'tag','cont_disp_1'));     %% set the first window as active
            
            set(gca,'nextplot','replace')
            az_step=(cont.az_max-cont.az_min)/visdiv;
            az_array=[cont.az_min+(0.5*az_step):az_step:cont.az_max-(0.5*az_step)];
            
            
            
            %%fit gauss curves
            [beta,r,J] =nlinfit(az_array,(dispall-min(dispall))/(max(dispall)-min(dispall)),@gauss,[round(mean(az_array)) 4]);
            [betar,r,J] =nlinfit(az_array,(dispr-min(dispr))/(max(dispr)-min(dispr)),@gauss,[round(mean(az_array)) 4]);
            [betal,r,J] =nlinfit(az_array,(displ-min(displ))/(max(displ)-min(displ)),@gauss,[round(mean(az_array)) 4]);
            az_array_int=[min(az_array):.25:max(az_array)];
            plot(az_array,dispall,'k','Linewidth',3)
            set(gca,'nextplot','add')
            plot(az_array,dispr,'r','Linewidth',2)
            plot(az_array,displ,'b','Linewidth',2)
            
            figure(findobj(0,'tag','set_cont_win'));
            if get(findobj(gcf,'tag','show_g_fit'),'value')
                figure(findobj(0,'tag','cont_disp_1'));
                plot(az_array_int,gauss(beta,az_array_int)*(max(dispall)-min(dispall))+min(dispall), 'k','Linewidth',1);
			    plot(az_array_int,gauss(betar,az_array_int)*(max(dispr)-min(dispr))+min(dispr), 'r','Linewidth',1);
			    plot(az_array_int,gauss(betal,az_array_int)*(max(displ)-min(displ))+min(displ), 'b','Linewidth',1);
            end 
            
            
            

            
            %%%%%%%%%%%%%%%%%%%%%%%%%
            if get(findobj(gcf,'tag','show_win_2'),'value')
	
                figure(findobj(0,'tag','cont_disp_2'));
                clf
                
                %%make and plot snips
                sweeptimes=zeros(1,1+cont.noise_hz);
                dir=vis_dir_list(1,1);
                sweeps=2;
                
                for j=[1:size(vis_dir_list,2)]
                    if dir~=vis_dir_list(1,j)
                        sweeptimes(sweeps)=j/60;
                        sweeps=sweeps+1;
                        dir=vis_dir_list(1,j);
                    end
                end
                sweeptimes(sweeps)=size(vis_dir_list,2)/60;
                snip1={};
                snip2={};
                num1=1;
                num2=1;
                for i=[1:cont.reps]
                    for j=[2:length(sweeptimes)]
                        if ~mod(j,2)
                            snip1{num1}=histc(cont.spike_times{i}/1000,[sweeptimes(j-1):0.1:sweeptimes(j)]);
                            num1=num1+1;
                          else
                            snip2{num2}=histc(cont.spike_times{i}/1000,[sweeptimes(j-1):0.1:sweeptimes(j)]);
                            num2=num2+1;
                        end
                    end    
                end
                
                maxsweep=max([length(snip1),length(snip2)]);
                
                
                
                ha1=axes('units','normalized','position', [.05,.4,.4,.4],'nextplot','replacechildren');
                set(gca,'nextplot','add')
                for i=[1:length(snip1)]
                    plot([1:length(snip1{i})]/10,snip1{i},'k','linewidth',1,'color',[i/maxsweep,0,1-i/maxsweep])
                end
                set(gca,'xlimmode','manual','xlim',[0,cont.time/cont.noise_hz]);

                if length(snip2)            
                    ha2=axes('units','normalized','position', [.55,.4,.4,.4],'nextplot','replacechildren');
                    set(gca,'nextplot','add')
                    for i=[1:length(snip2)]
                        plot([1:length(snip2{i})]/10,snip2{i},'k','linewidth',1,'color',[i/maxsweep,0,1-i/maxsweep])
                    end
                    set(gca,'xlimmode','manual','xlim',[0,cont.time/cont.noise_hz]);
                end
                                
                ha3=axes('units','normalized','position', [.05,.1,.9,.2],'nextplot','replacechildren');
                plot([0:0.1:cont.time], sum(spike_list_disp,1),'k','linewidth',0.05)
                set(gca,'XTickLabelMode','manual','XTickLabel','');
                set(gca,'xlimmode','manual','xlim',[0,cont.time]);
                set(gca,'ylimmode','manual','ylim',[0,max(sum(spike_list_disp,1))]);
                set(gca,'YTickLabelMode','manual','YTickLabel','');

                ha4=axes('units','normalized','position', [.05,.05,.9,.05],'nextplot','replacechildren');
                plot([0:1/60:cont.time], mean(vis_list_disp,1),'r')
                set(gca,'xlimmode','manual','xlim',[0,cont.time]);
                set(gca,'ylimmode','manual','ylim',[cont.az_min,cont.az_max]);
                set(gca,'YTickLabelMode','manual','YTickLabel','');
                
            end
        end
        
            figure(findobj(0,'tag','cont_disp_1'));
    figure(findobj(0,'tag','set_cont_win'));     %% set the third window as active
            
return;