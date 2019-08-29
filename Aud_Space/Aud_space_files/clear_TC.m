function clear_TC()
	global rec snd;
	snd.tc_handle=[];
	snd.timecourse_plot_num=0;
    snd.tc_string={''};
	cla;
    
    
    set( findobj('tag','TC_list'),'string', snd.tc_string );
    set( findobj('tag','TC_list'),'value', 1);
return;