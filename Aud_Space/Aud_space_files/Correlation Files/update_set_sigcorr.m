function update_set_sigcorr()
global chan_select
chan_select(1)=str2num(get(findobj(gcf,'tag','chan1'),'string'));
chan_select(2)=str2num(get(findobj(gcf,'tag','chan2'),'string'));
end