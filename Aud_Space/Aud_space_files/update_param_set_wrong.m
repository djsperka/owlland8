function update_param_set_wrong()
    global cont rec savecont

    cont.param_set_wrong=get(findobj(gcf,'tag','param_set_wrong'),'value');
    update_file_cont
