function [freq,pt_points]=S2_Auto_freq_n_pre_trig(finfo)
%Automatically extract recording frequency and number of pre-trigger points
%from the header texts that come from the Spike2 generated text files

commacounter=0;
charcounter=0;
while commacounter~=5
    charcounter=charcounter+1;
    if finfo{1}{2}(charcounter)==','
        commacounter=commacounter+1;
    end
end
startcomma=charcounter;
while commacounter~=6
    charcounter=charcounter+1;
    if finfo{1}{2}(charcounter)==','
        commacounter=commacounter+1;
    end
end
endcomma=charcounter;
freq=str2num(finfo{1}{2}(startcomma+1:endcomma-1));
while commacounter~=9
    charcounter=charcounter+1;
    if finfo{1}{2}(charcounter)==','
        commacounter=commacounter+1;
    end
end
startcomma=charcounter;
while commacounter~=10
    charcounter=charcounter+1;
    if finfo{1}{2}(charcounter)==','
        commacounter=commacounter+1;
    end
end
endcomma=charcounter;
pt_points=str2num(finfo{1}{2}(startcomma+1:endcomma-1));

end