    global snd
    if findobj(0,'tag','Message_win')>=1
        figure(findobj(0,'tag','Message_win'));     %% set the first window as active
      else    %%open a new window
        myscreen=get(0,'screensize');
        figure('position',[4,(myscreen(4)-430),400,400],'menubar','none','tag','Message_win');
	    c=get(gcf,'color');
%     	'ListboxTop',[1],...

   snd.message     
   uicontrol('style','Listbox',...
    	'units','normalized',...
    	'position', [.02 .125 .96 .85],...
    	'backgroundcolor',[1,1,1],...
    	'horizontalalignment','left',...
  		'string',snd.message,...
   	    'tag','message'); 
   uicontrol('style','pushbutton',...
    	'units','normalized',...
    	'position', [.15 .025 .2 .075],...
    	'backgroundcolor',c,...
    	'horizontalalignment','center',...
  		'string','Remove',...
        'callback','snd.message{get(findobj(''tag'',''message''),''value'')}='''';snd.message=setdiff(snd.message,'''');set(findobj(''tag'',''message''),''string'',snd.message);'); 

   uicontrol('style','pushbutton',...
    	'units','normalized',...
    	'position', [.65 .025 .2 .075],...
    	'backgroundcolor',c,...
    	'horizontalalignment','center',...
  		'string','Add',...
    	'callback','add_message;'); 
    set(findobj('tag','message'),'string',snd.message);

        
    end
