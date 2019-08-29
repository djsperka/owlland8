function setsnd()
global snd screen_offset;
%added size_change2 DJT 3/10/2014

c_yellow=[.95, .95, .7];
c_green=[.5,.58,.5];
c_red=[.7 .4 .4];

if findobj(0,'tag','JoeSound_win')>=1
    figure(findobj(0,'tag','JoeSound_win'));     %% set the first window as active
else    %%open a new window
    myscreen=get(0,'screensize');
    figure('position',[4+screen_offset,(myscreen(4)-380),800,350],'menubar','none','tag','JoeSound_win', 'color', c_yellow);
    %figure('position',[4,(myscreen(4)-380),800,350],'menubar','none','tag','JoeSound_win', 'color', c_yellow); %
    %Changed to reposition for extended display DJT 1/25/2012
    
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.05 .86 .25 .08],...
        'backgroundcolor',c_yellow,...
        'string','General Parameters',...
        'horizontalalignment','center',...
        'fontweight','bold',...
        'fontsize',12);
    
    %% set duration
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.08 .8 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Duration',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.16 .8 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.duration,...
        'tag','duration',...
        'callback','update_setsnd;');
    
    %% set pre and post time
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.08 .73 .18 .05],...
        'backgroundcolor',c_yellow,...
        'string','Pre / Post',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.16 .73 .06 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.pre,...
        'tag','pre',...
        'callback','update_setsnd;');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.22 .73 .06 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.post,...
        'tag','post',...
        'callback','update_setsnd;');
    
    %% Set the ISI
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.08 .66 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','ISI',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.16 .66 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.isi,...
        'tag','isi',...
        'callback','update_setsnd;');
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.05 .5 .25 .08],...
        'backgroundcolor',c_yellow,...
        'string','Sound Parameters',...
        'horizontalalignment','center',...
        'fontweight','bold',...
        'fontsize',12);
    
    d=-.07;
    dd=-.09;
    
    %%%SND1 STUFF
    %% label snd1
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.09+d .44 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','SND 1',...
        'tag', 'SND1text',...
        'fontweight', 'bold',...
        'fontsize', 10,...
        'horizontalalignment','left');
    uicontrol('style','checkbox',...
        'units','normalized',...
        'position', [.185+dd .44 .15 .05],...
        'backgroundcolor',c_yellow,...
        'tag', 'soundonoff',...
        'fontsize',8,...
        'string', 'Play it',...
        'tag', 'play_sound1',...
        'value', snd.play_sound1,...
        'callback', 'update_setsnd',...
        'horizontalalignment','left');
    
    %% set itd1
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.08+d .37 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','ITD1',...
        'tag', 'ITDtext',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.16+dd .37 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.itd1,...
        'tag','itd1',...
        'callback','update_setsnd;');
    
    %% set ild1
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.08+d .3 .15 .05],...
        'backgroundcolor',c_yellow,...
        'tag', 'ILDtext',...
        'string','ILD1',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.16+dd .3 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.ild1,...
        'tag','ild1',...
        'callback','update_setsnd;');
    
    %% set abi1
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.08+d .23 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','ABI1',...
        'tag', 'ABItext',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.16+dd .23 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.abi1,...
        'tag','abi1',...
        'callback','update_setsnd;');
    
    %% set Low Frequency 1
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.08+d .16 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Freq Lo',...
        'horizontalalignment','left',...
        'tag','lofreqtext');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.16+dd .16 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.freqlo1,...
        'tag','freqlo1',...
        'callback','update_setsnd;');
    
    %% set High Freq 1
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.08+d .09 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Freq Hi',...
        'horizontalalignment','left',...
        'tag','hifreqtext');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.16+dd .09 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.freqhi1,...
        'tag','freqhi1',...
        'callback','update_setsnd;');
    
    %%SND2 STUFF
    d2= .11;
    dd2=.09;
    
    %% label snd2
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.09+d2 .44 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','SND 2',...
        'tag', 'SND2text',...
        'fontweight', 'bold',...
        'fontsize', 10,...
        'horizontalalignment','left');
    uicontrol('style','checkbox',...
        'units','normalized',...
        'position', [.185+dd2 .44 .15 .05],...
        'backgroundcolor',c_yellow,...
        'fontsize',8,...
        'string', 'Play it',...
        'tag', 'play_sound2',...
        'value', snd.play_sound2,...
        'callback', 'update_setsnd',...
        'horizontalalignment','left');
    
    %% set itd2
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.08+d2 .37 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','ITD2',...
        'tag', 'ITD2text',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.16+dd2 .37 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.itd2,...
        'tag','itd2',...
        'callback','update_setsnd;');
    
    %% set ild2
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.08+d2 .3 .15 .05],...
        'backgroundcolor',c_yellow,...
        'tag', 'ILD2text',...
        'string','ILD2',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.16+dd2 .3 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.ild2,...
        'tag','ild2',...
        'callback','update_setsnd;');
    
    %% set abi2
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.08+d2 .23 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','ABI2',...
        'tag', 'ABI2text',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.16+dd2 .23 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.abi2,...
        'tag','abi2',...
        'callback','update_setsnd;');
    
    %% set Low Frequency 2
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.08+d2 .16 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Freq Lo',...
        'horizontalalignment','left',...
        'tag','lofreqtext2');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.16+dd2 .16 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.freqlo2,...
        'tag','freqlo2',...
        'callback','update_setsnd;');
    
    %% set High Freq 2
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.08+d2 .09 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Freq Hi',...
        'horizontalalignment','left',...
        'tag','hifreqtext2');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.16+dd2 .09 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.freqhi2,...
        'tag','freqhi2',...
        'callback','update_setsnd;');
    
    
    
    %% set ITDflank
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.35 .23 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','ITDflank',...
        'horizontalalignment','left',...
        'tag','ITDflank_text');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.42 .23 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.ITDflank,...
        'tag','ITDflank',...
        'callback','update_setsnd;');
    
    %% set aud_offset
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.35 .16 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Aud Offset',...
        'horizontalalignment','left',...
        'tag','aud_offset_text');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.42 .16 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.aud_offset,...
        'tag','aud_offset',...
        'callback','update_setsnd;');
    
    
    %% set rise time
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.35 .09 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Rise time',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.42 .09 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.rise,...
        'tag','rise',...
        'callback','update_setsnd;');
    
    %% set corr
    uicontrol('style','checkbox',...
        'units','normalized',...
        'position', [.35 .3 .15 .05],...
        'backgroundcolor',c_yellow,...
        'fontsize',8,...
        'string', 'corr',...
        'tag', 'corr',...
        'value', snd.corr,...
        'callback', 'update_setsnd',...
        'horizontalalignment','left');
    
    v=.08;
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.4+v .86 .25 .08],...
        'backgroundcolor',c_yellow,...
        'string','Visual Parameters',...
        'horizontalalignment','center',...
        'fontweight','bold',...
        'fontsize',12);
    
    %% VIS1
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.44+v .8 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','VIS 1',...
        'tag', 'VIS1text',...
        'fontweight', 'bold',...
        'fontsize', 10,...
        'horizontalalignment','left');
    uicontrol('style','checkbox',...
        'units','normalized',...
        'position', [.52+v .8 .1 .05],...
        'backgroundcolor',c_yellow,...
        'fontsize',8,...
        'string', 'Play it',...
        'tag', 'play_vis1',...
        'value', snd.play_vis1,...
        'callback', 'update_setsnd',...
        'horizontalalignment','left');
    
    %% set background
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.66+v .88 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Background',...
        'tag','backgroundtext',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.75+v .89 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.background,...
        'tag','background',...
        'callback','update_setsnd;');
    
    %% set foreground
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v .73 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Foreground',...
        'tag','foregroundtext',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+v .73 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.foreground,...
        'tag','foreground',...
        'callback','update_setsnd;');
    %% set dotsize
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v .66 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Dot Size',...
        'tag','dotsizetext',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+v .66 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.dotsize,...
        'tag','dotsize',...
        'callback','update_setsnd;');
    
    %% set distance
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v .59 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Distance',...
        'tag','distancetext',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+v .59 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.distance,...
        'tag','distance',...
        'callback','update_setsnd;');
    
    %% set angle
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v .52 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Angle',...
        'tag','angletext',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+v .52 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.angle,...
        'tag','angle',...
        'callback','update_setsnd;');
    
    %% set az
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v .45 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Azimuth',...
        'tag','aztext',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+v .45 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.az,...
        'tag','az',...
        'callback','update_setsnd;');
    
    %% set el
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v .38 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Elevation',...
        'tag','eltext',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+v .38 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.el,...
        'tag','el',...
        'callback','update_setsnd;');
    %% set size change
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v .31 .15 .05],...
        'backgroundcolor',c_yellow,...
        'tag','size_change_text',...
        'string','Size Change',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+v .31 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.size_change,...
        'tag','size_change',...
        'callback','update_setsnd;');
    %% set vis_offset
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v .23 .15 .05],...
        'backgroundcolor',c_yellow,...
        'tag','vis_offsettext',...
        'string','Vis Offset',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+v .23 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.vis_offset,...
        'tag','vis_offset',...
        'callback','update_setsnd;');
    
    %% set_interleaved_modulation 
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.44+v .16 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Loom Inter',...
        'tag', 'VIS1text',...
        'horizontalalignment','left');
    uicontrol('style','checkbox',...
        'units','normalized',...
        'position', [.52+v .16 .1 .05],...
        'backgroundcolor',c_yellow,...
        'fontsize',8,...
        'string', 'Play it',...
        'tag', 'inter_loom',...
        'value', snd.inter_loom,...
        'callback', 'update_setsnd',...
        'horizontalalignment','left');
    
    %         uicontrol('style','text',...
    %        	    'units','normalized',...
    %        	    'position', [.44+v .8 .15 .05],...
    %        	    'backgroundcolor',c_yellow,...
    %        	    'string','VIS 1',...
    %             'tag', 'VIS1text',...
    %             'fontweight', 'bold',...
    %             'fontsize', 10,...
    %        	    'horizontalalignment','left');
    %        uicontrol('style','checkbox',...
    %        	    'units','normalized',...
    %        	    'position', [.52+v .8 .1 .05],...
    %        	    'backgroundcolor',c_yellow,...
    %             'fontsize',8,...
    %             'string', 'Play it',...
    %             'tag', 'play_vis1',...
    %             'value', snd.play_vis1,...
    %             'callback', 'update_setsnd',...
    %        	    'horizontalalignment','left');
    
    
    %%VIS2
    q=.18;
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.44+v+q .8 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','VIS 2',...
        'tag', 'VIS2text',...
        'fontweight', 'bold',...
        'fontsize', 10,...
        'horizontalalignment','left');
    uicontrol('style','checkbox',...
        'units','normalized',...
        'position', [.52+v+q .8 .1 .05],...
        'backgroundcolor',c_yellow,...
        'fontsize',8,...
        'string', 'Play it',...
        'tag', 'play_vis2',...
        'value', snd.play_vis2,...
        'callback', 'update_setsnd',...
        'horizontalalignment','left');
    
    %% set foreground
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v+q .73 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Foreground',...
        'tag','foreground2text',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+v+q .73 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.foreground2,...
        'tag','foreground2',...
        'callback','update_setsnd;');
    %% set dotsize
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v+q .66 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Dot Size',...
        'tag','dotsize2text',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+v+q .66 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.dotsize2,...
        'tag','dotsize2',...
        'callback','update_setsnd;');
    
    %% set distance
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v+q .59 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Distance',...
        'tag','distance2text',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+v+q .59 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.distance2,...
        'tag','distance2',...
        'callback','update_setsnd;');
    
    %% set angle
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v+q .52 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Angle',...
        'tag','angle2text',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+v+q .52 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.angle2,...
        'tag','angle2',...
        'callback','update_setsnd;');
    
    %% set az
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v+q .45 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Azimuth',...
        'tag','az2text',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+v+q .45 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.az2,...
        'tag','az2',...
        'callback','update_setsnd;');
    
    %% set el
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v+q .38 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Elevation',...
        'tag','el2text',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+q+v .38 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.el2,...
        'tag','el2',...
        'callback','update_setsnd;');
    
    %% set size change
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.43+v+q .31 .15 .05],...
        'backgroundcolor',c_yellow,...
        'tag','size_change2_text',...
        'string','Size Change',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.51+v+q .31 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.size_change2,...
        'tag','size_change2',...
        'callback','update_setsnd;');
    
    %         %% set vis_offset
    %         uicontrol('style','text',...
    %        	    'units','normalized',...
    %        	    'position', [.43+v+q .31 .15 .05],...
    %        	    'backgroundcolor',c_yellow,...
    %        	    'string','Vis Offset',...
    %             'tag','vis_offset2text',...
    %        	    'horizontalalignment','left');
    %         uicontrol('style','edit',...
    %         	'units','normalized',...
    %         	'position', [.51+v+q .31 .08 .05],...
    %         	'backgroundcolor',c_yellow,...
    %         	'horizontalalignment','left',...
    %       		'string',snd.vis_offset2,...
    %        	    'tag','vis_offset2',...
    %         	'callback','update_setsnd;');
    %
    
    
    
    
    
    %% close button
    uicontrol('style','pushbutton',...
        'units','normalized',...
        'position', [.85 .1 .13 .08],...
        'horizontalalignment','center',...
        'string','Close',...
        'fontweight', 'bold', ...
        'fontsize', 10,...
        'backgroundcolor', c_red,...
        'callback','closesetsnd');
    
    %         %% update button
    %         uicontrol('style','pushbutton',...
    %             'units','normalized',...
    %             'position', [.85 .1 .13 .08],...
    %             'horizontalalignment','center',...
    %             'backgroundcolor', c_red,...
    %             'fontweight', 'bold', ...
    %             'fontsize', 10,...
    %             'string','Update',...
    %             'callback','update_setsnd_display');
    
    %% default button
    uicontrol('style','pushbutton',...
        'units','normalized',...
        'position', [.85 0.02 .13 .08],...
        'backgroundcolor', c_red,...
        'horizontalalignment','center',...
        'string','Defaults',...
        'fontsize', 10,...
        'fontweight', 'bold', ...
        'callback','get_setsnd_defaults');
    
    
    %%other
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.35 .86 .1 .08],...%[.7 .3 .10 .1]
        'backgroundcolor',c_yellow,...
        'string','Other',...
        'horizontalalignment','center',...
        'fontweight','bold',...
        'fontsize',12);
    
    
    
    %%%%% set AM choice
    
    shift1=.4;
    shift2=.45;
    
    uicontrol('style','popup',...
        'units','normalized',...
        'position', [.72-shift1 .36+shift2 .08 .05],...
        'backgroundcolor',c_yellow,...
        'fontsize',8,...
        'string', snd.AMchoices,...
        'value', snd.AMtype,...
        'tag', 'noAM',...
        'callback', 'update_setsnd',...
        'horizontalalignment','left');
    %% set depth_mod
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.72-shift1 .25+shift2 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Mod depth',...
        'horizontalalignment','left');
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.8-shift1 .29+shift2 .035 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string','Aud');
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.845-shift1 .29+shift2 .035 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string','Vis');
    
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.8-shift1 .25+shift2 .035 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.mod_depth,...
        'tag','mod_depth',...
        'callback','update_setsnd;');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.845-shift1 .25+shift2 .035 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.amp_mod_vis,...
        'tag','amp_mod_vis',...
        'callback','update_setsnd;');
    
    %% set Freq_mod
    uicontrol('style','text',...
        'units','normalized',...
        'position', [.72-shift1 .18+shift2 .15 .05],...
        'backgroundcolor',c_yellow,...
        'string','Mod Hz',...
        'horizontalalignment','left');
    uicontrol('style','edit',...
        'units','normalized',...
        'position', [.8-shift1 .18+shift2 .08 .05],...
        'backgroundcolor',c_yellow,...
        'horizontalalignment','left',...
        'string',snd.Freq_mod,...
        'tag','Freq_mod',...
        'callback','update_setsnd;');
    
    enable_on_off;  %% this function disables sound/vis tags that aren't being used, and vice versa
end;

return;