function file_browse()
    global cal RP_1 RP_2 pa5_1 pa5_2 pa5_3 pa5_4 RA_16  zbus;

    [cal.file cal.path]=uiputfile('*.*','Find the program you will run');        
    % display the chosen file
    uicontrol('style','text','units','normalized',...
        'position', [0.1 0.23 2 0.1],'backgroundcolor',cal.c_yellow,...
        'string',[cal.path cal.file],...
        'horizontalalignment','left','fontsize',8);
  
    
return;
