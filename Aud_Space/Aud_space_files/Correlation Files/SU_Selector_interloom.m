function pair_tagger=SU_Selector (unit_type, site_data, pair_tagger)

if unit_type==1 %if all units selected

%Don't do anything
    
elseif unit_type==2 %if only plotting single units
    
    chan_tag=site_data.id_chan(find(site_data.id_su==1));
    tag_combo=nan(length(chan_tag)*(length(chan_tag)-1)/2,2);
    counter=0;
    for i=1:length(chan_tag)-1;
        for j=i+1:length(chan_tag);
            counter=counter+1;
            tag_combo(counter,1)=chan_tag(i);
            tag_combo(counter,2)=chan_tag(j);
        end
    end

    hits=0;
    counter=0;
    while hits<length(tag_combo);
        counter=counter+1;
        if ~(site_data.data_chans(counter,:)==tag_combo(hits+1,:))
            %if channels are NOT the next combination of tagged channels
            pair_tagger(counter)=0;
            %set them to 0
        else %but if it IS the tagged combo
            hits=hits+1;
        end
    end
    pair_tagger(counter+1:end)=0;
    
elseif unit_type==3
    
    chan_tag=site_data.id_chan(find(site_data.id_su==0));
    tag_combo=nan(length(chan_tag)*(length(chan_tag)-1)/2,2);
    counter=0;
    for i=1:length(chan_tag)-1;
        for j=i+1:length(chan_tag);
            counter=counter+1;
            tag_combo(counter,1)=chan_tag(i);
            tag_combo(counter,2)=chan_tag(j);
        end
    end

    hits=0;
    counter=0;
    while hits<length(tag_combo);
        counter=counter+1;
        if ~(site_data.data_chans(counter,:)==tag_combo(hits+1,:))
            %if channels are NOT the next combination of tagged channels
            pair_tagger(counter)=0;
            %set them to 0
        else %but if it IS the tagged combo
            hits=hits+1;
        end
    end
    pair_tagger(counter+1:end)=0;
 
end