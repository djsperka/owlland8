function set_thresh()
    global rec;
    
    [x,y]=ginput(1);
    switch rec.OscCh
        case 1 
            rec.thresh1=y;
        case 2 
            rec.thresh2=y;
        case 3 
            rec.thresh3=y;
        case 4 
            rec.thresh4=y;
            %%Added 4 more channels djt 9/13/2012
        case 5 
            rec.thresh5=y;
        case 6
            rec.thresh6=y;
        case 7 
            rec.thresh7=y;
        case 8 
            rec.thresh8=y;
    end;
            
    rec.ThreshOsc=y;
    update_rec_disp;
    set_RA16;

return;
