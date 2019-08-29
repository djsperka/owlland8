function [myu, c] =fit_gauss_AS()

    global snd rec harray1 harray2 hmat;
    
    if snd.graph_type==1    %%display type is adjusted
        dispmat=(snd.datamat_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.datamat_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
    end
    if snd.graph_type==2    %%display type is pre
        dispmat=snd.datamat_pre(:,:,rec.dispch)/snd.reps;   
    end
    if snd.graph_type==3    %%display type is post
        dispmat=snd.datamat_post(:,:,rec.dispch)/snd.reps;   
    end
    if snd.graph_type==4    %%display type is normal
        tempmin=min(min(snd.datamat_post(:,:,rec.dispch)));
        tempmax=max(max(snd.datamat_post(:,:,rec.dispch)));
        if tempmin==tempmax %%cannot be normalized
            dispmat=snd.datamat_post(:,:,rec.dispch);
        else
            dispmat=(snd.datamat_post(:,:,rec.dispch)-tempmin)*100/(tempmax-tempmin);
        end
    end
    
    if snd.interleave_alone==1  %%if there is interleaved alone trials
        if snd.graph_type==1    %%display type is adjusted
            disparr1=(snd.data_arr1_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.data_arr1_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
            disparr2=(snd.data_arr2_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.data_arr2_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
        end
        if snd.graph_type==2    %%display type is pre
            disparr1=snd.data_arr1_pre(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and divide by reps
            disparr2=snd.data_arr2_pre(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and divide by reps
        end
        if snd.graph_type==3    %%display type is post
            disparr1=snd.data_arr1_post(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and divide by reps
            disparr2=snd.data_arr2_post(:,:,rec.dispch)/snd.reps;   %%  subtract the average pre and divide by reps
        end
        if snd.graph_type==4    %%display type is normal
            min1=min(data_arr1_post(:,:,rec.dispch));
            max1=max(data_arr1_post(:,:,rec.dispch));
            min2=min(data_arr2_post(:,:,rec.dispch));
            max2=max(data_arr2_post(:,:,rec.dispch));
            disparr1=(snd.data_arr1_post(:,:,rec.dispch)-min1)/(max1-min1);   %%  subtract the average pre and divide by reps
            disparr2=(snd.data_arr2_post(:,:,rec.dispch)-min2)/(max2-min2);   %%  subtract the average pre and divide by reps
        end
            disparr1=squeeze(disparr1(1,:));   %%  originally has two rows
            disparr2=squeeze(disparr2(:,1));   %%  originally has two columns

    end

    %%  clear the graphs of previous best area plots.
    set_graphs(snd.reps)        

    
    % For the rest of the function, set the upper left graphing window as
    % active, and have the plots add rather than replace each other.
    figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
	set(gca,'nextplot','add')

    
    
   %% var1 ranging, no var2 (simple tuning curve) 
   if snd.Var2==7 && snd.interleave_alone==0         
        myu_seed=snd.Var1array(find(dispmat==max(dispmat))); %first guess at mean is whatever value got most spikes
        sig_seed=(max(snd.Var1array)-min(snd.Var1array))/4; % first guess at width
        
        % nlinfit returns mean and standard-deviation of the gauss that best fits the data
        lastwarn('');
        [beta,r,J] =nlinfit(snd.Var1array,dispmat,@gauss,[myu_seed sig_seed max(dispmat) min(dispmat)]);
        no_converge=lastwarn;  % check for warning if fit didn't converge. *note: to make this work I had to change
            % the Matlab nlinfit function to use 'warning' rather than 'disp' when gauss didn't converge.*
        
        if isempty(no_converge) % if nlinfit converged correctly, plot the gauss
			myu=beta(1);
			confidence=nlparci(beta,r,J);
			c=confidence(1,:);
            figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
			%set(gca,'nextplot','add');
		
            % fit a gaussian to the data.  give "gauss" function the mean, standard deviation, and the interpolated Var1array.
            int_Var1array=interp1(snd.Var1array, snd.Var1array,  [snd.Var1min:1:snd.Var1max], 'linear' ); % interpolate Var1array into steps 1
            fitgauss = gauss(beta,int_Var1array);
            plot(int_Var1array, fitgauss, 'r','Linewidth',2);
            % calculate half-max of the fitted gauss
            halfmax = (max(fitgauss) - min(fitgauss)) / 2 + min(fitgauss);
            halfmax_pointer = find (fitgauss >= halfmax);  
            halfmax_pointer=[min(halfmax_pointer),max(halfmax_pointer)];        
            plot (int_Var1array(halfmax_pointer), [halfmax,halfmax], 'r', 'Linewidth', 2);  % plot halfmax width
            halfwidth = abs(diff(int_Var1array(halfmax_pointer)));   
        end
       % set(gca,'nextplot','replace')
        
        figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
        set(findobj(gcf,'tag','Var1_ba_label'),'string',snd.Var1_choices(snd.Var1));
        if (no_converge)
            set(findobj(gcf,'tag','var1_ba'),'string','n/a');
            set(findobj(gcf,'tag','var1_width'),'string','n/a');            
        else
            set(findobj(gcf,'tag','var1_ba'),'string',round(myu*10)/10);
            set(findobj(gcf,'tag','var1_width'),'string',round(halfwidth*10)/10);
        end
    end

   %% var1 ranging, var2 ranging (matrix tuning curve)
   %% (doesn't compute half-max width) 
   if snd.Var2~=7 && length(snd.Var2array)>1 
        dispy=squeeze(sum(dispmat,2));    %%flatten data except for ITD info
        dispx=squeeze(sum(dispmat,1));    %%flatten data except for ITD info

        lastwarn('');               
		%[betax,r,J] =nlinfit(snd.Var1array,(dispx-min(dispx))/(max(dispx)-min(dispx)),@gauss,[mean(snd.Var1array) (max(snd.Var1array)-min(snd.Var1array))/4]);
        myu_seed=snd.Var1array(find(dispx==max(dispx)));
        sig_seed=(max(snd.Var1array)-min(snd.Var1array))/4;
        [betax,r,J] =nlinfit(snd.Var1array,dispx,@gauss,[myu_seed sig_seed max(dispx) min(dispx)]);
        x_no_converge=lastwarn;
        myux=betax(1); 
        sigx=abs(betax(2)); 
                
		% [betay,r,J] =nlinfit(snd.Var2array,(dispy-min(dispy))/(max(dispy)-min(dispy)),@gauss,[mean(snd.Var2array) (max(snd.Var2array)-min(snd.Var2array))/4 max(dispy) min(dispy)]);
        lastwarn('');  
        myu_seed=snd.Var2array(find(dispy==max(dispy)));
        sig_seed=(max(snd.Var2array)-min(snd.Var2array))/4;     
		[betay,r,J] =nlinfit(snd.Var2array,dispy,@gauss,[myu_seed sig_seed max(dispy) min(dispy)]);
        myuy=betay(1); 
        sigy=abs(betay(2)); 
        y_no_converge=lastwarn;  
        
        if isempty(y_no_converge) && isempty(x_no_converge) % if nlinfit converged correctly
            figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
			%set(gca,'nextplot','add')
            rectangle('Position',[myux-sigx,myuy-sigy,sigx*2,sigy*2],'Curvature',[1,1])
            plot(myux,myuy, '*k');
        end
        
        figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
        set(findobj(gcf,'tag','Var1_ba_label'),'string',snd.Var1_choices(snd.Var1));   
        set(findobj(gcf,'tag','Var2_ba_label'),'string',snd.Var2_choices(snd.Var2));    
        if isempty(x_no_converge) 
            set(findobj(gcf,'tag','var1_ba'),'string',round(myux*10)/10);
        else        
            set(findobj(gcf,'tag','var1_ba'),'string','n/a');
        end
        if isempty(y_no_converge)
            set(findobj(gcf,'tag','var2_ba'),'string',round(myuy*10)/10);
        else  
            set(findobj(gcf,'tag','var2_ba'),'string','n/a');
        end
        
    end 

    %% var1 ranging, var2 constant, always both
    if snd.Var2~=7 && length(snd.Var2array)==1 && snd.interleave_alone==0  

        myu_seed=snd.Var1array(find(dispmat==max(dispmat))); %first guess at mean is whatever value got most spikes
        sig_seed=(max(snd.Var1array)-min(snd.Var1array))/4; 
        lastwarn(''); 
		[beta,r,J] =nlinfit(snd.Var1array,dispmat,@gauss,[myu_seed sig_seed max(dispmat) min(dispmat)]);
        no_converge=lastwarn;
		myu=beta(1);
        
        if isempty(no_converge)  % if nlinfit converged correctly
			confidence=nlparci(beta,r,J);
			c=confidence(1,:);
            figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
			%set(gca,'nextplot','add')
            int_Var1array=interp1(snd.Var1array, snd.Var1array,  [snd.Var1min:1:snd.Var1max], 'linear' );
            
            fitgauss = gauss(beta,int_Var1array);   % *(max(dispmat)-min(dispmat))+min(dispmat);
			plot(int_Var1array, fitgauss, 'r','Linewidth',2);
            halfmax = (max(fitgauss) - min(fitgauss)) / 2 + min(fitgauss);
            halfmax_pointer = find (fitgauss >= halfmax);  
            halfmax_pointer=[min(halfmax_pointer),max(halfmax_pointer)];        
            plot (int_Var1array(halfmax_pointer), [halfmax,halfmax], 'r', 'Linewidth', 2);  % plot halfmax width
            halfwidth = abs(diff(int_Var1array(halfmax_pointer)));   	
        end
        %set(gca,'nextplot','replace')
        
        figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
        set(findobj(gcf,'tag','Var1_ba_label'),'string','Both');
        if isempty(no_converge)
            set(findobj(gcf,'tag','var1_ba'),'string',round(myu*10)/10);
            set(findobj(gcf,'tag','var1_width'),'string',round(halfwidth*10)/10);
        else
            set(findobj(gcf,'tag','var1_ba'),'string','n/a');
            set(findobj(gcf,'tag','var1_width'),'string','n/a');           
        end
    end
 
    %% var1 ranging, var2 constant, interleave alone
    if snd.Var2~=7 && length(snd.Var2array)==1 && snd.interleave_alone==1   
                
        myu_seed=snd.Var1array(find(dispmat==max(dispmat))); %first guess at mean is whatever value got most spikes
        sig_seed=(max(snd.Var1array)-min(snd.Var1array))/4;
        lastwarn(''); 
		[beta,r,J] =nlinfit(snd.Var1array,dispmat,@gauss,[myu_seed sig_seed max(dispmat) min(dispmat)]);
        both_no_converge=lastwarn;
        myu_both=beta(1);
        
        myu_seed=snd.Var1array(find(disparr1==max(disparr1)));
        lastwarn('');
        [beta_alone,r,J] =nlinfit(snd.Var1array,disparr1,@gauss,[myu_seed sig_seed max(disparr1) min(disparr1)]);
        alone_no_converge=lastwarn;
        myu_one_alone=beta_alone(1);
        
        figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
		%set(gca,'nextplot','add')
        int_x_alone=[1:.05:length(snd.Var1array)];
        int_x=[6+length(snd.Var1array):.05:length(snd.Var1array)*2+5];
        int_Var1array=interp1(snd.Var1array, snd.Var1array,  [snd.Var1min:.05*snd.Var1step:snd.Var1max], 'linear' );        
        
       if isempty(alone_no_converge)  % if nlinfit converged correctly            
            % 'Alone' curve gauss
            fitgauss = gauss(beta_alone,int_Var1array); % *(max(disparr1)-min(disparr1))+min(disparr1);
            plot(int_x_alone, fitgauss, 'r','Linewidth',2);  % plot gauss
            halfmax = (max(fitgauss) - min(fitgauss)) / 2 + min(fitgauss);
            halfmax_pointer = find (fitgauss >= halfmax);  
            halfmax_pointer=[min(halfmax_pointer),max(halfmax_pointer)];        
            plot (int_x_alone(halfmax_pointer), [halfmax,halfmax], 'r', 'Linewidth', 2);  % plot halfmax width
            halfwidth_alone = abs(diff(int_Var1array(halfmax_pointer)));
       end
       if isempty(both_no_converge)  % if nlinfit converged correctly
            % 'Both' curve gauss
            fitgauss = gauss(beta,int_Var1array); % *(max(dispmat)-min(dispmat))+min(dispmat);
            plot(int_x, fitgauss, 'r','Linewidth',2);
            halfmax = (max(fitgauss) - min(fitgauss)) / 2 + min(fitgauss);        
            halfmax_pointer = find (fitgauss >= halfmax);  
            halfmax_pointer=[min(halfmax_pointer),max(halfmax_pointer)];        
            plot (int_x(halfmax_pointer), [halfmax,halfmax], 'r', 'Linewidth', 2);
            halfwidth = abs(diff(int_Var1array(halfmax_pointer)));            
        end
        %set(gca,'nextplot','replace')

        figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
        set(findobj(gcf,'tag','Var1_ba_label'),'string','Both');  
		set(findobj(gcf,'tag','Var1_alone_label'),'string','Alone');
        set(findobj(gcf,'tag','Var1_alone_ba_label'),'string',snd.Var1_choices(snd.Var1)); 

        if isempty(both_no_converge)
            set(findobj(gcf,'tag','var1_ba'),'string',round(myu_both*10)/10);
            set(findobj(gcf,'tag','var1_width'),'string',round(halfwidth*10)/10);
        else            
            set(findobj(gcf,'tag','var1_ba'),'string','n/a');
            set(findobj(gcf,'tag','var1_width'),'string','n/a');
        end            
        if isempty(alone_no_converge)
            set(findobj(gcf,'tag','var1_alone_ba'),'string',round(myu_one_alone*10)/10);
            set(findobj(gcf,'tag','var1_alone_width'),'string',round(halfwidth_alone*10)/10);
        else
            set(findobj(gcf,'tag','var1_alone_ba'),'string','n/a');
            set(findobj(gcf,'tag','var1_alone_width'),'string','n/a');
        end           
       
    end
    
    %% var1 ranging, var2 ranging, interleave alone
    %% (doesn't compute half-max width) 
    if snd.Var2~=7 && length(snd.Var2array)>1 && snd.interleave_alone==1   
        
        myu_seed=snd.Var1array(find(disparr1==max(disparr1))); %first guess at mean is whatever value got most spikes
        sig_seed=(max(snd.Var1array)-min(snd.Var1array))/4;
        lastwarn(''); 
        [beta_alone_1,r,J] =nlinfit(snd.Var1array,disparr1,@gauss,[myu_seed sig_seed max(disparr1) min(disparr1)]);
		myu_one_alone_1=beta_alone_1(1);
        alone1_no_converge=lastwarn;
        
        myu_seed=snd.Var2array(find(disparr2==max(disparr2)));
        sig_seed=(max(snd.Var2array)-min(snd.Var2array))/4;
        lastwarn(''); 
        [beta_alone_2,r,J] =nlinfit(snd.Var2array,disparr2,@gauss,[myu_seed sig_seed max(disparr2) min(disparr2)]);
		myu_one_alone_2=beta_alone_2(1);
        alone2_no_converge=lastwarn;

        if (isempty(alone1_no_converge) && isempty(alone2_no_converge)) % if nlinfit converged correctly
            axes(harray1)
			%set(gca,'nextplot','add')
            plot(myu_one_alone_1,1.5, '*k');
			%set(gca,'nextplot','replace')
            
            axes(harray2)
			%set(gca,'nextplot','add')
            
            plot(1.5,myu_one_alone_2, '*k');
			%set(gca,'nextplot','replace')
	
            axes(hmat)
        end
        
        figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
        set(findobj(gcf,'tag','Var1_alone_ba_label'),'string',snd.Var1_choices(snd.Var1));   
        set(findobj(gcf,'tag','Var1_alone_label'),'string','Alone');  
        set(findobj(gcf,'tag','Var2_alone_ba_label'),'string',snd.Var2_choices(snd.Var2));   
        set(findobj(gcf,'tag','Var2_alone_label'),'string','Alone');  
        if isempty(alone1_no_converge)             
            set(findobj(gcf,'tag','var1_alone_ba'),'string',round(myu_one_alone_1*10)/10);
        else
            set(findobj(gcf,'tag','var1_alone_ba'),'string','n/a');
        end
        if isempty(alone2_no_converge)               
            set(findobj(gcf,'tag','var2_alone_ba'),'string',round(myu_one_alone_2*10)/10);        
        else
            set(findobj(gcf,'tag','var2_alone_ba'),'string','n/a');        
        end            
    end
    
    
    %%% Set the upper left graphing window to replace for the next trace.
    figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
	set(gca,'nextplot','replace')

return;