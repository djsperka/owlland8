%%%This function goes through, finds each spike from the specified channel
%%%and retrieves its associated variable and spike time.
%%%Hacked from Set_raster in OwlLand/Aud_space/Aud_space_files by DJT

function raster_handles=Raster(snd,chans,NAME) 
raster_handles=[];
rep=snd.reps; 

MyScreen=get(0,'ScreenSize');

counter=0;
for chancount=chans %run through your matrix of channels
    counter=counter+1;
    p1=(counter-1)*MyScreen(3)/length(chans); %Save room for correlograms!
    if strcmp(NAME,'Real')
        p2=(MyScreen(4)/2); %Put it Halfway up
    else
        p2=0; %Put it at the bottom
    end
    p3=MyScreen(3)/length(chans);
    p4=MyScreen(4)/2-85;
    
    hand=figure ('position', [p1 p2 p3 p4]);
    raster_handles=[raster_handles,hand];
    
    %Reset raster vectors
    rasterplace=0;
    Var1raster=zeros(1,50000); %vector of spike variables
    timeraster=zeros(1,50000); %vector of spike times
    
    if ~isempty(snd.dataVar1)   %%if there is data
        
        for i=[1:length(snd.dataVar1)]
            if snd.datachan(i)==chancount
                rasterplace=rasterplace+1; %Count number of spikes
                if rep>1 %Save the variable that this spike is associated with
                    %this makes sure that each dot is printed on the
                    %correct line
                    Var1raster(rasterplace)=(snd.dataVar1(i)-.3*snd.Var1step)+(.6*snd.Var1step*((snd.datarep(i)-1)/(rep-1))); 
                else
                    Var1raster(rasterplace)=snd.dataVar1(i);
                end;
                
                timeraster(rasterplace)=snd.datatime(i); %Save the time of this spike
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
    Var1raster=Var1raster(1:rasterplace); %Remove excess zeros from Var1raster
    timeraster=timeraster(1:rasterplace); %Remove excess zeros from timeraster
    hrast=plot(timeraster,Var1raster,'k.','markersize',((6/rep)+5));
    set(gca,'ytickmode','manual','ytick',snd.Var1array)
    plot([0,0],y_lim,':k')
    set(gca,'ylim',y_lim)
    set(gca,'xlim',x_lim)
    
    title(['Trace= ' num2str(snd.trace) '       channel= ' num2str(chancount)]);
    set(get(gca,'xlabel'),'fontsize',14)
    set(get(gca,'ylabel'),'fontsize',14)
    ylabel(snd.Var1_choices(snd.Var1));
    xlabel('time (ms)');
    
    
    
end

return;