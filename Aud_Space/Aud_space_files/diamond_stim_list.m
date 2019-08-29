function diamond_stim_list()
    global snd
            var1_array=[snd.Var1min:snd.Var1step:snd.Var1max];
        var2_array=[snd.Var2min:snd.Var2step:snd.Var2max];

    
    width=(get(findobj(gcf,'tag','cross'),'value')*2)-1;
    half_width=(width-1)/2;
    [x,y]=ginput(1);
    [xi,yi]=ginput(1);

            temparray=abs(var2_array-y);
            ycenter=find(temparray==min(temparray));
            temparray=abs(var1_array-x);
            xcenter=find(temparray==min(temparray));
            temparray=abs(var2_array-yi);
            yedge=find(temparray==min(temparray));
            temparray=abs(var1_array-xi);
            xedge=find(temparray==min(temparray));
            
            edge=max(abs([(ycenter-yedge),(xcenter-xedge)]));

% %             [xcenter,ycenter]
% %             [var1_array(xcenter),var2_array(ycenter)]

            add_place=1;
            add_array=[];
            
            
        if snd.Var2~=7
            for k=[0:edge]
                for i=[xcenter-k:xcenter+k]
                    for j=[(ycenter-(edge-k)):(ycenter+(edge-k))]
                        if i>0 & i<=length(var1_array) & j>0 & j<=length(var2_array)
                            add_array(add_place)=sub2ind([length(var2_array),length(var1_array)],j,i);
                            add_place=add_place+1;
                        end
                    end
                end
            end
        end
    snd.stim_list=union(snd.stim_list,add_array);
        close
        show_stim_grid

    
return
    
