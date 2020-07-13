function pair_tagger=Layer_Combo_Selector (layer_combo,site_data,pair_tagger)
% Sort by layer combination (ie. supeXsupe, supeXdeep etc)
% 1=any combo
% 2=within structure combinations only
% 3=between structure combinations only

if layer_combo==1
    %Do nothing
    
elseif layer_combo==2
    %Within structure
    
    %Build the layer-pairs identifier
    layer_pairs=NaN(size(site_data.data_chans,1),2);
    counter=0;
    for i=1:length(site_data.id_layer)-1
        for j=i+1:length(site_data.id_layer)
            counter=counter+1;
            layer_pairs(counter,1)=site_data.id_layer(i);
            layer_pairs(counter,2)=site_data.id_layer(j);
        end
    end
    %Remove between-structure pairs
    for i=1:size(layer_pairs,1)
        if ~(layer_pairs(i,1)==layer_pairs(i,2))
            pair_tagger(i)=0;
        end
    end
    
elseif layer_combo==3
    %Between structures
    
    %Build the layer-pairs identifier
    layer_pairs=NaN(size(site_data.data_chans,1),2);
    counter=0;
    for i=1:length(site_data.id_layer)-1
        for j=i+1:length(site_data.id_layer)
            counter=counter+1;
            layer_pairs(counter,1)=site_data.id_layer(i);
            layer_pairs(counter,2)=site_data.id_layer(j);
        end
    end
    %Remove within-structure pairs
    for i=1:size(layer_pairs,1)
        if (layer_pairs(i,1)==layer_pairs(i,2))
            pair_tagger(i)=0;
        end
    end
    
end