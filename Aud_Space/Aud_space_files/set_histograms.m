  function set_histograms(currentrep)
    global rec snd;
    
            if snd.graph_type==1    %%display type is adjusted
                dispmat=(snd.datamat_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.datamat_pre(:,:,rec.dispch))))/currentrep;   %%  subtract the average pre and devide by reps
            end
            if snd.graph_type==2    %%display type is pre
                dispmat=snd.datamat_pre(:,:,rec.dispch)/currentrep;   
            end
            if snd.graph_type==3    %%display type is post
                dispmat=snd.datamat_post(:,:,rec.dispch)/currentrep;   
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
%             dispmat=(snd.datamat_post(:,:,rec.dispch)-((snd.post/snd.pre)*(snd.datamat_pre(:,:,rec.dispch))))/currentrep;   %%  subtract the average pre and devide by reps
            
            figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
            bar(snd.Var1array,transpose(dispmat(1,:)));
            xlabel(snd.Var1_choices(snd.Var1));
            ylabel('spikes');
            set(get(gca,'xlabel'),'fontsize',14);
            set(gca,'xlim',[(snd.Var1min-(0.5*snd.Var1step)),(snd.Var1max+(0.5*snd.Var1step))]);
            set(get(gca,'ylabel'),'fontsize',14);
            title(['Trace= ' num2str(snd.trace) '        channel= ' num2str(rec.dispch)]);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if snd.show_error_bars==1
                rep_hist_pre=zeros(snd.reps,length(dispmat));
                rep_hist_post=zeros(snd.reps,length(dispmat));

                for i=[1:currentrep]
                    for j=[1:length(snd.Var1array)]
                        rep_hist_pre(i,j)=length(find(snd.datatime<0 & snd.dataVar1==snd.Var1array(j) & snd.datarep==i));
                        rep_hist_post(i,j)=length(find(snd.datatime>=snd.rangemin & snd.datatime<=snd.rangemax & snd.datarep==i & snd.dataVar1==snd.Var1array(j)));
                    end
                end
                
                if snd.graph_type==1    %%display type is adjusted
                    errmat=rep_hist_post-rep_hist_pre;
                end
                if snd.graph_type==2    %%display type is pre
                    errmat=rep_hist_pre;
                end
                if snd.graph_type==3    %%display type is post
                    errmat=rep_hist_post;
                end
                if snd.graph_type==4    %%display type is normal
                    if tempmin==tempmax %%cannot be normalized
                        errmat=rep_hist_post;
                    else
                        errmat=(rep_hist_post-tempmin)*100/(tempmax-tempmin);
                    end
                end

                
                
            set(gca,'nextplot','add')
            errorbar(snd.Var1array,transpose(dispmat(1,:)),std(errmat)/sqrt(currentrep),'k.');
            set(gca,'nextplot','replace')

        end
        
        
        figure(findobj(0,'tag','Aud_Space_win'));     %% set the main window as active
  
return;