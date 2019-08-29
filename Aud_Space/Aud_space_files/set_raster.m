function set_raster(rep)
    global rec snd; 
 
    rasterplace=0;
    Var1raster=zeros(1,50000);
    timeraster=zeros(1,50000);
    
    if length(snd.dataVar1)>0   %%if there is data
            figure(findobj(0,'tag','disp_win_2'));     %% set the second window as active
            
            for i=[1:length(snd.dataVar1)]
                if snd.datachan(i)==rec.dispch
                        rasterplace=rasterplace+1;
                        if rep>1
                            Var1raster(rasterplace)=(snd.dataVar1(i)-.3*snd.Var1step)+(.6*snd.Var1step*((snd.datarep(i)-1)/(rep-1)));
                           else
                            Var1raster(rasterplace)=snd.dataVar1(i);
                        end;
                        
                        timeraster(rasterplace)=snd.datatime(i);
                    end; 
                end;
            end;
            y_lim=[(snd.Var1min-(0.5*snd.Var1step)),(snd.Var1max+(0.5*snd.Var1step))];
            x_lim=[-snd.pre,snd.post];
            set(gca,'nextplot','replace')
            h=fill([snd.vis_offset,snd.vis_offset,snd.vis_offset+snd.duration,snd.vis_offset+snd.duration],[y_lim(1),y_lim(2),y_lim(2),y_lim(1)],[.1,.8,.8]);
            set(gca,'nextplot','add')
            set(h,'LineStyle','none')
            h=fill([snd.aud_offset,snd.aud_offset,snd.aud_offset+snd.duration,snd.aud_offset+snd.duration],[y_lim(1),y_lim(2),y_lim(2),y_lim(1)],[.86,.86,.86]);
            set(h,'LineStyle','none')
            Var1raster=Var1raster(1:rasterplace);
            timeraster=timeraster(1:rasterplace);
            hrast=plot(timeraster,Var1raster,'k.','markersize',((6/rep)+5));
            set(gca,'ytickmode','manual','ytick',snd.Var1array)
            plot([0,0],y_lim,':k')
            set(gca,'ylim',y_lim)
            set(gca,'xlim',x_lim)
            
            title(['Trace= ' num2str(snd.trace) '       channel= ' num2str(rec.dispch)]);
            set(get(gca,'xlabel'),'fontsize',14)
            set(get(gca,'ylabel'),'fontsize',14)
            ylabel(snd.Var1_choices(snd.Var1));
            xlabel('time (ms)');

                        
                        
            

  
return;
