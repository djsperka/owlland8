function save_file_dialog_cont()
    global snd rec;
    snd.oldname=snd.filename;
    
    screen=get(0,'screensize');
    figure('position',[screen(3)/2-200 screen(4)/2-100 400 200],...
        'windowstyle','modal',...
        'menubar','none')
    c=get(gcf,'color');

    uicontrol('style','text',...
        'units','normalized',...
        'backgroundcolor',c,...
        'position',[0.1 0.7 0.8 0.2],...
        'string','Save raw waveform to file?',...
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
        'string','Save',...
        'fontweight','bold',...
        'callback','close(gcf);save_raw_file_bin');

    
    
    
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
        'string',snd.path,...
        'callback','set_file',...
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
        'string',snd.filename,...
        'callback','set_file',...
        'tag','file');
        

    uicontrol('style','pushbutton',...
        'units','normalized',...
        'position', [.65 .3 .2 .1],...
        'horizontalalignment','center',...
        'string','browse',...
        'callback','browse_file');
  
return;
