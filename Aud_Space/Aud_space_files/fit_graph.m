function fit_graph()
    %%fit types ={'Gauss','Sigmoid','Weighted Ave'}
    
    figure(findobj(0,'tag','disp_win_3'));     %% set the correct window as active
    fit_type=get(findobj(gcf,'tag','fit_type'), 'value');

    switch fit_type
        case 1
            fit_gauss_AS;   %%gauss
        case 2
            fit_sig_AS; %%sigmoid
        case 3
            fit_weighted_AS; %%weighted average.  used to use 'find_best_area' function; now
                % uses Ilana's 'halfmax' function. Finds center of mass.
    end
return;