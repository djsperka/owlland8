function get_trace(trace,filename,path)
    global snd rec;
    temp_graph_type=snd.graph_type;
    sndnames=fieldnames(snd);
    recnames=fieldnames(rec);
    
    runmode=snd.runmode;
    dispch=rec.dispch;
    
    
    %%  clear the plots
    figure(findobj(0,'tag','disp_win_1'));
    clf  
    figure(findobj(0,'tag','disp_win_2'));
    clf
    figure(findobj(0,'tag','disp_win_3'));
    set(findobj(gcf,'tag','var1_ba'),'string','');
    set(findobj(gcf,'tag','var2_ba'),'string','');
    set(findobj(gcf,'tag','var1_alone_ba'),'string','');
    set(findobj(gcf,'tag','var2_alone_ba'),'string','');

    snd.ba_handle=[];
    %%%%%%%%%%%%%%%%%%%%

    openpath=[path,filename];
    load(openpath)

    snd=struct(cell2mat(savesnd(trace)));   %%open to a given trace 
    rec=struct(cell2mat(saverec(trace)));
    
    
    fixnames_snd=setdiff(sndnames,fieldnames(snd));
    fixnames_rec=setdiff(recnames,fieldnames(rec));

    %%retrofit old vis files (update for added snd.play_vis1)
    if ~isfield(snd, 'play_vis1') && or(ismember(snd.Var1,[8:12]),ismember(snd.Var2,[8:11]))      
        snd.play_vis1=1;    
    end
    
    for i=[1:length(fixnames_snd)]
        snd=setfield(snd,char(fixnames_snd(i)),0);        %%  set all new variable fields to 0
    end
        
    for i=[1:length(fixnames_rec)]
        rec=setfield(rec,char(fixnames_rec(i)),0);       %%  set all new variable fields to 0
    end
    
    
    
        
    %%  these variables needed to be updated after the load
    snd.maxtrace=length(savesnd);
    snd.filename=filename;
    snd.path=path;
    snd.runmode=runmode;
    snd.posttime=snd.post;
    
    
    if dispch<=rec.numch
        rec.dispch=dispch;
    else
        rec.dispch=1;
    end
    
    %%%update joe's old vars to the new vars
    if max(ismember(fieldnames(snd),'centfreq'))
        snd.freqlo1=snd.centfreq-snd.widthfreq;
        snd.freqhi1=snd.centfreq+snd.widthfreq;
    end
    
    if max(ismember(fieldnames(snd),'itd'))
        snd.itd1=snd.itd;
        snd.ild1=snd.ild;
        snd.abi1=snd.abi;
        snd.play_sound1=snd.play_sound;
    end
    
    if max(ismember(fieldnames(snd),'amp_mod'))
        snd.mod_depth=snd.amp_mod;
    end
    %%now update ilana's old variable names
    if max(ismember(fieldnames(snd),'AM'))
        snd.freq_mod=snd.AM;
    end
    
    if max(ismember(fieldnames(snd),'noAM'))
        if snd.noAM==0  %% this condition refers to the random AM in the old scenario
            snd.AMtype=3;
        else  %%no AM
            snd.AMtype=1; 
        end
    end
    %%%
    
    
    if length(snd.datachan)>0   %% if there is data
        rec.numch=max(snd.datachan);
    end
    
    if findobj(0,'tag','JoeSound_win')>=1
        figure(findobj(0,'tag','JoeSound_win'));     %% set the first window as active
        update_setsnd_display;
    end
        
    figure(findobj(0,'tag','disp_win_3'));
    snd.graph_type=temp_graph_type;
    set(findobj(gcf,'tag','graph_type'),'value',snd.graph_type);  %%update the type of histogram
    
    figure(findobj(0,'tag','Aud_Space_win'));
    set(findobj(gcf,'tag','dispch'),'string',num2cell([1:rec.numch]));  %%update the number of channels
    set(findobj(gcf,'tag','dispch'),'value',rec.dispch);  %%update the number of channels
    drawnow

return;