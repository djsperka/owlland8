function  screen_calibration(owl_distance_inches, left_pixels, right_pixels, left_inches, right_inches, top_inches, bottom_inches)

    % INPUTS:  owl_distance= distance in inches from owl to origin on screen.
    %          left_pixels= x value returned by 'get_pixels' for left edge of screen
    %          right_pixels= x value returned by 'get_pixels' for right edge of screen
    
    %          left_inches= distance in iches from origin to left edge of screen
    %          right_inches=distance in iches from origin to right edge of screen
    %          etc. for top_inches and bottom_inches
    %
   

    if (left_inches<=0 || right_inches<=0 || top_inches<=0 || bottom_inches<=0)
        'ERROR: screen distances should be positive values.'
        return;
    end

    % convert distance from owl --> origin from inches to pixels
    screen_width_inches = right_inches + left_inches;
    screen_width_pixels = right_pixels - left_pixels;
    pix_owl_dist = owl_distance_inches * screen_width_pixels / screen_width_inches;
    
    % find angle (in degrees) from owl to the right, left, top, and bottom edges of screen
    left_deg = (atan(left_inches/owl_distance_inches)) * 360 / (2*pi);
    right_deg = (atan(right_inches/owl_distance_inches)) * 360 / (2*pi);
    top_deg = (atan(top_inches/owl_distance_inches)) * 360 / (2*pi);
    bottom_deg = (atan(bottom_inches/owl_distance_inches)) * 360 / (2*pi);
    
    fprintf(1,'screendistance= %0.2f\n', pix_owl_dist);
    fprintf(1,'deg=[-%0.2f -%0.2f %0.2f %0.2f]\n', left_deg, bottom_deg, right_deg, top_deg);
    
return

