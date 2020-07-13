function [pair_tagger]=Same_Trode_Dropper(site_data,pair_tagger)
%Remove any sites that did not have good weighted average estimates

counter=0;
for i=1:length(site_data.id_chan)-1
    for j=i+1:length(site_data.id_chan)
        counter=counter+1;
        if site_data.id_trode(i)==site_data.id_trode(j)
        pair_tagger(counter)=0;
        end
    end
end