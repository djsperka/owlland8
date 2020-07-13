function pair_tagger=Layer_Selector (layer_id,site_data,pair_tagger)
%drop any pairs with a unit located in the layer specfied by layer_id
% 1=superficial
% 2=intermediate
% 3=deep
layer_pairs=NaN(length(site_data.data_chans),2);
counter=0;
for i=1:length(site_data.id_layer)-1
    for j=i+1:length(site_data.id_layer)
        counter=counter+1;
        layer_pairs(counter,1)=site_data.id_layer(i);
        layer_pairs(counter,2)=site_data.id_layer(j);
    end
end
        
for i=1:length(site_data.data_chans)
    if layer_pairs(i,1)==layer_id || layer_pairs(i,2)==layer_id
        pair_tagger(i)=0;
    end
end