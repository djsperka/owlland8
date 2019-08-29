function remove_stim_list()
global snd
        var1_array=[snd.Var1min:snd.Var1step:snd.Var1max];
        var2_array=[snd.Var2min:snd.Var2step:snd.Var2max];

            figure(findobj(0,'tag','stim_grid_win'));     %% set the third window as active
            [xa,ya]=ginput(1);
            [xb,yb]=ginput(1);
            xi=min(xa,xb);
            xii=max(xa,xb);
            yi=min(ya,yb);
            yii=max(ya,yb);
            
            temparray=abs(var2_array-yi);
            tcv2min=find(temparray==min(temparray));
            temparray=abs(var2_array-yii);
            tcv2max=find(temparray==min(temparray));
            temparray=abs(var1_array-xi);
            tcv1min=find(temparray==min(temparray));
            temparray=abs(var1_array-xii);
            tcv1max=find(temparray==min(temparray));
            if snd.Var2==7
                for i=[1:length(snd.stim_list)]
                    if snd.stim_list(i)>=tcv1min & snd.stim_list(i)<=tcv1max
                        snd.stim_list(i)=0;
                    end
                end
              else

                for i=[1:length(snd.stim_list)]
                    [Var2_place,Var1_place]=ind2sub([length(var2_array),length(var1_array)],snd.stim_list(i));
                    if Var1_place>=tcv1min & Var1_place<=tcv1max & Var2_place>=tcv2min & Var2_place<=tcv2max
                        snd.stim_list(i)=0;
                    end
                end
            end

snd.stim_list=snd.stim_list(find(snd.stim_list));
        close
        show_stim_grid


return;
