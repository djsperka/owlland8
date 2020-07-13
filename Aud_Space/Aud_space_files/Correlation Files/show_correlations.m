function show_correlations()
global snd rec;

addpath ('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Correlation Files')

h=findobj(gcf,'tag','correlation_type');
corr_type=get(h,'value');
snd.graph_num=snd.graph_num+1;

switch corr_type
    case 1
        set_sigcorr
        
    case 2
        set_noisecorr
        
    case 3
        set_spikecorr
end