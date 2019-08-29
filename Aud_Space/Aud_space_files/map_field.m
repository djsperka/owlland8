function map_field()
global snd RA_16

%Get rid of white opening screen for PTB DJT 3/10/2014
Screen ('Preference','VisualDebugLevel',3);

myscreen=get(0,'screensize');

%% Initialize Parameters

screenNumber=0;
[window,windowRect]=Screen(screenNumber,'OpenWindow');  %window=handle  windowRect is size of screen
black=snd.black;       %%  Find the value of black
white=snd.white;       %%  Find the Value of white
origin=snd.origin{snd.screen_pos};           %%origin in pixels
screendistance=snd.screendistance{snd.screen_pos};        %%distance from owl to screen in pixels (estimated from total horizontal screen)

visual_stim=1;
stim_size=25;

x=0;
y=0;
center=[640 512];

background=(snd.background*white)+((1-snd.background)*black);
foreground=(snd.foreground*white)+((1-snd.foreground)*black);
buttons=0;

edges={};
stimlist=[];

xdivs=60;
ydivs=40;
%this determines how many location bins are activated one either side of
%your stim.  for small stim this will be zero, because its only activating
%a central bin
xbins=round((0.5*stim_size*xdivs)/myscreen(3));
ybins=round((0.5*stim_size*ydivs)/myscreen(4));

cursor_place_mat=ones(ydivs,xdivs); %changed this because otherwise we are 
% by vary small numbers sometimes  DJT 5/19/2014
% cursor_place_mat=zeros(ydivs,xdivs)+.0001;
spike_mat=zeros(ydivs,xdivs)+.0001;
%     cursor_place_mat=zeros(xdivs,ydivs)+.0001;
%     spike_mat=zeros(xdivs,ydivs);

HideCursor;
Screen(window,'fillRect',background);

%% show the border
%%%This doesn't seem to do anything - DJT 3/9/14
xmin=round(tan(snd.deg{snd.screen_pos}(1)*pi/180)*screendistance+origin(1));
xmax=round(tan(snd.deg{snd.screen_pos}(3)*pi/180)*screendistance+origin(1));
ymin=round(origin(2)-tan(snd.deg{snd.screen_pos}(2)*pi/180)*screendistance);
ymax=round(origin(2)-tan(snd.deg{snd.screen_pos}(4)*pi/180)*screendistance);
Screen(window,'DrawLine',[0,0,0],xmin,myscreen(2),xmin,myscreen(4),[1]);
Screen(window,'DrawLine',[0,0,0],xmax,myscreen(2),xmax,myscreen(4),[1]);
Screen(window,'DrawLine',[0,0,0],myscreen(1),ymin,myscreen(3),ymin,[1]);
Screen(window,'DrawLine',[0,0,0],myscreen(1),ymax,myscreen(3),ymax,[1]);
%%%%%%%%%%%%%%%%%%

Screen (window, 'Flip'); % DJT 3/7/2014

oldmouseloc=[640 512];
tic
i=0;

%% Update mouse position and record responses
while 1
    i=i+1;
    [x,y,buttons] = GetMouse(window);
    mouseloc=[x(end) y(end)];
%     oldmouseloc=mouseloc; %Moved later in the scrip 3/9/14 DJT
    
    %play the vis stim
    switch visual_stim
        case 1
            circle_size = [mouseloc(1)-stim_size/2, mouseloc(2)-stim_size/2, mouseloc(1)+stim_size/2, mouseloc(2)+stim_size/2];
            Screen(window,'FillOval',foreground,circle_size); %Made this an elipse 3/9/2014
%             Screen(window,'DrawLine',foreground,oldmouseloc(1),oldmouseloc(2),mouseloc(1),mouseloc(2),[stim_size]);
        case 2
            Screen(window,'FillRect',foreground,[mouseloc(1)-(stim_size/2),windowRect(2),mouseloc(1)+(stim_size/2),windowRect(4)]);
        case 3 
            Screen(window,'FillRect',foreground,[windowRect(1),mouseloc(2)-(stim_size/2),windowRect(3),mouseloc(2)+(stim_size/2)]);
    end
    %the center of where your mouse is, in pixels
    mousecenter=(mouseloc+oldmouseloc)/2; 
    %convert pixel location to location bin
    xplace=round((xdivs*mousecenter(1)/myscreen(3))+.5);
    yplace=round((ydivs*mousecenter(2)/myscreen(4))+.5);
    
    %if the mouse was moved (and a stim was played) calculate where the mouse has been
    %if you didn't move the mouse, no stim was playing, so don't add that
    %to the total time the stim was at a location
    if oldmouseloc~=mouseloc
    if i>2
        switch visual_stim
            case 1
                ydot_min=max(1,yplace-ybins);
                ydot_max=min(ydivs,yplace+ybins);
                xdot_min=max(1,xplace-xbins);
                xdot_max=min(xdivs,xplace+xbins);
                cursor_place_mat(ydot_min:ydot_max,xdot_min:xdot_max)=cursor_place_mat(ydot_min:ydot_max,xdot_min:xdot_max)+toc*10; % just made toc * 10 so everything grows a little faster
            case 2
                if xplace>0 %added this because I was getting problems when the mouse moved off the screen DJT 4/9/2014
                cursor_place_mat(:,xplace)=cursor_place_mat(:,xplace)+toc;
                end
            case 3
                cursor_place_mat(yplace,:)=cursor_place_mat(yplace,:)+toc;
        end
        
    end
    end
    
    %detect any spikes
    spikes=invoke(RA_16,'gettagval','OscSpikeIndex');
    tic
    if invoke(RA_16,'SoftTrg',3)
    else
        e='error in triggering'
    end
    
    % If there were spikes detected, associate them w/ where the mouse was
    if spikes>0
        if i>2
            switch visual_stim
                case 1
                    ydot_min=max(1,yplace-ybins);
                    ydot_max=min(ydivs,yplace+ybins);
                    xdot_min=max(1,xplace-xbins);
                    xdot_max=min(xdivs,xplace+xbins);
                    spike_mat(ydot_min:ydot_max,xdot_min:xdot_max)=spike_mat(ydot_min:ydot_max,xdot_min:xdot_max)+double(spikes);
                case 2
                    spike_mat(:,xplace)=spike_mat(:,xplace)+double(spikes);
                case 3
                    spike_mat(yplace,:)=spike_mat(yplace,:)+double(spikes);
            end
            
        end
    end
    
    % If you didn't move your mouse, black out the stim
    if oldmouseloc==mouseloc
        switch visual_stim
            case 1
            circle_size = [mouseloc(1)-stim_size/2, mouseloc(2)-stim_size/2, mouseloc(1)+stim_size/2, mouseloc(2)+stim_size/2];
            Screen(window,'FillOval',background,circle_size); %changed this to an elipse DJT 3/9/2014
            case 2
                Screen(window,'FillRect',background,[mouseloc(1)-(stim_size/2),windowRect(2),mouseloc(1)+(stim_size/2),windowRect(4)]);                
            case 3
                Screen(window,'FillRect',background,[windowRect(1),mouseloc(2)-(stim_size/2),windowRect(3),mouseloc(2)+(stim_size/2)]);                
        end

    end    
    Screen (window,'Flip'); %DJT 3/7/2014  
    
%     if oldmouseloc~=mouseloc %if the mouse has changed positions
%         oldoldmouseloc=oldmouseloc;
%     end
    oldmouseloc=mouseloc; %Moved this down from beginning of while loop to here.  Not sure why it was in beginning of while loop.  DJT 3/9/14
    
    %% If you click your mouse - End Map Field
    if any(buttons)
        if buttons==1
            edges{length(edges)+1}=[x,y];
            stimlist(length(stimlist)+1)=visual_stim;
            
            
        else
            break
        end
    end
    
    %% If a button is pressed on keyboard, open keyboard controls
    [keypress, time, keycode, deltasecs]=KbCheck; %DJT 3/7/2014
    
    if keypress %DJT 3/7/2014
        %wait til you release the key, so you can't register multiple
        %entries per keystroke
        keystilldown=1;
        while keystilldown
            keystilldown=KbCheck; 
        end            
        %         if CharAvail
        keypress=0; %DJT 3/7/2014
        str=KbName(keycode);%DJT 3/7/2014
        %         str=GetChar;
        
        %Draw a dot
        if strcmp(str,'d')
            visual_stim=1;
        end
        
        %Draw a vertical bar
        if strcmp(str,'v')
            visual_stim=2;
        end
        
        %Draw a horizontal bar
        if strcmp(str,'h')
            visual_stim=3;
        end
        
        %Make stim larger
        if strcmp(str,'l')
            stim_size=1.25*stim_size;
            xbins=round((0.5*stim_size*xdivs)/myscreen(3));
            ybins=round((0.5*stim_size*ydivs)/myscreen(4));
        end
        
        %Make stim smaller
        if strcmp(str,'s')
            stim_size=stim_size/1.25;
            xbins=round((0.5*stim_size*xdivs)/myscreen(3));
            ybins=round((0.5*stim_size*ydivs)/myscreen(4));%             
        end
        
        % Control background luminance
        if strcmp(str,'b')
            'b pressed!'
            
            while 1 %wait until you tell it up or down
                [blank,time, keycode, deltasecs]=KbCheck; %DJT 3/7/2014
                %                     if keycode %DJT 3/7/2014
                str=KbName(keycode); %DJT 3/7/2014
                if strcmp(str,'d')
                    'd pressed!'
                    background=background-(0.1*white);
                    background=max(background,black);
                    Screen(window,'FillRect',background);
                    Screen (window,'Flip'); %DJT 3/7/2014
                    break
                end
                if strcmp(str,'u')
                    'u pressed!'
                    background=background+(0.1*white);
                    background=min(background,white);
                    Screen(window,'FillRect',background);
                    Screen (window,'Flip'); %DJT 3/7/2014
                    break
                end
                %                         break
                %                     end %DJT 3/7/2014
            end
        end
        
        % Control foreground luminance
        if strcmp(str,'f')
            while 1
                [blank, time, keycode, deltasecs]=KbCheck; %DJT 3/7/2014
                %                     if keypress %DJT 3/7/2014
                str=KbName (keycode); %DJT 3/7/2014
                if strcmp(str,'d')
                    foreground=foreground-(0.1*white);
                    foreground=max(foreground,black);
                    Screen (window,'Flip'); %DJT 3/7/2014
                    break
                end
                if strcmp(str,'u')
                    foreground=foreground+(0.1*white);
                    foreground=min(foreground,white);
                    Screen (window,'Flip'); %DJT 3/7/2014
                    break
                end
                %                         break
                %                     end %DJT 3/7/2014
            end
        end
    end %%% - End Keyboard Button Loop
    
end; %%% - End stim presentation

%% Figure out where there was activity and plot it

%divide how many spikes were detected by how long the stim was there
norm_spike_mat=spike_mat./cursor_place_mat; 

%smooth the matrix
kernel=[0,0.125,0; 0.125,0.5,0.125; 0,0.125,0];
norm_spike_mat=conv2(kernel,norm_spike_mat(2:ydivs-1,2:xdivs-1));        

%scale the matrix
norm_min=min(min(norm_spike_mat(2:ydivs-1,2:xdivs-1)));
norm_max=max(max(norm_spike_mat(2:ydivs-1,2:xdivs-1)));
norm_spike_mat=(norm_spike_mat-norm_min)/(norm_max-norm_min); %added *.8 to normalization so that no response isn't quite black

Screen(window,'FillRect',background );

norm_spike_mat(1,1:xdivs)=norm_spike_mat(2,1:xdivs);      %%extend over filtered edges
norm_spike_mat(ydivs,1:xdivs)=norm_spike_mat(ydivs-1,1:xdivs);      %%extend over filtered edges
norm_spike_mat(1:ydivs,1)=norm_spike_mat(1:ydivs,2);      %%extend over filtered edges
norm_spike_mat(1:ydivs,xdivs)=norm_spike_mat(1:ydivs,xdivs-1);      %%extend over filtered edges

%added a /2 to the white, so everything is a little less bright DJT 5/19/14
Screen(window,'PutImage',norm_spike_mat*white/2,myscreen) %changed from WindowRect to myscreen. 
%these two seem like they should be acheiving the same thing, but actually
%are giving 2 different results, probably because we have multiple
%monitors.

%%% Plot visual grid
%%% KM: copied code from Vis_Field.m.  Replaced 'white' with '[100,0,0]'.
%%% DJT: changed [100,0,0] to [255,0,0]
xmin=floor(snd.deg{snd.screen_pos}(1)/5)*5;
% xmax=ceil(snd.deg{snd.screen_pos}(3)/5)*5;
% ymin=floor(snd.deg{snd.screen_pos}(2)/5)*5;
% ymax=ceil(snd.deg{snd.screen_pos}(4)/5)*5;
xmax=75;
ymin=-60;
ymax=60;
step=5;

Screen(window,'DrawLine',[255,0,0],origin(1),myscreen(2),origin(1),myscreen(4),[3])
Screen(window,'DrawLine',[255,0,0],myscreen(1),origin(2),myscreen(3),origin(2),[3])
for h=[xmin:step:xmax]
    L=tan(h*pi/180)*screendistance+origin(1);
%     L2=tan((h+1)*pi/180)*screendistance+origin(1);
    Screen(window,'DrawLine',[255,0,0],L,myscreen(2),L,myscreen(4),[1])
%     Screen(window,'DrawLine',[255,255,255],L,myscreen(2),L,myscreen(4),[1])
end
for v=[ymin:step:ymax]
    L=origin(2)-tan(v*pi/180)*screendistance;
%     L2=origin(2)-tan((v+1)*pi/180)*screendistance;
    Screen(window,'DrawLine',[255,0,0],myscreen(1),L,myscreen(3),L,[1])
%     Screen(window,'DrawLine',[255,255,255],myscreen(1),L2,myscreen(3),L2,[1])
end
%added L2 to make a second grid, offset by 1 degree

% for h=[xmin:5:xmax]
%     for v=[ymin:5:ymax]
%         lv=origin(2)-tan(v*pi/180)*screendistance;
%         lh=tan(h*pi/180)*screendistance+origin(1);
%         if snd.screen_pos==1  % only draw all the 1-degree marks if in far screen position
%             Screen(window,'DrawLine',[100,0,0],lh,lv-3,lh,lv+3,[1])
%             Screen(window,'DrawLine',[100,0,0],lh-3,lv,lh+3,lv,[1])
%         end
%     end
% end

Screen (window,'Flip'); %DJT 3/7/2014

WaitSecs(1)
while 1
    ShowCursor;
    [x,y,buttons] = GetMouse(window);
    if any(buttons)
        break
    end
end

Screen('CloseAll');                 %%  Close the Screen

return;