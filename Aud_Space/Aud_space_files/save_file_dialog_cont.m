function save_file_dialog_cont()
    global snd rec cont screen_offset;
    
    screen=get(0,'screensize');
    %figure('position',[screen(3)/2-200 screen(4)/2-100 400 200],...
    figure('position',[screen(3)/2-200+screen_offset screen(4)/2-100 400 200],...
        'windowstyle','modal',...
        'menubar','none') 
        %changed to work w/ extended display DJT 1/25/2012
    %Changed again on 2/12/2012.  This time changed snd.screen_offset
        %to just plain screen_offset.  Also Added screen_offset to global
        %paramaters DJT
    c=get(gcf,'color');

    uicontrol('style','text',...
        'units','normalized',...
        'backgroundcolor',c,...
        'position',[0.1 0.7 0.8 0.2],...
        'string','Save data to file?',...
        'fontsize',12,...
        'fontweight','bold',...
        'horizontalalignment','center');
    uicontrol('style','pushbutton',...
        'units','normalized',...
        'position',[0.15 0.05 0.3 0.2],...
        'string','do not save',...
        'fontweight','bold',...
        'callback','close(gcf)');

    %%here is the new save button
    uicontrol('style','pushbutton',...
        'units','normalized',...
        'position',[0.55 0.05 0.3 0.2],...
        'string','Save bin',...
        'fontweight','bold',...
        'callback','close(gcf);save_file_bin_cont');

    
    
    
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.1 .55 .2 .1],...
        'backgroundcolor',c,...
        'string','directory',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.3 .5 .6 .2],...
        'backgroundcolor',c,...
        'horizontalalignment','left',...
        'string',cont.path,...
        'callback','set_file_cont',...
        'tag','path');
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.1 .3 .2 .1],...
        'backgroundcolor',c,...
        'string','file name',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.3 .3 .3 .1],...
        'backgroundcolor',c,...
        'horizontalalignment','left',...
        'string',cont.filename,...
        'callback','set_file_cont',...
        'tag','file');
        

    uicontrol('style','pushbutton',...
        'units','normalized',...
        'position', [.65 .3 .2 .1],...
        'horizontalalignment','center',...
        'string','browse',...
        'callback','browse_file_cont');
  
return;
