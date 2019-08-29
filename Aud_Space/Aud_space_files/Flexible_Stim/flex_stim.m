%%copied from map_field: DR 3/3/13

function aud_pointnclick
global snd RA_16
myscreen=get(0,'screensize');

screenNumber=0;
[snd.window,windowRect]=SCREEN(screenNumber,'OpenWindow');  %window=handle  windowRect is size of screen
black=snd.black;       %%  Find the value of black 
white=snd.white;       %%  Find the Value of white
origin=snd.origin{snd.screen_pos};           %%origin in pixels
screendistance=snd.screendistance{snd.screen_pos};        %%distance from owl to screen in pixels (estimated from total horizontal screen)


visual_stim=1;
stim_size=20;

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
xbins=round((0.5*stim_size*xdivs)/myscreen(3));
ybins=round((0.5*stim_size*ydivs)/myscreen(4));

cursor_place_mat=zeros(ydivs,xdivs)+.0001;
spike_mat=zeros(ydivs,xdivs)+.0001;
%     cursor_place_mat=zeros(xdivs,ydivs)+.0001;
%     spike_mat=zeros(xdivs,ydivs);

hidecursor;                 
screen(snd.window,'fillRect',background);   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%%show the border
xmin=round(tan(snd.deg{snd.screen_pos}(1)*pi/180)*screendistance+origin(1));
xmax=round(tan(snd.deg{snd.screen_pos}(3)*pi/180)*screendistance+origin(1));
ymin=round(origin(2)-tan(snd.deg{snd.screen_pos}(2)*pi/180)*screendistance);
ymax=round(origin(2)-tan(snd.deg{snd.screen_pos}(4)*pi/180)*screendistance);

screen(snd.window,'DrawLine',[0,0,0],xmin,myscreen(2),xmin,myscreen(4),[1]);
screen(snd.window,'DrawLine',[0,0,0],xmax,myscreen(2),xmax,myscreen(4),[1]);
screen(snd.window,'DrawLine',[0,0,0],myscreen(1),ymin,myscreen(3),ymin,[1]);
screen(snd.window,'DrawLine',[0,0,0],myscreen(1),ymax,myscreen(3),ymax,[1]);
%%%%%%%%%%%%%%%%%%

oldmouseloc=[640 512];
tic
i=0;
while 1
    i=i+1;
    [x,y,buttons] = GetMouse(snd.window);
    mouseloc=[x(end) y(end)];
    oldmouseloc=mouseloc;
    switch visual_stim
        case 1
            SCREEN(snd.window,'DrawLine',foreground,oldmouseloc(1),oldmouseloc(2),mouseloc(1),mouseloc(2),[stim_size]);
        case 2
            SCREEN(snd.window,'FillRect',foreground,[mouseloc(1)-(stim_size/2),windowRect(2),mouseloc(1)+(stim_size/2),windowRect(4)]);
        case 3
            SCREEN(snd.window,'FillRect',foreground,[windowRect(1),mouseloc(2)-(stim_size/2),windowRect(3),mouseloc(2)+(stim_size/2)]);
    end 
    mousecenter=(mouseloc+oldmouseloc)/2;
    xplace=round((xdivs*mousecenter(1)/myscreen(3))+.5);
    yplace=round((ydivs*mousecenter(2)/myscreen(4))+.5);
    
    if i>2
        switch visual_stim
            case 1
                ydot_min=max(1,yplace-ybins);
                ydot_max=min(ydivs,yplace+ybins);
                xdot_min=max(1,xplace-xbins);
                xdot_max=min(xdivs,xplace+xbins);
                cursor_place_mat(ydot_min:ydot_max,xdot_min:xdot_max)=cursor_place_mat(ydot_min:ydot_max,xdot_min:xdot_max)+toc;
            case 2
                cursor_place_mat(:,xplace)=cursor_place_mat(:,xplace)+toc;
            case 3
                cursor_place_mat(yplace,:)=cursor_place_mat(yplace,:)+toc;
        end 
        
    end
    
    spikes=invoke(RA_16,'gettagval','OscSpikeIndex');
    tic
    if invoke(RA_16,'SoftTrg',3)
    else
        e='error in triggering'
    end
    
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
    
    SCREEN(snd.window,'WaitBlanking',1);
    if oldmouseloc==mouseloc
        switch visual_stim
            case 1
                SCREEN(snd.window,'DrawLine',background,oldmouseloc(1),oldmouseloc(2),mouseloc(1),mouseloc(2),[stim_size]);
            case 2
                SCREEN(snd.window,'FillRect',background,[mouseloc(1)-(stim_size/2),windowRect(2),mouseloc(1)+(stim_size/2),windowRect(4)]);
            case 3
                SCREEN(snd.window,'FillRect',background,[windowRect(1),mouseloc(2)-(stim_size/2),windowRect(3),mouseloc(2)+(stim_size/2)]);
        end 
    end
  
    
    %% ---------------------ACTIVATE AUDITORY STIM ---------------------------------
    if any(buttons) 
        if buttons(1) == 1;
           [x,y,buttons] = GetMouse(snd.window);  
              
        eldeg = -1*atan((y-origin(2))/screendistance)*180/pi;
        azdeg = -1*atan((x-origin(1))/screendistance)*180/pi;
        
        az = azdeg;
        itd = az*2.5 %seconds
        el = eldeg;
        ild = el*1 %dB
        isi = 1000
        
        if ild > 40 | ild < -40  %Click off the screen to end the program
        break 
        else aud_search;
        end
        
        
        elseif buttons(2) == 1;
            edges{length(edges)+1}=[x,y];
            stimlist(length(stimlist)+1)=visual_stim;                
            break
        end
    end
    
    
    if CharAvail
        str=GetChar;
        
        if strcmp(str,'d')
            visual_stim=1;
        end
        if strcmp(str,'v')
            visual_stim=2;
        end
        if strcmp(str,'h')
            visual_stim=3;
        end
        if strcmp(str,'l')
            stim_size=1.25*stim_size;
            xbins=round((0.5*stim_size*xdivs)/myscreen(3));
            ybins=round((0.5*stim_size*ydivs)/myscreen(4));
        end
        if strcmp(str,'s')
            stim_size=stim_size/1.25;
            xbins=round((0.5*stim_size*xdivs)/myscreen(3));
            ybins=round((0.5*stim_size*ydivs)/myscreen(4));
        end
        if strcmp(str,'b')
            while 1
                if CharAvail
                    str=GetChar;
                    if strcmp(str,'d')
                        background=background-(0.1*white);
                        background=max(background,black);
                    end
                    if strcmp(str,'u')
                        background=background+(0.1*white);
                        background=min(background,white);
                    end
                    SCREEN(snd.window,'FillRect',background);
                    break
                end
            end
        end
        if strcmp(str,'f')
            while 1
                if CharAvail
                    str=GetChar;
                    if strcmp(str,'d')
                        foreground=foreground-(0.1*white);
                        foreground=max(foreground,black);
                    end
                    if strcmp(str,'u')
                        foreground=foreground+(0.1*white);
                        foreground=min(foreground,white);
                    end
                    break
                end
            end
        end
    end
end;

% norm_spike_mat=spike_mat./cursor_place_mat;
% kernel=[0,0.125,0; 0.125,0.5,0.125; 0,0.125,0];
% norm_spike_mat=conv2(kernel,norm_spike_mat(2:ydivs-1,2:xdivs-1));        %%smooth the matrix
% 
% norm_min=min(min(norm_spike_mat(2:ydivs-1,2:xdivs-1)));
% norm_max=max(max(norm_spike_mat(2:ydivs-1,2:xdivs-1)));
% 
% norm_spike_mat=(norm_spike_mat-norm_min)/(norm_max-norm_min);
% 
% SCREEN(snd.window,'FillRect',background );
% 
% norm_spike_mat(1,1:xdivs)=norm_spike_mat(2,1:xdivs);      %%extend over filtered edges
% norm_spike_mat(ydivs,1:xdivs)=norm_spike_mat(ydivs-1,1:xdivs);      %%extend over filtered edges
% norm_spike_mat(1:ydivs,1)=norm_spike_mat(1:ydivs,2);      %%extend over filtered edges
% norm_spike_mat(1:ydivs,xdivs)=norm_spike_mat(1:ydivs,xdivs-1);      %%extend over filtered edges
% 
% 
% SCREEN(snd.window,'PutImage',norm_spike_mat*white,windowRect)
% 
% %%% KM: copied code from Vis_Field.m.  Replaced 'white' with '[100,0,0]'.
% xmin=floor(snd.deg{snd.screen_pos}(1)/5)*5;
% xmax=ceil(snd.deg{snd.screen_pos}(3)/5)*5;
% ymin=floor(snd.deg{snd.screen_pos}(2)/5)*5;
% ymax=ceil(snd.deg{snd.screen_pos}(4)/5)*5;
% step=5;
% 
% SCREEN(snd.window,'DrawLine',[100,0,0],origin(1),myscreen(2),origin(1),myscreen(4),[3])
% SCREEN(snd.window,'DrawLine',[100,0,0],myscreen(1),origin(2),myscreen(3),origin(2),[3])
% for h=[xmin:step:xmax]
%     l=tan(h*pi/180)*screendistance+origin(1);
%     SCREEN(snd.window,'DrawLine',[100,0,0],l,myscreen(2),l,myscreen(4),[1])
% end
% for v=[ymin:step:ymax]
%     l=origin(2)-tan(v*pi/180)*screendistance;
%     SCREEN(snd.window,'DrawLine',[100,0,0],myscreen(1),l,myscreen(3),l,[1])
% end
% 
% for h=[xmin:xmax]          
%     for v=[ymin:ymax]
%         lv=origin(2)-tan(v*pi/180)*screendistance; %(y pos pixels)
%         lh=tan(h*pi/180)*screendistance+origin(1); %(x pos pixels)
%         
%         if snd.screen_pos==1  % only draw all the 1-degree marks if in far screen position
%             SCREEN(snd.window,'DrawLine',[100,0,0],lh,lv-3,lh,lv+3,[1])%vertical marks (mark horizontal position - x)
%             SCREEN(snd.window,'DrawLine',[100,0,0],lh-3,lv,lh+3,lv,[1])%horizontal marks (mark vertical position - y)
%         end
%     end
% end
% 
% waitsecs(1)
% 
% while 1
%     showcursor;
%     [x,y,buttons] = GetMouse(snd.window);
%     %if buttons(1) == 1;
%     if any (buttons);
%         break
%     end
% end
% 
% 

SCREEN('CloseAll');                 %%  Close the Screen


return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
