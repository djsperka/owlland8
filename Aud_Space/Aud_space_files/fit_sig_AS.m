function [myu, c] =fit_sig_AS()

    global snd rec;
    
    %% Normal 
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
            
    %%  clear the graphs of previous best area plots.
    set_graphs(snd.reps)        
    
    %% Interleave (just does disparr1, not disparr2. for now I'm assuming that var2 is not ranging)
    if snd.interleave_alone==1        
			if snd.graph_type==1    %%display type is adjusted                
                temp_disparr1=(snd.data_arr1_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.data_arr1_pre(:,:,rec.dispch))))/snd.reps;   %%  subtract the average pre and devide by reps
			end
			if snd.graph_type==2    %%display type is pre
                temp_disparr1=snd.data_arr1_pre(:,:,rec.dispch)/snd.reps;   
			end
			if snd.graph_type==3    %%display type is post
                temp_disparr1=snd.data_arr1_post(:,:,rec.dispch)/snd.reps; 
                
			end
			if snd.graph_type==4    %%display type is normal
                tempmin=min(min(snd.data_arr1_post(:,:,rec.dispch)));
                tempmax=max(max(snd.data_arr1_post(:,:,rec.dispch)));
                if tempmin==tempmax %%cannot be normalized
                    temp_disparr1=snd.data_arr1_post(:,:,rec.dispch);
                else
                    temp_disparr1=(snd.data_arr1_post(:,:,rec.dispch)-tempmin)*100/(tempmax-tempmin);
                end
			end   
            
            % for some reason all of data_arr1 arrays have 2 rows of repeated information, which means that temp_disparr1 
            % does as well. change it to a single row so you can use it in functions below. there is probably a  
            % prettier way to do this! 
            [rows,columns] = size (temp_disparr1);
             for (j=1:columns)
                 disparr1(j) = temp_disparr1(1,j);
             end

         end
        
        
        
    
    
    %% var1 ranging, var2 constant, interleave alone (KM-- for stim/no stim ABI curves) 
    if snd.Var2~=7 && length(snd.Var2array)==1 && snd.interleave_alone==1   

        figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
		set(gca,'nextplot','add')		
        int_x_alone=[1:.05:length(snd.Var1array)];
        int_x=[6+length(snd.Var1array):.05:length(snd.Var1array)*2+5];    % does this apply to these curves????
 		int_Var1array=interp1(snd.Var1array, snd.Var1array,  [snd.Var1min:.05*snd.Var1step:snd.Var1max], 'linear' );
      
        % 'Both' curve
		[beta,r,J] =nlinfit(snd.Var1array,(dispmat-min(dispmat))/(max(dispmat)-min(dispmat)),@sig,[mean(snd.Var1array) 10]);
		myu_both=beta(1);
		confidence=nlparci(beta,r,J);
		c=confidence(1,:);
 		fitsig_both = sig(beta,int_Var1array)*(max(dispmat)-min(dispmat))+min(dispmat);
 		plot(int_x, fitsig_both, 'r','Linewidth',2);   % error plotting vectors of diff. lengths

        % 'Alone' curve
        [beta_alone,r,J] =nlinfit(snd.Var1array,(disparr1-min(disparr1))/(max(disparr1)-min(disparr1)),@sig,[mean(snd.Var1array) 10]);
		myu_alone=beta_alone(1);
		confidence=nlparci(beta_alone,r,J);
		c_alone=confidence(1,:);
 		fitsig_alone = sig(beta_alone,int_Var1array)*(max(disparr1)-min(disparr1))+min(disparr1);
 		plot(int_x_alone, fitsig_alone, 'r','Linewidth',2);

		set(gca,'nextplot','replace')		
		figure(findobj(0,'tag','disp_win_3'));     %% set the third window as active
		set(findobj(gcf,'tag','var1_ba'),'string',round(myu_both*10)/10);
		set(findobj(gcf,'tag','Var1_ba_label'),'string','Both');

        set(findobj(gcf,'tag','var1_alone_ba'),'string',round(myu_alone*10)/10);
		set(findobj(gcf,'tag','Var1_alone_ba_label'),'string',snd.Var1_choices(snd.Var1));
		set(findobj(gcf,'tag','Var1_alone_label'),'string','Alone');

        
    %% for now, just group all other conditions together (code will break for
    %% cases where var1 and var2 both ranging, but before it broke for
    %% everything but simple curves-- so having the above case is better than nothing)
    else
                
		[beta,r,J] =nlinfit(snd.Var1array,(dispmat-min(dispmat))/(max(dispmat)-min(dispmat)),@sig,[mean(snd.Var1array) 10]);
		myu=beta(1);
		
		confidence=nlparci(beta,r,J);
		c=confidence(1,:);
		
		figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
		set(gca,'nextplot','add')
		
		int_Var1array=interp1(snd.Var1array, snd.Var1array,  [snd.Var1min:1:snd.Var1max], 'linear' );
		fitsig = sig(beta,int_Var1array)*(max(dispmat)-min(dispmat))+min(dispmat);
		plot(int_Var1array, fitsig, 'r','Linewidth',2);
		set(gca,'nextplot','replace')
		
		figure(findobj(0,'tag','disp_win_3'));     %% set the first window as active
		set(findobj(gcf,'tag','var1_ba'),'string',round(myu*10)/10);
		set(findobj(gcf,'tag','Var1_ba_label'),'string',snd.Var1_choices(snd.Var1));
    end
    
return;