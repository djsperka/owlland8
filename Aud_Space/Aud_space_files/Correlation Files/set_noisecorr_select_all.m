function set_noisecorr_select_all
global chan_select
for i=1:length(chan_select)
set(findobj(gcf,'tag',strcat('chan',num2str(i))),'Value',1); 
chan_select(i)=1;
end