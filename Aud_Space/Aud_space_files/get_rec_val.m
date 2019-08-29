function get_rec_val()
    global rec snd;
    
    %%  update parameters
    h=findobj(gcf,'tag','filtcent');
    rec.filtcent=str2num(get(h,'string'));
    h=findobj(gcf,'tag','filtwidth');
    rec.filtwidth=str2num(get(h,'string'));
    h=findobj(gcf,'tag','gain');
    rec.gain=str2num(get(h,'string'));
    h=findobj(gcf,'tag','shift');
    rec.shift=str2num(get(h,'string'));
    h=findobj(gcf,'tag','thresh1');
    rec.thresh1=str2num(get(h,'string'));
    h=findobj(gcf,'tag','thresh2');
    rec.thresh2=str2num(get(h,'string'));
    h=findobj(gcf,'tag','thresh3');
    rec.thresh3=str2num(get(h,'string'));
    h=findobj(gcf,'tag','thresh4');
    rec.thresh4=str2num(get(h,'string'));
    
    %%Added djt 9/13/2012
    h=findobj(gcf,'tag','thresh5');
    rec.thresh5=str2num(get(h,'string'));
    h=findobj(gcf,'tag','thresh6');
    rec.thresh6=str2num(get(h,'string'));
    h=findobj(gcf,'tag','thresh7');
    rec.thresh7=str2num(get(h,'string'));
    h=findobj(gcf,'tag','thresh8');
    rec.thresh8=str2num(get(h,'string'));
    
    
    rec.OscCh=get(findobj(gcf,'tag','OscCh'),'value');
    snd.volume=str2num(get(findobj(gcf,'tag','volume'),'string'));
    rec.overlay=str2num(get(findobj(gcf,'tag','overlay'),'string')); %Added djt 12/11/2012
    snd.volume=min(snd.volume,100);
    snd.volume=max(snd.volume,0);
    set(findobj(gcf,'tag','volume'),'string',snd.volume);   

    h=findobj(gcf,'tag','numch');
    rec.numch=str2num(get(h,'string'));
 
    
    
    
    h=findobj(gcf,'tag','Ch_ID1');
    rec.ChID1=str2num(get(h,'string'));
    h=findobj(gcf,'tag','Ch_ID2');
    rec.ChID2=str2num(get(h,'string'));
    h=findobj(gcf,'tag','Ch_ID3');
    rec.ChID3=str2num(get(h,'string'));
    h=findobj(gcf,'tag','Ch_ID4');
    rec.ChID4=str2num(get(h,'string'));
    h=findobj(gcf,'tag','Ch_ID5');
    rec.ChID5=str2num(get(h,'string'));
    h=findobj(gcf,'tag','Ch_ID6');
    rec.ChID6=str2num(get(h,'string'));
    h=findobj(gcf,'tag','Ch_ID7');
    rec.ChID7=str2num(get(h,'string'));
    h=findobj(gcf,'tag','Ch_ID8');
    rec.ChID8=str2num(get(h,'string'));

 
    rec.OscCh=min(rec.OscCh,rec.numch);
        set(findobj(gcf,'tag','OscCh'),'value',rec.OscCh);   

    set(findobj(gcf,'tag','OscCh'),'string',num2cell([1:rec.numch]));   

return;
