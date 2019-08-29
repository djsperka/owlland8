function outpoint=converttopixels(inpoint,origin,screendistance)
    %inpoint should be entered in degrees
    %origin is the pixel at [0,0]
    %screendistance is the distance from the owl to the screen in terms of
    %pixels
    radpoint=((inpoint*pi)/180);
    xout=origin(1)+(screendistance*tan(radpoint(1)));
    yout=origin(2)-(screendistance*tan(radpoint(2)));
    outpoint=round([xout,yout]);
return;
