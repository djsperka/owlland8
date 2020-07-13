function update_set_noisecorr
global save_mat save_tif close_figs   

save_mat=get(findobj(gcf,'tag','save_mat'),'value');
save_tif=get(findobj(gcf,'tag','save_tif'),'value');
close_figs=get(findobj(gcf,'tag','close_figs'),'value');

