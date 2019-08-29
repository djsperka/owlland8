function set_disp_params()
    global snd rec;
% % %     figure(findobj(0,'tag','Aud_Space_win'));
% % %     rec.dispch=get(findobj(gcf,'tag','dispch'),'value');
    
    

    if length(snd.datatime)>0
        set_range_window
    end;

    
return;
