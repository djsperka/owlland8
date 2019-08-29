function update_fit_type()
    figure(findobj(0,'tag','disp_win_3'));     %% set the correct window as active
    if get(findobj(gcf,'tag','fit_type'), 'value')==3
        set(findobj(gcf,'tag','ba_cutoff'), 'enable','on');
        set(findobj(gcf,'tag','cutoff_label'), 'enable','on');
      else
        set(findobj(gcf,'tag','ba_cutoff'), 'enable','off');
        set(findobj(gcf,'tag','cutoff_label'), 'enable','off');
    end
return;