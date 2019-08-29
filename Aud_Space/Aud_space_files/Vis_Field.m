function    Vis_Field()
global snd;

%Get rid of white opening screen for PTB DJT 3/10/2014
%Screen ('Preference','VisualDebugLevel',3); % I commented this line out as
%I didin't think it was actually getting rid of white opening ds 1/30/19

myscreen=get(0,'screensize');
window=Screen(0,'OpenWindow',0);
HideCursor;                         %%  Hide the cursor
black=BlackIndex(window);  %%  Find the value of black for the monitor
white=WhiteIndex(window);  %%

origin=snd.origin{snd.screen_pos};           %%origin in pixels
screendistance=snd.screendistance{snd.screen_pos};        %%distance from owl to screen in pixels (estimated from total horizontal screen)

Screen(window,'fillRect',black);       %%  Blank the Screen with the background color

%             xmin=floor(snd.deg{snd.screen_pos}(1)/5)*5;
%             xmax=ceil(snd.deg{snd.screen_pos}(3)/5)*5;
%             ymin=floor(snd.deg{snd.screen_pos}(2)/5)*5;
%             ymax=ceil(snd.deg{snd.screen_pos}(4)/5)*5;
xmin=-30;
ymin=-60;
ymax=50;
xmax=85; %changed 4/11/2014 DJT
step=5;

%Draw origin
booth_window=snd.psychpixels{snd.screen_pos};
Screen(window,'DrawLine',[255 255 255],origin(1),booth_window(2),origin(1),booth_window(4),[3])
Screen(window,'DrawLine',[0 255 255],booth_window(1),origin(2),booth_window(3),origin(2),[3])
% Screen(window,'DrawLine',[255 0 0],origin(1),booth_window(2),origin(1),booth_window(4),[3])
% Screen(window,'DrawLine',[255 0 0],booth_window(1),origin(2),booth_window(3),origin(2),[3])

%Draw grid lines
for h=[xmin:step:xmax]
    l=tan(h*pi/180)*screendistance+origin(1);
    Screen(window,'DrawLine',[255 0 0],l,booth_window(2),l,booth_window(4),[1])
end
for v=[ymin:step:ymax]
    l=origin(2)-tan(v*pi/180)*screendistance;
    Screen(window,'DrawLine',[255 0 0],booth_window(1),l,booth_window(3),l,[1])
end

%Draw booth window
Screen (window,'DrawLine',[255 0 0], booth_window(1),booth_window(2),booth_window(3),booth_window(2),3);
Screen (window,'DrawLine',[255 0 0], booth_window(1),booth_window(4),booth_window(3),booth_window(4),3);
Screen (window,'DrawLine',[255 0 0], booth_window(1),booth_window(2),booth_window(1),booth_window(4),3);
Screen (window,'DrawLine',[255 0 0], booth_window(3),booth_window(2),booth_window(3),booth_window(4),3);


fprintf ('\n Made it so rather than drawing every degree, only draws every 5 degrees\n')
fprintf('This mod was made to Vis_Field.m.  To restore, edit this file.\n')
%Removed this so it doesn't draw every single degree spacing,
%only every 5 degrees DJT 4/11/2014
%             if snd.screen_pos==1
%                 for h=[xmin:xmax]
%                     for v=[ymin:ymax]
%                         lv=origin(2)-tan(v*pi/180)*screendistance;
%                         lh=tan(h*pi/180)*screendistance+origin(1);
%                         Screen(window,'DrawLine',white,lh,lv-3,lh,lv+3,[1])
%                         Screen(window,'DrawLine',white,lh-3,lv,lh+3,lv,[1])
%                     end
%                 end
%             end

Screen (window, 'Flip');  %DJT 3/7/2014

pause
Screen(window,'fillRect',black);       %%  Blank the Screen with the background color

pause
Screen('CloseAll');                 %%  Close the Screen
return;

