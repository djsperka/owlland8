function update_set_dotproduct
global chan_select
for i=1:length(chan_select)
    chan_select(i)=get(findobj(gcf,'tag',strcat('chan',num2str(i))),'value');   
end





    

