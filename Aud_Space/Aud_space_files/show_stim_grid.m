function show_stim_grid()
        global snd
        var1_array=[snd.Var1min:snd.Var1step:snd.Var1max];
        var2_array=[snd.Var2min:snd.Var2step:snd.Var2max];
       
        if findobj(0,'tag','stim_grid_win')>=1
            figure(findobj(0,'tag','stim_grid_win'));     %% set the first window as active
            close
        end    %%open a new window
 
   figure('position',[4,34,500,500],'menubar','none','tag','stim_grid_win');
       c=get(gcf,'color');

   ha1=axes('units','normalized','position', [.1 .3 .85 .65],'tag','stim_grid','nextplot','add');
            set(gca,'XLimmode','manual','XLim',[snd.Var1min,snd.Var1max],'XTick',var1_array);
            if snd.Var2==7
                set(gca,'YLimmode','manual','YLim',[-1,1],'YTick',[]);
              else
                set(gca,'YLimmode','manual','YLim',[snd.Var2min,snd.Var2max],'YTick',var2_array);
            end
            xlabel(snd.Var1_choices(snd.Var1));
            ylabel(snd.Var2_choices(snd.Var2));
            
   uicontrol('style','pushbutton',...
        'units','normalized',...
        'position', [.1 .1 .15 .05],...
        'horizontalalignment','center',...
        'string','Clear',...
        'callback','clear_stim_list');
   uicontrol('style','pushbutton',...
        'units','normalized',...
        'position', [.1 .05 .15 .05],...
        'horizontalalignment','center',...
        'string','All',...
        'callback','all_stim_list');
   uicontrol('style','pushbutton',...
        'units','normalized',...
        'position', [.3 .1 .15 .05],...
        'horizontalalignment','center',...
        'string','Remove',...
        'callback','remove_stim_list');
   uicontrol('style','pushbutton',...
        'units','normalized',...
        'position', [.3 .05 .15 .05],...
        'horizontalalignment','center',...
        'string','Add',...
        'callback','add_stim_list');
       uicontrol('style','pushbutton',...
        'units','normalized',...
        'position', [.5 .1 .15 .05],...
    	'horizontalalignment','left',...
        'string','Diamond',...
    	'callback','diamond_stim_list;');    
       uicontrol('style','pushbutton',...
        'units','normalized',...
        'position', [.5 .05 .15 .05],...
    	'horizontalalignment','left',...
        'string','Update',...
    	'callback','close;show_stim_grid;');    

   uicontrol('style','text',...
        'units','normalized',...
        'position', [.7 .1 .15 .04],...
    	'backgroundcolor',c,...
        'string','Cross');
   uicontrol('style','popup',...
    	'units','normalized',...
    	'position', [.82 .1 .1 .05],... 
    	'backgroundcolor',c,...
    	'horizontalalignment','left',...
  		'string',{'1','3','5','7','9','11'},...
   	    'tag','cross',...
    	'callback','cross_stim_list;');    
 
       uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.697 .047 .206 .036],...
    	'backgroundcolor',[.4,.4,.4]);    

   uicontrol('style','text',...
        'units','normalized',...
        'position', [.7 .05 .15 .03],...
    	'backgroundcolor','w',...
    	'horizontalalignment','left',...
        'string',' # of Stimuli = ');
   uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.84 .05 .06 .03],...
    	'backgroundcolor','w',...
    	'horizontalalignment','left',...
  		'string',num2str(length(snd.stim_list)));    
     
          
        if snd.Var2~=7
            for i=[1:length(snd.stim_list)]
                    [Var2_place,Var1_place]=ind2sub([length(var2_array),length(var1_array)],snd.stim_list(i));
                    plot(var1_array(Var1_place),var2_array(Var2_place),'kx');
            end
          else
                    plot(var1_array(snd.stim_list),zeros(1,length(snd.stim_list)),'kx');
        end
            
   
return
   





