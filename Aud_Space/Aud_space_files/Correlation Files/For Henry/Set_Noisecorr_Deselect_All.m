function Set_Noisecorr_Deselect_All
global chan_select

for i=1:length(chan_select)
set(findobj(gcf,'tag',strcat('chan',num2str(i))),'Value',0); 
chan_select(i)=0;
end