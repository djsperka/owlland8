function Fig_Ctrl (pp_type)
global save_mat save_tif close_figs fig_hands root

% Called by Run_NoiseCorr, this is designed to automatically go through all
% of the figures that were generated during the noise correlation routine
% and save them as a matlab file, a tif, and/or close the windows,
% depending on the radiobuttons that are checked in the Figure Control user
% interface

newdir=strcat(root,'_figures');
mkdir(newdir);
startcd=cd;
cd (newdir) 
num_chan=ceil((length(fig_hands)*2)^.5); %Calculates number of channels
%this works because length of fig_hands =num_chans*(num_chans-1) ... thus
%square rooting will give a number in between the two, and rounding up
%gives num_chans
counter=0;
fprintf('\n')

if pp_type==1
    pp_name='';
elseif pp_type==2
    pp_name='_pre';
else 
    pp_name='_post';
end

for i=1:num_chan-1
    for j=i+1:num_chan
        counter=counter+1;
        if save_mat || save_tif
            figname=strcat(root,'_',num2str(i),'x',num2str(j),'_stat',pp_name);
        end
    if ~isnan(fig_hands(counter,1))
        figure(fig_hands(counter,1))
        if save_mat
        saveas(fig_hands(counter,1),figname)
        end
        if save_tif
            saveas(fig_hands(counter,1),strcat(figname,'.tif'))
        end
        if close_figs
            close
        end
    end
    end
end

if size(fig_hands,2)>1
    counter=0;
    for i=1:num_chan-1
    for j=i+1:num_chan
        counter=counter+1;
        if save_mat || save_tif
            figname=strcat(root,'_',num2str(i),'x',num2str(j),'_loom',pp_name);
        end
    if ~isnan(fig_hands(counter,2))
        figure(fig_hands(counter,2))
        if save_mat
        saveas(fig_hands(counter,2),figname)
        end
        if save_tif
            saveas(fig_hands(counter,2),strcat(figname,'.tif'))
        end
        if close_figs
            close
        end
    end
    end
    end
end
cd (startcd)
figname