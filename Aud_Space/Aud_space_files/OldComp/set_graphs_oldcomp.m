function set_graphs(rep)
    global rec snd;
    figure(findobj(0,'tag','disp_win_3'));
    snd.graph_type=get(findobj(gcf,'tag','graph_type'),'value');
    snd.show_error_bars=get(findobj(gcf,'tag','show_error_bars'),'value');
    snd.interloom_type=get(findobj(gcf,'tag','interloom_type'),'value'); %added DJT 6/26/2013

    %%clear all of the labels   
    set(findobj(gcf,'tag','Var1_alone_ba_label'),'string','');   
    set(findobj(gcf,'tag','Var1_alone_label'),'string','');  
    set(findobj(gcf,'tag','Var2_alone_ba_label'),'string','');   
    set(findobj(gcf,'tag','Var2_alone_label'),'string','');  
    set(findobj(gcf,'tag','Var1_ba_label'),'string','');   
    set(findobj(gcf,'tag','Var2_ba_label'),'string','');            
    set(findobj(gcf,'tag','var1_alone_ba'),'string','');  
    set(findobj(gcf,'tag','var2_alone_ba'),'string','');  
    set(findobj(gcf,'tag','var1_ba'),'string','');  
    set(findobj(gcf,'tag','var2_ba'),'string','');  
    set(findobj(gcf,'tag','var1_alone_width'),'string','');  
    set(findobj(gcf,'tag','var2_alone_width'),'string','');  
    set(findobj(gcf,'tag','var1_width'),'string','');  
    set(findobj(gcf,'tag','var2_width'),'string','');  
    set(findobj(gcf,'tag','Var1_extra_label'),'string','');  
    set(findobj(gcf,'tag','Var2_extra_label'),'string','');  
        
    snd.ba_handle=0;        %%delete the handle to the best area plot

        
    if nargin==0        %%make snd.reps the default value
        rep=snd.reps;
    end
        
        
    if snd.interleave_alone==1      %%if there were interleaved trials of single variables
        set_inter_graphs(rep);
        
      else
        if snd.Var2~=7
            if length(snd.Var2array)~=1
                set_matrix_graph(rep)
              else
                set_histograms(rep)
                set_raster(rep)
            end;
        end
        
        if snd.Var2==7  %%  if the second variable is 'none'  display a histogram
            set_histograms(rep)
                set_raster(rep);
        end;
    end
    

return;
