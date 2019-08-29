  function set_matrix_graph(currentrep)
    global rec snd;
        if size(snd.datamat_pre,1)>1 & size(snd.datamat_pre,2)>1                  %%  display a contour plot if possible
            if snd.graph_type==1    %%display type is adjusted
                dispmat=(snd.datamat_post(:,:,rec.dispch)-((snd.posttime/snd.pre)*(snd.datamat_pre(:,:,rec.dispch))))/currentrep;   %%  subtract the average pre and devide by reps
            end
            if snd.graph_type==2    %%display type is pre
                dispmat=snd.datamat_pre(:,:,rec.dispch)/currentrep;   %%  subtract the average pre and devide by reps
            end
            if snd.graph_type==3    %%display type is post
                dispmat=snd.datamat_post(:,:,rec.dispch)/currentrep;   %%  subtract the average pre and devide by reps
            end
            if snd.graph_type==4    %%display type is post
                tempmax=max(max(snd.datamat_post(:,:,rec.dispch)));
                tempmin=min(min(snd.datamat_post(:,:,rec.dispch)));
                if tempmin==tempmax %%cannot be normalized
                    dispmat=snd.datamat_post(:,:,rec.dispch);
                    else
                    dispmat=(snd.datamat_post(:,:,rec.dispch)-tempmin)*100/(tempmax-tempmin);
                end
            end
            
            figure(findobj(0,'tag','disp_win_1'));     %% set the first window as active
            contourf(snd.Var1array,snd.Var2array,dispmat,100);       %%show contour plot of one Channel
            colorbar;       %%show a reference bar for the contour plot
            h=get(gca,'children');
            set(h,'linestyle','none');
            xlabel(snd.Var1_choices(snd.Var1));
            ylabel(snd.Var2_choices(snd.Var2));
            set(get(gca,'xlabel'),'fontsize',14);
            set(get(gca,'ylabel'),'fontsize',14);
            title(['Trace= ' num2str(snd.trace) '        channel= ' num2str(rec.dispch)]);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end;

  
return;