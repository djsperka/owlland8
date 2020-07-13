function [com,leftval,rightval,xi,yi,leftval_width,rightval_width,border_flag]= WAPeak_Anal(x,y,cutoff)
global rec
%  Re-structured this from the Knudsen Weighted Average algorithms.  Main
%  difference is that the knudsen algorithms calculate use two different
%  half-max definitions to calculate the center and the width.  

%  They used cutoff=(max-min)/2 to calculate peak because they said it
%  helped with high baseline firing.  I only feed in baseline subtracted
%  data so this doesn't matter for me.

% They used cutoff=max/2 to calculate width.  This is what I use for all of
% my calculations

% DJT 8/18/2014

border_flag=0; %Added border flag DJT

if nanmin(y)==nanmax(y) %If response min == response max
    com=NaN;
    leftval=NaN;
    rightval=NaN;
else
    
    %If cutoff wasn't sepcified, set it
    if nargin==2
        cutoff=0.5;
    end
    
    %Get rid of nans
    ind= find(~isnan(y));
    y=y(ind);
    x=x(ind);
    
    %Interpolate
    xi= min(x):.1:max(x);
    yi=interp1(x,y,xi, 'spline');
    
    %Find halfmax regions
    [mx, ~]=max(yi);  
    if mx<0 
        com=nan;
        leftval=nan;
        rightval=nan;
        xi=nan;
        yi=nan;
        leftval_width=nan;
        rightval_width=nan;
        border_flag=1;
        return
    end
    halfmax=cutoff*mx;
    greaterthanhalf=find(yi > halfmax);
    
    d=find(diff(greaterthanhalf) ~= 1);
    
    if isempty(d) % If there is only one peak region
        rightval=xi(greaterthanhalf(end));
        right_indx=greaterthanhalf(end);
        leftval = xi(greaterthanhalf(1));
        left_indx=greaterthanhalf(1);
    else
        border=(d); % d=boundary between regions
        
        % make a vector of the left and right side of each border, and the far
        % left and far right edges
        border=[border,(border+1),1,length(greaterthanhalf)];
        
        % find the point with the largest response
        [~, m_i] = max(yi(greaterthanhalf));
        
        rightofborder=border(border-m_i>=0); %find borders right of peak
        right_indx=greaterthanhalf(min(rightofborder)); %find rightmost of left borders
        rightval= xi(right_indx); %find the variable value at the right border
        
        leftofborder=border(border-m_i<=0); %find borders left of peak
        left_indx=greaterthanhalf(max(leftofborder)); %find rightmost of left borders
        leftval=xi(left_indx); %find the variable value at the left border
    end
    
    %If this was unbounded on the left or right
    if right_indx==length(xi) || left_indx==1; 
        border_flag=1;
    end
    
    % Peak regions
    ind = find(xi>=leftval & xi <=rightval);
    peak_x = xi(ind);
    peak_y = yi(ind);
    
    % Center of mass calculation
    scaled_y = (peak_y-halfmax)/sum(peak_y-halfmax);
    com = peak_x*scaled_y';    
    
end

% In Knudsen code these two outputs meant two different things; leftval was
% the left point at 1/2 *(max-min) + min, while leftval_width = 1/2max.  I
% only use the latter, but rather than switching everything around I just
% set the two as equal to simplify recoding - DJT 9/30/14
leftval_width=leftval;
rightval_width=rightval;

return;