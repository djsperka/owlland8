function update_set_flex()
    global rec snd spacemap pos_plots
        oldpost=snd.post;
        %%update all of the values
        snd.duration=str2num(get(findobj(gcf,'tag','duration'),'string'));
%         snd.rise=str2num(get(findobj(gcf,'tag','rise'),'string'));
        snd.pre=str2num(get(findobj(gcf,'tag','pre'),'string'));
        snd.post=str2num(get(findobj(gcf,'tag','post'),'string'));
        snd.itd1=str2num(get(findobj(gcf,'tag','itd1'),'string'));
        snd.ild1=str2num(get(findobj(gcf,'tag','ild1'),'string'));
        snd.abi1=str2num(get(findobj(gcf,'tag','abi1'),'string'));
%         snd.itd2=str2num(get(findobj(gcf,'tag','itd2'),'string'));
%         snd.ild2=str2num(get(findobj(gcf,'tag','ild2'),'string'));
%         snd.abi2=str2num(get(findobj(gcf,'tag','abi2'),'string'));
        snd.freqlo1=str2num(get(findobj(gcf,'tag','freqlo1'),'string'));
        snd.freqhi1=str2num(get(findobj(gcf,'tag','freqhi1'),'string'));
%         snd.freqlo2=str2num(get(findobj(gcf,'tag','freqlo2'),'string'));
%         snd.freqhi2=str2num(get(findobj(gcf,'tag','freqhi2'),'string'));
        snd.isi=str2num(get(findobj(gcf,'tag','isi'),'string'));
%         snd.aud_offset=str2num(get(findobj(gcf,'tag','aud_offset'),'string'));
        snd.background=str2num(get(findobj(gcf,'tag','background'),'string'));

%         snd.Freq_mod=str2num(get(findobj(gcf,'tag','Freq_mod'),'string'));
%         snd.mod_depth=str2num(get(findobj(gcf,'tag','mod_depth'),'string'));
%         snd.amp_mod_vis=str2num(get(findobj(gcf,'tag','amp_mod_vis'),'string'));

        snd.foreground=str2num(get(findobj(gcf,'tag','foreground'),'string'));
        snd.dotsize=str2num(get(findobj(gcf,'tag','dotsize'),'string'));
        snd.distance=str2num(get(findobj(gcf,'tag','distance'),'string'));
        snd.angle=str2num(get(findobj(gcf,'tag','angle'),'string'));
        snd.az=str2num(get(findobj(gcf,'tag','az'),'string'));
        snd.el=str2num(get(findobj(gcf,'tag','el'),'string'));
        snd.size_change=str2num(get(findobj(gcf,'tag','size_change'),'string'));
%         snd.vis_offset=str2num(get(findobj(gcf,'tag','vis_offset'),'string'));
        
        snd.foreground2=str2num(get(findobj(gcf,'tag','foreground2'),'string'));
        snd.dotsize2=str2num(get(findobj(gcf,'tag','dotsize2'),'string'));
        snd.distance2=str2num(get(findobj(gcf,'tag','distance2'),'string'));
        snd.angle2=str2num(get(findobj(gcf,'tag','angle2'),'string'));
        snd.az2=str2num(get(findobj(gcf,'tag','az2'),'string'));
        snd.el2=str2num(get(findobj(gcf,'tag','el2'),'string'));
%         snd.vis_offset2=str2num(get(findobj(gcf,'tag','vis_offset2'),'string'));
        
        snd.play_sound1=get(findobj(gcf,'tag','play_sound1'), 'value');
%         snd.play_sound2=get(findobj(gcf,'tag','play_sound2'), 'value');
        snd.play_vis1=get(findobj(gcf,'tag','play_vis1'), 'value');
        snd.play_vis2=get(findobj(gcf,'tag','play_vis2'), 'value');
        
%         snd.corr=get(findobj(gcf,'tag','corr'), 'value');
%         snd.AMtype=get(findobj(gcf,'tag','noAM'), 'value');

%         snd.ITDflank=str2num(get(findobj(gcf,'tag','ITDflank'),'string'));
        
        %%%%%%Dougs Competition Mods
        snd.flex_pos1(1)=str2num(get(findobj(gcf,'tag','flex1_x'),'string'));
        snd.flex_pos1(2)=str2num(get(findobj(gcf,'tag','flex1_y'),'string'));
        snd.flex_pos2(1)=str2num(get(findobj(gcf,'tag','flex2_x'),'string'));
        snd.flex_pos2(2)=str2num(get(findobj(gcf,'tag','flex2_y'),'string'));
%         snd.flex_pos_a1(1)=str2num(get(findobj(gcf,'tag','aud_x'),'string'));
%         snd.flex_pos_a1(2)=str2num(get(findobj(gcf,'tag','aud_y'),'string'));
        snd.flex_v1_on=get(findobj(gcf,'tag','flex_v1_on'),'value');
        snd.flex_v2_on=get(findobj(gcf,'tag','flex_v2_on'),'value');
        snd.flex_a1_on=get(findobj(gcf,'tag','flex_a1_on'),'value');
        snd.size_change_v2=str2num(get(findobj(gcf,'tag','size_change_v2'),'string'));
            
		flex_on_off;
        
        %%  check and make the values compatable
        snd.mod_depth=max(snd.mod_depth,0);
        snd.mod_depth=min(snd.mod_depth,1);
        snd.foreground=max(snd.foreground,0);
        snd.foreground=min(snd.foreground,1);
        snd.foreground2=max(snd.foreground2,0);
        snd.foreground2=min(snd.foreground2,1);
        snd.background=max(snd.background,0);
        snd.background=min(snd.background,1);
        snd.post=max(snd.post,snd.duration);
        snd.isi=max(snd.pre+snd.post,snd.isi);
        snd.rangemax=min(snd.rangemax,snd.post);
%         if oldpost~=snd.post    %%  if post was changed set rangemax to post
%             snd.rangemax=snd.post;
%             figure(findobj(0,'tag','disp_win_3'));     %% set the third window as active
%             set(findobj(gcf,'tag','rangemax'),'string',snd.rangemax);
%             figure(findobj(0,'tag','JoeSound_win'));
%         end;

%             figure(findobj(0,'tag','Aud_Space_win'));     %% set the first window as active
%             if snd.play_sound1
%                 set(findobj(gcf,'tag','sound_on'), 'string','sound1 on');
%                else
%                 set(findobj(gcf,'tag','sound_on'), 'string','sound1 off');
%             end
% %             figure(findobj(0,'tag','JoeSound_win'));

        figure(spacemap);
        subplot (2,2,2);
        hold on        
        delete(pos_plots(1),pos_plots(2))
        pos_plots(1)=plot (snd.flex_pos1(1),snd.flex_pos1(2),'diamondb','MarkerSize',15,'LineWidth',5);
        pos_plots(2)=plot (snd.flex_pos2(1),snd.flex_pos2(2),'diamondr','MarkerSize',15,'LineWidth',5);        
        axis ([-40 40 -40 20])
        grid on
        hold off
        
        
        %%update the values
        set(findobj(gcf,'tag','post'),'string',snd.post);
        set(findobj(gcf,'tag','mod_depth'),'string',snd.mod_depth);
        set(findobj(gcf,'tag','isi'),'string',snd.isi);
        set(findobj(gcf,'tag','foreground'),'string',snd.foreground);
        set(findobj(gcf,'tag','background'),'string',snd.background);
        snd.posttime=snd.rangemax-snd.rangemin;
        

return;
    