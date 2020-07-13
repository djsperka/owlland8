function update_set_noisecorr
global chan_select save_corr pre_post save_mat save_tif close_figs suppress_figs
for i=1:length(chan_select)
    chan_select(i)=get(findobj(gcf,'tag',strcat('chan',num2str(i))),'value');   
end

save_corr=get(findobj(gcf,'tag','save_corr'), 'value');

pre_post(1)=get(findobj(gcf,'tag','pre_and_post'),'value');
pre_post(2)=get(findobj(gcf,'tag','pre_alone'),'value');
pre_post(3)=get(findobj(gcf,'tag','post_alone'),'value');
save_mat=get(findobj(gcf,'tag','save_mat'),'value');
save_tif=get(findobj(gcf,'tag','save_tif'),'value');
close_figs=get(findobj(gcf,'tag','close_figs'),'value');
suppress_figs=get(findobj(gcf,'tag','suppress_figs'),'value');




    

