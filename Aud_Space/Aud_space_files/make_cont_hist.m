function [aud_only,vis_only,bimod]=make_cont_hist(savecont,visdiv,ITDdiv)

    num_traces=length(savecont);
    
    for i=1:num_traces
        hz(i)=(savecont{i}.az_max-savecont{i}.az_min)*savecont{i}.noise_hz/(savecont{i}.time);
        present_aud(i)=savecont{i}.present_aud;
        present_vis(i)=savecont{i}.present_vis;
    end
    
    aud_trials=find(present_aud==1 & present_vis==0);
    vis_trials=find(present_vis==1 & present_aud==0);
    bimod_trials=find(present_aud==1 & present_vis==1);
    
    %%%first run the function calc_hist on the bimod trials
    if length(bimod_trials)>0
        hz_bimod=hz(bimod_trials);
        ind=unique(hz_bimod);
        for i=1:length(ind)
            index=find(hz_bimod==ind(i));
             bimod{i}.rate=hz(index(1));
             bimod{i}.histmat=[];
             bimod{i}.histtime=[];
             bimod{i}.az_array=[];
             bimod{i}.ITD_array=[];
            for j=1:length(index)      
               [histmat,histtime,az_array,ITD_array]=calc_hist(savecont{bimod_trials(index(j))},visdiv,ITDdiv);
               if length(histmat)~=0
				  if length(bimod{i}.histmat)==0;
                      bimod{i}.histmat=histmat;
                      bimod{i}.histtime=histtime;
                  else
                      bimod{i}.histmat=cat(3,bimod{i}.histmat,histmat);  %% Concatenate histmat along the array of reps
                      bimod{i}.histtime=cat(3,bimod{i}.histtime,histtime);
                  end
               end
            end
            bimod{i}.az_array=az_array;
            bimod{i}.ITD_array=ITD_array;
            
            %%fit gauss curves
            allhist=squeeze(sum(sum(sum(bimod{i}.histmat,4),3),2));    %%flatten data except for  info
            alltime=squeeze(sum(sum(sum(bimod{i}.histtime,4),3),2));
            dispall=allhist./alltime;
            
            rhist=squeeze(sum(sum(sum(bimod{i}.histmat(:,:,:,4),4),3),2));    %%grab all  moving to right
            rtime=squeeze(sum(sum(sum(bimod{i}.histtime(:,:,:,4),4),3),2));    %%grab all  moving to right
            dispr=rhist./rtime;
            
            lhist=squeeze(sum(sum(sum(bimod{i}.histmat(:,:,:,1),4),3),2));     %%grab all ITD moving to the left
            ltime=squeeze(sum(sum(sum(bimod{i}.histtime(:,:,:,1),4),3),2));
            displ=lhist./ltime;

            az_array=bimod{i}.az_array;
            [beta,r,J] =nlinfit(az_array,(dispall-min(dispall))/(max(dispall)-min(dispall)),@gauss,[round(mean(az_array)) 10]);
            [betar,rr,Jr] =nlinfit(az_array,(dispr-min(dispr))/(max(dispr)-min(dispr)),@gauss,[round(mean(az_array)) 10]);
            [betal,rl,Jl] =nlinfit(az_array,(displ-min(displ))/(max(displ)-min(displ)),@gauss,[round(mean(az_array)) 10]);
            
            bimod{i}.myu=beta(1);
            bimod{i}.myu_r=betar(1);
            bimod{i}.myu_l=betal(1);
            
            confidence=nlparci(beta,r,J);
            bimod{i}.c=confidence(1,:);
            
            confidence=nlparci(betar,rr,Jr);
            bimod{i}.c_r=confidence(1,:);
            
            confidence=nlparci(betal,rl,Jl);
            bimod{i}.c_l=confidence(1,:);

        end
    end
    
    %%now do the analysis on the aud trials
    if length(aud_trials)>0
        hz_aud=hz(aud_trials);
        ind=unique(hz_aud);
        for i=1:length(ind)
            index=find(hz_aud==ind(i));
             aud_only{i}.rate=hz(index(1));
             aud_only{i}.histmat=[];
             aud_only{i}.histtime=[];
             aud_only{i}.ITD_array=[];
            for j=1:length(index)   
               [histmat,histtime,az_array,ITD_array]=calc_hist(savecont{aud_trials(index(j))},visdiv,ITDdiv);
               if length(histmat)~=0
                   if length(bimod{i}.histmat)==0;
				      aud_only{i}.histmat=histmat;
                      aud_only{i}.histtime=histtime;
                   else
                      aud_only{i}.histmat=cat(3,aud_only{i}.histmat,histmat);  %% Concatenate histmat along the array of reps
                      aud_only{i}.histtime=cat(3,aud_only{i}.histtime,histtime);
                  end
               end
            end
            aud_only{i}.ITD_array=ITD_array;
            %%fit gauss curves
            
            allhist=squeeze(sum(sum(sum(aud_only{i}.histmat,4),3),1));    %%flatten data except for ITD info
            alltime=squeeze(sum(sum(sum(aud_only{i}.histtime,4),3),1));
            dispall=allhist./alltime;
            
            rhist=squeeze(sum(sum(sum(aud_only{i}.histmat(:,:,:,4),4),3),1));    %%grab all ITD moving to right
            rtime=squeeze(sum(sum(sum(aud_only{i}.histtime(:,:,:,4),4),3),1));
            dispr=rhist./rtime;
            
            lhist=squeeze(sum(sum(sum(aud_only{i}.histmat(:,:,:,1),4),3),1));    %%grab all ITD moving to the left
            ltime=squeeze(sum(sum(sum(aud_only{i}.histtime(:,:,:,1),4),3),1));
            displ=lhist./ltime;
            
            [beta,r,J] =nlinfit(ITD_array,(dispall-min(dispall))/(max(dispall)-min(dispall)),@gauss,[round(mean(ITD_array)) 10]);
            [betar,rr,Jr] =nlinfit(ITD_array,(dispr-min(dispr))/(max(dispr)-min(dispr)),@gauss,[round(mean(ITD_array)) 10]);
            [betal,rl,Jl] =nlinfit(ITD_array,(displ-min(displ))/(max(displ)-min(displ)),@gauss,[round(mean(ITD_array)) 10]);
         
            aud_only{i}.myu=beta(1);
            aud_only{i}.myu_r=betar(1);
            aud_only{i}.myu_l=betal(1);
            
            confidence=nlparci(beta,r,J);
            aud_only{i}.c=confidence(1,:);
            
            confidence=nlparci(betar,rr,Jr);
            aud_only{i}.c_r=confidence(1,:);
            
            confidence=nlparci(betal,rl,Jl);
            aud_only{i}.c_l=confidence(1,:);
        end
    end
    
%%%finally the vis trials
    if length(vis_trials)>0
        hz_vis=hz(vis_trials);
        ind=unique(hz_vis);
        for i=1:length(ind)
            index=find(hz_vis==ind(i));
            vis_only{i}.rate=hz(index(1));
            vis_only{i}.histmat=[];
            vis_only{i}.histtime=[];
            vis_only{i}.az_array=[];
            for j=1:length(index)   
               [histmat,histtime,az_array,ITD_array]=calc_hist(savecont{vis_trials(index(j))},visdiv,ITDdiv);
               if length(histmat)~=0
                   if length(vis_only{i}.histmat)==0;
				      vis_only{i}.histmat=histmat;
                      vis_only{i}.histtime=histtime;
                   else
                      vis_only{i}.histmat=cat(3,vis_only{i}.histmat,histmat);  %% Concatenate histmat along the array of reps
                      vis_only{i}.histtime=cat(3,vis_only{i}.histtime,histtime);
                  end
               end
             end
             vis_only{i}.az_array=az_array;

            %%fit gauss curves
            allhist=squeeze(sum(sum(sum(vis_only{i}.histmat,4),3),2));    %%flatten data except for  info
            alltime=squeeze(sum(sum(sum(vis_only{i}.histtime,4),3),2));
            dispall=allhist./alltime;
            
            rhist=squeeze(sum(sum(sum(vis_only{i}.histmat(:,:,:,4),4),3),2));    %%grab all  moving to right
            rtime=squeeze(sum(sum(sum(vis_only{i}.histtime(:,:,:,4),4),3),2));    %%grab all  moving to right
            dispr=rhist./rtime;
            
            lhist=squeeze(sum(sum(sum(vis_only{i}.histmat(:,:,:,1),4),3),2));     %%grab all ITD moving to the left
            ltime=squeeze(sum(sum(sum(vis_only{i}.histtime(:,:,:,1),4),3),2));
            displ=lhist./ltime;

            az_array=vis_only{i}.az_array;
            
            [beta,r,J] =nlinfit(az_array,(dispall-min(dispall))/(max(dispall)-min(dispall)),@gauss,[round(mean(az_array)) 10]);
            [betar,rr,Jr] =nlinfit(az_array,(dispr-min(dispr))/(max(dispr)-min(dispr)),@gauss,[round(mean(az_array)) 10]);
            [betal,rl,Jl] =nlinfit(az_array,(displ-min(displ))/(max(displ)-min(displ)),@gauss,[round(mean(az_array)) 10]);
            
            vis_only{i}.myu=beta(1);
            vis_only{i}.myu_r=betar(1);
            vis_only{i}.myu_l=betal(1);
            
            confidence=nlparci(beta,r,J);
            vis_only{i}.c=confidence(1,:);
            
            confidence=nlparci(betar,rr,Jr);
            vis_only{i}.c_r=confidence(1,:);
            
            confidence=nlparci(betal,rl,Jl);
            vis_only{i}.c_l=confidence(1,:);
         end
    end

    

    %%%%%%%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%%%%%%
                              %%%%%%%%%%%%%%%%%%%%%%
                              
                              %%%GRAPH EVERYTHING%%%
                              
                              %%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%%%%%%

    
     if exist('vis_only')
        
        figure; 
        for i=1:length(vis_only)
            subplot(length(vis_only),1,i)
            ax(i)=gca;

            allhist=squeeze(sum(sum(sum(vis_only{i}.histmat,4),3),2));    %%flatten data except for  info
            alltime=squeeze(sum(sum(sum(vis_only{i}.histtime,4),3),2));
            dispall=allhist./alltime;
            
            rhist=squeeze(sum(sum(sum(vis_only{i}.histmat(:,:,:,4),4),3),2));    %%grab all  moving to right
            rtime=squeeze(sum(sum(sum(vis_only{i}.histtime(:,:,:,4),4),3),2));    %%grab all  moving to right
            dispr=rhist./rtime;
            
            lhist=squeeze(sum(sum(sum(vis_only{i}.histmat(:,:,:,1),4),3),2));     %%grab all ITD moving to the left
            ltime=squeeze(sum(sum(sum(vis_only{i}.histtime(:,:,:,1),4),3),2));
            displ=lhist./ltime;

            az_array=vis_only{i}.az_array;
            [beta,r,J] =nlinfit(az_array,(dispall-min(dispall))/(max(dispall)-min(dispall)),@gauss,[round(mean(az_array)) 10]);
            [betar,rr,Jr] =nlinfit(az_array,(dispr-min(dispr))/(max(dispr)-min(dispr)),@gauss,[round(mean(az_array)) 10]);
            [betal,rl,Jl] =nlinfit(az_array,(displ-min(displ))/(max(displ)-min(displ)),@gauss,[round(mean(az_array)) 10]);
                  
            az_array_int=[min(az_array):.25:max(az_array)];
            plot(az_array,dispall,'k','Linewidth',3)
            hold on
            plot(az_array,dispr,'r','Linewidth',2)
            plot(az_array,displ,'b','Linewidth',2)

		    plot(az_array_int,gauss(beta,az_array_int)*(max(dispall)-min(dispall))+min(dispall), 'k','Linewidth',1);
		    plot(az_array_int,gauss(betar,az_array_int)*(max(dispr)-min(dispr))+min(dispr), 'r','Linewidth',1);
		    plot(az_array_int,gauss(betal,az_array_int)*(max(displ)-min(displ))+min(displ), 'b','Linewidth',1); 
            
            text(max(az_array)/1.9,max(dispall)/1.2, ['Speed = ' num2str(vis_only{i}.rate) ' deg/sec'])

        end
        axes(ax(1)); title('VIS ONLY','fontsize',17); 
    end

    if exist('aud_only')
        
        figure; 
        for i=1:length(aud_only)
            subplot(length(aud_only),1,i)
            ax(i)=gca;

            allhist=squeeze(sum(sum(sum(aud_only{i}.histmat,4),3),1));    %%flatten data except for ITD info
            alltime=squeeze(sum(sum(sum(aud_only{i}.histtime,4),3),1));
            dispall=allhist./alltime;
            
            rhist=squeeze(sum(sum(sum(aud_only{i}.histmat(:,:,:,4),4),3),1));    %%grab all ITD moving to right
            rtime=squeeze(sum(sum(sum(aud_only{i}.histtime(:,:,:,4),4),3),1));
            dispr=rhist./rtime;
            
            lhist=squeeze(sum(sum(sum(aud_only{i}.histmat(:,:,:,1),4),3),1));    %%grab all ITD moving to the left
            ltime=squeeze(sum(sum(sum(aud_only{i}.histtime(:,:,:,1),4),3),1));
            displ=lhist./ltime;
            
            [beta,r,J] =nlinfit(ITD_array,(dispall-min(dispall))/(max(dispall)-min(dispall)),@gauss,[round(mean(ITD_array)) 10]);
            [betar,rr,Jr] =nlinfit(ITD_array,(dispr-min(dispr))/(max(dispr)-min(dispr)),@gauss,[round(mean(ITD_array)) 10]);
            [betal,rl,Jl] =nlinfit(ITD_array,(displ-min(displ))/(max(displ)-min(displ)),@gauss,[round(mean(ITD_array)) 10]);
           
            ITD_array_int=[min(ITD_array):.25:max(ITD_array)];
            plot(ITD_array,dispall,'k','Linewidth',3)
            hold on
            plot(ITD_array,dispr,'r','Linewidth',2)
            plot(ITD_array,displ,'b','Linewidth',2)

		    plot(ITD_array_int,gauss(beta,ITD_array_int)*(max(dispall)-min(dispall))+min(dispall), 'k','Linewidth',1);
		    plot(ITD_array_int,gauss(betar,ITD_array_int)*(max(dispr)-min(dispr))+min(dispr), 'r','Linewidth',1);
		    plot(ITD_array_int,gauss(betal,ITD_array_int)*(max(displ)-min(displ))+min(displ), 'b','Linewidth',1);
                
            text(max(ITD_array)/1.9,max(dispall)/1.2, ['Speed = ' num2str(aud_only{i}.rate) ' deg/sec'])

        end
        axes(ax(1)); title('AUD ONLY','fontsize',17); 


    end
    
         if exist('bimod')
        
        figure; 
        for i=1:length(bimod)
            subplot(length(bimod),1,i)
            ax(i)=gca;

            allhist=squeeze(sum(sum(sum(bimod{i}.histmat,4),3),2));    %%flatten data except for  info
            alltime=squeeze(sum(sum(sum(bimod{i}.histtime,4),3),2));
            dispall=allhist./alltime;
            
            rhist=squeeze(sum(sum(sum(bimod{i}.histmat(:,:,:,4),4),3),2));    %%grab all  moving to right
            rtime=squeeze(sum(sum(sum(bimod{i}.histtime(:,:,:,4),4),3),2));    %%grab all  moving to right
            dispr=rhist./rtime;
            
            lhist=squeeze(sum(sum(sum(bimod{i}.histmat(:,:,:,1),4),3),2));     %%grab all ITD moving to the left
            ltime=squeeze(sum(sum(sum(bimod{i}.histtime(:,:,:,1),4),3),2));
            displ=lhist./ltime;

            az_array=bimod{i}.az_array;
            [beta,r,J] =nlinfit(az_array,(dispall-min(dispall))/(max(dispall)-min(dispall)),@gauss,[round(mean(az_array)) 10]);
            [betar,rr,Jr] =nlinfit(az_array,(dispr-min(dispr))/(max(dispr)-min(dispr)),@gauss,[round(mean(az_array)) 10]);
            [betal,rl,Jl] =nlinfit(az_array,(displ-min(displ))/(max(displ)-min(displ)),@gauss,[round(mean(az_array)) 10]);
            
            
            az_array_int=[min(az_array):.25:max(az_array)];
            plot(az_array,dispall,'k','Linewidth',3)
            hold on
            plot(az_array,dispr,'r','Linewidth',2)
            plot(az_array,displ,'b','Linewidth',2)

		    plot(az_array_int,gauss(beta,az_array_int)*(max(dispall)-min(dispall))+min(dispall), 'k','Linewidth',1);
		    plot(az_array_int,gauss(betar,az_array_int)*(max(dispr)-min(dispr))+min(dispr), 'r','Linewidth',1);
		    plot(az_array_int,gauss(betal,az_array_int)*(max(displ)-min(displ))+min(displ), 'b','Linewidth',1);
             
            text(max(az_array)/1.9,max(dispall)/1.2, ['Speed = ' num2str(bimod{i}.rate) ' deg/sec'])
            
        end
        axes(ax(1)); title('BIMODAL','fontsize',17); 

    end
        
        %%% plot the means & the error bars
     if exist('aud_only')
        figure; 
        for i=1:length(aud_only)
            aud_mns_r(i)=aud_only{i}.myu_r;
            aud_lowb_r(i)=aud_only{i}.c_r(1);
            aud_upb_r(i)=aud_only{i}.c_r(2);
	
            aud_mns_l(i)=aud_only{i}.myu_l;
            aud_lowb_l(i)=aud_only{i}.c_l(1);
            aud_upb_l(i)=aud_only{i}.c_l(2);
            
            aud_rt(i)=aud_only{i}.rate;
        end
        
        errorbar(aud_rt,aud_mns_r, aud_lowb_r, aud_upb_r, 'or')
        hold on
        errorbar(aud_rt,aud_mns_l, aud_lowb_l, aud_upb_l, 'ok')
        
        title('AUD', 'fontsize',17)
        xlabel('Degrees/second', 'fontsize', 15)
        ylabel('Tuning (microsec)', 'fontsize', 15)
    else 
        aud_only=[];
    end
    
    if exist('vis_only')
        figure; 
        for i=1:length(aud_only)
            vis_mns_r(i)=vis_only{i}.myu_r;
            vis_lowb_r(i)=vis_only{i}.c_r(1);
            vis_upb_r(i)=vis_only{i}.c_r(2);
	
            vis_mns_l(i)=vis_only{i}.myu_l;
            vis_lowb_l(i)=vis_only{i}.c_l(1);
            vis_upb_l(i)=vis_only{i}.c_l(2);
            
            vis_rt(i)=vis_only{i}.rate;
        end
        
        errorbar(vis_rt,vis_mns_r, vis_lowb_r, vis_upb_r, 'or')
        hold on
        errorbar(vis_rt,vis_mns_l, vis_lowb_l, vis_upb_l, 'ok')
        
        title('VIS', 'fontsize',17)
		xlabel('Degrees/second', 'fontsize', 15)
		ylabel('Tuning (degrees)', 'fontsize', 15)
    else 
        vis_only=[];
    end
    
     if exist('bimod')
        figure; 
        for i=1:length(bimod)
            bimod_mns_r(i)=bimod{i}.myu_r;
            bimod_lowb_r(i)=bimod{i}.c_r(1);
            bimod_upb_r(i)=bimod{i}.c_r(2);
	
            bimod_mns_l(i)=bimod{i}.myu_l;
            bimod_lowb_l(i)=bimod{i}.c_l(1);
            bimod_upb_l(i)=bimod{i}.c_l(2);
            
            bimod_rt(i)=bimod{i}.rate;
        end
        
        errorbar(bimod_rt,bimod_mns_r, bimod_lowb_r, bimod_upb_r, 'or')
        hold on
        errorbar(bimod_rt,bimod_mns_l, bimod_lowb_l, bimod_upb_l, 'ok')
        
        title('BIMODAL', 'fontsize',17)
                xlabel('Degrees/second', 'fontsize', 15)
        ylabel('Tuning (degrees)', 'fontsize', 15)

    else 
        bimod=[];
    end
    
        
    %%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%

return;