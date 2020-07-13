function show_raster()
    global snd rec;
%         keyboard
    h=findobj(gcf,'tag','raster');
    hist_type=get(h,'value');
    snd.graph_num=snd.graph_num+1;
    
    graphsize=((get(0,'screensize')-[0,0,0,32])/2);
    x_offset=mod(snd.graph_num-1,2);
    y_offset=floor(mod(((snd.graph_num-1)/2),2));
    x_inc=graphsize(3);
    y_inc=graphsize(4);
    
    graphlocation=graphsize+(x_offset*[x_inc,0,0,0])+(y_offset*[0,y_inc,0,0])+[4,32,0,0];

    switch hist_type
        case 1 %horizontal raster
            figure(findobj(0,'tag','disp_win_1'));     %% set the third window as active
            [x,y]=ginput(1); %Cool little command.  This guy could be useful!
            
            %next two lines find the value closest to the one user clicked
            temparray=abs(snd.Var2array-y);
            raster_position=find(temparray==min(temparray));
            
            figure('menubar','none','position',graphlocation);
            Var1raster=zeros(1,50000);
            timeraster=zeros(1,50000);
            rasterplace=0;
%             keyboard
            for i=[1:length(snd.dataVar1_arr1)] %for all spikes
                if snd.datachan_arr1(i)==rec.dispch %if spike is from current channel
                        if snd.dataVar2_arr1(i)==snd.Var2array(raster_position) %and the selected variable value
                            rasterplace=rasterplace+1;
                            if snd.reps>1 %next 3 lines are about positioning the dots vertically
                                Var1raster(rasterplace)=(snd.dataVar1_arr1(i)-.3*snd.Var1step)+(.6*snd.Var1step*((snd.datarep_arr1(i)-1)/(snd.reps-1)));
                               else
                                Var1raster(rasterplace)=snd.dataVar1_arr1(i);
                            end;
                            timeraster(rasterplace)=snd.datatime_arr1(i); % and this will be used to locat dots horizontally
                        end;
                
                end;
            end;
            Var1raster=Var1raster(1:rasterplace);
            timeraster=timeraster(1:rasterplace);
            plot(timeraster,Var1raster,'linestyle','none','marker','.','markerfacecolor','k','markersize',((10/snd.reps)+4));
            ylabel(snd.Var1_choices(snd.Var1));
            xlabel('time (ms)');
            set(gca,'ylim',[(snd.Var1min-(0.5*snd.Var1step)),(snd.Var1max+(0.5*snd.Var1step))])
            set(gca,'xlim',[-snd.pre,snd.post])
            set(gca,'ytick',snd.Var1array)
            title([char(snd.Var2_choices(snd.Var2)) ' = ' num2str(snd.Var2array(raster_position)) '    Trace = ' num2str(snd.trace) '   channel = ' num2str(rec.dispch)]);
            
        case 2 %vertical raster
            figure(findobj(0,'tag','disp_win_1'));     %% set the third window as active
            [x,y]=ginput(1);
            temparray=abs(snd.Var1array-x);
            raster_position=find(temparray==min(temparray));
            
            figure('menubar','none','position',graphlocation);
            Var2raster=zeros(1,50000);
            timeraster=zeros(1,50000);
            rasterplace=0;
            for i=[1:length(snd.dataVar2_arr1)]
                if snd.datachan_arr1(i)==rec.dispch

                    if snd.dataVar1_arr1(i)==snd.Var1array(raster_position)
                        rasterplace=rasterplace+1;
                        if snd.reps>1
                            Var2raster(rasterplace)=(snd.dataVar2_arr1(i)-.3*snd.Var2step)+(.6*snd.Var2step*((snd.datarep_arr1(i)-1)/(snd.reps-1)));
                           else
                            Var2raster(rasterplace)=snd.dataVar2_arr1(i);
                        end;
                        timeraster(rasterplace)=snd.datatime_arr1(i);
                    end;
                end;
            end;
            Var2raster=Var2raster(1:rasterplace);
            timeraster=timeraster(1:rasterplace);
            plot(timeraster,Var2raster,'linestyle','none','marker','.','markerfacecolor','k','markersize',((10/snd.reps)+4));
            ylabel(snd.Var2_choices(snd.Var2));
            xlabel('time (ms)');
            set(gca,'ylim',[(snd.Var2min-(0.5*snd.Var2step)),(snd.Var2max+(0.5*snd.Var2step))])
            set(gca,'xlim',[-snd.pre,snd.post])
            set(gca,'ytick',snd.Var2array)
            title([char(snd.Var1_choices(snd.Var1)) ' = ' num2str(snd.Var1array(raster_position)) '    Trace = ' num2str(snd.trace) '   channel = ' num2str(rec.dispch)]);
            
        case 4 %variable 1 raster
            error ('Not currently available for looming data')
%             figure('menubar','none','position',graphlocation);
%             Var1raster=zeros(1,50000);
%             timeraster=zeros(1,50000);
%             rasterplace=0;
%  
%             for i=[1:snd.spikeplace_arr1]
%                 if snd.datachan_arr1(i)==rec.dispch
%                     rasterplace=rasterplace+1;
%                     if snd.reps>1
%                         Var1raster(rasterplace)=(snd.dataVar1_arr1_arr1(i)-.3*snd.Var1step)+(.6*snd.Var1step*((snd.datarep_arr1(i)-1)/(snd.reps-1)));
%                       else
%                         Var1raster(rasterplace)=snd.dataVar1_arr1_arr1(i);
%                     end;
%                     timeraster(rasterplace)=snd.datatime_arr1_arr1(i);
%                 end;
%             end;
%             Var1raster=Var1raster(1:rasterplace);
%             timeraster=timeraster(1:rasterplace);
%             plot(timeraster,Var1raster,'linestyle','none','marker','.','markerfacecolor','k','markersize',((6/snd.reps)+4));
%             ylabel(snd.Var1_choices(snd.Var1));
%             xlabel('time (ms)');
%             set(gca,'ylim',[(snd.Var1min-(0.5*snd.Var1step)),(snd.Var1max+(0.5*snd.Var1step))])
%             set(gca,'xlim',[-snd.pre,snd.post])
%             set(gca,'ytick',snd.Var1array)
%             title([char(snd.Var1_choices(snd.Var1)),' Alone','    Trace = ' num2str(snd.trace) '   channel = ' num2str(rec.dispch)]);
%             
        case 5 %variable 2 raster
            error('Not currently available for looming data')
%             figure('menubar','none','position',graphlocation);
%             Var1raster=zeros(1,50000);
%             timeraster=zeros(1,50000);
%             rasterplace=0;
%  
%             for i=[1:snd.spikeplace_arr2]
%                 if snd.datachan_arr2(i)==rec.dispch
%                     rasterplace=rasterplace+1;
%                     if snd.reps>1
%                         Var2raster(rasterplace)=(snd.dataVar2_arr1_arr2(i)-.3*snd.Var2step)+(.6*snd.Var2step*((snd.datarep_arr2(i)-1)/(snd.reps-1)));
%                       else
%                         Var2raster(rasterplace)=snd.dataVar2_arr1_arr2(i);
%                     end;
%                     timeraster(rasterplace)=snd.datatime_arr1_arr2(i);
%                 end;
%             end;
%             Var2raster=Var2raster(1:rasterplace);
%             timeraster=timeraster(1:rasterplace);
%             plot(timeraster,Var2raster,'linestyle','none','marker','.','markerfacecolor','k','markersize',((6/snd.reps)+4));
%             ylabel(snd.Var2_choices(snd.Var2));
%             xlabel('time (ms)');
%             set(gca,'ylim',[(snd.Var2min-(0.5*snd.Var2step)),(snd.Var2max+(0.5*snd.Var2step))])
%             set(gca,'xlim',[-snd.pre,snd.post])
%             set(gca,'ytick',snd.Var2array)
%             title([char(snd.Var2_choices(snd.Var2)),' Alone','    Trace = ' num2str(snd.trace) '   channel = ' num2str(rec.dispch)]);
            
    end    


    c=get(gcf,'color');
    uicontrol('style','pushbutton',...
        'units','normalized',...
        'position', [.02 .05 .08 .05],...
        'horizontalalignment','center',...
        'string','Close',...
        'callback','close_graph;');




return;
