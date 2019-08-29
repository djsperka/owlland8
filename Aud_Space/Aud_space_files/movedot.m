function    movedot(window,dotcenter,dotcenter2,foreground_lum,foreground_lum2,background_lum,angle,angle2,dotsize,dotsize2,pre,amp_mod_vis,Freq_mod,duration,vis_offset,stim_curve,distance,distance2,play_vis, size_change, size_change2);
global snd zbus RP_1 RP_2;

% 2/4/2014 DJT edit - Using priority instead of Rush 
% 2/24/2014 DJT edit - Changed all 'WaitBlanking' to 'Flip'
% 3/10/10`4 DJT edit - Added size_change2, and gave the second stim
% independent control of its loom speed
%4/8/2014 DJT edit - got rid of all superfluouse 'Flip's and added a
%WaitSec command to get the vis stim presentation timing correct

total_refreshes=ceil(snd.hz*duration/1000); %how many times a screen will update during a stimulus  
%changed all instances of scr_num to total_refreshes, cause they are the
%same thing and this is a better name and calculated earlier DJT 3/3/2014.


%% Calculate all the frames for Vis1 stim
if play_vis(1)==1  %% go ahead and calculate the vis positions (in pixels) for vis1
    rad_angle=angle*pi/180;
    % the first element in startpos & endpos is az; the second element is el
    % This calculation accounts for the angle of movement
    startpos=[dotcenter(1)-(0.5*distance*sin(rad_angle)),dotcenter(2)-(0.5*distance*cos(rad_angle))];
    endpos=[dotcenter(1)+(0.5*distance*sin(rad_angle)),dotcenter(2)+(0.5*distance*cos(rad_angle))];
    
    startpos=round(startpos*10000)/10000;
    endpos=round(endpos*10000)/10000;
    
    vis_step=(endpos-startpos)/(snd.hz*duration/1000);  %% size (in space) of each step
    size_step=size_change/(snd.hz*duration/1000); 

    if size_change
        dotsize=[dotsize-size_change:size_step:dotsize]; %changed to this, so the final size is the specified size DJT 7/1/2013
%         dotsize=[dotsize-size_change/2+size_step/2:size_step:dotsize+size_change/2-size_step/2];
    end
    
    if vis_step(1)  %% if the end pos is different from the start pos
        vis_pos_x=[startpos(1):vis_step(1):endpos(1)]; %changed 3/3/2014
%         vis_pos_x=[startpos(1)+vis_step(1)/2:vis_step(1):endpos(1)-vis_step(1)/2];
    else
        vis_pos_x=ones(1,total_refreshes+1)*startpos(1);% DJT 3/9/1014
    end
    
    if vis_step(2)
        vis_pos_y=[startpos(2):vis_step(2):endpos(2)]; %changed 3/3/2014
%         vis_pos_y=[startpos(2)+vis_step(2)/2:vis_step(2):endpos(2)-vis_step(2)/2];
        
    else
        vis_pos_y=ones(1,total_refreshes+1)*startpos(2); % DJT 3/9/1014
    end
    
    vis_locs_min=zeros(2,length(vis_pos_x));
    vis_locs_max=zeros(2,length(vis_pos_x));
    vis_locs_min(1,:)=vis_pos_x-dotsize/2; %*
    vis_locs_max(2,:)=vis_pos_y-dotsize/2; %*
%     vis_locs_min(2,:)=vis_pos_y-dotsize; %%Changed ymin/max definitions
%     DJT 2/6/2014
    vis_locs_max(1,:)=vis_pos_x+dotsize/2; %*
    vis_locs_min(2,:)=vis_pos_y+dotsize/2; %*
%     vis_locs_max(2,:)=vis_pos_y+dotsize; %%Changed ymin/max definitions
%     DJT 2/6/2014

% * for min/max calculations, changed dotsize to dotsize/2  3/3/2014 DJT
% take in the positions (in degrees) and convert them to pixels
    vis_pix_min=convert_array_to_pixels(vis_locs_min,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    vis_pix_max=convert_array_to_pixels(vis_locs_max,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});       
    
end
%% Calculate all the frames for Vis2 stim
if play_vis(2)==1 %% go ahead and calculate the vis positions (in pixels) for vis2
    rad_angle2=angle2*pi/180;
    startpos2=[dotcenter2(1)-(0.5*distance2*sin(rad_angle2)),dotcenter2(2)-(0.5*distance2*cos(rad_angle2))];
    endpos2=[dotcenter2(1)+(0.5*distance2*sin(rad_angle2)),dotcenter2(2)+(0.5*distance2*cos(rad_angle2))];
    
    startpos2=round(startpos2*10000)/10000;
    endpos2=round(endpos2*10000)/10000;
    
    vis_step2=(endpos2-startpos2)/(snd.hz*duration/1000);
    size_step=size_change2/(snd.hz*duration/1000); 
    
    if size_change2
        dotsize2=[dotsize2-size_change2:size_step:dotsize2]; % changed to this so loom terminates at "dot size" 7/1/2013
%         dotsize2=[dotsize2-size_change/2:size_step:dotsize2];
    end
    
    if vis_step2(1)
        vis_pos_x2=[startpos2(1):vis_step2(1):endpos2(1)]; %changed 3/3/2014 DJT
%         vis_pos_x2=[startpos2(1)+vis_step2(1)/2:vis_step2(1):endpos2(1)-vis_step2(1)/2];
    else
        vis_pos_x2=ones(1,total_refreshes+1)*startpos2(1);% DJT 3/9/1014
    end
    
    if vis_step2(2)
        vis_pos_y2=[startpos2(2):vis_step2(2):endpos2(2)]; %changed 3/3/2014 DJT
%         vis_pos_y2=[startpos2(2)+vis_step2(2)/2:vis_step2(2):endpos2(2)-vis_step2(2)/2];    
    else
        vis_pos_y2=ones(1,total_refreshes+1)*startpos2(2);% DJT 3/9/1014
    end

    
    vis_locs_min2=zeros(2,length(vis_pos_x2));
    vis_locs_max2=zeros(2,length(vis_pos_x2));
    vis_locs_min2(1,:)=vis_pos_x2-dotsize2/2; %*
    vis_locs_max2(2,:)=vis_pos_y2-dotsize2/2; %*
%     vis_locs_min2(2,:)=vis_pos_y2-dotsize2/2; %*
% swapped min/max definitions 2/6/2014
    vis_locs_max2(1,:)=vis_pos_x2+dotsize2/2; %*
    vis_locs_min2(2,:)=vis_pos_y2+dotsize2/2; %*
%     vis_locs_max2(2,:)=vis_pos_y2+dotsize2/2; %*
% swapped min/max definitions 2/6/2014
    % added /2 ... dots were coming up twice the size they should be DJT
    % 3/5/2014
    vis_pix_min2=convert_array_to_pixels(vis_locs_min2,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    vis_pix_max2=convert_array_to_pixels(vis_locs_max2,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
end

%% calculate the other stim params %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set luminance w/ gamma-curve correction
background_lum=gamma_correct(background_lum)*snd.white;
foreground_lum=gamma_correct(foreground_lum)*snd.white;
foreground_lum2=gamma_correct(foreground_lum2)*snd.white;

% count the # of screens in "pre" time (before stim onset)
prescreens=round(((snd.hz/1000)*(pre+vis_offset)))-1;

%% Play the stim

if stim_curve
    invoke(RP_2,'SetTagVal','trggate', 1);
end

invoke(zbus,'zBusTrigA',0,0,4); %%start the aud and data collection.

%%% If you aren't playing any visual stim
if play_vis(1)==0&&play_vis(2)==0   
%     prescreens=round(((snd.hz/1000)*(pre+snd.post)))-1;  %Got rid of
%     prescreens.  Don't think its necessary DJT 6/10/14
    
    old_prio=Priority(1); %set priority to 1
    
    %make a background, w/ a black box at the trigger and a red dot in that
    %black box
    Screen(window,'FillRect',background_lum);
    Screen(window,'FillRect',[snd.black,snd.black,snd.black],snd.trigger_loc);
    Screen(window,'FillOval',[snd.white,snd.black,snd.black],snd.trigger_loc);
    Screen(window,'Flip');
    
    %make a background w/ a black box at the trigger location.  Keep it
    %there for a duration of "prescreens"
    Screen(window,'FillRect',background_lum);
    Screen(window,'FillRect',[snd.black,snd.black,snd.black],snd.trigger_loc);
    Screen(window,'Flip');
%     Screen(window,'Flip',prescreens); %Got rid of
%     prescreens.  Don't think its necessary DJT 6/10/14

    %wait for pre period
    wait_time=(pre+vis_offset)/1000 - 1/snd.hz;
    WaitSecs(wait_time);
    
    Priority(old_prio); %set priority back to what it was
end

%%% If you are only playing vis stim #1
if play_vis(1)==1&&play_vis(2)==0
        
    old_prio=Priority(1); %set priority to 1
    
    %Make the background, w/ a black box around the trigger and a red dot
    %in the black box
    Screen(window,'FillRect',background_lum);
    Screen(window,'FillRect',[snd.black,snd.black,snd.black],snd.trigger_loc);
    Screen(window,'FillOval',[snd.white,snd.black,snd.black],snd.trigger_loc);
    Screen(window,'Flip');        

    % restore background and black box 
    Screen(window,'FillRect',background_lum);
    Screen(window,'FillRect',[snd.black,snd.black,snd.black],snd.trigger_loc);    
    Screen(window,'Flip');

    %wait for pre period
    wait_time=(pre+vis_offset)/1000 - 1/snd.hz;
    WaitSecs(wait_time);
    
    %play first frame of the visual stim
    Screen(window,'FillOval',foreground_lum,[vis_pix_min(1,1),vis_pix_min(2,1),vis_pix_max(1,1),vis_pix_max(2,1)]);
    Screen(window,'Flip');
    for i=[2:total_refreshes]; %erase stim at old location and draw stim at new location
        Screen(window,'FillOval',background_lum,[vis_pix_min(1,i-1),vis_pix_min(2,i-1),vis_pix_max(1,i-1),vis_pix_max(2,i-1)]);
        Screen(window,'FillOval',foreground_lum,[vis_pix_min(1,i),vis_pix_min(2,i),vis_pix_max(1,i),vis_pix_max(2,i)]);
        Screen(window,'Flip');
    end;
    
    %erase stim at whatever position it was last at
    Screen(window,'FillOval',background_lum,[vis_pix_min(1,total_refreshes),vis_pix_min(2,total_refreshes),vis_pix_max(1,total_refreshes),vis_pix_max(2,total_refreshes)]);
    Screen(window,'Flip');
        
    Priority(old_prio);         %reset priority
end

%%% If you are playing 2 visual stim
if play_vis(1)==1&&play_vis(2)==1
    
    old_prio=Priority(1); %set priority to 1
    
    %make background, black trigger box and red trigger in box
    Screen(window,'FillRect',background_lum);
    Screen(window,'FillRect',[0,0,0],snd.trigger_loc);
    Screen(window,'FillOval',[snd.white,0,0],snd.trigger_loc);
    Screen(window,'Flip');
    
    %clear the trigger dot
    Screen(window,'FillRect',background_lum);
    Screen(window,'FillRect',[0,0,0],snd.trigger_loc);
    Screen(window,'Flip');    
    
    %wait for pre period
    wait_time=(pre+vis_offset)/1000 - 1/snd.hz;
    WaitSecs(wait_time);
    
    %play first frame of visual stim
    Screen(window,'FillOval',foreground_lum,[vis_pix_min(1,1),vis_pix_min(2,1),vis_pix_max(1,1),vis_pix_max(2,1)]);
    Screen(window,'FillOval',foreground_lum2,[vis_pix_min2(1,1),vis_pix_min2(2,1),vis_pix_max2(1,1),vis_pix_max2(2,1)]);
    Screen(window,'Flip');
    for i=[2:total_refreshes]; %clear last frame and draw next frame for vis stim
        Screen(window,'FillOval',background_lum,[vis_pix_min(1,i-1),vis_pix_min(2,i-1),vis_pix_max(1,i-1),vis_pix_max(2,i-1)]);
        Screen(window,'FillOval',foreground_lum,[vis_pix_min(1,i),vis_pix_min(2,i),vis_pix_max(1,i),vis_pix_max(2,i)]);
        Screen(window,'FillOval',background_lum,[vis_pix_min2(1,i-1),vis_pix_min2(2,i-1),vis_pix_max2(1,i-1),vis_pix_max2(2,i-1)]);
        Screen(window,'FillOval',foreground_lum2,[vis_pix_min2(1,i),vis_pix_min2(2,i),vis_pix_max2(1,i),vis_pix_max2(2,i)]);
        Screen(window,'Flip');
    end;
    
    %clear last frame of vis stim
    Screen(window,'FillOval',background_lum,[vis_pix_min(1,total_refreshes),vis_pix_min(2,total_refreshes),vis_pix_max(1,total_refreshes),vis_pix_max(2,total_refreshes)]);
    Screen(window,'FillOval',background_lum,[vis_pix_min2(1,total_refreshes),vis_pix_min2(2,total_refreshes),vis_pix_max2(1,total_refreshes),vis_pix_max2(2,total_refreshes)]);
    Screen(window,'Flip');
    
    Priority(old_prio); %reset priority 
end

%%% If you are only vis stim #2
if play_vis(1)==0&&play_vis(2)==1
    
    old_prio=Priority(1); %set priority to 1
    
    %make background, black box around trigger, and red light on trigger
    Screen(window,'FillRect',background_lum);
    Screen(window,'FillRect',[0,0,0],snd.trigger_loc);
    Screen(window,'FillOval',[snd.white,0,0],snd.trigger_loc);
    Screen(window,'Flip');
    
    %clear trigger
    Screen(window,'FillRect',background_lum);
    Screen(window,'FillRect',[0,0,0],snd.trigger_loc);
    Screen(window,'Flip');    
    
    %wait for pre period
    wait_time=(pre+vis_offset)/1000 - 1/snd.hz;
    WaitSecs(wait_time);
    
    %draw first frame of vis stim
    Screen(window,'FillOval',foreground_lum2,[vis_pix_min2(1,1),vis_pix_min2(2,1),vis_pix_max2(1,1),vis_pix_max2(2,1)]);
    Screen(window,'Flip');
    for i=[2:total_refreshes]; %clear last frame and draw next frame for vis stim
        Screen(window,'FillOval',background_lum,[vis_pix_min2(1,i-1),vis_pix_min2(2,i-1),vis_pix_max2(1,i-1),vis_pix_max2(2,i-1)]);
        Screen(window,'FillOval',foreground_lum2,[vis_pix_min2(1,i),vis_pix_min2(2,i),vis_pix_max2(1,i),vis_pix_max2(2,i)]);
        Screen(window,'Flip');
    end;
    
    %clear last frame of vbis stim
    Screen(window,'FillOval',background_lum,[vis_pix_min2(1,total_refreshes),vis_pix_min2(2,total_refreshes),vis_pix_max2(1,total_refreshes),vis_pix_max2(2,total_refreshes)]);
    Screen(window,'Flip');

    Priority(old_prio); %reset priority 
    
end
%%% Clear the visual stim
old_prio=Priority(1); %set priority to 1
Screen(window,'FillRect',background_lum);
Screen(window,'FillRect',[snd.black,snd.black,snd.black],snd.trigger_loc);
Screen (window,'Flip'); %Need this is here to clear stim after they finish DJT 3/5/2014
Priority(old_prio); %reset priority

return;
