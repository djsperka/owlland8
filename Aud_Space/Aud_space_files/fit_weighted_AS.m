function fit_weighted_AS()
    % function used to be called 'find_best_area'.  Now using it as wrapper to call 
    % 'weighted_average' function (renamed from Ilana's 'halfmax' function.
    global snd rec;
    figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
    snd.ba_cutoff=str2num(get(findobj(gcf,'tag','ba_cutoff'),'string'));  %%  get the cutoff level
    snd.ba_cutoff=max(snd.ba_cutoff,0);
    snd.ba_cutoff=min(snd.ba_cutoff,100);
    set(findobj(gcf,'tag','ba_cutoff'),'string',snd.ba_cutoff);
         
    %%  clear the graphs of previous best area plots.
    set_graphs(snd.reps)        
    
    %%%%%%%%%%%%%%% create the display graphs
    if snd.graph_type==1    %%display type is adjusted
        dispmat=(snd.datamat_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.datamat_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
    end
    if snd.graph_type==2    %%display type is pre
        dispmat=snd.datamat_pre(:,:,rec.dispch)/snd.reps;   
    end
    if snd.graph_type==3    %%display type is post or normal// both should be normalized the same
        dispmat=snd.datamat_post(:,:,rec.dispch)/snd.reps;  
    end
    if snd.graph_type==4    %%display type is post or normal// both should be normalized the same
        dispmat=snd.datamat_post(:,:,rec.dispch)/snd.reps;   
        dispmat=100*((dispmat-min(min(dispmat)))/(max(max(dispmat))-min(min(dispmat))));
    end

    if snd.interleave_alone==1
        if snd.graph_type==1    %%display type is adjusted
            disparr1=(snd.data_arr1_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.data_arr1_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
            disparr2=(snd.data_arr2_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.data_arr2_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
        end
        if snd.graph_type==2    %%display type is pre
                disparr1=snd.data_arr1_pre(:,:,rec.dispch)/snd.reps;  
                disparr2=snd.data_arr2_pre(:,:,rec.dispch)/snd.reps;   
        end
        if snd.graph_type>=3    %%display type is post or normal// both should be normalized the same
            disparr1=snd.data_arr1_post(:,:,rec.dispch)/snd.reps;  
            disparr2=snd.data_arr2_post(:,:,rec.dispch)/snd.reps;  
        end
    end
    %%%%%%%%%%%%%%% end of display graphs

    
    
    
    
    
    %%% BEGIN KRISTIN'S ADDITIONS
    
    % For the rest of the function, set the upper left graphing window as
    % active, and have the plots add rather than replace each other.
    figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
	set(gca,'nextplot','add')
    
    
    
    %% var1 ranging, no var2 (simple tuning curve) -OR- var1 ranging, var2 constant, always both
    if (snd.Var2==7 && snd.interleave_alone==0) ||  (snd.Var2~=7 && length(snd.Var2array)==1 && snd.interleave_alone==0) 

        % Find weighted average and halfmax
        [com,leftval,rightval,xi,yi,leftval_width,rightval_width]= weighted_average(snd.Var1array,dispmat,snd.ba_cutoff/100);
        
        % Display results
        if ~isnan(com)  % Only plot results if weighted_average returned an answer
            figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
            
            %%%%% BLUE line: plot interpolated spike responses
            plot(xi,yi, 'b','linewidth', 2);

            %%%%% MAGENTA: plot best value as a magenta dot, and a magenta line to show which values were included for 
            % calculating weighted average best value. (Note: values used are any whose spikes go 
            % above the halfway point between min spikes and max spikes.  This approach helps account for high 
            % baseline firing rates).
            [minimum,com_index]=min(abs(xi-com));  % use this to find the xi value that is closest to com
                       % (can't find com directly because it may be more than 1 decimal place)
			plot(com,yi(com_index),'.m','markersize',[25]); 
			[minimum,leftval_index]=min(abs(xi-leftval));  % use this to find the xi value that is closest to leftval
			[minimum,rightval_index]=min(abs(xi-rightval));  % use this to find the xi value that is closest to rightval
            plot(xi(leftval_index:rightval_index),yi(leftval_index:rightval_index), 'm','linewidth', 2);
% 			plot([leftval,rightval],[yi(find(xi==leftval)),yi(find(xi==leftval))],'m', 'Linewidth', 2);  

            %%%%% GREEN: plot the bandwidth at halfmax.  This is simply half the maximum firing rate (doesn't 
            % take minimum spikes or baseline firing rates into account). NOTE:  this does *not* necessarily 
            % line up with the magenta points, and it isn't supposed to. they're two different measures.
            if ~isnan(leftval_width) && ~isnan(rightval_width)
			    plot([leftval_width,rightval_width],[yi(find(xi==leftval_width)),yi(find(xi==leftval_width))],'g', 'Linewidth', 2);
                    % green line shows bandwidth at halfmax
            end    
        end
        
        figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active        
        set(findobj(gcf,'tag','var1_ba'),'string',round(com*10)/10);
        set(findobj(gcf,'tag','var1_width'),'string',round((rightval_width-leftval_width)*10)/10);  
        
        if (snd.Var2==7)
            set(findobj(gcf,'tag','Var1_ba_label'),'string',snd.Var1_choices(snd.Var1));
        else
            set(findobj(gcf,'tag','Var1_ba_label'),'string','Both');
        end
    end
    
   %% var1 ranging, var2 ranging (matrix tuning curve)
   %% (doesn't compute half-max width) 
   if snd.Var2~=7 && length(snd.Var2array)>1        
        % Get a *first estimate* of the best x and y by collapsing all data into 1-D arrays 
        % KM note: one thing that can go wrong here is if the first estimate returns an NaN 
        % (because edge of curve is off of the plot), then the "slices" are just taken at the 
        % first element of each array.
        dispy_estimate=squeeze(sum(dispmat,2));    %%flatten data 
        dispx_estimate=squeeze(sum(dispmat,1));    %%flatten data        
        [com_x_estimate,left_x_estimate,right_x_estimate,xi_junk,yi_junk,left_width_x,right_width_x]= weighted_average(snd.Var1array,dispx_estimate,snd.ba_cutoff/100);
        [com_y_estimate,left_y_estimate,right_y_estimate,xi_junk,yi_junk,left_width_y,right_width_y]= weighted_average(snd.Var2array,dispy_estimate,snd.ba_cutoff/100);

        
        % If you got an estimate for each variable, take slices through the matrix at best values.
        if ~isnan(com_x_estimate) && ~isnan(com_y_estimate)         
            % Use these estimated best values of x and y to take a slice through the matrix at the hot spots. 
            % Get the final values of x and y from these slices.
            [minimum, x_estimate_index]= min(abs(snd.Var1array-com_x_estimate));
            [minimum, y_estimate_index]= min(abs(snd.Var2array-com_y_estimate));
            dispx=squeeze(dispmat(y_estimate_index,:));
            dispy=squeeze(dispmat(:,x_estimate_index));
            
            [com_x,leftval_x,rightval_x,xi_junk,yi_junk,left_width_x,right_width_x]= weighted_average(snd.Var1array,dispx,snd.ba_cutoff/100);
            [com_y,leftval_y,rightval_y,xi_junk,yi_junk,left_width_y,right_width_y]= weighted_average(snd.Var2array,dispy,snd.ba_cutoff/100);

        % If don't have both estimates, *don't take slices. Use whole matrix*
        else
            com_x= com_x_estimate; leftval_x= left_x_estimate; rightval_x= right_x_estimate;
            com_y= com_y_estimate; leftval_y= left_y_estimate; rightval_y= right_y_estimate;
        end
        
        
        if ~isnan(com_x) && ~isnan(com_y)
            figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
            plot(com_x,com_y, 'ok', 'markersize', [5]);
            if ~isnan(left_width_x) && ~isnan(right_width_x) 
                plot([left_width_x, right_width_x],[com_y, com_y],'k');
            end
            if ~isnan(left_width_y) && ~isnan(right_width_y)
                plot([com_x,com_x],[left_width_y,right_width_y],'k');        
            end
        end
    
        figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
        set(findobj(gcf,'tag','Var1_ba_label'),'string',snd.Var1_choices(snd.Var1));  
        set(findobj(gcf,'tag','Var2_ba_label'),'string',snd.Var2_choices(snd.Var2));    
        set(findobj(gcf,'tag','var1_ba'),'string',round(com_x*10)/10);
        set(findobj(gcf,'tag','var2_ba'),'string',round(com_y*10)/10);
        set(findobj(gcf,'tag','var1_width'),'string',round((right_width_x-left_width_x)*10)/10);
        set(findobj(gcf,'tag','var2_width'),'string',round((right_width_y-left_width_y)*10)/10);
        
        if ~isnan(com_x_estimate) && ~isnan(com_y_estimate)
            set(findobj(gcf,'tag','Var1_extra_label'),'string',strcat('at ',num2str(snd.Var2array(y_estimate_index))));  % tells user the slice you took      
			set(findobj(gcf,'tag','Var2_extra_label'),'string',strcat('at ',num2str(snd.Var1array(x_estimate_index))));  %   tells user the slice you took  
        end       
        
    end    

    %% var1 ranging, var2 constant, interleave alone
     if snd.Var2~=7 && length(snd.Var2array)==1 && snd.interleave_alone==1   

        [com_both, leftval_both, rightval_both, xi_both, yi_both, leftval_width_both, rightval_width_both]= weighted_average(snd.Var1array,dispmat,snd.ba_cutoff/100);
        [com_alone,leftval_alone,rightval_alone,xi_alone,yi_alone, leftval_width_alone, rightval_width_alone]= weighted_average(snd.Var1array,disparr1(1,:),snd.ba_cutoff/100);
        
        % steps of 0.1/snd.Var1step.  The 0.1 corresponds to the step of interpolated xi in weighted_average function.
        int_x_alone=[1:.1/snd.Var1step:length(snd.Var1array)];
        int_x_both=[6+length(snd.Var1array):.1/snd.Var1step:length(snd.Var1array)*2+5];           
        
        % Plots for 'alone' curve
        if ~isnan(com_alone)
            figure(findobj(0,'tag','disp_win_1'));    
            
            % BLUE: interpolated spikes
     		plot(int_x_alone,yi_alone, 'b','linewidth', 2);

            % MAGENTA: best value (measured by weighted average) and the values used to find it
            [minimum,com_index]=min(abs(xi_alone-com_alone));  % use this to find the xi value that is closest to com
			plot(int_x_alone(com_index),yi_alone(com_index),'.m','markersize',[25]); 
            [minimum,left_index]=min(abs(xi_alone-leftval_alone)); % use this to find the xi value that is closest to leftval_alone
            [minimum,right_index]=min(abs(xi_alone-rightval_alone)); % use this to find the xi value that is closest to rightval_alone
            plot(int_x_alone(left_index:right_index),yi_alone(left_index:right_index), 'm','linewidth', 2);
%             left_index = find(xi_alone==leftval_alone);
%             right_index= find(xi_alone==rightval_alone);
% 			plot([int_x_alone(left_index),int_x_alone(right_index)],[yi_alone(left_index),yi_alone(left_index)],'m', 'Linewidth', 2);                        

            % GREEN: bandwidth at half max
            if ~isnan(leftval_width_alone) && ~isnan(rightval_width_alone)
                left_index = find(xi_alone==leftval_width_alone);
                right_index= find(xi_alone==rightval_width_alone);            
                plot([int_x_alone(left_index),int_x_alone(right_index)],[yi_alone(left_index),yi_alone(left_index)],'g', 'Linewidth', 2);    
            end
        end      
        
        % Plots for 'both' curve
        if ~isnan(com_alone)        
            figure(findobj(0,'tag','disp_win_1'));  
            % BLUE: interpolated spikes            
            plot(int_x_both,yi_both, 'b','linewidth', 2);
            
            % MAGENTA: best value (measured by weighted average) and the values used to find it            
     		[minimum,com_index]=min(abs(xi_both-com_both));  % use this to find the xi value that is closest to com
			plot(int_x_both(com_index),yi_both(com_index),'.m','markersize',[25]); 
            [minimum,left_index]=min(abs(xi_both-leftval_both)); % use this to find the xi value that is closest to leftval_both
            [minimum,right_index]=min(abs(xi_both-rightval_both)); % use this to find the xi value that is closest to rightval_both
            plot(int_x_both(left_index:right_index),yi_both(left_index:right_index), 'm','linewidth', 2);            
%             left_index = find(xi_both==leftval_both);
%             right_index= find(xi_both==rightval_both);
% 			plot([int_x_both(left_index),int_x_both(right_index)],[yi_both(left_index),yi_both(left_index)],'m', 'Linewidth', 2); 

            % GREEN: bandwidth at half max            
            if ~isnan(leftval_width_both) && ~isnan(rightval_width_both)
                left_index = find(xi_both==leftval_width_both);
                right_index= find(xi_both==rightval_width_both);            
                plot([int_x_both(left_index),int_x_both(right_index)],[yi_both(left_index),yi_both(left_index)],'g', 'Linewidth', 2);    
            end
            
        end
        
        figure(findobj(0,'tag','disp_win_3'));     
        set(findobj(gcf,'tag','Var1_ba_label'),'string','Both');  
		set(findobj(gcf,'tag','Var1_alone_label'),'string','Alone');
        set(findobj(gcf,'tag','Var1_alone_ba_label'),'string',snd.Var1_choices(snd.Var1)); 
        set(findobj(gcf,'tag','var1_ba'),'string',round(com_both*10)/10);
        set(findobj(gcf,'tag','var1_width'),'string',round((rightval_width_both-leftval_width_both)*10)/10);
        set(findobj(gcf,'tag','var1_alone_ba'),'string',round(com_alone*10)/10);
        set(findobj(gcf,'tag','var1_alone_width'),'string',round((rightval_width_alone-leftval_width_alone)*10)/10);
    end    
    
    %% var1 ranging, var2 ranging, interleave alone
    %% (doesn't plot half-max width) 
    if snd.Var2~=7 && length(snd.Var2array)>1 && snd.interleave_alone==1   
        
        % Together
        dispy=squeeze(sum(dispmat,2));    
        dispx=squeeze(sum(dispmat,1));          
        [com_both1,leftval_both1,rightval_both1,xi_both1,yi_both1,leftval_width_both1,rightval_width_both1]= weighted_average(snd.Var1array,dispx,snd.ba_cutoff/100);
        [com_both2,leftval_both2,rightval_both2,xi_both1,yi_both2,leftval_width_both2,rightval_width_both2]= weighted_average(snd.Var2array,dispy,snd.ba_cutoff/100);
        
        % Alone
        [com_alone1,leftval_alone1,rightval_alone1,xi_alone1,yi_alone1,leftval_width_alone1,rightval_width_alone1]= weighted_average(snd.Var1array,disparr1,snd.ba_cutoff/100);
        [com_alone2,leftval_alone2,rightval_alone2,xi_alone2,yi_alone2,leftval_width_alone2,rightval_width_alone2]= weighted_average(snd.Var2array,disparr2,snd.ba_cutoff/100);
        
        % Not sure how to plot best values because I don't know what the existing plots are like
%        if ~isnan(xxxx)
%         axes(harray1)
%         plot(myu_one_alone_1,1.5, '*k');
%         axes(harray2)
%         plot(1.5,myu_one_alone_2, '*k');
%         axes(hmat)
%        end
        
        figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
        set(findobj(gcf,'tag','Var1_alone_ba_label'),'string',snd.Var1_choices(snd.Var1));   
        set(findobj(gcf,'tag','Var1_alone_label'),'string','Alone');  
        set(findobj(gcf,'tag','Var2_alone_ba_label'),'string',snd.Var2_choices(snd.Var2));   
        set(findobj(gcf,'tag','Var2_alone_label'),'string','Alone');  
        set(findobj(gcf,'tag','Var1_ba_label'),'string',snd.Var1_choices(snd.Var1));   
        set(findobj(gcf,'tag','Var2_ba_label'),'string',snd.Var2_choices(snd.Var2));           
        
        set(findobj(gcf,'tag','var1_alone_ba'),'string',round(com_alone1*10)/10);
        set(findobj(gcf,'tag','var2_alone_ba'),'string',round(com_alone2*10)/10); 
        set(findobj(gcf,'tag','var1_ba'),'string',round(com_both1*10)/10);
        set(findobj(gcf,'tag','var2_ba'),'string',round(com_both2*10)/10); 
        
        set(findobj(gcf,'tag','var1_alone_width'),'string',round((rightval_width_alone1 - leftval_width_alone1)*10)/10);
        set(findobj(gcf,'tag','var2_alone_width'),'string',round((rightval_width_alone2 - leftval_width_alone2)*10)/10); 
        set(findobj(gcf,'tag','var1_width'),'string',round((rightval_width_both1 - leftval_width_both1)*10)/10);
        set(findobj(gcf,'tag','var2_width'),'string',round((rightval_width_both2 - leftval_width_both2)*10)/10); 
    end    
    

    %%% Set the upper left graphing window to replace for the next trace.
    figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
	set(gca,'nextplot','replace')
    
       
    
    
    
% % % % % %   BELOW IS JOE'S ORIGINAL 'FIND_BEST_AREA' FUNCTION WHICH WE'RE NOT USING ANYMORE.
% % % % % %     tempmat=100*((dispmat-min(min(dispmat)))/(max(max(dispmat))-min(min(dispmat))));
% % % % % %     [var2_rf_pts,var1_rf_pts]=find(tempmat>=snd.ba_cutoff);
% % % % % %     
% % % % % %     %%get the spike counts for each point
% % % % % %     for i=[1:length(var2_rf_pts)];
% % % % % %         spike_counts(i)=tempmat(var2_rf_pts(i),var1_rf_pts(i));
% % % % % %     end;
% % % % % %     
% % % % % %     
% % % % % %     snd.var1_ba=sum(immultiply(snd.Var1array(var1_rf_pts),spike_counts)/sum(spike_counts));
% % % % % %     snd.var2_ba=sum(immultiply(snd.Var2array(var2_rf_pts),spike_counts)/sum(spike_counts));
% % % % % %     
% % % % % %     
% % % % % %     if or(snd.interleave_alone==0,min(size(dispmat))>1)
% % % % % %         if length(snd.Var2array)>1 & snd.Var2~=7
% % % % % %             snd.ba_handle(2)=line(snd.var1_ba,snd.var2_ba,'linestyle','none','color',[0,0,0],'marker','+');
% % % % % %         else
% % % % % %             snd.ba_handle(2)=line([snd.var1_ba,snd.var1_ba],get(gca,'ylim'),'linestyle',':','color',[0,0,0],'marker','+');
% % % % % %         end
% % % % % %         set(gca,'nextplot','replace');
% % % % % %                 
% % % % % %         %%plot the points that are involved in the average
% % % % % %         figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
% % % % % %         set(gca,'nextplot','add');
% % % % % %         if length(snd.Var2array)>1 & snd.Var2~=7
% % % % % %             snd.ba_handle(1)=line(snd.Var1array(var1_rf_pts),snd.Var2array(var2_rf_pts),'linestyle','none','color',[0,0,0],'marker','.');
% % % % % %         else
% % % % % %             snd.ba_handle(1)=bar(snd.Var1array(var1_rf_pts),transpose(dispmat(1,var1_rf_pts)),'-.r');
% % % % % %         end
% % % % % % 
% % % % % %         %%  print the best area        
% % % % % %         figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
% % % % % %         if length(snd.Var2array)>1 & snd.Var2~=7
% % % % % %             set(findobj(gcf,'tag','var1_ba'),'string',num2str(round(snd.var1_ba*10)/10));
% % % % % %             set(findobj(gcf,'tag','var2_ba'),'string',num2str(round(snd.var2_ba*10)/10));
% % % % % %             set(findobj(gcf,'tag','Var1_ba_label'),'string',snd.Var1_choices(snd.Var1));
% % % % % %             set(findobj(gcf,'tag','Var2_ba_label'),'string',snd.Var2_choices(snd.Var2));
% % % % % %         else
% % % % % %             set(findobj(gcf,'tag','var1_ba'),'string',num2str(round(snd.var1_ba*10)/10));
% % % % % %             set(findobj(gcf,'tag','Var1_ba_label'),'string',snd.Var1_choices(snd.Var1));
% % % % % %         end
% % % % % %     end
% % % % % %     
% % % % % %    
% % % % % %     if snd.interleave_alone==1        
% % % % % %         %%%find Var1 alone
% % % % % %         tempmat=100*((disparr1(1,:)-min(min(disparr1)))/(max(max(disparr1))-min(min(disparr1))));
% % % % % %         var1_rf_pts=find(tempmat>=snd.ba_cutoff);
% % % % % %         snd.var1_inter_ba=sum(immultiply(snd.Var1array(var1_rf_pts),tempmat(var1_rf_pts))/sum(tempmat(var1_rf_pts)));
% % % % % %         
% % % % % %         %%%find Var2 alone
% % % % % %         tempmat=100*((disparr2(:,1)-min(min(disparr2)))/(max(max(disparr2))-min(min(disparr2))));
% % % % % %         var2_rf_pts=find(tempmat>=snd.ba_cutoff);
% % % % % %         snd.var2_inter_ba=sum(immultiply(transpose(snd.Var2array(var2_rf_pts)),tempmat(var2_rf_pts))/sum(tempmat(var2_rf_pts)));
% % % % % %                 
% % % % % %         figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
% % % % % %         if size(dispmat,2)>1        
% % % % % %             set(findobj(gcf,'tag','var1_ba'),'string',num2str(round(snd.var1_ba*10)/10));
% % % % % %             set(findobj(gcf,'tag','var1_alone_ba'),'string',num2str(round(snd.var1_inter_ba*10)/10));
% % % % % %             set(findobj(gcf,'tag','Var1_ba_label'),'string',snd.Var1_choices(snd.Var1));
% % % % % %             set(findobj(gcf,'tag','Var1_alone_ba_label'),'string',snd.Var1_choices(snd.Var1));
% % % % % %         end
% % % % % %         if size(dispmat,1)>1
% % % % % %             set(findobj(gcf,'tag','var2_ba'),'string',num2str(round(snd.var2_ba*10)/10));
% % % % % %             set(findobj(gcf,'tag','var2_alone_ba'),'string',num2str(round(snd.var2_inter_ba*10)/10));
% % % % % %             set(findobj(gcf,'tag','Var2_ba_label'),'string',snd.Var2_choices(snd.Var2));
% % % % % %             set(findobj(gcf,'tag','Var2_alone_ba_label'),'string',snd.Var2_choices(snd.Var2));
% % % % % %         end   
% % % % % %     end
    
return;