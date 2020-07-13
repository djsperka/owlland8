function Close_Figures
global fig_hands

%%OUTDATED ... now done in Fig_Ctrl

if size(fig_hands,2)==2
    for i=1:length(fig_hands)
        if ~isnan(fig_hands(i))
        figure (fig_hands(i,1))
        close
        figure (fig_hands(i,2))
        close
        end
    end
else
    for i=1:length(fig_hands)
        if ~isnan(fig_hands(i))
        figure (fig_hands(i))
        close
        end
    end
end

    