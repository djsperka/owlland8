function set_dispch
    global snd rec

    rec.dispch=get(findobj(gcf,'tag','dispch'),'value');

    set_graphs(snd.reps);




return;
