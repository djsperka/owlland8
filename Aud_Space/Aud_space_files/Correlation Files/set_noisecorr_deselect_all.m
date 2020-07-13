function set_noisecorr_deselect_all
global chan_select

for i=1:length(chan_select)
set(findobj(gcf,'tag',strcat('chan',num2str(i))),'Value',0); 
chan_select(i)=0;
end