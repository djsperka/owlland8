function set_sigcorr
global snd screen_offset chan_select;

addpath ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\DataAnalysis')
    
    c_yellow=[.95, .95, .7];
    c_green=[.5,.58,.5]; 
    c_red=[.7 .4 .4];

    num_chan=max(snd.datachan);
    chan_select = zeros(1,num_chan);
    
    %%open a new window
        myscreen=get(0,'screensize');
        figure('position',[(myscreen(3)/2+screen_offset),(myscreen(4)/2-380),300,400],'menubar','none','tag','JoeSound_win', 'color', c_yellow); 
        %figure('position',[4,(myscreen(4)-380),800,350],'menubar','none','tag','JoeSound_win', 'color', c_yellow); %
        %Changed to reposition for extended display DJT 1/25/2012
for i=1:num_chan;        
uicontrol('style','text',...
        	'units','normalized',...
        	'position', [.05 .8/num_chan*(num_chan+1-i)+.08 .4 .1],...
        	'backgroundcolor',c_yellow,...
        	'string',strcat('Channel ', num2str(i)),...
        	'horizontalalignment','center',...
        	'fontweight','bold',...
        	'fontsize',12);
        uicontrol('style','checkbox',...
       	    'units','normalized',...
       	    'position', [.5 .8/num_chan*(num_chan+1-i)+.1 .1 .1],...
       	    'backgroundcolor',c_yellow,...
            'fontsize',8,...
            'tag', strcat('chan',num2str(i)),...
            'callback', 'update_set_noisecorr',...
       	    'horizontalalignment','left');
end

        uicontrol('style','pushbutton',...
            'units','normalized',...
            'position', [.1 .025 .8 .1],...
            'horizontalalignment','center',...
            'string','Do it!',...
            'fontweight', 'bold', ...
            'fontsize', 10,...
            'backgroundcolor', c_red,...
            'callback','Run_SigCorr_Interloom');