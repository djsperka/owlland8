function disp_inter_cb()
global snd multsnd;

val=get(findobj('tag','inter_tag'),'value');
snd=multsnd{val};
update_control_window;

 figure(findobj(0,'tag','Interleave_win'));     %% set the first window as active
 setsnd;
 close
 setsnd;

return