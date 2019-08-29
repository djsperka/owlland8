function set_inter_graphs(currentrep)    
    global snd rec harray1 harray2 hmat


    
        switch  snd.graph_type
            case 1
                dispmat=(snd.datamat_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.datamat_pre(:,:,rec.dispch))))/currentrep;   %%  subtract the average pre and devide by reps
                disparr1=(snd.data_arr1_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.data_arr1_pre(:,:,rec.dispch))))/currentrep;   %%  subtract the average pre and devide by reps
                disparr2=(snd.data_arr2_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.data_arr2_pre(:,:,rec.dispch))))/currentrep;   %%  subtract the average pre and devide by reps
            
            case 2
                dispmat=snd.datamat_pre(:,:,rec.dispch)/currentrep;   %%  
                disparr1=snd.data_arr1_pre(:,:,rec.dispch)/currentrep;   %%  
                disparr2=snd.data_arr2_pre(:,:,rec.dispch)/currentrep;   %%  
                
            case 3
                dispmat=snd.datamat_post(:,:,rec.dispch)/currentrep;   %%  
                disparr1=snd.data_arr1_post(:,:,rec.dispch)/currentrep;   %% 
                disparr2=snd.data_arr2_post(:,:,rec.dispch)/currentrep;   %%  
            case 4
                tempmax=max([max(max(snd.datamat_post(:,:,rec.dispch))),max(max(snd.data_arr1_post(:,:,rec.dispch))),max(max(snd.data_arr2_post(:,:,rec.dispch)))]);
                tempmin=min([min(min(snd.datamat_post(:,:,rec.dispch))),min(min(snd.data_arr1_post(:,:,rec.dispch))),min(min(snd.data_arr2_post(:,:,rec.dispch)))]);
                dispmat=(snd.datamat_post(:,:,rec.dispch)-tempmin)*100/(tempmax-tempmin);   %%  subtract the average pre and divide by reps
                disparr1=(snd.data_arr1_post(:,:,rec.dispch)-tempmin)*100/(tempmax-tempmin);   %%  subtract the average pre and divide by reps
                disparr2=(snd.data_arr2_post(:,:,rec.dispch)-tempmin)*100/(tempmax-tempmin);   %%  subtract the average pre and divide by reps
        end

        figure(findobj(0,'tag','disp_win_1'));
        clf

        if min(size(dispmat))>1     %%if there are multiple range values for each variable--> contour plot
            harray1=axes('units','normalized','position', [.15 .10 .684 .03],'tag','arr2','nextplot','replace',...
                'YTickMode','manual','YTick',[],'XTickMode','manual','XTick',[]);
            harray2=axes('units','normalized','position', [.10 .15 .03 .7],'tag','arr1','nextplot','replace',...
                'YTickMode','manual','YTick',[],'XTickMode','manual','XTick',[]);
            hmat=axes('units','normalized','position', [.15 .15 .8 .7],'tag','mat','nextplot','replace',...
                'YTickMode','manual','YTick',[],'XTickMode','manual','XTick',[]);
        
            myrange=[min([min(min(disparr1)),min(min(disparr2)),min(min(dispmat))]),max([max(max(disparr2)),max(max(disparr1)),max(max(dispmat))])];
    
            axes(hmat);
                contourf(snd.Var1array,snd.Var2array,dispmat,100);       %%show contour plot of one Channel
                set(get(gca,'children'),'linestyle','none');
                set(gca,'YTickMode','manual','YTick',[],'XTickMode','manual','XTick',[])
                title(['Trace= ' num2str(snd.trace) '        channel= ' num2str(rec.dispch)]);
                caxis(myrange);
                colorbar
            axes(harray1);
                contourf(snd.Var1array,[1,2],disparr1,100);       %%show contour plot of one Channel
                set(get(gca,'children'),'linestyle','none');
                set(gca,'YTickMode','manual','YTick',[],'XTick',snd.Var1array)
                caxis(myrange);
                xlabel(snd.Var1_choices(snd.Var1));
                set(get(gca,'xlabel'),'fontsize',14);
            axes(harray2);
                contourf([1,2],snd.Var2array,disparr2,100);       %%show contour plot of one Channel
                set(get(gca,'children'),'linestyle','none');
                set(gca,'YTickMode','manual','YTick',snd.Var2array,'XTickMode','manual','XTick',[])
                caxis(myrange);
                ylabel(snd.Var2_choices(snd.Var2));
                set(get(gca,'ylabel'),'fontsize',14);
            axes(hmat);
        end;


        
        
        
        
        
        
        
        
        
        
        
        
        
    if max(size(dispmat))==1     %%Interleaved single range values bar plot with rasters
        myhist=[disparr1(1,1),dispmat(1,1),disparr2(1,1)];
        bar([1,2,3],myhist);
        set(gca,'XTickLabelMode','manual','XTickLabel',{char(snd.Var1_choices(snd.Var1)),'both',char(snd.Var2_choices(snd.Var2))})
        ylabel('Spikes');
        set(get(gca,'ylabel'),'fontsize',14);
        title(['Trace= ' num2str(snd.trace) '        channel= ' num2str(rec.dispch)]);
        
        %%make the raster plot
        figure(findobj(0,'tag','disp_win_2'));
        clf
        rasterarray=[(0.6+(0.8*snd.datarep_arr1/currentrep)),(1.6+(0.8*snd.datarep/currentrep)),(2.6+(0.8*snd.datarep_arr2/currentrep))];
        rastertimes=[snd.datatime_arr1,snd.datatime,snd.datatime_arr2];
        mychan=find([snd.datachan_arr1,snd.datachan,snd.datachan_arr2]==rec.dispch);
        
        
        y_lim=[0.5,3.5];  %%sTrue range of y values plotted
        x_lim=[-snd.pre,snd.post];
        set(gca,'nextplot','replace')
        h=fill([snd.vis_offset,snd.vis_offset,snd.vis_offset+snd.duration,snd.vis_offset+snd.duration],[y_lim(1),y_lim(2),y_lim(2),y_lim(1)],[.1,.8,.8]);
        set(gca,'nextplot','add')
        set(h,'LineStyle','none')
        h=fill([snd.aud_offset,snd.aud_offset,snd.aud_offset+snd.duration,snd.aud_offset+snd.duration],[y_lim(1),y_lim(2),y_lim(2),y_lim(1)],[.86,.86,.86]);
        set(h,'LineStyle','none')
        plot(rastertimes(mychan),rasterarray(mychan),'k.','markersize',((6/currentrep)+5));
        plot([0,0],y_lim,':k')
        
        set(gca,'YTickMode','manual','YTick',[1:3])
        set(gca,'YTickLabelMode','manual','YTickLabel',{char(snd.Var1_choices(snd.Var1)),'both',char(snd.Var2_choices(snd.Var2))})
        xlabel('Time (ms)');
        set(get(gca,'xlabel'),'fontsize',14);
        title(['Trace= ' num2str(snd.trace) '        channel= ' num2str(rec.dispch)]);

        
        
        
        
        
        
        
        
        
        
    end;

    
    if size(dispmat,1)==1 & size(dispmat,2)>1  %%Interleaved multiple vals for Var1 but only 1 for var2
        myhist=[squeeze(disparr1(1,:)),0,0,disparr2(1,1),0,0,squeeze(dispmat)]; %histograms: arr1 -- arr2 -- both
        bar([1:length(myhist)],myhist);
        set(gca,'XTickMode','manual','XTick',[1:length(myhist)])
        set(gca,'XTickLabelMode','manual','XTickLabel',{snd.Var1array, ' ', ' ', char(snd.Var2_choices(snd.Var2)),' ',' ',snd.Var1array})
        ylabel('Spikes');
        set(get(gca,'ylabel'),'fontsize',14);
        xlabel('Alone                                            Both');
        set(get(gca,'xlabel'),'fontsize',14);
        title(['Trace= ' num2str(snd.trace) '        channel= ' num2str(rec.dispch)]);
        
        figure(findobj(0,'tag','disp_win_2'));
        clf  %clear

        % make 'both' raster
        rasterplace=0;
        Var1raster=zeros(1,length(snd.dataVar1));
        timeraster=zeros(1,length(snd.dataVar1));

        for i=[1:length(snd.dataVar1)]
            if snd.datachan(i)==rec.dispch
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
            if snd.datachan_arr2(i)==rec.dispch
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
            if snd.datachan_arr1(i)==rec.dispch
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
        
      
        
        disp_raster(1:length(Var1raster_arr1))=Var1raster_arr1+(2*snd.Var1step)-snd.Var1min;
        disp_raster(length(Var1raster_arr1)+1:length(Var1raster_arr1)+length(Var2raster_arr2))=Var2raster_arr2;
        disp_raster(length(Var1raster_arr1)+length(Var2raster_arr2)+1:length(Var1raster_arr1)+length(Var2raster_arr2)+length(Var1raster))=Var1raster-(2*snd.Var1step)-snd.Var1max;
    
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
        title(['Trace= ' num2str(snd.trace) '       channel= ' num2str(rec.dispch) '       '  snd.Var2_choices{snd.Var2} '='  num2str(snd.Var2array(rec.dispVar2))]);
        set(get(gca,'xlabel'),'fontsize',14)
        set(get(gca,'ylabel'),'fontsize',14)
        ylabel(snd.Var1_choices(snd.Var1));
        xlabel('time (ms)');

         
    end;

        
          
        
        
return