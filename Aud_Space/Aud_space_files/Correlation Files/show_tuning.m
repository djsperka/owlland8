function show_tuning()
global snd rec;

addpath ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Correlation Files')

h=findobj(gcf,'tag','tuning_type');
corr_type=get(h,'value');
snd.graph_num=snd.graph_num+1;

switch corr_type
    case 1
        set_euc_distance
        %%Doug's distance calculator
        %This is designed to auto-calculate the below metrics for all
        %channels in all conditions (static or looming), then calculate the
        %euclidean distance from the calculated locations which seperates
        %each channel 1)Modified weighted average, based on the Knudsen lab
        %function 2)Full field weighted average function 3)Plane ol' peak.
        %Just the location of max firing.
                    
    case 2
        set_dot_product
        
end