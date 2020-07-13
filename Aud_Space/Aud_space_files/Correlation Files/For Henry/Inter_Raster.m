%Takes the raster loops from set_inter_graphs and places them under the
%same channel/figure window routine that is implimented in the Raster
%script used for Run_XCor

function inter_handles=Inter_Raster (snd, chans,NAME) 
%Took REC out.  It was only being used to generate the title.  
inter_handles=[];
currentrep=snd.reps;

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
    inter_handles=[inter_handles,hand];
 
     % make 'both' raster
        rasterplace=0;
        Var1raster=zeros(1,length(snd.dataVar1)); %variable associated with each spike
        timeraster=zeros(1,length(snd.dataVar1)); %time associated with each spike

        for i=[1:length(snd.dataVar1)]
            if snd.datachan(i)==chancount
                rasterplace=rasterplace+1;  %make display pretty, check spike channel
                if currentrep>1
                    Var1raster(rasterplace)=(snd.dataVar1(i)-.3*snd.Var1step)+(.6*snd.Var1step*((snd.datarep(i)-1)/(currentrep-1)));
                   else
                    Var1raster(rasterplace)=snd.dataVar1(i);
                end;
                
                timeraster(rasterplace)=snd.datatime(i);  %get spike time
            end; 
		end;
        Var1raster=Var1raster(1:rasterplace); % get rid of zeros (make raterplace length)
        timeraster=timeraster(1:rasterplace);

       
        % make 'arr2' raster (single value var)
        rasterplace_arr2=0;
        Var2raster_arr2=zeros(1,length(snd.dataVar2_arr2));
        timeraster_arr2=zeros(1,length(snd.dataVar2_arr2));

        for i=[1:length(snd.dataVar2_arr2)]
            if snd.datachan_arr2(i)==chancount
                rasterplace_arr2=rasterplace_arr2+1;  %make display pretty, check spike channel
                if currentrep>1
                    Var2raster_arr2(rasterplace_arr2)=(.6*snd.Var1step*((snd.datarep_arr2(i)-1)/(currentrep-1)))-.3*snd.Var1step;
                   else
                    Var2raster_arr2(rasterplace_arr2)=0;
                end;
                
                timeraster_arr2(rasterplace_arr2)=snd.datatime_arr2(i);  %get spike time
            end; 
		end;
        Var2raster_arr2=Var2raster_arr2(1:rasterplace_arr2); % get rid of zeros (make raterplace length)
        timeraster_arr2=timeraster_arr2(1:rasterplace_arr2);
        
        
        % make 'arr1' raster (multi value var)
        rasterplace_arr1=0;
        Var1raster_arr1=zeros(1,length(snd.dataVar1_arr1));
        timeraster_arr1=zeros(1,length(snd.dataVar1_arr1));

        for i=[1:length(snd.dataVar1_arr1)]
            if snd.datachan_arr1(i)==chancount
                rasterplace_arr1=rasterplace_arr1+1;  %make display pretty, check spike channel
                if currentrep>1
                    Var1raster_arr1(rasterplace_arr1)=(snd.dataVar1_arr1(i)-.3*snd.Var1step)+(.6*snd.Var1step*((snd.datarep_arr1(i)-1)/(currentrep-1)));
                else
                    Var1raster_arr1(rasterplace_arr1)=snd.dataVar1_arr1(i);
                end;
                
                timeraster_arr1(rasterplace_arr1)=snd.datatime_arr1(i);  %get spike time
            end;
        end;
        Var1raster_arr1=Var1raster_arr1(1:rasterplace_arr1); % get rid of zeros (make raterplace length)
        timeraster_arr1=timeraster_arr1(1:rasterplace_arr1);
        
        disp_raster=[]; %clear disp_raster
        disp_raster(1:length(Var1raster_arr1))=Var1raster_arr1+(2*snd.Var1step)-snd.Var1min; %make var1 alone
        disp_raster(length(Var1raster_arr1)+1:length(Var1raster_arr1)+length(Var2raster_arr2))=Var2raster_arr2; %make var2 alone
        disp_raster(length(Var1raster_arr1)+length(Var2raster_arr2)+1:length(Var1raster_arr1)+length(Var2raster_arr2)+length(Var1raster))=Var1raster-(2*snd.Var1step)-snd.Var1max; %make both
        y_lim=[(snd.Var1min-(2.5*snd.Var1step))-snd.Var1max,(snd.Var1max-snd.Var1min+(2.5*snd.Var1step))];  %%sTrue range of y values plotted
        x_lim=[-snd.pre,snd.post];
        set(gca,'nextplot','replace')
        h=fill([snd.vis_offset,snd.vis_offset,snd.vis_offset+snd.duration,snd.vis_offset+snd.duration],[y_lim(1),y_lim(2),y_lim(2),y_lim(1)],[.1,.8,.8]);
        set(gca,'nextplot','add')
        set(h,'LineStyle','none')
        h=fill([snd.aud_offset,snd.aud_offset,snd.aud_offset+snd.duration,snd.aud_offset+snd.duration],[y_lim(1),y_lim(2),y_lim(2),y_lim(1)],[.86,.86,.86]);
        set(h,'LineStyle','none')
        hrast=plot([timeraster_arr1,timeraster_arr2,timeraster],disp_raster,'.k','markersize',((6/currentrep)+5));
        plot([0,0],y_lim,':k')
        set(gca,'ylim',y_lim)
        set(gca,'xlim',x_lim)

        
        set(gca,'YTickMode','manual','YTick',[y_lim(1)+0.5*snd.Var1step:snd.Var1step:y_lim(2)-0.5*snd.Var1step])
        set(gca,'YTickLabelMode','manual','YTickLabel',{snd.Var1array, ' ', char(snd.Var2_choices(snd.Var2)),' ',snd.Var1array})
        title(['Trace= ' num2str(snd.trace) '       channel= ' num2str(chancount) '       '  snd.Var2_choices{snd.Var2} '='  num2str(snd.Var2array(1))]); %rec.dispVar2))]);  CHANGED 6/24/2013 DJT
        set(get(gca,'xlabel'),'fontsize',14)
        set(get(gca,'ylabel'),'fontsize',14)
        ylabel(snd.Var1_choices(snd.Var1));
        xlabel('time (ms)');

end
