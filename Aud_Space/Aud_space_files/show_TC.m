function show_TC()
    global snd rec;
    trace=get(findobj('tag','TC_list'),'value');
    set(snd.tc_handle,'LineWidth',1);
    set(snd.tc_handle(trace),'LineWidth',3);
return;