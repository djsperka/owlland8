function close_rec()
    global rec snd;
    rec.dispwave=0;
    get_rec_val;
    close;
    
    if snd.runmode==1    %%  if TDT hardware is connected plot waveform        
        set_RA16;
    end
    
    h=findobj(gcf,'tag','dispch');
    set(h,'string',num2cell([1:rec.numch]));

return;
