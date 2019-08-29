function disp_cont_cb()
global cont multcont;
    
	val=get(findobj('tag','inter_cont_tag'),'value');
	cont=multcont{val};

	update_cont_window;

return