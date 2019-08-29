function add_stim_list()
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
            add_place=1;
            add_array=[];
            
            
        if snd.Var2==7
            add_array=[tcv1min:tcv1max];
          else
            for i=[tcv1min:tcv1max]
            for j=[tcv2min:tcv2max]
                    add_array(add_place)=sub2ind([length(var2_array),length(var1_array)],j,i);
                    add_place=add_place+1;
            end
            end
        end

        
    snd.stim_list=union(snd.stim_list,add_array);
        close
        show_stim_grid


return;
