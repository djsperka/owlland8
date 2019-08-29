function update_rec_disp()
    global rec;

    h=findobj(gcf,'tag','filtcent');
    set(h,'string',rec.filtcent);
    h=findobj(gcf,'tag','filtwidth');
    set(h,'string',rec.filtwidth);
    h=findobj(gcf,'tag','gain');
    set(h,'string',rec.gain); 
    h=findobj(gcf,'tag','shift');
    set(h,'string',rec.shift);
    h=findobj(gcf,'tag','thresh1');
    set(h,'string',rec.thresh1);
    h=findobj(gcf,'tag','thresh2');
    set(h,'string',rec.thresh2);
    h=findobj(gcf,'tag','thresh3');
    set(h,'string',rec.thresh3);
    h=findobj(gcf,'tag','thresh4');
    set(h,'string',rec.thresh4);
    
    %%Added djt 9/13/2012
    h=findobj(gcf,'tag','thresh5');
    set(h,'string',rec.thresh5);
    h=findobj(gcf,'tag','thresh6');
    set(h,'string',rec.thresh6);
    h=findobj(gcf,'tag','thresh7');
    set(h,'string',rec.thresh7);
    h=findobj(gcf,'tag','thresh8');
    set(h,'string',rec.thresh8);
    
    h=findobj(gcf,'tag','OscCh');
    set(h,'value',rec.OscCh);
    
    
    
    
    h=findobj(gcf,'tag','Ch_ID1');
    set(h,'string',rec.ChID1);
    h=findobj(gcf,'tag','Ch_ID2');
    set(h,'string',rec.ChID2);
    h=findobj(gcf,'tag','Ch_ID3');
    set(h,'string',rec.ChID3);
    h=findobj(gcf,'tag','Ch_ID4');
    set(h,'string',rec.ChID4);
    %%Added djt 9/13/2012
    h=findobj(gcf,'tag','Ch_ID5');
    set(h,'string',rec.ChID5);
    h=findobj(gcf,'tag','Ch_ID6');
    set(h,'string',rec.ChID6);
    h=findobj(gcf,'tag','Ch_ID7');
    set(h,'string',rec.ChID7);
    h=findobj(gcf,'tag','Ch_ID8');
    set(h,'string',rec.ChID8);

return;
