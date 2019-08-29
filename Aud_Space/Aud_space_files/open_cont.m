function open_cont()
    global cont savecont saverec rec
    load_cont(1)
    update_cont_window

    %%find Vector Strength if there is data
    if length(cont.ITD_pos)
        if length(cont.ITD_pos{1})  %%if there is data
            params=cont_V_strength;
            VS_min=params(3);
            if cont.noise_hz>1
                VS_min=min([params(3),params(4)]);
            end
        end
    end

    if VS_min>str2num(get(findobj(gcf,'tag','vs_cutoff'),'string'));
        show_cont_graphs        %%if good vector strength show the graphs
    end

return;