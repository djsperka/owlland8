function set_prediction()
    global cont
    figure('position',[400,300,400,150],'menubar','none');
    c=get(gcf,'color');

    
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.05 .7 .2 .1],...
    	'horizontalalignment','right',...
  		'string','Auditory',...
        'backgroundcolor',c,...
        'tag','aud','value',1);
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.25 .7 .2 .1],...
    	'horizontalalignment','right',...
  		'string','Visual',...
        'backgroundcolor',c,...
        'tag','vis','value',1);
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.45 .7 .2 .1],...
    	'horizontalalignment','right',...
  		'string','Bimodal',...
        'backgroundcolor',c,...
        'tag','bim','value',1);
    
    uicontrol('style','popup',...
    	'units','normalized',...
    	'position', [.7 .7 .25 .1],...
    	'backgroundcolor',c,...
    	'horizontalalignment','left',...
  		'string',{'right','left','both'},...
   	    'tag','pred_dir','value',3);  
    

    uicontrol('style','text',...
    	'units','normalized',...
    	'position', [.05 .4 .1 .1],...
    	'horizontalalignment','left',...
  		'string','Rate',...
        'backgroundcolor',c);
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.15 .4 .1 .1],...
    	'horizontalalignment','right',...
  		'string','1',...
        'backgroundcolor',c,...
        'tag','hz1','value',1);
    
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.25 .4 .1 .1],...
    	'horizontalalignment','right',...
  		'string','2',...
        'backgroundcolor',c,...
        'tag','hz2','value',1);
    
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.35 .4 .1 .1],...
    	'horizontalalignment','right',...
  		'string','4',...
        'backgroundcolor',c,...
        'tag','hz4','value',1);
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.45 .4 .1 .1],...
    	'horizontalalignment','right',...
  		'string','8',...
        'backgroundcolor',c,...
        'tag','hz8','value',1);
    uicontrol('style','checkbox',...
    	'units','normalized',...
    	'position', [.55 .4 .1 .1],...
    	'horizontalalignment','right',...
  		'string','16',...
        'backgroundcolor',c,...
        'tag','hz16','value',1);
    

    
    
    uicontrol('style','pushbutton',...
    	'units','normalized',...
    	'position', [.05 .1 .4 .2],...
        'fontweight','bold',...
    	'horizontalalignment','center',...
  		'string','Cancel',...
    	'callback','close;');     
    uicontrol('style','pushbutton',...
    	'units','normalized',...
    	'position', [.55 .1 .4 .2],...
        'fontweight','bold',...
    	'horizontalalignment','center',...
  		'string','Load',...
    	'callback','load_prediction_curves;');     

    
    
    

    
    