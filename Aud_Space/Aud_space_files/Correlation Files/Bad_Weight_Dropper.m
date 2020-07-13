% function [stat_tagger,loom_tagger]=Bad_Weight_Dropper(site_data,pair_tagger)
function [pair_tagger]=Bad_Weight_Dropper(site_data,pair_tagger)
%Remove any sites that did not have good weighted average estimates


% loom_tagger=pair_tagger;
% stat_tagger=pair_tagger;
counter=0;
for i=1:length(site_data.id_chan)-1
    for j=i+1:length(site_data.id_chan)
        counter=counter+1;
        if site_data.id_loc_guess_loom(i)==1 || site_data.id_loc_guess_loom(j)==1 || site_data.id_loc_guess_stat(i)==1 || site_data.id_loc_guess_loom (i)==1
        pair_tagger(counter)=0;
        end  %Combined loom_tagger and stat_tagger into one, so that stat-loom paired data are maintained DJT 9/19/2013
%         if site_data.id_loc_guess_loom(i)==1 || site_data.id_loc_guess_loom(j)==1
%         loom_tagger(counter)=0;
%         end
%         if site_data.id_loc_guess_stat(i)==1 || site_data.id_loc_guess_stat(j)==1
%         stat_tagger(counter)=0;
%         end
    end
end
        