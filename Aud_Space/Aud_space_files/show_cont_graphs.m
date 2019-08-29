function show_cont_graphs(visdiv,ITDdiv,hist_type)
    global cont rec;
    %%%figure out how to deal with the plotting of flat dist!
    
    
    
    display_chan=get(findobj(gcf,'tag','display_chan'),'value');   %%change in the end when things are ready for multiple channels
    
    %%  get the needed plotting parameters
    figure(findobj(0,'tag','cont_disp_1'));     %% set the first window as active
    clf
    figure(findobj(0,'tag','cont_disp_2'));     %% set the first window as active
    clf
    figure(findobj(0,'tag','set_cont_win'));     %% set the third window as active
    if nargin==0
        visdiv=str2num(get(findobj(gcf,'tag','visdiv'),'string'));
        ITDdiv=str2num(get(findobj(gcf,'tag','ITDdiv'),'string'));
        hist_type=get(findobj(gcf,'tag','hist_type'), 'value');
        show_error=get(findobj(gcf,'tag','show_error'), 'value');
    end
    g_fit=get(findobj(gcf,'tag','show_g_fit'),'value');
    show_win_2=get(findobj(gcf,'tag','show_win_2'),'value');
    show_graphs=get(findobj(gcf,'tag','show_graphs'),'value');
    ITD_step=(cont.ITD_max-cont.ITD_min)/ITDdiv;
    ITD_array=[cont.ITD_min+(0.5*ITD_step):ITD_step:cont.ITD_max-(0.5*ITD_step)];
    az_step=(cont.az_max-cont.az_min)/visdiv;
    az_array=[cont.az_min+(0.5*az_step):az_step:cont.az_max-(0.5*az_step)];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    make_cont_mat(visdiv,ITDdiv,1)  %%make data matrix for chan 1

    
    %%here it would be good to make the VS_strength stuff
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    if show_graphs      %%if graphs should be plotted
        if cont.motion_type==2  %%triangular
            figure(findobj(0,'tag','cont_disp_1'));     %% set the first window as active
            set(gca,'nextplot','add')
            if hist_type<3
                if hist_type==1
                    %%(chan,Sweep,visdiv,ITDdiv,visdir,ITDdir)
                    if sum(sum(sum(sum(sum(sum(cont.histtime,6),5),4),3),2),1)
                        adisp=squeeze(sum(sum(sum(sum(sum(cont.histmat,6),5),3),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime,6),5),3),2),1));
                      else
                        adisp=squeeze(sum(sum(sum(sum(sum(cont.histmat,6),5),3),2),1));
                    end
                    if sum(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,:,1),6),5),4),3),2),1)
                        ldisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,:,1),6),5),3),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,:,1),6),5),3),2),1));
                      else
                        ldisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,:,1),6),5),3),2),1));
                    end
                    if sum(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,:,2),6),5),4),3),2),1)
                        rdisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,:,2),6),5),3),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,:,2),6),5),3),2),1));
                      else
                        rdisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,:,2),6),5),3),2),1));
                    end
%                     rdisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,:,2),6),5),3),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,:,2),6),5),3),2),1));
                    xarray=ITD_array+cont.ITD_offset;
                    xstep=ITD_step;
                                  
                  else  %%hist_type==2
                    if sum(sum(sum(sum(sum(sum(cont.histtime,6),5),4),3),2),1)
                        adisp=squeeze(sum(sum(sum(sum(sum(cont.histmat,6),5),4),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime,6),5),4),2),1));
                      else
                        adisp=squeeze(sum(sum(sum(sum(sum(cont.histmat,6),5),4),2),1));
                    end
                    if sum(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,1,:),6),5),4),3),2),1)
                        ldisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,1,:),6),5),4),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,1,:),6),5),4),2),1));
                      else
                        ldisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,1,:),6),5),4),2),1));
                    end
                    if sum(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,2,:),6),5),4),3),2),1)
                        rdisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,2,:),6),5),4),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,2,:),6),5),4),2),1));
                      else
                        rdisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,2,:),6),5),4),2),1));
                    end
                      
%                     ldisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,:,1),6),5),4),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,:,1),6),5),4),2),1));
%                     rdisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,:,2),6),5),4),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,:,2),6),5),4),2),1));
                    xarray=az_array;
                    xstep=az_step;
                end
	
                if g_fit
                    %%calculate the fit
                    [beta,r,J] =nlinfit(xarray,(adisp-min(adisp))/(max(adisp)-min(adisp)),@gauss,[round(mean(xarray)),round((max(xarray)-min(xarray))/4)]);
                    [betal,r,J] =nlinfit(xarray,(ldisp-min(ldisp))/(max(ldisp)-min(ldisp)),@gauss,[round(mean(xarray)),round((max(xarray)-min(xarray))/4)]);
                    [betar,r,J] =nlinfit(xarray,(rdisp-min(rdisp))/(max(rdisp)-min(rdisp)),@gauss,[round(mean(xarray)),round((max(xarray)-min(xarray))/4)]);
                    
                    %%plot the fit at high resolution
                    xarray_int=[min(xarray):.1*xstep:max(xarray)];
                    plot(xarray_int,gauss(beta,xarray_int)*(max(adisp)-min(adisp))+min(adisp), 'k','Linewidth',1);
                    plot(xarray_int,gauss(betal,xarray_int)*(max(ldisp)-min(ldisp))+min(ldisp), 'b','Linewidth',1);
                    plot(xarray_int,gauss(betar,xarray_int)*(max(rdisp)-min(rdisp))+min(rdisp), 'r','Linewidth',1);
                end %%end the g_fit loop
            
                %%make sweeps
                max_sweep=size(cont.histmat,2);
                sweepl_ind=0;  %%index for sweeps
                sweepr_ind=0;
                sweepa_ind=0;
		
                lsweeps=zeros(max_sweep,length(xarray));    %%spikes for each sweep
                rsweeps=zeros(max_sweep,length(xarray));
                asweeps=zeros(max_sweep,length(xarray));
                
                lsweeps_time=zeros(max_sweep,length(xarray));   %%times for each sweep
                rsweeps_time=zeros(max_sweep,length(xarray));
                asweeps_time=zeros(max_sweep,length(xarray));
		
                if hist_type==1 %%Aud snips
                    for i=[1:max_sweep]
                        if max(max(squeeze(sum(sum(sum(sum(sum(cont.histmat(1,i,:,:,:,1),6),5),3),2),1))))
                            sweepl_ind=sweepl_ind+1;
                            lsweeps(sweepl_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histmat(1,i,:,:,:,1),6),5),3),2),1)));
                            lsweeps_time(sweepl_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histtime(1,i,:,:,:,1),6),5),3),2),1)));
                            sweepa_ind=sweepa_ind+1;
                            asweeps(sweepa_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histmat(1,i,:,:,:,:),6),5),3),2),1)));
                            asweeps_time(sweepa_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histtime(1,i,:,:,:,:),6),5),3),2),1)));
                        end
                        if max(max(squeeze(sum(sum(sum(sum(sum(cont.histmat(1,i,:,:,:,2),6),5),3),2),1))))
                            sweepr_ind=sweepr_ind+1;
                            rsweeps(sweepr_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histmat(1,i,:,:,:,2),6),5),3),2),1)));
                            rsweeps_time(sweepr_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histtime(1,i,:,:,:,2),6),5),3),2),1)));
                            sweepa_ind=sweepa_ind+1;
                            asweeps(sweepa_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histmat(1,i,:,:,:,:),6),5),3),2),1)));
                            asweeps_time(sweepa_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histtime(1,i,:,:,:,:),6),5),3),2),1)));
                        end
                    end
                  else %%vis snips
                    for i=[1:max_sweep]
                        if max(max(squeeze(sum(sum(sum(sum(sum(cont.histmat(1,i,:,:,:,1),6),5),4),2),1))))
                            sweepl_ind=sweepl_ind+1;
                            lsweeps(sweepl_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histmat(1,i,:,:,:,1),6),5),4),2),1)));
                            lsweeps_time(sweepl_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histtime(1,i,:,:,:,1),6),5),4),2),1)));
                            sweepa_ind=sweepa_ind+1;
                            asweeps(sweepa_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histmat(1,i,:,:,:,:),6),5),4),2),1)));
                            asweeps_time(sweepa_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histtime(1,i,:,:,:,:),6),5),4),2),1)));
                        end
                        if max(max(squeeze(sum(sum(sum(sum(sum(cont.histmat(1,i,:,:,:,2),6),5),4),2),1))))
                            sweepr_ind=sweepr_ind+1;
                            rsweeps(sweepr_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histmat(1,i,:,:,:,2),6),5),4),2),1)));
                            rsweeps_time(sweepr_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histtime(1,i,:,:,:,2),6),5),4),2),1)));
                            sweepa_ind=sweepa_ind+1;
                            asweeps(sweepa_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histmat(1,i,:,:,:,:),6),5),4),2),1)));
                            asweeps_time(sweepa_ind,:)=transpose(squeeze(sum(sum(sum(sum(sum(cont.histtime(1,i,:,:,:,:),6),5),4),2),1)));
                        end
                        
                    end
                end         %%end sweep making
	
                %%eliminate unfilled matrix entries                
                asweeps=asweeps(1:sweepa_ind,:);
                lsweeps=lsweeps(1:sweepl_ind,:);
                rsweeps=rsweeps(1:sweepr_ind,:);
                asweeps_time=asweeps_time(1:sweepa_ind,:);
                lsweeps_time=lsweeps_time(1:sweepl_ind,:);
                rsweeps_time=rsweeps_time(1:sweepr_ind,:);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                if show_error
                    if sum(asweeps_time)
                        h=errorbar(xarray,mean(asweeps./asweeps_time),std(asweeps./asweeps_time)/sqrt(sweepa_ind),std(asweeps./asweeps_time)/sqrt(sweepa_ind),'k');   
                        set(h(2),'LineWidth',3)
                    end
                    if sum(lsweeps_time)
                        h=errorbar(xarray,mean(lsweeps./lsweeps_time),std(lsweeps./lsweeps_time)/sqrt(sweepl_ind),std(lsweeps./lsweeps_time)/sqrt(sweepl_ind),'b');   
                        set(h(2),'LineWidth',3)
                    end
                    if sum(rsweeps_time)
                        h=errorbar(xarray,mean(rsweeps./rsweeps_time),std(rsweeps./rsweeps_time)/sqrt(sweepr_ind),std(rsweeps./rsweeps_time)/sqrt(sweepr_ind),'r');   
                        set(h(2),'LineWidth',3)
                    end
                  else
                    if sum(asweeps_time)
                         plot(xarray,adisp,'k','LineWidth',3)   
                    end
                    if sum(lsweeps_time)
                         plot(xarray,ldisp,'b','LineWidth',3)   
                    end
                    if sum(rsweeps_time)
                         plot(xarray,rdisp,'r','LineWidth',3)
                    end

                end
                
                if show_win_2   %%summary in the second window
                    figure(findobj(0,'tag','cont_disp_2'));
                        
                    for i=[1,cont.reps]
                        subplot(2,cont.reps,i*2)
                        plot([0:(0.5):cont.time],histc(cont.spike_times{i}.chan{display_chan}/1000,[0:0.5:cont.time]),'k')
                        ylims=get(gca,'ylim');
                        set(gca,'nextplot','add')
                        plot([0:(1/60):cont.time],(cont.vis_pos_array{i}(1,:)-min(cont.vis_pos_array{i}(1,:)))/(max(cont.vis_pos_array{i}(1,:))-min(cont.vis_pos_array{i}(1,:)))*ylims(2),'r')
                        plot([0:(0.5):cont.time],histc(cont.spike_times{i}.chan{display_chan}/1000,[0:0.5:cont.time]),'k')
                        
                    end
	
                    
                    if sweepa_ind>0
	
                        haa=axes('units','normalized','position', [.1,.1,.4,.8],'nextplot','replacechildren');
                        set(gca,'nextplot','add')
      
                        
                        waterfall(xarray,[1:sweepa_ind],asweeps./asweeps_time)
                        set(haa,'CameraPositionMode','Manual','CameraPosition',[-200 -280 655])
                        set(gca,'xlimmode','manual','xlim',[min(xarray),max(xarray)])
                        set(gca,'ylimmode','manual','ylim',[1,sweepa_ind])
                        set(gca,'zlimmode','manual','zlim',[0,max(max(asweeps./asweeps_time))])
                    end
                    
                    
                        
                end %%end the show_win_2
            end     %%end the hist_type<3
            if hist_type==3
                'NOT YET READY'    
                
            end
        else
            
            
            
            
            
            if or(cont.motion_type==1,cont.motion_type==3)
                figure(findobj(0,'tag','cont_disp_1'));     %% set the first window as active
                set(gca,'nextplot','add')

                if hist_type<3
                    if hist_type==1
                        %%(chan,Sweep,visdiv,ITDdiv,visdir,ITDdir)
                        adisp=squeeze(sum(sum(sum(sum(sum(cont.histmat,6),5),3),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime,6),5),3),2),1));
                        ldisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,:,1),6),5),3),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,:,1),6),5),3),2),1));
                        rdisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,:,2),6),5),3),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,:,2),6),5),3),2),1));
                        xarray=ITD_array+cont.ITD_offset;
                        xstep=ITD_step;
                      else  %%hist_type==2
                        adisp=squeeze(sum(sum(sum(sum(sum(cont.histmat,6),5),4),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime,6),5),4),2),1));
                        ldisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,:,1),6),5),4),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,:,1),6),5),4),2),1));
                        rdisp=squeeze(sum(sum(sum(sum(sum(cont.histmat(:,:,:,:,:,2),6),5),4),2),1))./squeeze(sum(sum(sum(sum(sum(cont.histtime(:,:,:,:,:,2),6),5),4),2),1));
                        xarray=az_array;
                        xstep=az_step;
                    end
		
                    if g_fit
                        %%calculate the fit
                        [beta,r,J] =nlinfit(xarray,(adisp-min(adisp))/(max(adisp)-min(adisp)),@gauss,[round(mean(xarray)),round((max(xarray)-min(xarray))/4)]);
                        [betal,r,J] =nlinfit(xarray,(ldisp-min(ldisp))/(max(ldisp)-min(ldisp)),@gauss,[round(mean(xarray)),round((max(xarray)-min(xarray))/4)]);
                        [betar,r,J] =nlinfit(xarray,(rdisp-min(rdisp))/(max(rdisp)-min(rdisp)),@gauss,[round(mean(xarray)),round((max(xarray)-min(xarray))/4)]);
                        
                        %%plot the fit at high resolution
                        xarray_int=[min(xarray):.1*xstep:max(xarray)];
                        plot(xarray_int,gauss(beta,xarray_int)*(max(adisp)-min(adisp))+min(adisp), 'k','Linewidth',1);
                        plot(xarray_int,gauss(betal,xarray_int)*(max(ldisp)-min(ldisp))+min(ldisp), 'b','Linewidth',1);
                        plot(xarray_int,gauss(betar,xarray_int)*(max(rdisp)-min(rdisp))+min(rdisp), 'r','Linewidth',1);
                    end %%end the g_fit loop
                    
                                         plot(xarray,adisp,'k','LineWidth',3)   
                         plot(xarray,ldisp,'b','LineWidth',3)   
                         plot(xarray,rdisp,'r','LineWidth',3)
	
                end
            end
                
        end %%end motion type loop
    end %%end the show graphs loop   
    figure(findobj(0,'tag','cont_disp_1'));
    figure(findobj(0,'tag','set_cont_win'));     %% set the main window as active
return;