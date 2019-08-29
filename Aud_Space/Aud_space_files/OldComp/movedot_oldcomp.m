function    movedot(window,dotcenter,dotcenter2,foreground_lum,foreground_lum2,background_lum,angle,angle2,dotsize,dotsize2,pre,amp_mod_vis,Freq_mod,duration,vis_offset,stim_curve,distance,distance2,play_vis, size_change, size_change2);
global snd zbus RP_1 RP_2;

%% VIS1
if play_vis(1)==1  %% go ahead and calculate the vis positions (in pixels) for vis1
    rad_angle=angle*pi/180;
    %% the first element in startpos & endpos is az; the second element is el
    startpos=[dotcenter(1)-(0.5*distance*sin(rad_angle)),dotcenter(2)-(0.5*distance*cos(rad_angle))];
    endpos=[dotcenter(1)+(0.5*distance*sin(rad_angle)),dotcenter(2)+(0.5*distance*cos(rad_angle))];
    
    startpos=round(startpos*10000)/10000;
    endpos=round(endpos*10000)/10000;
    
    vis_step=(endpos-startpos)/(snd.hz*(duration/1000));  %% size (in space) of each step
    size_step=size_change/(snd.hz*(duration/1000)-1); %added a -1 to the denominator DJT 7/1/2013
    if size_change
        dotsize=[dotsize-size_change:size_step:dotsize]; %changed to this, so the final size is the specified size DJT 7/1/2013
%         dotsize=[dotsize-size_change/2+size_step/2:size_step:dotsize+size_change/2-size_step/2];
    end
    if vis_step(1)  %% if the end pos is different from the start pos
        vis_pos_x=[startpos(1)+vis_step(1)/2:vis_step(1):endpos(1)-vis_step(1)/2];
    else
        vis_pos_x=ones(1,round(snd.hz*(duration/1000)))*startpos(1);
    end
    
    if vis_step(2)
        vis_pos_y=[startpos(2)+vis_step(2)/2:vis_step(2):endpos(2)-vis_step(2)/2];
        
    else
        vis_pos_y=ones(1,round(snd.hz*(duration/1000)))*startpos(2);
    end
    
    vis_locs_min=zeros(2,length(vis_pos_x));
    vis_locs_max=zeros(2,length(vis_pos_x));
    vis_locs_min(1,:)=vis_pos_x-dotsize;
    vis_locs_min(2,:)=vis_pos_y-dotsize;
    vis_locs_max(1,:)=vis_pos_x+dotsize;
    vis_locs_max(2,:)=vis_pos_y+dotsize;
    vis_pix_min=convert_array_to_pixels(vis_locs_min,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    vis_pix_max=convert_array_to_pixels(vis_locs_max,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});   
    
    scr_num=length(vis_pos_x);
    
    
end
%% VIS2
if play_vis(2)==1 %% go ahead and calculate the vis positions (in pixels) for vis2
    rad_angle2=angle2*pi/180;
    startpos2=[dotcenter2(1)-(0.5*distance2*sin(rad_angle2)),dotcenter2(2)-(0.5*distance2*cos(rad_angle2))];
    endpos2=[dotcenter2(1)+(0.5*distance2*sin(rad_angle2)),dotcenter2(2)+(0.5*distance2*cos(rad_angle2))];
    
    startpos2=round(startpos2*10000)/10000;
    endpos2=round(endpos2*10000)/10000;
    
    vis_step2=(endpos2-startpos2)/(snd.hz*(duration/1000));
    size_step=size_change2/(snd.hz*(duration/1000)-1); %size_change-->size_change2 ... made changes independent DJT
%added -1 to the denominator for some reason following above modifications
%that were made on 7/1/1013
    
    if size_change2
        dotsize2=[dotsize2-size_change2:size_step:dotsize2]; %changed to this, so the final size is the specified size DJT 7/1/2013
%         dotsize=[dotsize-size_change/2+size_step/2:size_step:dotsize+size_change/2-size_step/2];
% dotsize2=[dotsize2-size_change2/2+size_step/2:size_step:dotsize2+size_change2/2-size_step/2];%size_change-->size_change2 ... made changes independent DJT
    end
    
    if vis_step2(1)
        vis_pos_x2=[startpos2(1)+vis_step2(1)/2:vis_step2(1):endpos2(1)-vis_step2(1)/2];
    else
        vis_pos_x2=ones(1,round(snd.hz*(duration/1000)))*startpos2(1);
    end
    if vis_step2(2)
        vis_pos_y2=[startpos2(2)+vis_step2(2)/2:vis_step2(2):endpos2(2)-vis_step2(2)/2];
    else
        vis_pos_y2=ones(1,round(snd.hz*(duration/1000)))*startpos2(2);
    end

    
    vis_locs_min2=zeros(2,length(vis_pos_x2));
    vis_locs_max2=zeros(2,length(vis_pos_x2));
    vis_locs_min2(1,:)=vis_pos_x2-dotsize2;
    vis_locs_min2(2,:)=vis_pos_y2-dotsize2;
    vis_locs_max2(1,:)=vis_pos_x2+dotsize2;

    vis_locs_max2(2,:)=vis_pos_y2+dotsize2;
    vis_pix_min2=convert_array_to_pixels(vis_locs_min2,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    vis_pix_max2=convert_array_to_pixels(vis_locs_max2,snd.origin{snd.screen_pos},snd.screendistance{snd.screen_pos});
    scr_num=length(vis_pos_x2);  %% scr_num is the same for vis1 & vis2, so i just call it scr_num
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%calculate the other stim params

%% set luminance w/ gamma-curve correction
background_lum=gamma_correct(background_lum)*snd.white;
foreground_lum=gamma_correct(foreground_lum)*snd.white;
foreground_lum2=gamma_correct(foreground_lum2)*snd.white;

%% count the # of screens in "pre" time (before stim onset)
prescreens=round(((snd.hz/1000)*(pre+vis_offset)))-1;

%%MAKE THE ScreenS
% play_vis %%%DIAGNOSTIC added DJT 9/30/2013
if play_vis(1)==0&&play_vis(2)==0   %%no vis, aka background==foreground
    prescreens=round(((snd.hz/1000)*(pre+snd.post)))-1;
    

%         Screen(window,'WaitBlanking');
%         Screen(window,'FillRect',background_lum);
%         Screen(window,'FillRect',[snd.black,snd.black,snd.black],snd.trigger_loc);
%         Screen(window,'WaitBlanking');
%         Screen(window,'FillOval',[snd.white,snd.black,snd.black],snd.trigger_loc);
%         Screen(window,'WaitBlanking');
%         Screen(window,'fillRect',background_lum);
%         Screen(window,'FillRect',[snd.black,snd.black,snd.black],snd.trigger_loc);
%         Screen(window,'WaitBlanking',prescreens);

    
    loop={                
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''FillRect'',background_lum);'
        'Screen(window,''FillRect'',[snd.black,snd.black,snd.black],snd.trigger_loc);'
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''FillOval'',[snd.white,snd.black,snd.black],snd.trigger_loc);'
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''fillRect'',background_lum);'
        'Screen(window,''FillRect'',[snd.black,snd.black,snd.black],snd.trigger_loc);'
        'Screen(window,''WaitBlanking'',prescreens);'
    };          %%create a string that contains the necessary lines to display all boxes.
end

if play_vis(1)==1&&play_vis(2)==0
    loop={                
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''fillRect'',background_lum);'
        'Screen(window,''FillRect'',[snd.black,snd.black,snd.black],snd.trigger_loc);'
        
        'Screen(window,''WaitBlanking'');'
        
        'Screen(window,''FillOval'',[snd.white,snd.black,snd.black],snd.trigger_loc);'
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''fillRect'',background_lum);'
        'Screen(window,''FillRect'',[snd.black,snd.black,snd.black],snd.trigger_loc);'
        
        
        'Screen(window,''WaitBlanking'',prescreens);'
        'Screen(window,''FillOval'',foreground_lum,[vis_pix_min(1,1),vis_pix_min(2,1),vis_pix_max(1,1),vis_pix_max(2,1)]);'
        'for i=[2:scr_num];'
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''FillOval'',background_lum,[vis_pix_min(1,i-1),vis_pix_min(2,i-1),vis_pix_max(1,i-1),vis_pix_max(2,i-1)]);'
        'Screen(window,''FillOval'',foreground_lum,[vis_pix_min(1,i),vis_pix_min(2,i),vis_pix_max(1,i),vis_pix_max(2,i)]);'
        'end;'
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''FillOval'',background_lum,[vis_pix_min(1,scr_num),vis_pix_min(2,scr_num),vis_pix_max(1,scr_num),vis_pix_max(2,scr_num)]);'
        
    };          %%create a string that contains the necessary lines to display all boxes.
end

if play_vis(1)==1&&play_vis(2)==1
    loop={
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''fillRect'',background_lum);'
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''FillOval'',[snd.white,0,0],snd.trigger_loc);'
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''fillRect'',background_lum);'
        'Screen(window,''WaitBlanking'',prescreens);'
        'Screen(window,''FillOval'',foreground_lum,[vis_pix_min(1,1),vis_pix_min(2,1),vis_pix_max(1,1),vis_pix_max(2,1)]);'
        'Screen(window,''FillOval'',foreground_lum2,[vis_pix_min2(1,1),vis_pix_min2(2,1),vis_pix_max2(1,1),vis_pix_max2(2,1)]);'
        
        'for i=[2:scr_num];'
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''FillOval'',background_lum,[vis_pix_min(1,i-1),vis_pix_min(2,i-1),vis_pix_max(1,i-1),vis_pix_max(2,i-1)]);'
        'Screen(window,''FillOval'',foreground_lum,[vis_pix_min(1,i),vis_pix_min(2,i),vis_pix_max(1,i),vis_pix_max(2,i)]);'
        'Screen(window,''FillOval'',background_lum,[vis_pix_min2(1,i-1),vis_pix_min2(2,i-1),vis_pix_max2(1,i-1),vis_pix_max2(2,i-1)]);'
        'Screen(window,''FillOval'',foreground_lum2,[vis_pix_min2(1,i),vis_pix_min2(2,i),vis_pix_max2(1,i),vis_pix_max2(2,i)]);'
        'end;'
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''FillOval'',background_lum,[vis_pix_min(1,scr_num),vis_pix_min(2,scr_num),vis_pix_max(1,scr_num),vis_pix_max(2,scr_num)]);'
        'Screen(window,''FillOval'',background_lum,[vis_pix_min2(1,scr_num),vis_pix_min2(2,scr_num),vis_pix_max2(1,scr_num),vis_pix_max2(2,scr_num)]);'	
    };          %%create a string that contains the necessary lines to display all boxes.
end

if play_vis(1)==0&&play_vis(2)==1
    loop={
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''fillRect'',background_lum);'
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''FillOval'',[snd.white,0,0],snd.trigger_loc);'
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''fillRect'',background_lum);'
        'Screen(window,''WaitBlanking'',prescreens);'
        'Screen(window,''FillOval'',foreground_lum2,[vis_pix_min2(1,1),vis_pix_min2(2,1),vis_pix_max2(1,1),vis_pix_max2(2,1)]);'
        
        'for i=[2:scr_num];'
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''FillOval'',background_lum,[vis_pix_min2(1,i-1),vis_pix_min2(2,i-1),vis_pix_max2(1,i-1),vis_pix_max2(2,i-1)]);'
        'Screen(window,''FillOval'',foreground_lum2,[vis_pix_min2(1,i),vis_pix_min2(2,i),vis_pix_max2(1,i),vis_pix_max2(2,i)]);'
        'end;'
        'Screen(window,''WaitBlanking'');'
        'Screen(window,''FillOval'',background_lum,[vis_pix_min2(1,scr_num),vis_pix_min2(2,scr_num),vis_pix_max2(1,scr_num),vis_pix_max2(2,scr_num)]);'	
    };          %%create a string that contains the necessary lines to display all boxes.
end

if stim_curve
    invoke(RP_2,'SetTagVal','trggate', 1);
end

if play_vis(1)==1||play_vis(2)==1
    Screen(window,'WaitBlanking');  %% wait for particular frame position to start stimulus presentation
end

invoke(zbus,'zBusTrigA',0,0,4); %%start the aud and data collection.
% Rush(sprintf('%s',loop{:}),snd.priorityLevel);   %present the movie 
% evalin('caller',sprintf('%s',loop{:}))
%... added sprinft(...) to make updated version work DJT 9/30/2013
Rush(loop,snd.priorityLevel);   %present the movie
Screen(window,'fillRect',background_lum);
Screen(window,'FillRect',[snd.black,snd.black,snd.black],snd.trigger_loc);

return;
