function remove_TC()
    global snd rec;
    trace=get(findobj('tag','TC_list'),'value');
    delete(snd.tc_handle(trace));
    
    snd.tc_handle(trace:length(snd.tc_handle)-1)=snd.tc_handle(trace+1:length(snd.tc_handle));
    snd.tc_handle=snd.tc_handle(1:length(snd.tc_handle)-1);
    
    p=1;
    temp_string{1}='';
    for i=1:length(snd.tc_string)
        if i~=trace
            temp_string{p}=snd.tc_string{i}; 
            p=p+1;
        end
    end
    snd.tc_string=temp_string;
    
    set(findobj('tag','TC_list'),'value',min(trace,length(snd.tc_string)));
    set( findobj('tag','TC_list'),'string', snd.tc_string );
return;