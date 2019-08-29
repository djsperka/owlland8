function [com,leftval,rightval,xi,yi,leftval_width,rightval_width,border_flag]= WAPeak_Anal(x,y,cutoff)

%  Function returns:
% com: best value (as determined by weighted average)
% leftval, rightval:  left and right borders of the values used in determining best value by weighted average.
%       these are defined as anything above the halfway point between min
%       and max firing.
% xi, yi:  x/y values for *interpolated* firing rate y in response to stimuli x
% leftval_width, rightval_width: left and right borders of the width at
%       halfmax.  these are defined as a simple half of the maximum firing rate.
%
%% This is Ilana's halfmax function, renamed for clarity.
% % for time=1:size(data.mat,1)
% % x=data.ref;
% % y=data.mat(time,:);

border_flag=0; %Added border flag DJT

if nanmin(y)==nanmax(y)
    com=NaN;
    leftval=NaN;
    rightval=NaN;
else
    
    if nargin==2
        cutoff=0.5;
    end
    
    ind= find(~isnan(y));
    y=y(ind);
    x=x(ind);
    
    %     %% i want to try smoothing the y values
    %     %% maybe this will improve the fits?
    %     filter_size=3;
    %     myfilter= ones(1,filter_size)/filter_size;
    %     y=filtfilt(myfilter,1,y);
    %%%%%%
    
    xi=[min(x):.1:max(x)];
    yi=interp1(x,y,xi, 'spline');
    %     figure
    %     plot(x,y, 'r')
    %     hold on
    %     plot(xi,yi, 'linewidth', 2)
    
    [mx, mx_i]=max(yi);
    mn=min(yi);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% 1.  For the purposes of finding the best value,
    %%% find the half-way point between the maximum and minimum firing
    %%% rates and find the left and right edges of points that are above
    %%% these points.  (This helps for seeing tuning despite high baseline
    %%% firing rates).  This is Ilana's original code.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    halfway=(cutoff*(mx-mn)+mn);
    greaterthanhalf=find(yi > halfway);
    lessthanhalf=find(yi <= halfway);
    
    if max(lessthanhalf) >  mx_i  %%if we have a right side max
        rightval = xi(greaterthanhalf(length(greaterthanhalf)));
        % if there are multiple cutoff crossings,
        % choose the ones that are closest to the max val
        d=find(diff(greaterthanhalf) ~= 1);
        if ~isempty(d)
            border=(d);
            %border=[border, 1, (length(greaterthanhalf)-1)];
            %border=[greaterthanhalf(border+1),greaterthanhalf(border)];
            border=[border,(border+1),1,length(greaterthanhalf)];            
            border=greaterthanhalf(border); %added these two lines and got 
%rid of above lines because the algoraithm was wrong DJT 9/6/2013
            [m, m_i] = max(yi(greaterthanhalf));
            m_i=greaterthanhalf(m_i);
            %         leftval = xi(m_i+max(border(find(border-m_i<0))-m_i));
            rightval= xi(min(border(find(border-m_i>0))-m_i)+m_i);
        end
    else %peak-region hits right border
        %         rightval = NaN;%DJT 9/5/2013
        rightval=xi(greaterthanhalf(end));
        border_flag=1;
    end
    
    if min(lessthanhalf) <  mx_i  %%if we have a left side max
        leftval = xi(greaterthanhalf(1));
        % if there are multiple cutoff crossings,
        % choose the ones that are closest to the max val
        d=find(diff(greaterthanhalf) ~= 1);
        if ~isempty(d)
            border=(d);
            %border=[border, 1, (length(greaterthanhalf)-1)];
            %border=[greaterthanhalf(border+1),greaterthanhalf(border)];
            border=[border,(border+1),1,length(greaterthanhalf)];            
            border=greaterthanhalf(border); %added these two lines and got 
%rid of above lines because the algoraithm was wrong DJT 9/6/2013
            [m, m_i] = max(yi(greaterthanhalf));
            m_i=greaterthanhalf(m_i);
            leftval = xi(m_i+max(border(find(border-m_i<0))-m_i));
            %         rightval= xi(min(border(find(border-m_i>0))-m_i)+m_i);
        end
    else %peak region hits left border
        %         leftval = NaN;%DJT 9/5/2013
        leftval=xi(greaterthanhalf(1));
        border_flag=1;
    end
    
    if ~isnan(rightval) && ~isnan(leftval)
        ind = find(xi>=leftval & xi <=rightval);
        com_x = xi(ind);
        com_y = yi(ind)-halfway;
        com_y = com_y/sum(com_y);
        com = sum(com_x.*com_y);
    else
        com = NaN;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% 2.  For the purposes of reporting sharpness of tuning, find the
    %%% width of responses that are above half the maximum firing rate.
    %%% (This is Kristin's addition).
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     halfmax=cutoff*mx;
    halfmax=(cutoff*(mx-mn)+mn); %made this the same as the above text, 
%instead of disregarding the baseline
    greaterthanhalf=find(yi > halfmax);
    lessthanhalf=find(yi <= halfmax);
    
    if max(lessthanhalf) >  mx_i  %%if we have a right side edge (eg. the responses fell below
        % halfmax of the firing rate somewhere to the right of our best value)
        rightval_width = xi(greaterthanhalf(length(greaterthanhalf)));
        % if there are multiple cutoff crossings,
        % choose the ones that are closest to the max val
        d=find(diff(greaterthanhalf) ~= 1);
        if ~isempty(d)
            border=(d);
            %border=[border, 1, (length(greaterthanhalf)-1)];
            %border=[greaterthanhalf(border+1),greaterthanhalf(border)];
            border=[border,(border+1),1,length(greaterthanhalf)];            
            border=greaterthanhalf(border); %added these two lines and got 
%rid of above lines because the algoraithm was wrong DJT 9/6/2013
            [m, m_i] = max(yi(greaterthanhalf));
            m_i=greaterthanhalf(m_i);
            %         leftval_width = xi(m_i+max(border(find(border-m_i<0))-m_i));
            rightval_width= xi(min(border(find(border-m_i>0))-m_i)+m_i);
        end
    else
        %         rightval_width = NaN; %DJT 9/5/2013
        rightval_width = xi(greaterthanhalf(length(greaterthanhalf)));
    end
    
    if min(lessthanhalf) <  mx_i  %%if we have a left side edge
        leftval_width = xi(greaterthanhalf(1));
        % if there are multiple cutoff crossings,
        % choose the ones that are closest to the max val
        d=find(diff(greaterthanhalf) ~= 1);
        if ~isempty(d)
            border=(d);
            %border=[border, 1, (length(greaterthanhalf)-1)];
            %border=[greaterthanhalf(border+1),greaterthanhalf(border)];
            border=[border,(border+1),1,length(greaterthanhalf)];            
            border=greaterthanhalf(border); %added these two lines and got 
%rid of above lines because the algoraithm was wrong DJT 9/6/2013
            [m, m_i] = max(yi(greaterthanhalf));
            m_i=greaterthanhalf(m_i);
            leftval_width = xi(m_i+max(border(find(border-m_i<0))-m_i));
            %         rightval_width= xi(min(border(find(border-m_i>0))-m_i)+m_i);
        end
    else
        %         leftval_width = NaN;%DJT 9/5/2013
        leftval_width = xi(greaterthanhalf(1));
    end
    
    
end
% keyboard
return;