function outpoints=convert_array_to_pixels(inpoints,origin,screendistance)
    %inpoints should be entered as a 2xn array in degrees 
    %origin is the pixel at [0,0]
    %screendistance is the distance from the owl to the screen in terms of
    %pixels
    outpoints=zeros(size(inpoints));
    for i=[1:size(inpoints,2)]
        radpoint=((inpoints(:,i)*pi)/180);
        xout=round(origin(1)+(screendistance*tan(radpoint(1))));
        yout=round(origin(2)-(screendistance*tan(radpoint(2))));
        outpoints(:,i)=round([xout;yout]);
    end
return;
